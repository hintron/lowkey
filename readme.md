# Lowkey Language and Compiler

Lowkey is an educational language and compiler that novice programmers can incrementally write from scratch, step by step!

The goal is to iteratively go through the process of writing an optimizing compiler targeting amd64 (x86-64 - most laptops with Windows) and arm64 (most laptops with macOS) for a simple language, step by step, with visible progress and feedback [^1] [^2]. Each step should not take more than an hour, and each step has a suite of test input and expected output files that need to be passed in order to proceed to the next step. You may use any programming language you want!

Lowkey is loosely based on the [Odin programming language](https://odin-lang.org/).

See [docs/getting-started.md](docs/getting-started.md) to get started.


## Resources on compilers, tokenization/lexing/scanning, and parsing

* [Discussion with Casey Muratori about how easy precedence is...](https://youtu.be/fIPO4G42wYE?si=MaMlMQjjCxqD0rUE) by Jonathan Blow and Casey Muratori

* [Crafting Interpreters](https://craftinginterpreters.com/contents.html) by Robert Nystrom ([Chapter 2](https://craftinginterpreters.com/a-map-of-the-territory.html) is a great introduction!)

* [Compiler Construction](https://people.inf.ethz.ch/wirth/CompilerConstruction/index.html) by Niklaus Wirth

* [An Incremental Approach to Compiler Construction](http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf)

* [Discussion: Making Programming Language Parsers, etc](https://youtu.be/MnctEW1oL-E?si=9zwTX3mWbQGeJ0hx) by Jonathan Blow and Casey Muratori

* [Zig Tokenizer](https://mitchellh.com/zig/tokenizer) by Mitchell Hashimoto

* [Zig Parser](https://mitchellh.com/zig/parser) by Mitchell Hashimoto

* [Lexing](https://interpreterbook.com/sample.pdf) by Thorsten Ball

* [Blaise](https://github.com/gingerBill/blaise) by Ginger Bill. It's an educational compiler implementation to teach people how to make a compiler from scratch and all of the minimal stages to produce an executable.


## Notable incremental tutorials

* [Handmade Hero](https://guide.handmadehero.org/code/day001/)

* [Writing an OS in Rust](https://os.phil-opp.com/)


[^1]: https://mitchellh.com/writing/building-large-technical-projects
[^2]: http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
