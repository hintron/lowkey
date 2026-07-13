[Previous Step](../step-011/step-011.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-013/step-013.md)

# Task

Implement `//` as a single line comment.

In the tokenizer, simply discard everything after // until a newline is reached.

# Background


# Tests

  Example Test Input:
  ```
  // Goodbye, world!
  a := 5 // This is a comment
  // This is a comment b := 5
  // // // // Hi
  c := 5//0
  //d := 5
      // e := 5 // Hi
  /
  ```

  Result:
  Only `a` and `c` should be assigned. Everything else should be ignored, and the final line with the stray slash should produce a "StraySlash" error. Note that a comment appears right after a number with no space.

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I detect a stray slash character (`/`)?
<details>
<summary>Show Hint</summary>

Create a tokenization state called "PreviousSlash", and if the next character is not another slash character, emit a tokenization error. Since we haven't implemented division yet, we can assume any single `/` is a stray slash, though we will have to change this logic in the future.

</details>


### How do I allow for `5//` to work without a space?
<details>
<summary>Show Hint</summary>

Since there is no whitespace to indicate an end of the `5` token, we need the first `/` character to also do what whitespace does and "finish" or "complete" the previous token. So extract that token finalization logic into a function and call it in both the whitespace handling code and the first `/` handling code.

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 12 reference implementation code](../../reference-implementation/step-012/main.odin) ([diff from step 012](../../reference-implementation/step-012/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-013.md (The next step is currently under construction.)`](../step-013/step-013.md).

[Previous Step](../step-011/step-011.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-013/step-013.md)
