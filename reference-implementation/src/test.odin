package main

import "core:testing"

@(test)
test_tokenize_a :: proc(t: ^testing.T) {
	token_list := tokenize("a")
	defer delete(token_list)
	testing.expect(t, len(token_list) == 1, "Expected 1 tokens")
}

@(test)
test_tokenize_a_gt_b :: proc(t: ^testing.T) {
	token_list := tokenize("a > b")
	defer delete(token_list)
	testing.expect(t, len(token_list) == 3, "Expected 3 tokens")
}

@(test)
test_tokenize_abcde_single :: proc(t: ^testing.T) {
	token_list := tokenize("a > b + c * d + e")
	defer delete(token_list)
	testing.expect(t, len(token_list) == 9, "Expected 9 tokens")
}

@(test)
test_tokenize_abcde_multiple :: proc(t: ^testing.T) {
	token_list := tokenize("a > bb + ccc * dddd + eeeee")
	defer delete(token_list)
	testing.expect(t, len(token_list) == 9, "Expected 9 tokens")
}
