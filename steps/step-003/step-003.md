# Task

Have `tokenize()` return a dynamic array of `Token`s instead of `u8`s. `Token` should be a Plain Old Data (POD) struct with `type`, `start_byte`, and `length` fields. Check that start byte and length produce the expected values when using them to index into the source text.

# Tests

  Input (source text):
  ```
  This   is my program\n
  ```

  Expected output:
  You should now output a dynamic array of `Token`s with `type`, `start_byte`, and `length` fields. Use these fields to index into the source text and check that you get back the same word as you expect.


# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

### Token type
<details>
<summary>Show Hint</summary>

Make an enum called `TokenType` for the `type` field in `Token`.

</details>

---

### When to create token, set length, and append to output
<details>
<summary>Show Hint</summary>

You want to create the identifier token on the first identifier character, but just save it to a local variable, and don't set the length yet because you don't know what the length is.

Then, on the next whitespace, you know that the identifier ended, so set the length and append the token to the output then.

</details>

---

# Finished?

Congratulations! Copy your code into the next step's directory and read the task description at [`step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md). Or, go back to the [Step Schedule](../../readme.md#step-schedule).
