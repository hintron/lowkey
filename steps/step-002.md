# Task

Create a function called `tokenize()` that returns the string `Hello, world, from the Lowkey compiler!`. Then, create a test runner program that will invoke `tokenize()` and compare the returned string to the contents of the expected output file [`tests/step-001-1.out`](../tests/step-002-1.out).

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

<details>
<summary>Show Hint 1</summary>

There are a few ways to create a test runner program. You can either:

* Use your language's built-in testing framework (if there is one) and call `tokenize()` from that.

* Or, have your main function print out the output of `tokenize()` and then run your program via a script (bash or shell scripts on Linux/macOS, or Batch or PowerShell scripts on Windows). In the script, capture the output, then read the contents of the output file, and compare the two.

* Both of these methods will be shown in the reference implementation, though I recommend using the built-in testing framework if possible, as that approach will be cross-platform and not involve learning scripts.

</details>
