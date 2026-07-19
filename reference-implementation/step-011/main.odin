package lowkey

import "base:runtime"
import "core:fmt"
import "core:log"
import vmem "core:mem/virtual"
import "core:os"
import "core:strings"
import "core:strconv"
import "core:unicode/utf8"

when !ODIN_DEBUG { _ :: log } // Avoid unused import error for log

KB :: 1024
MB :: KB * 1024

////////////////////////////////////////////////////////////////////////////////
// REPL
////////////////////////////////////////////////////////////////////////////////

main :: proc() {
	fmt.println("Welcome to the Lowkey compiler! Starting REPL mode:")

	// program-wide allocations
	arena: vmem.Arena
	arena_allocator := vmem.arena_allocator(&arena)
	state := init_state(arena_allocator)

	// Make a source text string builder, and init to large capacity so it doesn't reallocate
	source_text_builder := strings.builder_make_len_cap(1 * MB, 50 * MB, arena_allocator)

	input_buffer: [1024]byte

	for {
		defer free_all(context.temp_allocator)

		fmt.print("> ")
		n, err := os.read(os.stdin, input_buffer[:])
		if err != nil {
			fmt.eprintln("Error reading:", err)
			return
		}

		input_string := string(input_buffer[:n])

		// Handle any commands (not intended to be part of the source text)
		if input_string == "state\n" {
			print_interpreter_state(&state)
			continue
		}

		// Append input string to source text
		strings.write_string(&source_text_builder, input_string)

		// Get a string view/slice into the source text
		source_text := strings.to_string(source_text_builder)

		// Tokenize input
		tokens, errors := tokenize(source_text, arena_allocator)

		// Print out any errors
		if len(errors) > 0 {
			for error in errors {
				fmt.eprint(generate_error_message(error, source_text))
			}
			continue
		}

		when ODIN_DEBUG {
			// Print out tokens
			for token in tokens {
				fmt.println(token)
			}
		}

		// Execute the tokens directly, for now
		execute(tokens, source_text, &state, arena_allocator)
	}
}

////////////////////////////////////////////////////////////////////////////////
// Tokenization
////////////////////////////////////////////////////////////////////////////////

TokenType :: enum {
	Nil,
	IdentifierVariable,
	OperatorBinaryAssignment,
	ConstantInteger,
}

Token :: struct {
	type: TokenType,
	start_byte: int,
	length: int,
	line_number: int,
	column_number: int,
	token_index: int,
}

// The states for the tokenization state machine
TokenizationState :: enum {
	Idle,
	CurrentlyTokenizing, // Currently creating a token
	CurrentlyError, // We hit an error - skipping to the next token
}

tokenize :: proc(source_text: string, allocator: runtime.Allocator) -> ([dynamic]Token, [dynamic]Error) {
	// TODO: Assert that source file length is < INT_MAX
	// TODO: Assert that source file ends with whitespace
	when ODIN_DEBUG {
		log.debug("tokenize() source text:")
		log.debug("---------------------------------------------------------")
		log.debug(source_text)
		log.debug("---------------------------------------------------------")
	}

	tokens := make([dynamic]Token, allocator)
	errors := make([dynamic]Error, allocator)

	line_number := 1
	line_start_byte := 0
	column_number := 0
	token_index := 0

	current_position := 0
	next_position := 0
	// A simple state machine to indicate if we are currently tokenizing a token
	// or skipping characters due to error.
	tokenization_state : TokenizationState
	current_token : Token
	// Loop through each byte
	for next_position < len(source_text) {
		current_position = next_position
		next_position += 1
		column_number += 1

		character := source_text[current_position]

		// Skip all whitespace
		if is_whitespace(character) {
			if tokenization_state == .CurrentlyTokenizing {
				// If we hit whitespace after an identifier, append token to output!
				current_token.length = current_position - current_token.start_byte
				when ODIN_DEBUG {
					log.debugf(
						"> Token %v: %v (%v:%v, byte %v) (%v)",
						current_token.token_index,
						source_text[current_token.start_byte:(current_token.start_byte + current_token.length)],
						current_token.line_number,
						current_token.column_number,
						current_token.start_byte,
						current_token.type
					)
				}
				append(&tokens, current_token)
				current_token = {}
				tokenization_state = .Idle
			} else if tokenization_state == .CurrentlyError {
				// Reset now that we are going to next token
				tokenization_state = .Idle
			}

			// A newline increments line number and resets column number
			if character == '\n' {
				line_number += 1
				column_number = 0
				line_start_byte = current_position + 1
			}

			when ODIN_DEBUG {
				if character == '\n' {
					log.debugf("--------------------------(newline)--------------------------")
				}
			}
			continue
		} else if tokenization_state == .CurrentlyError {
			continue
		}

		// Something other than whitespace! Let's figure out what it is
		if tokenization_state == .Idle {
			// Append byte position of new word to output
			current_token = Token {
				start_byte = current_position,
				// We will fill in length at end of parsing token
				line_number = line_number,
				column_number = column_number,
				token_index = token_index,
			}

			// Figure out what the type is based on the first character
			if character == ':' {
				current_token.type = .OperatorBinaryAssignment
			} else if character >= '0' && character <= '9' {
				current_token.type = .ConstantInteger
			} else {
				current_token.type = .IdentifierVariable
			}

			token_index += 1
			tokenization_state = .CurrentlyTokenizing
			continue
		}

		// Check that the next character isn't obviously syntactically incorrect
		if
			current_token.type == .ConstantInteger &&
			((character < '0' || character > '9') && character != '_')
		{
			error := Error {
				type = .TokenizationInvalidNumber,
				start_byte = current_position,
				line_start_byte = line_start_byte,
				line_number = line_number,
				column_number = column_number,
			}
			append(&errors, error)
			tokenization_state = .CurrentlyError
			current_token = {}
			token_index -= 1
		}
	}

	// Assume source text ends in whitespace, so final token gets appended
	return tokens, errors
}

