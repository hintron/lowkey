package main

import "core:fmt"

Token :: enum {
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

OperatorBinary :: struct {
	type: Token,
	precedence: i8,
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
		return Token.EndOfExpression, position
	}

	next_position := position + 1
	if expr[position] == '>' {
		fmt.println("Found operator: >")
		return Token.GreaterThan, next_position
	} else if expr[position] == '+' {
		fmt.println("Found operator: +")
		return Token.Addition, next_position
	} else if expr[position] == '*' {
		fmt.println("Found operator: *")
		return Token.Multiplication, next_position
	} else if expr[position] >= 'a' && expr[position] <= 'z' {
		identifier_start := position
		// Parse an identifier (variable name)
		for next_position < len(expr) && expr[next_position] >= 'a' && expr[next_position] <= 'z' {
			next_position += 1
		}
		identifier_end := next_position
		fmt.printfln("Found identifier: %v", expr[identifier_start:identifier_end])
		return Token.Identifier, next_position
	} else if expr[position] == ' ' {
		fmt.println("Found whitespace: space")
		return Token.WhitespaceSpace, next_position
	} else if expr[position] == '\t' {
		fmt.println("Found whitespace: tab")
		return Token.WhitespaceTab, next_position
	} else if expr[position] == '\n' {
		fmt.println("Found whitespace: newline")
		return Token.WhitespaceNewline, next_position
	} else {
		fmt.println("Found unrecognized character:")
		// Skip whitespace and unrecognized characters
		return Token.UnrecognizedCharacter, next_position
	}
}

main :: proc() {
	// expression_to_parse := "a > bb + ccc * dddd + eeeee"
	expression_to_parse := "aaa > b"
	pos := 0
	new_pos := 0

	fmt.println("Parsing expression:", expression_to_parse)

	for pos < len(expression_to_parse) {
		token, new_pos := get_next_token(expression_to_parse, pos)
		pos = new_pos
	}
}

