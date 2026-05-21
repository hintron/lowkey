package main

import "core:fmt"

MAX_TOKENS :: 2 << 20 // 1 MB

////////////////////////////////////////////////////////////////////////////////
// Tokenization/lexing/scanning
////////////////////////////////////////////////////////////////////////////////
MAX_INDENTIFIER_SIZE :: 256

// Make Token a "Fat Struct"
Token :: struct {
	type: TokenType,
	// The value of the token. Only needed when TokenType is Identifier
	value: [MAX_INDENTIFIER_SIZE]u8,
}

TokenType :: enum {
	GreaterThan,
	Addition,
	Multiplication,
	Identifier,
	WhitespaceSpace,
	WhitespaceTab,
	WhitespaceNewline,
	UnrecognizedCharacter,
	EndOfExpression,
}

// Takes an input string and starting position, and returns a Token type and the start position of the byte after the next token
// If an error occurred, returns is_ok := false. Otherwise, returns is_ok := true.
// TODO: Perhaps change the error into an enum that has a string error that I can return to the caller
get_next_token :: proc(expr: string, position: int) -> (Token, int, bool) {
	// fmt.println("Getting next token starting at position", position)
	fmt.printfln("%v", expr)
	for _ in 0..<position {
		fmt.print("-")
	}
	fmt.printfln("^		(pos=%v)", position)

	if position >= len(expr) {
		return Token {
			type = .EndOfExpression,
		}, position, true
	}

	next_position := position + 1
	if expr[position] == '>' {
		fmt.println("Found operator: >")
		return Token {
			type = .GreaterThan,
		}, next_position, true
	} else if expr[position] == '+' {
		fmt.println("Found operator: +")
		return Token {
			type = .Addition,
		}, next_position, true
	} else if expr[position] == '*' {
		fmt.println("Found operator: *")
		return Token {
			type = .Multiplication,
		}, next_position, true
	} else if expr[position] >= 'a' && expr[position] <= 'z' {
		identifier_start := position
		// Parse an identifier (variable name)
		// TODO: Don't iterate bytes, but rather iterate runes so utf-8 characters are supported
		// TODO: Check that the next character is not whitespace instead of in an alphabetical range
		for next_position < len(expr) && expr[next_position] >= 'a' && expr[next_position] <= 'z' {
			next_position += 1
		}
		identifier_end := next_position
		fmt.printfln("Found identifier: %v", expr[identifier_start:identifier_end])

		if len(expr[identifier_start:identifier_end]) > MAX_INDENTIFIER_SIZE {
			fmt.println("Identifier is too long for token value buffer!")
			return {}, 0, false
		}

		token := Token {
			type = .Identifier,
		}

		// Copy bytes of identifier value string into fixed value buffer
		token_value_index := 0
		identifier_index := identifier_start
		for identifier_index < identifier_end {
			token.value[token_value_index] = expr[identifier_index]
			identifier_index += 1
			token_value_index += 1
		}

		// MGH TODO: Is token copied here? Or passed by reference somehow?
		return token, next_position, true
	} else if expr[position] == ' ' {
		fmt.println("Found whitespace: space")
		return Token {
			type = .WhitespaceSpace,
		}, next_position, true
	} else if expr[position] == '\t' {
		fmt.println("Found whitespace: tab")
		return Token {
			type = .WhitespaceTab,
		}, next_position, true
	} else if expr[position] == '\n' {
		fmt.println("Found whitespace: newline")
		return Token {
			type = .WhitespaceNewline,
		}, next_position, true
	} else {
		fmt.println("Found unrecognized character:")
		// Skip whitespace and unrecognized characters
		return Token {
			type = .UnrecognizedCharacter,
		}, next_position, true
	}
}

tokenize :: proc(expr: string) -> [dynamic]Token {
	fmt.println("Tokenizing expression:", expr)

	pos := 0
	invalid_token_count := 0
	token_list := make([dynamic]Token, 0, MAX_TOKENS)

	for pos < len(expr) {
		token, new_pos, token_ok := get_next_token(expr, pos)
		if !token_ok {
			fmt.println("Error tokenizing expression at position", pos)
			break
		}

		pos = new_pos

		// Skip whitespace and unrecognized characters
		if (
			token.type == .WhitespaceSpace ||
			token.type == .WhitespaceTab ||
			token.type == .WhitespaceNewline ||
			token.type == .UnrecognizedCharacter
		) {
			invalid_token_count += 1
			continue
		}

		// Append all valid tokens to the list
		append(&token_list, token)
	}

	fmt.println("Parsed tokens (valid):")
	for token in token_list {
		fmt.println("  ", token)
	}
	fmt.printfln("(%v invalid or whitespace tokens were ignored)", invalid_token_count)
	return token_list
}


////////////////////////////////////////////////////////////////////////////////
// Parsing/Semantic Analysis, Abstract Syntax Tree (AST)
////////////////////////////////////////////////////////////////////////////////

OperatorBinary :: struct {
	type: Token,
	precedence: i8,
}


main :: proc() {
	// TODO: Use an arena allocator for each parsed line, and free it after parsing the line

	expression_to_parse := "a > b + c * d + e"
	// expression_to_parse := "a > bb + ccc * dddd + eeeee"
	// expression_to_parse := "aaa > b"

	fmt.println("Parsing expression:", expression_to_parse)

	tokenize(expression_to_parse)
	// TODO: Loop through the token list and create an AST with precedence
}

// TODO: Create tests for the tokenizer



//////////////////////////////////////////////////////////////////////////////////
// Tests
//////////////////////////////////////////////////////////////////////////////////
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
