package lowkey

import "core:fmt"
import "core:log"

when !ODIN_DEBUG { _ :: log } // Avoid unused import error for log

main :: proc() {
	fmt.println("Hello, world, from the Lowkey compiler!")
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

tokenize :: proc(source_text: string) -> [dynamic]Token {
	// TODO: Assert that source file length is < INT_MAX
	// TODO: Assert that source file ends with whitespace
	when ODIN_DEBUG {
		log.debug("tokenize() source text:")
		log.debug("---------------------------------------------------------")
		log.debug(source_text)
		log.debug("---------------------------------------------------------")
	}

	tokens := make([dynamic]Token)

	line_number := 1
	column_number := 0
	token_index := 0

	current_position := 0
	next_position := 0
	// A simple state machine to indicate if we are tokenizing a word or not as
	// we loop through characters.
	currently_tokenizing := false
	current_token : Token
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
			}

			// A newline increments line number and resets column number
			if character == '\n' {
				line_number += 1
				column_number = 0
			}

			when ODIN_DEBUG {
				if character == '\n' {
					log.debugf("--------------------------(newline)--------------------------")
				}
			}
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
		}
	}

	// Assume source text ends in whitespace, so final token gets appended
	return tokens
}

token_to_string :: proc(token: Token, source_text: string) -> string {
	return source_text[token.start_byte:(token.start_byte + token.length)]
}

is_whitespace :: proc(character: u8) -> bool {
	return character == ' ' || character == '\t' || character == '\n'
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
	tokens := tokenize(source_text)
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
	delete(tokens)
}

@(test)
test_tokenize_005 :: proc(t: ^testing.T) {
	source_text := "my_var_1 := 1_337\nmy_var_2 := 663\n"
	tokens := tokenize(source_text)
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
	delete(tokens)
}
