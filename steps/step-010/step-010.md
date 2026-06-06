[Previous Step](../step-008/step-008.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task

In the REPL, properly execute code and add a `state` command to print out the state of the interpreter. Print variables in order of creation.


# Tests

  Example REPL Input:
  ```
  a := 1
  b := 3
  c := b
  d := c
  state
  ```

  Example output (of `execute()`) to check:
  ```
  Interpreter State:
    "a" -> 1
    "b" -> 3
    "c" -> 3
    "d" -> 3
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I handle source text in REPL mode?
<details>
<summary>Show Hint</summary>

Treat each input line in the REPL as its own source text. So all tokens will be relative to just that line. After execution and the next line is processed, those tokens will be stale because we will have already thrown away the last source text line. So, in between REPL input lines, only the interpreter state is carried over.

</details>

### How should I execute the tokens?
<details>
<summary>Show Hint</summary>

For now, just assume that the source text will be of the form `lefthand := righthand`. Always keep track of the previous token, and when you see `:=`, then set a `lefthand_token` to be the previous token and toggle a bool that says you are currently executing an assignment operation. That way, you know that the next token will be `righthand`.
Once you have all three, you have enough information to execute the assignment. Store the result in a variable name to value (`string`-to-`int`) map.

</details>

### How should I return the final state of the program?
<details>
<summary>Show Hint</summary>

Create a `string`-to-`int` map called `var_values`. Whenever you assign to a variable, set the value of that variable in `var_values`.

</details>

### How do I handle the `righthand` token?
<details>
<summary>Show Hint</summary>

Simply check the type of the `righthand` token. It should only be of two types: `ConstantInteger` and `IdentifierVariable`. If it's a constant integer, grab the string representation directly from the source text and convert it from a `string` to an `int` (using your language's string-to-int conversion function).

If it's an identifier variable, grab the identifier string directly from the source text and then get its value from `var_values`.

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 9 reference implementation code](../../reference-implementation/step-009/main.odin) ([diff from step 008](../../reference-implementation/step-009/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-008/step-008.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
