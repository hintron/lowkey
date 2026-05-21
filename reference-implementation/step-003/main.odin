package lowkey

import "core:fmt"

main :: proc() {
	output := tokenize()
	fmt.println(output)
}

tokenize :: proc() -> string {
	return "Hello, world, from the Lowkey compiler!"
}

////////////////////////////////////////////////////////////////////////////////
// Tests
////////////////////////////////////////////////////////////////////////////////
import "core:testing"
import "core:os"
import "core:path/filepath"
import "core:strings"

@(test)
test_tokenize :: proc(t: ^testing.T) {
	output := tokenize()

	// Use join_path so the path works on both Windows (\) and macOS/Linux (/)
	expected_output_file, err := filepath.join({"..", "..", "tests", "step-002-1-expected.txt"}, context.temp_allocator)
	testing.expect(t, err == nil, "Could not allocate filepath")

	expected_output_bytes, err2 := os.read_entire_file_from_path(expected_output_file, context.temp_allocator);
	testing.expectf(t, err2 == nil, "Error reading file: %v (%v)", os.error_string(err2), err2)

	expected_output := strings.trim_space(string(expected_output_bytes))

	testing.expectf(t, output == expected_output, "Output does not match expected output.\nExpected:\n'%v'\nGot:\n'%v'", expected_output, output)
}