token_index_to_string :: proc(token_idx: int, tokens: [dynamic]Token, source_text: string) -> string {
	return token_to_string(tokens[token_idx], source_text)
}

token_to_string :: proc(token: Token, source_text: string) -> string {
	return source_text[token.start_byte:(token.start_byte + token.length)]
}

is_whitespace :: proc(character: u8) -> bool {
	return character == ' ' || character == '\t' || character == '\n'
}

////////////////////////////////////////////////////////////////////////////////
// Errors
////////////////////////////////////////////////////////////////////////////////

ErrorType :: enum {
	TokenizationInvalidNumber,
}

Error :: struct {
	type: ErrorType,
	start_byte: int,
	line_start_byte: int,  // To find the line length, just iterate until next \n
	line_number: int,
	column_number: int,
}

// Generate a nice-looking error message from a tokenization error.
// Allocates using context's temporary allocator; free using `free_all(context.temp_allocator)`
//
// Example output:
//   Error: Tokenization: Invalid Number (1:12; byte 11)
//       a := 234234h //extra line context
//       -----------^
generate_error_message :: proc(error: Error, source_text: string) -> string {
	// Use a string builder to generate a string with multiple lines
	builder := strings.builder_make(context.temp_allocator)
	strings.write_string(&builder, "Error: ")

	// Print out the error information
	switch (error.type) {
	case .TokenizationInvalidNumber:
		strings.write_string(&builder, "Tokenization: Invalid Number")
	}
	strings.write_string(&builder, " (")
	strings.write_int(&builder, error.line_number)
	strings.write_rune(&builder, ':')
	strings.write_int(&builder, error.column_number)
	strings.write_string(&builder, "; byte ")
	strings.write_int(&builder, error.start_byte)
	strings.write_string(&builder, ")\n")

	// Get the byte location for the end of the line
	line_end_byte := error.line_start_byte
	for character in source_text[error.line_start_byte:] {
		if character == '\n' {
			break
		} else {
			line_end_byte += utf8.rune_size(character)
		}
		// TODO: Limit line length to a maximum?
	}

	// Print out the line in the source text
	strings.write_string(&builder, "    ") // Indentation
	strings.write_string(&builder, source_text[error.line_start_byte:line_end_byte])
	strings.write_rune(&builder, '\n')

	// Print an arrow to indicate which column in the source text line has the error
	strings.write_string(&builder, "    ") // Indentation
	cursor := 1
	for cursor < error.column_number {
		strings.write_rune(&builder, '-')
		cursor += 1
	}
	strings.write_rune(&builder, '^')
	strings.write_rune(&builder, '\n')

	return strings.to_string(builder)
}

////////////////////////////////////////////////////////////////////////////////
// Parsing
////////////////////////////////////////////////////////////////////////////////

AstNodeType :: enum {
	Nil,
	Assignment,
}

