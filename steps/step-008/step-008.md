[Previous Step](../step-007/step-007.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)

# Task
In the REPL, print nice-looking error messages from the error list returned by `tokenize()`.


# Tests

  The error output should look something like this:

  Example Input (interactive input):
  ```
  a := 234234h //extra line context
  ```

  Example output:
  ```
  Tokenization Error: Invalid Number (1:12; byte 11)
      a := 234234h //extra line context
      -----------^
  ```

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers! -->


### How do I print out the rest of the extra line context?
<details>
<summary>Show Hint</summary>

You will need to traverse the current line of text in the source text until you hit a newline. The error structs will have `line_start_byte` - use that to index into the original source text string, and go until the newline and get the byte number. Now you have the start and end and can print the whole line.

</details>


### What's the best way to generate a multi-line string in Odin?
<details>
<summary>Show Hint</summary>

Use a string builder! From https://zylinski.se/posts/introduction-to-odin/#working-with-strings-corestrings:

> Sometimes you need to build a string in several steps, you can then use a builder:
```odin
lines := []string {
	"I like",
	"I look for",
	"Where are the",
}
b := strings.builder_make()

for l, i in lines {
	strings.write_string(&b, l)
	if i != len(lines) - 1{
		strings.write_string(&b, " cats.\n")
	} else {
		strings.write_string(&b, " cats?")
	}
}

str := strings.to_string(b)
fmt.println(str)
This will print the following to the console:

I like cats.
I look for cats.
Where are the cats?
```
> You can pass context.temp_allocator to builder_make if you don’t need the string in the long run.

</details>


### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 8 reference implementation code](../../reference-implementation/step-008/main.odin) ([diff from step 007](../../reference-implementation/step-008/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the task description at `step-XXX.md (The next step is currently under construction.)`](../step-XXX/step-XXX.md).

[Previous Step](../step-007/step-007.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-XXX/step-XXX.md)
