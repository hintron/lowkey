# Learnings + Bugs

The following are various notes I learned about Odin while implementing the steps.

## Step 10 - Maps don't allocate keys!

In step 10, I was trying to save a value for every variable name, so I made a `map[string]int`. In the REPL mode, the `string` keys were all pulled from the same buffer used for `os.read()`. I started getting weird results when I would do the `state` REPL command to print the state, and all my one-letter variables started with `s`.

It turned out that all the strings used as keys were still pointing to the original `os.read()` buffer! So my one-letter variables were reading the `s` in `state`, the latest text in the buffer.

This was surprising to me, because I just assumed that the keys would have been allocated using the allocator for the map. Instead, I had to put in a cloned string when creating a new value into the map.

I want to look at the implementation of a map in Odin - I believe that it does NOT allocate keys, so if a string's data was allocated on the stack (not sure if that's even possible) or if it's backed by a buffer that is being reused (my case) then that will cause problems.probably should just look at the map delete procedure to see what it tries to delete. I'm guessing it doesn't delete the keys.


## Bug - Don't include newline in source identifier in assignment!

This would produce an error:

```
> a := 5
> b := a
/home/hintron/code/lowkey/reference-implementation/step-015/main.odin(594:6) not yet implemented: Tried to read from variable 'a' before it had a value!
```

The reason for this is because `a` would be assigned 5, but then `a\n` would be used as the identifier key into the variable names map in the interpreter state. Since only `a` was set, and not `a\n`, it would fail to find `a` and hit an unimplemented error.

TODO: Fix this bug!


## Two Bugs - Stray identifier token has huge length in REPL mode, and parsing error does not cause REPL to throw away related tokens, causing the error to propagate to subsequent statements

```
Welcome to the Lowkey compiler! Starting REPL mode:
> list
Token{type = "IdentifierVariable", start_byte = 0, length = 1048580, line_number = 1, column_number = 1, line_start_byte = 0, token_index = 0, flags = bit_set[TokenFlag]{IsStatementEnd}}
Error: Parsing: Stray Identifier (1:1; byte 0)
    list
    ^
> a := 5
Token{type = "IdentifierVariable", start_byte = 0, length = 1048580, line_number = 1, column_number = 1, line_start_byte = 0, token_index = 0, flags = bit_set[TokenFlag]{IsStatementEnd}}
Token{type = "IdentifierVariable", start_byte = 1048581, length = 1, line_number = 2, column_number = 1, line_start_byte = 1048581, token_index = 1, flags = bit_set[TokenFlag]{}}
Token{type = "OperatorBinaryAssignment", start_byte = 1048583, length = 2, line_number = 2, column_number = 3, line_start_byte = 1048581, token_index = 2, flags = bit_set[TokenFlag]{}}
Token{type = "ConstantInteger", start_byte = 1048586, length = 1, line_number = 2, column_number = 6, line_start_byte = 1048581, token_index = 3, flags = bit_set[TokenFlag]{IsStatementEnd}}
Error: Parsing: Stray Identifier (1:1; byte 0)
    list
    ^
```

TODO: Figure out the reason why this happens and fix!
