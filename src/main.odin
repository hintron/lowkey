package main

import "core:fmt"
import "core:strings"

MAX_TOKENS :: 2 << 20 // 1 MB

////////////////////////////////////////////////////////////////////////////////
// Tokenization/lexing/scanning
////////////////////////////////////////////////////////////////////////////////
Token :: struct {
	type: TokenType,
	value: string, // The value of the token. Only needed when TokenType is Identifier
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
get_next_token :: proc(expr: string, position: int) -> (Token, int) {
	// fmt.println("Getting next token starting at position", position)
	fmt.printfln("%v", expr)
	for i in 0..<position {
		fmt.print("-")
	}
	fmt.printfln("^		(pos=%v)", position)

	if position >= len(expr) {
		return Token {
			type = .EndOfExpression,
		}, position
	}

	next_position := position + 1
	if expr[position] == '>' {
		fmt.println("Found operator: >")
		return Token {
			type = .GreaterThan,
		}, next_position
	} else if expr[position] == '+' {
		fmt.println("Found operator: +")
		return Token {
			type = .Addition,
		}, next_position
	} else if expr[position] == '*' {
		fmt.println("Found operator: *")
		return Token {
			type = .Multiplication,
		}, next_position
	} else if expr[position] >= 'a' && expr[position] <= 'z' {
		identifier_start := position
		// Parse an identifier (variable name)
		for next_position < len(expr) && expr[next_position] >= 'a' && expr[next_position] <= 'z' {
			next_position += 1
		}
		identifier_end := next_position
		fmt.printfln("Found identifier: %v", expr[identifier_start:identifier_end])
		return Token {
			type = .Identifier,
			// MGH TODO: This is a memory allocation! Use arenas? Static arrays? How does Zig not allocate during tokenization?
			value = strings.clone(expr[identifier_start:identifier_end])
		}, next_position
	} else if expr[position] == ' ' {
		fmt.println("Found whitespace: space")
		return Token {
			type = .WhitespaceSpace,
		}, next_position
	} else if expr[position] == '\t' {
		fmt.println("Found whitespace: tab")
		return Token {
			type = .WhitespaceTab,
		}, next_position
	} else if expr[position] == '\n' {
		fmt.println("Found whitespace: newline")
		return Token {
			type = .WhitespaceNewline,
		}, next_position
	} else {
		fmt.println("Found unrecognized character:")
		// Skip whitespace and unrecognized characters
		return Token {
			type = .UnrecognizedCharacter,
		}, next_position
	}
}

tokenize :: proc(expr: string) -> [dynamic]Token {
	fmt.println("Tokenizing expression:", expr)

	pos := 0
	new_pos := 0
	invalid_token_count := 0
	token_list := make([dynamic]Token, 0, MAX_TOKENS)

	for pos < len(expr) {
		token, new_pos := get_next_token(expr, pos)
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

	token_list := tokenize(expression_to_parse)
	// TODO: Loop through the token list and create an AST with precedence
}

// TODO: Create tests for the tokenizer