AstNode :: struct {
	type: AstNodeType,  // Source is the right side of the assignment
	sourceType: ValueType,
	sourceToken: int,  // The index into the token stream for this value
	destType: ValueType,  // Dest is the left side of the assignment
	destToken: int,  // The index into the token stream for this value
}

ValueType :: enum {
	Nil,
	Variable,
	NumberConstant
}


parse :: proc(tokens: [dynamic]Token, allocator: runtime.Allocator) -> ([dynamic]AstNode) {
	nodes := make([dynamic]AstNode, allocator)

	curr_token := 0
	curr_statement := 0
	total_tokens := len(tokens)
	for curr_token < total_tokens {
		token := tokens[curr_token]
		switch token.type {
		case .Nil:
			unimplemented()
		case .IdentifierVariable:
			if curr_token + 1 >= total_tokens {
				// Not enough tokens left to finish assignment
				continue
			}
			next_token := tokens[curr_token + 1]
			if next_token.type == .OperatorBinaryAssignment {
				node, tokens_eaten := parse_statement_assignment(tokens, curr_token)
				append_elem(&nodes, node)
				curr_token += tokens_eaten
				curr_statement += 1
			} else {
				unimplemented()
			}
		case .OperatorBinaryAssignment:
			unimplemented()
		case .ConstantInteger:
			unimplemented()
		}
	}

	return nodes
}

// Parse an assignment statement and return an AstNode and the number of tokens it consumed
// The assignment statement expects a left side, an assigment operator, and a right side
parse_statement_assignment :: proc(tokens: [dynamic]Token, current_token_idx: int) -> (AstNode, int) {
	next_token_idx := current_token_idx
	node := AstNode {
		type = .Assignment
	}

	left_side := tokens[next_token_idx]
	if left_side.type != .IdentifierVariable {
		panic("Assignment statement expected identifier variable for left side")
	}
	node.destType = .Variable
	node.destToken = next_token_idx
	next_token_idx += 1

	assignment_operator := tokens[next_token_idx]
	if assignment_operator.type != .OperatorBinaryAssignment {
		panic("Assignment statement expected binary assignment operator")
	}
	next_token_idx += 1

	right_side := tokens[next_token_idx]
	if right_side.type == .IdentifierVariable {
		node.sourceType = .Variable
	} else if right_side.type == .ConstantInteger {
		node.sourceType = .NumberConstant
	} else {
		panic("Assignment statement expected variable or constant for right side")
	}
	node.sourceToken = next_token_idx
	next_token_idx += 1

	total_tokens := next_token_idx - current_token_idx

	return node, total_tokens
}

////////////////////////////////////////////////////////////////////////////////
// Execution
////////////////////////////////////////////////////////////////////////////////

InterpreterState :: struct {
	// Keep track of variable names, in order of creation
	var_names: [dynamic]string,
	// Keep track of variable values
	var_values: map[string]int,
}

init_state :: proc(allocator: runtime.Allocator) -> InterpreterState {
	state := InterpreterState {
		var_names = make([dynamic]string, allocator),
		var_values = make(map[string]int, allocator),
	}
	return state
}

// Execute the tokens directly and return a ProgramState struct, initializing state if nil
execute :: proc(tokens: [dynamic]Token, source_text: string, state: ^InterpreterState, allocator: runtime.Allocator) {
	// Execution state
	is_doing_assignment : bool
	dest_identifier : Token
	source_token : Token

	for token in tokens {
		switch token.type {
		case .Nil:
			continue
		case .IdentifierVariable:
			if is_doing_assignment {
				source_token = token
			} else {
				dest_identifier = token
			}
		case .OperatorBinaryAssignment:
			is_doing_assignment = true
			// clear any source tokens
			source_token = {}
		case .ConstantInteger:
			if is_doing_assignment {
				source_token = token
			}
		}

		// We have enough context to do an assignment operation!:
		// destination := source
		if dest_identifier.type != .Nil && is_doing_assignment && source_token.type != .Nil {
			dest_var_name := strings.clone(source_text[dest_identifier.start_byte:][:dest_identifier.length], allocator)
			if !(dest_var_name in state.var_values) {
				// First time we've seen this variable! Create it
				append_elem(&state.var_names, dest_var_name)
			}
			source_value : int
			ok : bool
			switch source_token.type {
			case .IdentifierVariable:
				source_var_name := source_text[source_token.start_byte:][:source_token.length]
				if source_value, ok = state.var_values[source_var_name]; !ok {
					unimplemented("Tried to read from variable before it had a value!")
				}
			case .ConstantInteger:
				source_value_string := source_text[source_token.start_byte:][:source_token.length]
				if source_value, ok = strconv.parse_int(source_value_string); !ok {
					unimplemented(fmt.tprintfln("Can't parse constant integer %v", source_value_string))
				}
			case .Nil:
				fallthrough
			case .OperatorBinaryAssignment:
				unimplemented(fmt.tprintfln("Can't assign a source/righthand value for token type %v", source_token.type))
			}

			// Do the actual assignment, overwriting anything already there
			state.var_values[dest_var_name] = source_value

			// Reset for next assignment operation
			is_doing_assignment = false
			dest_identifier = {}
			source_token = {}
		}
	}
}

