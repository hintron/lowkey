[Previous Step](../step-015/step-015.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task

Print out execution errors in the REPL. Do this by returning execution errors from `execute()` and printing them out in the main REPL loop. Make sure that an execution error doesn't leave behind a partial state change.

# Tests

In the REPL, make sure that these commands print errors instead of crashing the REPL, and make sure the execution state is still pristine:

```
> a := c
Error: Execution: Tried to read from variable before it had a value (1:6; byte 5)
    a := c
    -----^
> a := 1@
Error: Tokenization: Invalid Number (1:7; byte 6)
    a := 1@
    ------^
> state
Interpreter State:
```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->

### How do I prevent an invalid assignment from setting the destination variable to zero?
<details>
<summary>Show Hint</summary>

Reorganize your logic so that you handle the source variable first, and only after the source has been properly identified do you handle the destination variable and change the execution state of the program.

</details>

### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 16 reference implementation code](../../reference-implementation/step-016/main.odin) ([diff from step 016](../../reference-implementation/step-016/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-015/step-015.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
