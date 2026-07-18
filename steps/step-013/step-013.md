[Previous Step](../step-012/step-012.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-014/step-014.md)

# Task

Return some simple parsing errors from `parse()`.

# Tests

  Example Test Input:
  ```
  a := 5 // This is valid
  1 // Can't have a constant number by itself
  := // Can't have an assignment by itself
  a // Can't have a variable by itself
  ```

  Result:
  There should be separate parse errors for the last four lines.

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I know when a token is on a line by itself?
<details>
<summary>Show Hint</summary>

In the tokenizer, you need to start inserting "end statement" tokens on a newline if there was a token on the current line. This is basically a form of "Automatic Semicolon Insertion" (see https://www.gingerbill.org/article/2026/02/19/choosing-a-language-based-on-syntax/) and we want to be like Odin or Python, where a newline acts as an end statement in most cases.

</details>



### When creating a parsing error, how do I know what line/column/byte the error occurs on?
<details>
<summary>Show Hint</summary>

Use the data in the `Token` struct, and add a `line_start_byte` field if you haven't already.

Since the parser iterates through tokens, not lines of text, by default you don't know what the current line is that is being evaluated. But you *do* know what the current token is, and that has the data you need.

</details>




### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 13 reference implementation code](../../reference-implementation/step-013/main.odin) ([diff from step 013](../../reference-implementation/step-013/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-014.md`](../step-014/step-014.md).

[Previous Step](../step-012/step-012.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-014/step-014.md)
