[Previous Step](../step-010/step-010.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task

Create a `parse()` function that takes in a token list and outputs an array of assignment statements.


# Background

You can think of every program as an array of statements. A *statement* is a piece of code that does something. For example, in Lowkey, `a := 10` is an assignment statement. It assigns 10 to the variable `a` and changes the state of the program. That code does not produce a value.

Statements are in contrast to expressions. An *expression* is a piece of code that produces a value that can be used in some other statement or expression. For example, `5 + 5` is an expression - it produces the value of 10, and it could be used in an assignment statement, like `a := 5 + 5`. But `5 + 5` alone does not do anything.

Statements and expressions can have nested expressions. For example, the assignment statement `a := 5 + (5 - 5)` has a nested subtraction expression inside the addition expression.

We will eventually create an *Abstract Syntax Tree* (AST) that will allow for nesting expressions within expressions. But for now, we will simply assume that we can only ever have a simple array of statements (Abstract Syntax Array?).

Why do we care about statements vs. expressions? Because it helps catch syntax errors. E.g. `a := (b := 5 + 5)` would cause a syntax error in Lowkey, because assignments are statements and can't be used in a spot that expects an expression. However, in C, `a = b = 5 + 5` is valid because assignments are expressions (i.e. assignments produce values).

Other notes:
* Function calls (`foo()`) are expressions, even if they produce side effects.
* Function definitions consist of a series of statements.


# Tests

  Example REPL Input:
  ```
  a := 1
  b := 3
  c := b
  d := c
  ```

  Example output (of `parse()`) to check:
  ```
  dynamic array (StatementAssignmentType) [
    { destination: a, source: 1 },
    { destination: b, source: 3 },
    { destination: c, source: b },
    { destination: d, source: c },
  ]
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### What data structure should I use for assignment statements?
<details>
<summary>Show Hint</summary>

</details>

###
<details>
<summary>Show Hint</summary>

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 10 reference implementation code](../../reference-implementation/step-011/main.odin) ([diff from step 010](../../reference-implementation/step-011/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-010/step-010.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
