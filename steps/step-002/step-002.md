[Previous Step](../step-001/step-001.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-003/step-003.md)

# Task

Create a function called `tokenize()` that accepts an input string, and then returns a dynamic array of integers indicating the starting byte positions of each word in the input. Write a test that satisfies the given input.

# Test

  Input:
  ```
  This   is my program\n
  ```
  Expected output (a dynamic array of byte positions for each word):
  ```
  0
  7
  10
  13
  ```


# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

### Creating a test
<details>
<summary>Show Hint</summary>

Hopefully your language has a built-in test runner that you can use to call `tokenize()`. If not, just modify your `main()` function to call `tokenize()`. In either case, iterate through the output of `tokenize()` and assert that the correct starting byte positions for each word were found.

I would recommend keeping your test code inside your main file, and hard coding the input and expected output in the test itself. Later on, we'll have test files, but for now, that's too much overhead to deal with.

</details>

---

### Testing with Red, Green, Refactor
<details>
<summary>Show Hint</summary>

Steps:
* Get the test set up first so that it runs, but is failing.
* Then, make the test pass as quickly as possible, cutting corners along the way.
* Finally, now that the test is passing, go back and clean up the code and do it the "proper way".

This approach is called _Red, Green, Refactor_, and is a useful approach to testing because:
1) the _Red_ step guarantees that the testing infrastructure works and that tests can actually fail (you'd be surprised how easy it is to accidentally write tests that never fail!),
2) the _Green_ step helps you focus on reaching the outward behavior as quick as possible, regardless of code quality, and
3) the _Refactor_ step lets you freely do code cleanup and change the internal implementation without fear that you'll go too far, since you can go back to the code you wrote in your initial Green step. Also, maybe you don't need a more complicated or "correct" solution!

See [TDD, Where Did It All Go Wrong](https://youtu.be/EZ05e7EMOLM?si=7KTMHFLz7jobSd0v) for an excellent talk on this.
</details>

---

### Tokenization
<details>
<summary>Show Hint</summary>

Start tokenizing the source text by making a loop and looking at one character at a time. You shouldn't need to do anything more complicated than that.
</details>

---

### Tokenizing a word
<details>
<summary>Show Hint</summary>

To tokenize a word, start by skipping whitespace characters - i.e. space (` `), tab (`\t`), and newline (`\n`). If the current character is not whitespace, then you know you have hit your first word.
</details>

---

### Tokenizing multiple words
<details>
<summary>Show Hint</summary>

In order to tokenize multiple words while only looking at one character at a time, you need to make a simple state machine that indicates what state you are in (am I currently tokenizing a word for the current character?).

So, create a boolean variable that indicates if you are currently tokenizing a word or not. Set it to true when you hit a word (and output the starting byte position if it was false beforehand), and when you hit whitespace, set it to false.
</details>

---

### Single Character Tokenizer Explanation (Zig language tokenizer)
<details>
<summary>Show Hint</summary>

See [Zig Tokenizer -> Finding the Next Token](https://mitchellh.com/zig/tokenizer#finding-the-next-token) for an excellent explanation of a tokenizer that only looks at a single character at a time.

</details>

### Solution in Odin (Reference Implementation)

If you are still stuck, see my [step 2 reference implementation code](../../reference-implementation/step-002/main.odin) ([diff from step 001](../../reference-implementation/step-002/changes.diff)).


# Finished?

Congratulations! Copy your code into the next step's directory and [read the next step's task description at `step-003.md`](../step-003/step-003.md).

[Previous Step](../step-001/step-001.md) <-- [[Step Schedule](../../readme.md#step-schedule)] --> [Next Step](../step-003/step-003.md)
