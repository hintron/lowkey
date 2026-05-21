# Task

Modify `tokenize()` to take in an input string and returns that same string. Update your test runner to read in all `step-003-X-input.txt` files and then check that the `tokenize()` output matches `step-003-X-output.txt`.

`step-003-X-input.txt` is an input string to `tokenize()`.
`step-003-X-output.txt` is the expected output of `tokenize()` for the corresponding input file.
This should pass all `step-003-*` tests in [`tests`](../tests).

# Hints

NOTE: View this on a web browser in GitHub or in a markdown viewer to avoid spoilers!

<details>
<summary>Show Hint - Running Multiple Tests</summary>

Instead of creating individual functions for each test in [`tests`](../tests), simply create an array of steps that you want to run tests for. E.g.

```c
tests_to_run = ["step-003"]
```

Then, it's easy to change what set of tests you want to run your code on in the future (as `step-003` tests won't make sense for later steps).
E.g.

```c
tests_to_run = ["step-004", "step-008" /*, ...*/]
```

Then, create a variable `n = 1`, read `step-003-{n}-input.txt` as input, check the output against the expected output from `step-003-{n}-output.txt`, increment `n`, and repeat until no more input files are found.


</details>
