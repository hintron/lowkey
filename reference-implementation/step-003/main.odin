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
}

tokenize :: proc(source_text: string) -> [dynamic]Token {
	// TODO: Assert that source file length is < INT_MAX
	// TODO: Assert that source file ends with whitespace

	tokens := make([dynamic]Token)

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

		character := source_text[current_position]

		// Skip all whitespace
		if is_whitespace(character) {
			// If we hit whitespace after an identifier, append token to output!
			if tokenizing_word {
				current_token.length = current_position - current_token.start_byte
				append(&tokens, current_token)
				tokenizing_word = false
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
			}
			tokenizing_word = true
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
////////////////////////////////////////////////////////////////////////////////
import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	source_text := "This   is my program\n"
	tokens := tokenize(source_text)
	testing.expect_value(t, token_to_string(tokens[0], source_text), "This")
	testing.expect_value(t, token_to_string(tokens[1], source_text), "is")
	testing.expect_value(t, token_to_string(tokens[2], source_text), "my")
	testing.expect_value(t, token_to_string(tokens[3], source_text), "program")
	delete(tokens)
}