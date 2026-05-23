package lowkey

import "core:fmt"

main :: proc() {
	fmt.println("Hello, world, from the Lowkey compiler!")
}


tokenize :: proc(source_text: string) -> [dynamic]u8 {
	output := make([dynamic]u8, context.temp_allocator)
	append(&output, 0)
	append(&output, 7)
	append(&output, 10)
	append(&output, 13)
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
	testing.expect_value(t, output[0], 7)
	testing.expect_value(t, output[0], 10)
	testing.expect_value(t, output[0], 13)
}