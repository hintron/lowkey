# LowKey

An educational scripting language and interpreter, based on the Odin programming language.


## Background

The approach to this interpreter was originally based on the video "[Discussion with Casey Muratori about how easy precedence is...][1]" by Jonathan Blow. The goal of that video was to show how to properly parse the expression `a > b + c * d + e` with proper precedence without having to "fix it in post" and go back and rewrite the AST with proper precedence after the fact.


## Language Overview

LowKey is a statically typed (but types are mostly inferred) language.

LowKey has Odin syntax and semantics.

LowKey files end in the `.loki` suffix (or `.lk` suffix?).

LowKey programs are meant to run on 64-bit systems only (for now).

LowKey programs are cross-platform (MacOS, Windows, Linux, WASM).

LowKey programs use the Odin calling convention and can call into Odin code. (To call into C code, use Odin as the intermediary.)

LowKey strives to have a small, embeddable interpreter, like Lua, for games scripting and education.


### Progressive Complexity

LowKey has increasing layers of complexity that are exposed as the user is ready to opt in to them.

`#basic` - opts into a simplified programming experience. This contains basic data types and math operations.

`#intermediate` - opts into intermediate language features.

`#advanced` - all possible LowKey features are enabled

These can be set project-wide once. By default, if nothing is specified, it will be `#basic`.

Anything more advanced must be done in Odin (Odin is the `unsafe` opt-in)

### Data Types

| Basic | Intermediate | Advanced |
|-------|--------------|----------|
| `integer` (s64) | map | pointers |
| `float` (f64) | slices | casting? |
| `unsigned` (u64) | `byte` (u8) | u8, u16, u32 |
| `string` | `const`? | s8, s16, s32 |
| `rune` | `union` | f16, f32 |
| `enum` | | |
| `struct` | | |
| string literals | | |
| constants | | |


### Memory allocation

Everything is allocated onto the stack by default (stack space is increased a lot).


an arena by default, and you can't free anything.

There is no garbage collector. There is no freeing of memory.

There is tooling to see exactly what memory was allocated where.


| Basic | Intermediate | Advanced |
|-------|--------------|----------|
| | Can free arenas explicitly | Can change allocators |
| | | Heap allocator |





### Control Flow

| Basic | Intermediate | Advanced |
|-------|--------------|----------|
| `if` | `for x in ..<` | for (i = 0; i < 10; i+= 1) |
| `for` | `defer` | ternary (`a ? b : c`) |
| `for x in y` | `when` | |
| `func` | | |
| `proc` | | |
| `switch` | | |
| `and` | `&&` | |
| `or` | `\|\|` | |
| `not` | `!` | |

### Operations

| Basic | Intermediate | Advanced |
|-------|--------------|----------|
| Basic math ops | Full Odin math libraries | Bitwise ops - `&`, `\|`, `~` |
| Time | | |


### Experimental Features

LowKey has some experimental language features that I want to try out, that are opt-in:

* The Queue and queue-based function calls.

* Lexical lifetimes + borrow checker

* Arena-based automatic destruction


## Resources on Tokenization/Lexing/Scanning and Parsing

* [Discussion with Casey Muratori about how easy precedence is...][1] by Jonathan Blow and Casey Muratori

* [Compiler Construction](https://people.inf.ethz.ch/wirth/CompilerConstruction/index.html) by Niklaus Wirth

* [Discussion: Making Programming Language Parsers, etc](https://youtu.be/MnctEW1oL-E?si=9zwTX3mWbQGeJ0hx)

* [Zig Tokenizer](https://mitchellh.com/zig/tokenizer)

* [Zig Parser](https://mitchellh.com/zig/parser)

* [Lexing](https://interpreterbook.com/sample.pdf)

[1]: https://youtu.be/fIPO4G42wYE?si=MaMlMQjjCxqD0rUE



