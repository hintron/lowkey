package lowkey

import "core:fmt"

main :: proc() {
	fmt.println("Hello, world, from the Lowkey compiler!")
}


tokenize :: proc(source_text: string) -> [dynamic]u8 {
	output := make([dynamic]u8, context.temp_allocator)
	position := 0

	// A simple state machine to indicate if we are tokenizing a word or not as
	// we loop through characters.
	tokenizing_word := false

	// Loop through each byte
	for position < len(source_text) {
		current_position := position
		position += 1

		character := source_text[current_position]

		// Skip all whitespace
		if character == ' ' || character == '\t' || character == '\n' {
			tokenizing_word = false
			continue
		}

		// Anything other than whitespace is a word! (for now)
		if !tokenizing_word {
			// Append byte position of new word to output
			append(&output, u8(current_position))
			tokenizing_word = true
		}
	}
	return output
}

////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////
import "core:testing"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	source_text := "This   is my program."
	output := tokenize(source_text)
	testing.expect_value(t, output[0], 0)
	testing.expect_value(t, output[1], 7)
	testing.expect_value(t, output[2], 10)
	testing.expect_value(t, output[3], 13)
}