print_interpreter_state :: proc (state: ^InterpreterState) {
	builder := strings.builder_make(context.temp_allocator)
	strings.write_string(&builder, "Interpreter State:\n")

	for variable in state.var_names {
		strings.write_string(&builder, variable)
		strings.write_string(&builder, " = ")
		strings.write_int(&builder, state.var_values[variable])
		strings.write_rune(&builder, '\n')
	}

	fmt.print(strings.to_string(builder))
}


////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////
// odin test . -debug -define:ODIN_TEST_SHORT_LOGS=true -define:ODIN_TEST_THREADS=1
import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	source_text := "This   is my program\nLine two\n Line  three \n"
	tokens, _ := tokenize(source_text, context.temp_allocator)
	testing.expect_value(t, token_to_string(tokens[0], source_text), "This")
	testing.expect_value(t, tokens[0].line_number, 1)
	testing.expect_value(t, tokens[0].column_number, 1)
	testing.expect_value(t, tokens[0].token_index, 0)
	testing.expect_value(t, token_to_string(tokens[1], source_text), "is")
	testing.expect_value(t, tokens[1].line_number, 1)
	testing.expect_value(t, tokens[1].column_number, 8)
	testing.expect_value(t, tokens[1].token_index, 1)
	testing.expect_value(t, token_to_string(tokens[2], source_text), "my")
	testing.expect_value(t, tokens[2].line_number, 1)
	testing.expect_value(t, tokens[2].column_number, 11)
	testing.expect_value(t, tokens[2].token_index, 2)
	testing.expect_value(t, token_to_string(tokens[3], source_text), "program")
	testing.expect_value(t, tokens[3].line_number, 1)
	testing.expect_value(t, tokens[3].column_number, 14)
	testing.expect_value(t, tokens[3].token_index, 3)
	testing.expect_value(t, token_to_string(tokens[4], source_text), "Line")
	testing.expect_value(t, tokens[4].line_number, 2)
	testing.expect_value(t, tokens[4].column_number, 1)
	testing.expect_value(t, tokens[4].token_index, 4)
	testing.expect_value(t, token_to_string(tokens[5], source_text), "two")
	testing.expect_value(t, tokens[5].line_number, 2)
	testing.expect_value(t, tokens[5].column_number, 6)
	testing.expect_value(t, tokens[5].token_index, 5)
	testing.expect_value(t, token_to_string(tokens[6], source_text), "Line")
	testing.expect_value(t, tokens[6].line_number, 3)
	testing.expect_value(t, tokens[6].column_number, 2)
	testing.expect_value(t, tokens[6].token_index, 6)
	testing.expect_value(t, token_to_string(tokens[7], source_text), "three")
	testing.expect_value(t, tokens[7].line_number, 3)
	testing.expect_value(t, tokens[7].column_number, 8)
	testing.expect_value(t, tokens[7].token_index, 7)
}

