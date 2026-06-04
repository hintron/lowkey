[Previous Step](../step-008/step-008.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task

Create an `execute()` function to "execute" tokens and return the final state of the program.

There are only two operations that can be performed: assigning a constant to a variable, and copying a variable to variable. Variables are only of one implicit integer type.

# Tests

  Example Input:
  ```
  a := 1
  b := 3
  c := b
  d := c
  ```

  Example output (of `execute()`):
  ```
  Final Program State:
  a = 1
  b = 3
  c = 3
  d = 3
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### 
<details>
<summary>Show Hint</summary>

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 9 reference implementation code](../../reference-implementation/step-009/main.odin) ([diff from step 008](../../reference-implementation/step-009/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-008/step-008.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
