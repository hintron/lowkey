[Previous Step](../step-006/step-006.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task
Create a executable (i.e. fill out `main()`) that will act as a [REPL (read execute print loop)](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) - i.e. an interactive prompt to the compiler.

Simply accept a single line of input from the user at a time, pass that string to `tokenize()`, and print out the returned tokens. If there are errors, print out the errors and don't print out the tokens. Then repeat.


# Tests

  The output doesn't need to look exactly like this - this is just how structs are printed out by default in Odin.

  Example Input (interactive input):
  ```
  a := 234234h
  ```

  Example output:
  ```
  Tokenization error:  TokenizationError{type = "InvalidNumber", start_byte = 11, line_start_byte = 0, line_number = 1, column_number = 12}
  ```

  Example Input (interactive input):
  ```
  a := 987987
  ```

  Example output:
  ```
  Token{type = "IdentifierVariable", start_byte = 0, length = 1, line_number = 1, column_number = 1, token_index = 0}
  Token{type = "OperatorBinaryAssignment", start_byte = 2, length = 2, line_number = 1, column_number = 3, token_index = 1}
  Token{type = "ConstantInteger", start_byte = 5, length = 6, line_number = 1, column_number = 6, token_index = 2}
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I get keyboard input in Odin?
<details>
<summary>Show Hint</summary>

From https://github.com/odin-lang/examples/blob/master/console/read_console_input/read_console_input.odin:

```odin
import "core:fmt"
import "core:os"

main :: proc() {
	buf: [256]byte
	fmt.println("Please enter some text:")
	n, err := os.read(os.stdin, buf[:])
	if err != nil {
		fmt.eprintln("Error reading: ", err)
		return
	}
	str := string(buf[:n])
	fmt.println("Outputted text:", str)
}
```

</details>



### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 7 reference implementation code](../../reference-implementation/step-007/main.odin) ([diff from step 006](../../reference-implementation/step-007/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-006/step-006.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
