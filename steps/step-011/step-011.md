[Previous Step](../step-010/step-010.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-012/step-012.md)

# Task

Create a `parse()` function that takes in a token list and outputs an array of simple assignment statement AST nodes.


# Background

You can think of every program as an array of statements. A *statement* is a piece of code that does something. For example, in Lowkey, `a := 10` is an assignment statement. It assigns 10 to the variable `a` and changes the state of the program. That code does not produce a value.

Statements are in contrast to expressions. An *expression* is a piece of code that produces a value that can be used in some other statement or expression. For example, `5 + 5` is an expression - it produces the value of 10, and it could be used in an assignment statement, like `a := 5 + 5`. But `5 + 5` alone does not do anything.

Statements and expressions can have nested expressions. For example, the assignment statement `a := 5 + (5 - 5)` has a nested subtraction expression inside the addition expression.

We will eventually create an *Abstract Syntax Tree* (AST) that will allow for arbitrarily long expressions within statements. But for now, we will simply assume that we can only have a simple array of assignment statement AST nodes (Abstract Syntax Array?). There will be no tree structure to the output (yet).

Why do we care about statements vs. expressions? Because it helps catch syntax errors. E.g. `a := (b := 5 + 5)` would cause a syntax error in Lowkey, because assignments are statements and can't be used in a spot that expects an expression. However, in C, `a = b = 5 + 5` is valid because assignments are expressions (i.e. assignments produce values).

Other notes:
* Function calls (`foo()`) are expressions, even if they produce side effects.
* Function definitions consist of a series of statements.


# Tests

  Example Test Input:
  ```
  a := 1
  b := 3
  c := b
  d := c
  ```

  Example result of `parse()`:
  ```
  Dynamic array of AstNodes [
    {
      type: AstNodeType.Assignment
      destType: ValueType.Variable,
      destToken: a,
      sourceType: ValueType.NumberConstant,
      sourceToken: 1,
    },
    {
      type: AstNodeType.Assignment
      destType: ValueType.Variable,
      destToken: b,
      sourceType: ValueType.NumberConstant,
      sourceToken: 3,
    },
    {
      type: AstNodeType.Assignment
      destType: ValueType.Variable,
      destToken: c,
      sourceType: ValueType.Variable,
      sourceToken: b,
    },
    {
      type: AstNodeType.Assignment
      destType: ValueType.Variable,
      destToken: d,
      sourceType: ValueType.Variable,
      sourceToken: c,
    },
  ]
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### What should my AST nodes look like?
<details>
<summary>Show Hint</summary>

For now, your AST nodes should be a simple struct or object containing these fields:

* AST node type
* destination value type
* destination token index
* source value type
* source token index

They should not yet contain pointers/handles to child AST nodes. That will come in a later step.

We want these AST nodes to follow the 'fat struct' approach. So we will add more and more fields once we want to create differet AST node types in the future.

</details>


### How should I iterate over the tokens?
<details>
<summary>Show Hint</summary>

You don't want to do a `for token in tokens` approach, because that limits you to only looking at the current token. We need the ability to peek ahead and see what the next tokens are in order to know what kind of statement or expression we are dealing with.

Instead, after you have finished parsing the current AST node, increment a `curr_token` index by however many tokens you ate or consumed before advancing to the next iteration of the loop.

</details>

### How should I parse the assignment statement?
<details>
<summary>Show Hint</summary>

We know that for now, an assignment statement will only be of the form `a := 1` or `a := b`. So write a function that takes in the current token index and the tokens themselves, and parse ahead three tokens for the left, middle, and right while filling out the values of a new AstNode. Then return that node and the number of tokens consumed. Add the AstNode to the nodes/statements list, and increment the `curr_token` index the number of tokens consumed.

</details>

### How can I see the text for the source and destination fields?
<details>
<summary>Show Hint</summary>

Use the token indexes to index into the token stream to get back the token. Then, feed that token into the 'token to string' helper function you should already have.

</details>

### What should I do about parsing errors?
<details>
<summary>Show Hint</summary>

For now, we will assume no errors. A future step will add error handling.

</details>

### How should I execute the AstNodes?
<details>
<summary>Show Hint</summary>

For now, we will not execute the AstNodes. A future step will change our REPL `execute()` function to go from executing tokens to executing AstNodes (walking the AST).

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 11 reference implementation code](../../reference-implementation/step-011/main.odin) ([diff from step 010](../../reference-implementation/step-011/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-012.md`](../step-012/step-012.md).

[Previous Step](../step-010/step-010.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-012/step-012.md)
