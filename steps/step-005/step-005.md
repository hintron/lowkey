[Previous Step](../step-004/step-004.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-006/step-006.md)

# Task

Tokenize variables (`my_var_1`), multi-digit integer constants (`1_337`), and the assignment operator (`:=`). In addition to the `IdentifierVariable` type, add the `OperatorBinaryAssignment` and `ConstantInteger` types

# Tests

  Input (source text):
  ```
  my_var_1 := 1_337\nmy_var_2 := 663\n
  ```

  Expected result (`token <token_index>: <text> (<line_number>:<column_number>)`):

  ```
  token 0: my_var_1 (1:1)
  token 1: := (1:11)
  token 2: 1_337 (1:14)
  token 3: my_var_2 (2:1)
  token 4: := (2:10)
  token 5: 663 (2:13)
  ```


# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

### How Do I Parse Integers and Variables?
<details>
<summary>Show Hint</summary>

In most programming languages, a variable can't start with a number. Lowkey is the same. So if the token starts with a number, it's an integer, and if it starts with anything else, it's an identifier!

</details>

---

### Keep your old tests around, if you can!
<details>
<summary>Show Hint</summary>
Try to keep your old tests around, as they help catch new bugs you introduce in your code and make sure things still work as expected. Sometimes, you might need to modify old tests to work with your new code.
</details>

---

### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 5 reference implementation code](../../reference-implementation/step-005/main.odin).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-006.md`](../step-006/step-006.md).

[Previous Step](../step-004/step-004.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-006/step-006.md)
