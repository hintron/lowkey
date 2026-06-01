[Previous Step](../step-005/step-005.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task
Return a list of `TokenizationError` structs from `tokenize()` whenever an invalid integer is encountered during tokenization. The struct should have `type`, `start_byte`, `line_start_byte`, `line_length`, `line_number`, and `column_number`. For `type`, there only needs to be an `InvalidNumber` variant for now.


# Tests

  Input (source text):
  ```
  1_my_var_ := 1_337\nmy_var_2 := 6^3\n
  ```

  Expected result (format: error <error_index>: <line_text> (<line_number>:<column_number>) (<error_type>)):
  ```
  error 0: 1_my_var_ := 1_337 (1:3) (InvalidNumber)
  error 1: my_var_2 := 6^3 (2:14) (InvalidNumber)
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I check for errors after the first error?
<details>
<summary>Show Hint</summary>

Instead of returning on the first error, save off the first error and then try to keep tokenizing the next token as if nothing happened.

Since we are just tokenizing at this stage, the tokenizer doesn't need to understand the semantics of the code yet.

</details>


### How do I know if it's an invalid identifier or invalid number?
<details>
<summary>Show Hint</summary>

If a token starts with a number but then has non-number characters, and there is an assignment token right after it, then it means the user was likely trying to create an identifier. Otherwise, mark it as an invalid number.

</details>

---


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 6 reference implementation code](../../reference-implementation/step-006/main.odin) ([diff from step 005](../../reference-implementation/step-006/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-005/step-005.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
