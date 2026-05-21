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

* [Chibicc](https://github.com/rui314/chibicc) by Rui Ueyama - Write a C compiler from scratch, incrementally.

* [Real-time Operating Systems](https://github.com/hintron/8086-toolchain) by Dr. James Archibald - Through a series of labs, incrementally write your own custom "YAK" RTOS from scratch in C and 8086 assembly and run it on the class 8086 emulator.

* [Computer Enhance](https://www.computerenhance.com/) by Casey Muratori (15$/mo subscription) - Learn 8086 assembly and incrementally implement a complete 8086 emulator from scratch in part 1; learn how the CPU works from the perspective of a programmer in the other parts.

* [Writing an OS in Rust](https://os.phil-opp.com/) by Phil Opperman and [Intermezzos](https://intermezzos.github.io/book/first-edition/) by Steve Klabnik - Write the very beginnings of your own x64 OS in Rust

* [Handmade Hero](https://guide.handmadehero.org/code/day001/) by Casey Murator - Write a computer game from scratch, in 1 hour sessions (the consensus is to follow along for the first 30 days, and then as needed after that).



[^1]: https://mitchellh.com/writing/building-large-technical-projects
[^2]: http://scheme2006.cs.uchicago.edu/11-ghuloum.pdf
