[Previous Step](../step-009/step-009.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-011/step-011.md)

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


### How should I handle storing the source text in REPL mode?
<details>
<summary>Show Hint</summary>

Create a string builder (in Odin) and continuously append a clone of each input line to it. Make sure that you clone the string stored in your REPL's input buffer, or else the string contents will get overwritten on the next input line.

The string builder will be ever-growing, so pre-initialize it to a large capacity (for now) to avoid wasteful reallocations.

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 10 reference implementation code](../../reference-implementation/step-010/main.odin) ([diff from step 009](../../reference-implementation/step-010/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-011.md`](../step-011/step-011.md).

[Previous Step](../step-009/step-009.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-011/step-011.md)