@(test)
test_tokenize_005 :: proc(t: ^testing.T) {
	source_text := "my_var_1 := 1_337\nmy_var_2 := 663\n"
	tokens, _ := tokenize(source_text, context.temp_allocator)
	testing.expect_value(t, token_to_string(tokens[0], source_text), "my_var_1")
	testing.expect_value(t, tokens[0].line_number, 1)
	testing.expect_value(t, tokens[0].column_number, 1)
	testing.expect_value(t, tokens[0].token_index, 0)
	testing.expect_value(t, token_to_string(tokens[1], source_text), ":=")
	testing.expect_value(t, tokens[1].line_number, 1)
	testing.expect_value(t, tokens[1].column_number, 10)
	testing.expect_value(t, tokens[1].token_index, 1)
	testing.expect_value(t, token_to_string(tokens[2], source_text), "1_337")
	testing.expect_value(t, tokens[2].line_number, 1)
	testing.expect_value(t, tokens[2].column_number, 13)
	testing.expect_value(t, tokens[2].token_index, 2)
	testing.expect_value(t, token_to_string(tokens[3], source_text), "my_var_2")
	testing.expect_value(t, tokens[3].line_number, 2)
	testing.expect_value(t, tokens[3].column_number, 1)
	testing.expect_value(t, tokens[3].token_index, 3)
	testing.expect_value(t, token_to_string(tokens[4], source_text), ":=")
	testing.expect_value(t, tokens[4].line_number, 2)
	testing.expect_value(t, tokens[4].column_number, 10)
	testing.expect_value(t, tokens[4].token_index, 4)
	testing.expect_value(t, token_to_string(tokens[5], source_text), "663")
	testing.expect_value(t, tokens[5].line_number, 2)
	testing.expect_value(t, tokens[5].column_number, 13)
	testing.expect_value(t, tokens[5].token_index, 5)
}

@(test)
test_tokenize_006 :: proc(t: ^testing.T) {
	source_text := "1_my_var_ := 1_337\nmy_var_2 := 6^3\n"
	_, errors := tokenize(source_text, context.temp_allocator)
	testing.expect_value(t, errors[0].type, ErrorType.TokenizationInvalidNumber)
	testing.expect_value(t, errors[0].line_number, 1)
	testing.expect_value(t, errors[0].column_number, 3)
	testing.expect_value(t, errors[1].type, ErrorType.TokenizationInvalidNumber)
	testing.expect_value(t, errors[1].line_number, 2)
	testing.expect_value(t, errors[1].column_number, 14)
}

@(test)
test_execute_009 :: proc(t: ^testing.T) {
	source_text := "a := 1\nb := 3\nc := b\nd := c\n"
	tokens, errors := tokenize(source_text, context.temp_allocator)
	testing.expect_value(t, len(errors), 0)
	state : InterpreterState = init_state(context.temp_allocator)
	execute(tokens, source_text, &state, context.temp_allocator)
	testing.expect_value(t, state.var_names[0], "a")
	testing.expect_value(t, state.var_values[state.var_names[0]], 1)
	testing.expect_value(t, state.var_names[1], "b")
	testing.expect_value(t, state.var_values[state.var_names[1]], 3)
	testing.expect_value(t, state.var_names[2], "c")
	testing.expect_value(t, state.var_values[state.var_names[2]], 3)
	testing.expect_value(t, state.var_names[3], "d")
	testing.expect_value(t, state.var_values[state.var_names[3]], 3)
}

@(test)
test_parse_011 :: proc(t: ^testing.T) {
	source_text := "a := 1\nb := 3\nc := b\nd := c\n"
	tokens, tokenization_errors := tokenize(source_text, context.temp_allocator)
	testing.expect_value(t, len(tokenization_errors), 0)
	statements := parse(tokens, context.temp_allocator)
	testing.expect_value(t, len(statements), 4)
	testing.expect_value(t, statements[0].type, AstNodeType.Assignment)
	testing.expect_value(t, statements[0].destType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[0].destToken, tokens, source_text), "a")
	testing.expect_value(t, statements[0].sourceType, ValueType.NumberConstant)
	testing.expect_value(t, token_index_to_string(statements[0].sourceToken, tokens, source_text), "1")
	testing.expect_value(t, statements[1].type, AstNodeType.Assignment)
	testing.expect_value(t, statements[1].destType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[1].destToken, tokens, source_text), "b")
	testing.expect_value(t, statements[1].sourceType, ValueType.NumberConstant)
	testing.expect_value(t, token_index_to_string(statements[1].sourceToken, tokens, source_text), "3")
	testing.expect_value(t, statements[2].type, AstNodeType.Assignment)
	testing.expect_value(t, statements[2].destType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[2].destToken, tokens, source_text), "c")
	testing.expect_value(t, statements[2].sourceType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[2].sourceToken, tokens, source_text), "b")
	testing.expect_value(t, statements[3].type, AstNodeType.Assignment)
	testing.expect_value(t, statements[3].destType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[3].destToken, tokens, source_text), "d")
	testing.expect_value(t, statements[3].sourceType, ValueType.Variable)
	testing.expect_value(t, token_index_to_string(statements[3].sourceToken, tokens, source_text), "c")
}
