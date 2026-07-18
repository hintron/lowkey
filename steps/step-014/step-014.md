[Previous Step](../step-012/step-012.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task

Disallow multiple assignments on the same line.

# Tests

  Example Test Input:
  ```
  a := 5 // This is valid
  1 // Can't have a constant number by itself
  := // Can't have an assignment by itself
  a // Can't have a variable by itself
  a := b c := d // Can't have multiple assignments on the same line
  e := f := g // Can't have an assignment that starts with nothing
  ```

  Result:
  There should be separate parse errors for the last four lines.

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


###
<details>
<summary>Show Hint</summary>


</details>



### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 14 reference implementation code](../../reference-implementation/step-014/main.odin) ([diff from step 014](../../reference-implementation/step-014/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-013/step-013.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
