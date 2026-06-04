package lowkey

import "core:fmt"
import "core:log"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

when !ODIN_DEBUG { _ :: log } // Avoid unused import error for log

main :: proc() {
	fmt.println("Welcome to the Lowkey compiler! Starting REPL mode:")

	input_buffer: [1024]byte
	for {
		defer free_all(context.temp_allocator)

		fmt.print("> ")
		n, err := os.read(os.stdin, input_buffer[:])
		if err != nil {
			fmt.eprintln("Error reading:", err)
			return
		}

		source_text := string(input_buffer[:n])

		// Tokenize input
		tokens, errors := tokenize(source_text)

		// Print out any errors
		if len(errors) > 0 {
			for error in errors {
				fmt.eprint(generate_error_message(error, source_text))
			}
			continue
		}

		// Print out output
		for token in tokens {
			fmt.println(token)
		}
	}
}

TokenType :: enum {
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

TokenizationErrorType :: enum {
	InvalidNumber,
}

TokenizationError :: struct {
	type: TokenizationErrorType,
	start_byte: int,
	line_start_byte: int,  // To find the line length, just iterate until next \n
	line_number: int,
	column_number: int,
}

tokenize :: proc(source_text: string) -> ([dynamic]Token, [dynamic]TokenizationError) {
	// TODO: Assert that source file length is < INT_MAX
	// TODO: Assert that source file ends with whitespace
	when ODIN_DEBUG {
		log.debug("tokenize() source text:")
		log.debug("---------------------------------------------------------")
		log.debug(source_text)
		log.debug("---------------------------------------------------------")
	}

	tokens := make([dynamic]Token, context.temp_allocator)
	errors := make([dynamic]TokenizationError, context.temp_allocator)

	line_number := 1
	line_start_byte := 0
	column_number := 0
	token_index := 0

	current_position := 0
	next_position := 0
	// A simple state machine to indicate if we are tokenizing a word or not as
	// we loop through characters.
	currently_tokenizing := false
	current_token : Token
	skip_to_next_token_on_error := false
	// Loop through each byte
	for next_position < len(source_text) {
		current_position = next_position
		next_position += 1
		column_number += 1

		character := source_text[current_position]

		// Skip all whitespace
		if is_whitespace(character) {
			// If we hit whitespace after an identifier, append token to output!
			if currently_tokenizing {
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
				currently_tokenizing = false
			} else if skip_to_next_token_on_error {
				// Reset now that we are going to next token
				skip_to_next_token_on_error = false
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
		} else if skip_to_next_token_on_error {
			continue
		}

		// Something other than whitespace! Let's figure out what it is
		if !currently_tokenizing {
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
			currently_tokenizing = true
			continue
		}

		// Check that the next character isn't obviously syntactically incorrect
		if
			current_token.type == .ConstantInteger &&
			((character < '0' || character > '9') && character != '_')
		{
			error := TokenizationError {
				type = .InvalidNumber,
				start_byte = current_position,
				line_start_byte = line_start_byte,
				line_number = line_number,
				column_number = column_number,
			}
			append(&errors, error)
			skip_to_next_token_on_error = true
			currently_tokenizing = false
			current_token = {}
			token_index -= 1

			when ODIN_DEBUG {
				end := line_start_byte;
				for end < len(source_text) && source_text[end] != '\n'{
					end += 1
				}
				log.debugf(
					"> Token Error: %v (%v:%v, byte %v) (%v)",
					source_text[error.line_start_byte:end],
					error.line_number,
					error.column_number,
					error.start_byte,
					error.type
				)
			}
		}
	}

	// Assume source text ends in whitespace, so final token gets appended
	return tokens, errors
}

token_to_string :: proc(token: Token, source_text: string) -> string {
	return source_text[token.start_byte:(token.start_byte + token.length)]
}

is_whitespace :: proc(character: u8) -> bool {
	return character == ' ' || character == '\t' || character == '\n'
}

// Generate a nice-looking error message from a tokenization error.
// Allocates using context's temporary allocator; free using `free_all(context.temp_allocator)`
//
// Example output:
//   Tokenization Error: Invalid Number (1:12; byte 11)
//       a := 234234h //extra line context
//       -----------^
generate_error_message :: proc(error: TokenizationError, source_text: string) -> string {
	// Use a string builder to generate a string with multiple lines
	builder := strings.builder_make(context.temp_allocator)
	strings.write_string(&builder, "Tokenization Error: ")

	// Print out the error information
	switch (error.type) {
	case .InvalidNumber:
		strings.write_string(&builder, "Invalid Number (")
		strings.write_int(&builder, error.line_number)
		strings.write_rune(&builder, ':')
		strings.write_int(&builder, error.column_number)
		strings.write_string(&builder, "; byte ")
		strings.write_int(&builder, error.start_byte)
		strings.write_string(&builder, ")\n")
	}

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
// Tests
//
// odin test . -debug -define:ODIN_TEST_SHORT_LOGS=true -define:ODIN_TEST_THREADS=1
////////////////////////////////////////////////////////////////////////////////
import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	source_text := "This   is my program\nLine two\n Line  three \n"
	output, _ := tokenize(source_text)
	testing.expect_value(t, token_to_string(output[0], source_text), "This")
	testing.expect_value(t, output[0].line_number, 1)
	testing.expect_value(t, output[0].column_number, 1)
	testing.expect_value(t, output[0].token_index, 0)
	testing.expect_value(t, token_to_string(output[1], source_text), "is")
	testing.expect_value(t, output[1].line_number, 1)
	testing.expect_value(t, output[1].column_number, 8)
	testing.expect_value(t, output[1].token_index, 1)
	testing.expect_value(t, token_to_string(output[2], source_text), "my")
	testing.expect_value(t, output[2].line_number, 1)
	testing.expect_value(t, output[2].column_number, 11)
	testing.expect_value(t, output[2].token_index, 2)
	testing.expect_value(t, token_to_string(output[3], source_text), "program")
	testing.expect_value(t, output[3].line_number, 1)
	testing.expect_value(t, output[3].column_number, 14)
	testing.expect_value(t, output[3].token_index, 3)
	testing.expect_value(t, token_to_string(output[4], source_text), "Line")
	testing.expect_value(t, output[4].line_number, 2)
	testing.expect_value(t, output[4].column_number, 1)
	testing.expect_value(t, output[4].token_index, 4)
	testing.expect_value(t, token_to_string(output[5], source_text), "two")
	testing.expect_value(t, output[5].line_number, 2)
	testing.expect_value(t, output[5].column_number, 6)
	testing.expect_value(t, output[5].token_index, 5)
	testing.expect_value(t, token_to_string(output[6], source_text), "Line")
	testing.expect_value(t, output[6].line_number, 3)
	testing.expect_value(t, output[6].column_number, 2)
	testing.expect_value(t, output[6].token_index, 6)
	testing.expect_value(t, token_to_string(output[7], source_text), "three")
	testing.expect_value(t, output[7].line_number, 3)
	testing.expect_value(t, output[7].column_number, 8)
	testing.expect_value(t, output[7].token_index, 7)
}

@(test)
test_tokenize_005 :: proc(t: ^testing.T) {
	source_text := "my_var_1 := 1_337\nmy_var_2 := 663\n"
	output, _ := tokenize(source_text)
	testing.expect_value(t, token_to_string(output[0], source_text), "my_var_1")
	testing.expect_value(t, output[0].line_number, 1)
	testing.expect_value(t, output[0].column_number, 1)
	testing.expect_value(t, output[0].token_index, 0)
	testing.expect_value(t, token_to_string(output[1], source_text), ":=")
	testing.expect_value(t, output[1].line_number, 1)
	testing.expect_value(t, output[1].column_number, 10)
	testing.expect_value(t, output[1].token_index, 1)
	testing.expect_value(t, token_to_string(output[2], source_text), "1_337")
	testing.expect_value(t, output[2].line_number, 1)
	testing.expect_value(t, output[2].column_number, 13)
	testing.expect_value(t, output[2].token_index, 2)
	testing.expect_value(t, token_to_string(output[3], source_text), "my_var_2")
	testing.expect_value(t, output[3].line_number, 2)
	testing.expect_value(t, output[3].column_number, 1)
	testing.expect_value(t, output[3].token_index, 3)
	testing.expect_value(t, token_to_string(output[4], source_text), ":=")
	testing.expect_value(t, output[4].line_number, 2)
	testing.expect_value(t, output[4].column_number, 10)
	testing.expect_value(t, output[4].token_index, 4)
	testing.expect_value(t, token_to_string(output[5], source_text), "663")
	testing.expect_value(t, output[5].line_number, 2)
	testing.expect_value(t, output[5].column_number, 13)
	testing.expect_value(t, output[5].token_index, 5)
}

@(test)
test_tokenize_006 :: proc(t: ^testing.T) {
	source_text := "1_my_var_ := 1_337\nmy_var_2 := 6^3\n"
	_, errors := tokenize(source_text)
	testing.expect_value(t, errors[0].type, TokenizationErrorType.InvalidNumber)
	testing.expect_value(t, errors[0].line_number, 1)
	testing.expect_value(t, errors[0].column_number, 3)
	testing.expect_value(t, errors[1].type, TokenizationErrorType.InvalidNumber)
	testing.expect_value(t, errors[1].line_number, 2)
	testing.expect_value(t, errors[1].column_number, 14)
}
