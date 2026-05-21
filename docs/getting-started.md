# Getting Started

To get started, open [`step-001`](../steps/step-001.md).

# Schedule

The compiler will be implemented incrementally, step by step, in 1-hour sitdown sessions. Each step will have a suite of test files to pass. Each step will start with a copy of the source code from the previous step (a la [Handmade Hero](https://guide.handmadehero.org/code/day001/)).

* [`step-001`](../steps/step-001.md) : `Hello, world!`.
* [`step-002`](../steps/step-002.md) : Set up the test runner and create the `tokenize()` function stub.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize `7` and return it from tokenization function.
* [`step-XXX`](../steps/step-XXX.md) : Emit x64 and arm64 for `7` and save to an assembly file.
* [`step-XXX`](../steps/step-XXX.md) : Create a simple Lowkey runtime and link assembly into executable to print `7`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenization visualization.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and emit assembly for `1337` (multi-digit parsing state machine).
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and emit assembly for `-1337`.
* [`step-XXX`](../steps/step-XXX.md) : Make an abstract syntax tree (AST) for `2 + 2` and use AST to emit assembly.
* [`step-XXX`](../steps/step-XXX.md) : AST visualization.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize and emit assembly for `2 + 2`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and emit assembly for `2 - 2`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and emit assembly for `7 * 3`.
* [`step-XXX`](../steps/step-XXX.md) : Tokenize, parse, and emit assembly for `7 / 3`.
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :
* [`step-XXX`](../steps/step-XXX.md) :


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
