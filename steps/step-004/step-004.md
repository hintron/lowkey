# Task

Add line number, column number, and token number to `Token`s returned by `tokenize()`. Line number and column number start at 1, token index starts at 0.

Then, add a debug mode where each token or whitespace character parsed prints out the token type, starting byte, line number, column number, and token index. For example:

```
>>>>>>>> Found whitespace                  ( byte:    5 | line:   1 | col:   6 | token idx:   1 )
>>>>>>>> Found whitespace                  ( byte:    6 | line:   1 | col:   7 | token idx:   1 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:    7 | line:   1 | col:   8 | token idx:   2 )
>>>>>>>> Found whitespace                  ( byte:    9 | line:   1 | col:  10 | token idx:   2 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   10 | line:   1 | col:  11 | token idx:   3 )
>>>>>>>> Found whitespace                  ( byte:   12 | line:   1 | col:  13 | token idx:   3 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   13 | line:   1 | col:  14 | token idx:   4 )
>>>>>>>> Found whitespace                  ( byte:   20 | line:   1 | col:  21 | token idx:   4 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   21 | line:   2 | col:   1 | token idx:   5 )
>>>>>>>> Found whitespace                  ( byte:   25 | line:   2 | col:   5 | token idx:   5 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   26 | line:   2 | col:   6 | token idx:   6 )
>>>>>>>> Found whitespace                  ( byte:   29 | line:   2 | col:   9 | token idx:   6 )
>>>>>>>> Found whitespace                  ( byte:   30 | line:   3 | col:   1 | token idx:   6 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   31 | line:   3 | col:   2 | token idx:   7 )
>>>>>>>> Found whitespace                  ( byte:   35 | line:   3 | col:   6 | token idx:   7 )
>>>>>>>> Found whitespace                  ( byte:   36 | line:   3 | col:   7 | token idx:   7 )
>>>>>>>> Found Token (IdentifierVariable)  ( byte:   37 | line:   3 | col:   8 | token idx:   8 )
```

(Note: The byte numbers will probably be slightly different if you are on Windows, since Windows newlines are CR + LF instead of LF.)

# Tests

  Input (source text):
  ```
  This   is my program\nLine two\n Line  three \n
  ```

  Expected output (`token <token_index>: <text> (<line_number>:<column_number>)`):

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

# Finished?

Congratulations! Copy your code into the next step's directory and read the task description at [`step-005.md`](../step-005/step-005.md). Or, go back to the [Step Schedule](../../readme.md#step-schedule).
