[Previous Step](../step-003/step-003.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-005/step-005.md)

# Task

Add line number, column number, text length, and token number to `Token`s returned by `tokenize()`. Line number and column number start at 1, token index starts at 0.

Then, add a debug mode where each token is printed out after it's parsed, including its token index, text value, line number, column number, starting byte, and token type. For example:

```
---------------------------------------------------------
This   is my program
Line two
 Line  three

---------------------------------------------------------
> Token 0: This (1:1, byte 0) (IdentifierVariable)
> Token 1: is (1:8, byte 7) (IdentifierVariable)
> Token 2: my (1:11, byte 10) (IdentifierVariable)
> Token 3: program (1:14, byte 13) (IdentifierVariable)
--------------------------(newline)--------------------------
> Token 4: Line (2:1, byte 21) (IdentifierVariable)
> Token 5: two (2:6, byte 26) (IdentifierVariable)
--------------------------(newline)--------------------------
> Token 6: Line (3:2, byte 31) (IdentifierVariable)
> Token 7: three (3:8, byte 37) (IdentifierVariable)
--------------------------(newline)--------------------------
```

(Note: The byte numbers above are from running on Linux and will probably be slightly different if you are on Windows, since Windows newlines are CR + LF instead of just LF.)

# Tests

  Input (source text):
  ```
  This   is my program\nLine two\n Line  three \n
  ```

  Expected result (`token <token_index>: <text> (<line_number>:<column_number>)`):

  ```
  token 0: This (1:1)
  token 1: is (1:8)
  token 2: my (1:11)
  token 3: program (1:14)
  token 4: Line (2:1)
  token 5: two (2:6)
  token 6: Line (3:2)
  token 7: three (3:8)
  ```


# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

### Debug mode
<details>
<summary>Show Hint</summary>
Don't have the program print out token deubg information by default - have it be something you opt into with some kind of debug flag!
</details>

---

### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 4 reference implementation code](../../reference-implementation/step-004/main.odin).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-005.md`](../step-005/step-005.md).

[Previous Step](../step-003/step-003.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-005/step-005.md)
