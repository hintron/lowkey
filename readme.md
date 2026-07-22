# Lowkey - A Step by Step Compiler and Language

Lowkey is an educational language, interpreter, and compiler that novice programmers can incrementally write from scratch, step by step!

The goal is to iteratively write a compiler from scratch for a simple statically typed language, with visible progress and feedback [^1] [^2] [^3]. Each step aims to be 30 minutes or less. You may use any systems programming language you want, as long as it allows you to low-level access to memory and empowers you to build arbitrary data structures [^4].

Lowkey is loosely based on the [Odin programming language](https://odin-lang.org/) and is meant to only implement those language features that are common to most programming languages.

> [!IMPORTANT]
> This project is currently under construction. See [todo.md](docs/todo.md) for the future roadmap.


# Getting Started

To get started, open [`step-001.md`](steps/step-001/step-001.md) and complete the task.


# Step Schedule

The compiler will be implemented incrementally, step by step, in 30 minute sitdown sessions. Each step will have a suite of test files to pass. Each step will start with a copy of the source code from the previous step (a la [Handmade Hero](https://guide.handmadehero.org/code/day001/)).

* [`step-001.md`](steps/step-001/step-001.md) : Create a `Hello, world!` program in your chosen language.
* [`step-002.md`](steps/step-002/step-002.md) : Create a `tokenize()` function and have it find the starting byte positions of words in a sentence.
* [`step-003.md`](steps/step-003/step-003.md) : Have `tokenize()` return a dynamic array of `Token`s with token type, start byte, and length. Check that start byte and length produce the expected values from the source text.
* [`step-004.md`](steps/step-004/step-004.md) : Add line number, column number, and token index to the `Token` struct, as well as some debugging output.
* [`step-005.md`](steps/step-005/step-005.md) : Tokenize variables (`my_var_1`), multi-digit integer constants (`1_337`), and the assignment operator (`:=`)
* [`step-006.md`](steps/step-006/step-006.md) : Return a list of `Error` structs from `tokenize()` whenever an invalid integer is encountered during tokenization.
* [`step-007.md`](steps/step-007/step-007.md) : Create the beginnings of a REPL (read execute print loop) - i.e. an interactive prompt.
* [`step-008.md`](steps/step-008/step-008.md) : In the REPL, print nice-looking error messages from the error list returned by `tokenize()`.
* [`step-009.md`](steps/step-009/step-009.md) : Build a simple intepreter by creating an `execute()` function to "execute" tokens and return the final state.
* [`step-010.md`](steps/step-010/step-010.md) : In the REPL, add a `state` command to print out the program state.
* [`step-011.md`](steps/step-011/step-011.md) : Create a `parse()` function that takes in a token list and outputs an array of simple assignment statement AST nodes.
* [`step-012.md`](steps/step-012/step-012.md) : Implement `//` as a single line comment.
* [`step-013.md`](steps/step-013/step-013.md) : Return some simple parsing errors from `parse()`.
* [`step-014.md`](steps/step-014/step-014.md) : Disallow multiple assignments on the same line.
* [`step-015.md`](steps/step-015/step-015.md) : Make `execute()` execute a list of AST nodes instead of a list of tokens.
* [`step-016.md`](steps/step-016/step-016.md) : Print out execution errors in the REPL.
* [`step-017.md`](steps/step-017/step-017.md) : Add any remaining tokenization, parsing, and execution errors, and add tests to hit each one.


#### Unimplemented steps and step ideas

* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Change the AST node structure to be an intrusive list/graph with a parent-child-sibling hierachy and handles.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Implement simple expressions for the right side of the assignment statement.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Make the tokenizer and the parser handle UTF-8.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Add a `source` command to print out the current source text that has been accumulated.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Build a simple tree-walk interpreter in REPL mode.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Parse `-7234 + 3` and create an actual Abstract Syntax Tree (AST) instead of a list of nodes; AST creation visualization.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Create a simple Lowkey runtime executable with an internal function called `lowkey_main_temp()` that returns a single constant number `42`, and print out that value.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Create an assembly file for your given architecture and create a global function called `lowkey_main` that simply returns a constant number `43`. In the Lowkey runtime executable, replace `lowkey_main_temp()` with `lowkey_main()`. Finally, include the assembly file into the build, and verify that the runner prints out `43`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Take the single token output for `7234` and create an assembly file that returns that value, and see the runner print it out.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize `-7234` (tokenize a unary operation).
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize `-7234 + 3` (tokenize a binary operation; skip whitespace).
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Take AST for `-7234 + 3` and generate an add assembly instruction. Then, have that add result be returned instead of a constant number, and make sure it prints.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize and parse `return -7234 + 3`, so the `return` asm is explicitly generated based on AST instead of implicitly generated.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize and parse the function `lowkey_main :: proc() -> int { return -7234 + 3 }`, and don't implicitly generate any more asm.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `-` as either a binary operation or unary operation.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate more binary operations: `*`, `/`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Parse `1 + 2 * 3 + 4` with proper precedence, according to Jonathan Blow's technique.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize and parse `()` for explicit precedence (`(1 + 2) * (3 + 4)`).
<!-- TODO: From here on out, try to implement the things in Brian Will's video on all programming languages in 15 minutes -->
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate local variables of type int (s64).
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate local variables of type uint (u64).
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate local variables of type float (f64).
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate local variables of type bool.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Emit parse errors when values of incorrect types are used together.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `==`, `!=`, `<`, `<=`, `>`, `>=`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `if <condition> {}`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `for {}`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `for <condition> {}`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `continue`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `break`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `add_ints :: proc(a: int, b: int) -> int { return a + b }` called by `lowkey_main()`
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Write a program to solve some kind of puzzle, to prove that our little language works so far!
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate `struct`s.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate global variables.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate casting: `int(<val>)`, `float(<val>)`, `uint(<val>)`
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate an int pointer type and variable: `^int` and `&`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate dereferencing an int pointer: `int^`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate assigning to a dereferenced int pointer: `int^ = <val>`.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate raw unions.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate enumerated unions/tagged unions.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : Tokenize, parse, and generate a switch statement. (needed? I might want to skip this, since you can use ifs)
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : In the REPL, record command history and make up arrow cycle through entries.
* [`step-XXX.md`](steps/step-XXX/step-XXX.md) : In the REPL, make ctrl-r search through the command history.


# Reference Implementation

See the [reference-implementation](reference-implementation/readme.md) for example code for all the steps, written in [Odin](https://odin-lang.org). See also [`line-diffs.md`](./reference-implementation/line-diffs.md) to see how many lines each step took, to get a sense.

If you get stuck, first look at the hints in the step's readme. If you still can't figure it out, take a look at the `changes.diff` file for that step, and then look at the full `main.odin` implementation as a last resort.


# Language Overview

See the [Lowkey language overview](docs/lowkey-language-overview.md) (WIP!) for more information about Lowkey.


# Recommendations and Suggestions

I have a few opinionated suggestions for you, before you get started:

* Don't use AI! This is for your own learning, so do it the old fashioned way.

* Start off implementing all your code in a single file, and resist the initial urge to organize things into multiple files.

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

  * The thing I dislike about methods on objects is that it's a lie. To the CPU, there is no such thing as a self-contained object that has code and data bundled together. Code actually lives in one spot, while the data lives in another, and the CPU even caches them separately at the lowest level of the memory hierarchy.

  * It's a subtle shift in thinking, but I think it's important, especially coming from higher-level languages that heavily use objects, methods, and closures.

  * Also, I don't like how objects have this implicit state that's accessible via methods. I much prefer a more functional approach where you explicitly pass in the inputs. I think it makes the code more readible and easier to reason about.

  * To remember what functions work on what data objects, you can do a naming convention like `object_action()` and make the first argument a pointer to the data object (this is basically what methods do under the hood).

  * For a more in-depth discussion on this, see [How I Program C by Eskil Steinberg from 38:40](https://youtu.be/443UNeGrFoM?si=OUbbhYZuTEU0ryC3&t=2320) - 41:05 and [Why does Odin not have any methods?](https://odin-lang.org/docs/faq/#why-does-odin-not-have-any-methods).

* ["Code like a 15 year old with 30 years of experience."](https://youtu.be/-m7lhJ_Mzdg?si=Y0BT4VgbpM4egX74&t=118)

* If you are looking for a good programming language to use that is fast, powerful, and nudges you towards all the things I've mentioned above, [give Odin a try!](https://odin-lang.org/) It's a C alternative that is a joy to program in.

  * Odin a systems programming language, so it's lower level than Python, JavaScript, PHP, etc. There is no gargage collection, so you have to manage memory yourself. But it's actually not that bad, and gives you much more control over the performance of your program.

  * Start with [Introduction to the Odin Programming Language](https://zylinski.se/posts/introduction-to-odin/) by Karl Zylinski. [His book is also really good](https://odinbook.com), if you want to buy it (20$, PDF only).


# Resources on compilers, tokenization/lexing/scanning, and parsing

* [Crafting Interpreters](https://craftinginterpreters.com/contents.html) by Robert Nystrom ([Chapter 2](https://craftinginterpreters.com/a-map-of-the-territory.html) is a great introduction!).

* [Discussion: Making Programming Language Parsers, etc](https://youtu.be/MnctEW1oL-E?si=9zwTX3mWbQGeJ0hx) by Jonathan Blow and Casey Muratori (the first 25 minutes or so is a great introduction to how to go about doing tokenization and parsing).

* [Discussion with Casey Muratori about how easy precedence is...](https://youtu.be/fIPO4G42wYE?si=MaMlMQjjCxqD0rUE) by Jonathan Blow and Casey Muratori.

* [Zig Tokenizer](https://mitchellh.com/zig/tokenizer) and [Zig Parser](https://mitchellh.com/zig/parser) by Mitchell Hashimoto.

* [Writing an Interpreter in Go](https://interpreterbook.com/) by Thorsten Ball ($30). See also the free sample on [Lexing](https://interpreterbook.com/sample.pdf).

* [Compiler Construction](https://people.inf.ethz.ch/wirth/CompilerConstruction/index.html) by Niklaus Wirth.

* [An Incremental Approach to Compiler Construction](http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf) by Abdulaziz Ghuloum.

* [Blaise](https://github.com/gingerBill/blaise) by Ginger Bill. It's an educational compiler implementation to teach people how to make a compiler from scratch and all of the minimal stages to produce an executable (I haven't looked at it yet).


# What's in a Language?

I recommend watching these videos by Brian Will to get a sense for what is common between most programming languages:

* [Every Programming Language in 15 Minutes](https://youtu.be/duhDovqHbEs?si=fVAROzLUS9sFNNIn)

* [Every programming language in (another) 15 minutes: data types](https://youtu.be/QI-ktlf7qFU?si=2hZ-YxGyjBXjM-LQ)


# Notable incremental tutorials

* [Chibicc](https://github.com/rui314/chibicc) by Rui Ueyama - Write a C compiler from scratch, incrementally.

* [Real-time Operating Systems](https://github.com/hintron/8086-toolchain) by Dr. James Archibald - Through a series of labs, incrementally write your own custom "YAK" RTOS from scratch in C and 8086 assembly and run it on the class 8086 emulator.

* [Computer Enhance](https://www.computerenhance.com/) by Casey Muratori (15$/mo subscription) - Learn 8086 assembly and incrementally implement a complete 8086 emulator from scratch in part 1; learn how the CPU works from the perspective of a programmer in the other parts.

* [Writing an OS in Rust](https://os.phil-opp.com/) by Phil Opperman and [Intermezzos](https://intermezzos.github.io/book/first-edition/) by Steve Klabnik - Write the very beginnings of your own x64 OS in Rust.

* [Handmade Hero](https://guide.handmadehero.org/code/day001/) by Casey Muratori - Write a computer game from scratch, in 1 hour sessions (it is recommended to follow along for the first 30 days, and then as needed after that).


[^1]: [My Approach to Building Large Technical Projects - Mitchell Hashimoto](https://mitchellh.com/writing/building-large-technical-projects)
[^2]: [An Incremental Approach to Compiler Construction - Abdulaziz Ghuloum](http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf)
[^3]: [Step-by-step: Programming incrementally - Our Machinery](https://ruby0x1.github.io/machinery_blog_archive/post/step-by-step-programming-incrementally/index.html)
[^4]: Recommended languages: Odin, Zig, and C. Rust could work, but I'm not sure how much trouble it will give us to implement the data structures we want. Python, JavaScript, and other non-systems programming languages make accessing low-level bytes and controlling memory layout difficult.
