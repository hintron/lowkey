package lowkey

import "core:fmt"

main :: proc() {
	fmt.println("Hello, world, from the Lowkey compiler!")
}

TokenType :: enum {
	IdentifierVariable,
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

	output := make([dynamic]Token, context.temp_allocator)

	line_number := 1
	column_number := 0
	token_index := 0

	current_position := 0
	next_position := 0
	// A simple state machine to indicate if we are tokenizing a word or not as
	// we loop through characters.
	tokenizing_word := false
	current_token : Token
	// Loop through each byte
	for next_position < len(source_text) {
		current_position = next_position
		next_position += 1
		column_number += 1

		character := source_text[current_position]

		// Skip all whitespace
		if is_whitespace(character) {
			when ODIN_DEBUG {
				fmt.printf(">>>>>>>> Found whitespace                  ( byte: % 4v | line: % 3v | col: % 3v | token idx: % 3v )\n", current_position, line_number, column_number, token_index)
			}

			// If we hit whitespace after an identifier, append token to output!
			if tokenizing_word {
				current_token.length = current_position - current_token.start_byte
				append(&output, current_token)
				tokenizing_word = false
			}

			// A newline increments line number and resets column number
			if character == '\n' {
				line_number += 1
				column_number = 0
			}
			continue
		}

		// Anything other than whitespace is an identifier! (for now)
		if !tokenizing_word {
			// Append byte position of new word to output
			current_token = Token {
				type = .IdentifierVariable,
				start_byte = current_position,
				// We will fill in length at end of parsing token
				line_number = line_number,
				column_number = column_number,
				token_index = token_index,
			}
			token_index += 1
			tokenizing_word = true

			when ODIN_DEBUG {
				fmt.printf(">>>>>>>> Found Token (%v)  ( byte: % 4v | line: % 3v | col: % 3v | token idx: % 3v )\n", current_token.type, current_position, line_number, column_number, token_index)
			}
		}
	}

	// Assume source text ends in whitespace, so final token gets appended
	return output
}

token_to_string :: proc(token: Token, source_text: string) -> string {
	return source_text[token.start_byte:(token.start_byte + token.length)]
}

is_whitespace :: proc(character: u8) -> bool {
	return character == ' ' || character == '\t' || character == '\n'
}

////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////
import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	source_text := "This   is my program\nLine two\n Line  three \n"
	when ODIN_DEBUG {
		fmt.println("Testing tokenize() with source text:")
		fmt.println("---------------------------------------------------------")
		fmt.println(source_text)
		fmt.println("---------------------------------------------------------")
	}
	output := tokenize(source_text)
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
