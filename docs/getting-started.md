# Getting Started

To get started, open [`step-001`](../steps/step-001.md).

# Schedule

The compiler will be implemented incrementally, step by step, in 30 minute sitdown sessions. Each step will have a suite of test files to pass. Each step will start with a copy of the source code from the previous step (a la [Handmade Hero](https://guide.handmadehero.org/code/day001/)).

* [`step-001`](../steps/step-001.md) : `Hello, world!`.
* [`step-002`](../steps/step-002.md) : Set up the test runner and create the `tokenize()` function stub.
* [`step-003`](../steps/step-003.md) : Have `tokenize()` take in an input string and return that same input as the output string. Run multiple tests.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize `7` into a `Token` data structure. Change `tokenize()` to return a list of `Token`s instead of a string.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize `7234` (multi-digit numbers); tokenization visualization.
* [`step-XXX`](../steps/step-XXX.md) : Create a simple Lowkey runtime executable with an internal function called `lowkey_main_temp()` that returns a single constant number `42`, and print out that value.
* [`step-XXX`](../steps/step-XXX.md) : Create an assembly file for your given architecture and create a global function called `lowkey_main` that simply returns a constant number `43`. In the Lowkey runtime executable, replace `lowkey_main_temp()` with `lowkey_main()`. Finally, include the assembly file into the build, and verify that the runner prints out `43`.
* [`step-XXX`](../steps/step-XXX.md) : Take the single token output for `7234` and create an assembly file that returns that value, and see the runner print it out.
* [`step-XXX`](../steps/step-XXX.md) : Create a `parse()` function that takes in a token list and outputs a list of `SyntaxNode`s.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize `-7234` (tokenize a unary operation).
* [`step-XXX`](../steps/step-XXX.md) : Tokenize `-7234 + 3` (tokenize a binary operation; skip whitespace).
* [`step-XXX`](../steps/step-XXX.md) : Parse `-7234 + 3` and create an actual Abstract Syntax Tree (AST) instead of a list of nodes; AST creation visualization.
* [`step-XXX`](../steps/step-XXX.md) : Take AST for `-7234 + 3` and generate an add assembly instruction. Then, have that add result be returned instead of a constant number, and make sure it prints.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and parse `return -7234 + 3`, so the `return` asm is explicitly generated based on AST instead of implicitly generated.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and parse the function `lowkey_main :: proc() -> int { return -7234 + 3 }`, and don't implicitly generate any more asm.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `-` as either a binary operation or unary operation.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate more binary operations: `*`, `/`.
* [`step-XXX`](../steps/step-XXX.md) : Parse `1 + 2 * 3 + 4` with proper precedence, according to Jonathan Blow's technique.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and parse `()` for explicit precedence (`(1 + 2) * (3 + 4)`).
<!-- TODO: From here on out, try to implement the things in Brian Will's video on all programming languages in 15 minutes -->
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate local variables of type int (s64).
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate local variables of type uint (u64).
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate local variables of type float (f64).
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate local variables of type bool.
* [`step-XXX`](../steps/step-XXX.md) : Emit parse errors when values of incorrect types are used together.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `==`, `!=`, `<`, `<=`, `>`, `>=`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `if <condition> {}`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `for {}`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `for <condition> {}`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `continue`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `break`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `add_ints :: proc(a: int, b: int) -> int { return a + b }` called by `lowkey_main()`
* [`step-XXX`](../steps/step-XXX.md) : Write a program to solve some kind of puzzle, to prove that our little language works so far!
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate `struct`s.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate global variables.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate casting: `int(<val>)`, `float(<val>)`, `uint(<val>)`
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate an int pointer type and variable: `^int` and `&`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate dereferencing an int pointer: `int^`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate assigning to a dereferenced int pointer: `int^ = <val>`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate raw unions.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate enumerated unions/tagged unions.
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and generate a switch statement. (needed? I might want to skip this, since you can use ifs)


# Reference Implementation

See the [reference-implementation](../reference-implementation/readme.md) for example code for all the steps, written in [Odin](https://odin-lang.org). Please don't look at this unless you get stuck and have already looked at the hints in that step's readme.


# What's in a Language?

I recommend watching these videos by Brian Will to get a sense for what is common between most programming languages:

* [Every Programming Language in 15 Minutes](https://youtu.be/duhDovqHbEs?si=fVAROzLUS9sFNNIn)

* [Every programming language in (another) 15 minutes: data types](https://youtu.be/QI-ktlf7qFU?si=2hZ-YxGyjBXjM-LQ)


# Language Specification

See the [Lowkey language specification](lowkey-language-specification.md) (WIP!) for more information about Lowkey.


# Recommendations and Suggestions

I have a few opinionated suggestions for you, before you get started:

* Start off implementing all your code in a single file, and resist the initial urge to organize things into multiple files!

  * There may come a time when you will want to make some natural splits as it becomes obvious, but remember that each split is not free - each one adds friction to your code. That can be good once you know the shape of the problem you are trying to solve! But until you get a sense of the full picture, 'premature program organization' can instead slow you down dramatically because you are more worried about how to split things perfectly than you are about writing the code, solving the problem, and doing the thing. So just do the thing!

  * For more on this, see [Clean Code : Horrible Performance | Full Interview @ 39:24](https://youtu.be/OtozASk68Os?si=--DqS9SqJhefdWyu&t=2364) and [Semantic Compression](https://caseymuratori.com/blog_0015).

* Write your code in a procedural style. What this means is that you want to think in terms of Plain Old Data ([POD](https://en.wikipedia.org/wiki/Passive_data_structure)) objects and the functions that operate on them, not in terms of objects as self-aware beings that act. Ditch Object Oriented Programming (OOP).

  * For more on this, see [CppCon 2014: Mike Acton "Data-Oriented Design and C++"](https://youtu.be/rX0ItVEVjHc?si=R6R6Qgb9gnnrw5Mx) from 12:24 - 25:29 and [Object-Oriented Programming is Bad](https://www.youtube.com/watch?v=QM1iUe6IofM) by Brian Will.

* Don't use object/class methods! Just use boring, old functions. So instead of something like this (in C++):

  ```c
  tokenizer.parse(token_stream);
  ```
  Do this:
  ```c
  tokenizer_parse(&tokenizer_state, token_stream);
  ```

  * To remember what functions work on what data objects, you can do a naming convention like `object_action()` and make the first argument a pointer to the data object (this is all that methods do under the hood, anyways).

  * The thing I dislike about methods on objects is that it's a lie. To the CPU, there is no such thing as a self-contained object that has code and data bundled together. Code actually lives in one spot, while the data lives in another, and the CPU even caches them separately at the lowest level of the memory hierarchy.

  * It's a subtle shift in thinking, but I think it's important, especially coming from higher-level languages that only deal with objects, methods, and closures. (By the way, [Odin does not have methods!](https://odin-lang.org/docs/faq/#why-does-odin-not-have-any-methods))

  * For a more in-depth discussion on this, see [How I Program C by Eskil Steinberg](https://youtu.be/443UNeGrFoM?si=ruGUbGQ1RBdhUpD6) from 38:40 - 41:05.

* ["Code like a 15 year old with 30 years of experience."](https://youtu.be/-m7lhJ_Mzdg?si=Y0BT4VgbpM4egX74&t=118)

* If you are looking for a good programming language to use that is fast, powerful, and nudges you towards all the things I've mentioned above, [give Odin a try!](https://odin-lang.org/) It's a C alternative that is a joy to program in.

  * Start with [Introduction to the Odin Programming Language](https://zylinski.se/posts/introduction-to-odin/) by Karl Zylinski.
