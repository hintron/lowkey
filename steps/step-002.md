# Task

Create a function called `tokenize()` that accepts an input string, and then returns a dynamic array of integers indicating the starting byte positions of each word in the input. Write a test that satisfies the given input.

# Tests

#### Test 002-1:

  Input:
  ```
  This   is my program.
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

<details>
<summary>Show Hint - Creating a test</summary>

Hopefully your language has a built-in test runner that you can use to call `tokenize()`. If not, just modify your `main()` function to call `tokenize()`. In either case, iterate through the output of `tokenize()` and assert that the correct word starting byte positions were found.

I would recommend keeping your test code inside your main file, and hard coding the input and expected output in the test itself. Later on, we'll have test files, but for now, that's too much overhead to deal with.

</details>

<details>
<summary>Show Hint - Red, Green, Refactor</summary>

* Get the test set up first so that it runs, but is failing.
* Then, make the test pass as quickly as possible, cutting corners along the way.
* Finally, now that the test is passing, go back and clean up the code and do it the "proper way".

This approach is called _Red, Green, Refactor_, and is a useful approach to testing because:
1) the _Red_ step guarantees that the testing infrastructure works and that tests can actually fail (you'd be surprised how easy it is to accidentally write tests that never fail!),
2) the _Green_ step helps you focus on reaching the outward behavior as quick as possible, regardless of code quality, and
3) the _Refactor_ step lets you freely do code cleanup and change the internal implementation without fear that you'll go too far, since you can go back to your initial Green step.

See [TDD, Where Did It All Go Wrong](https://youtu.be/EZ05e7EMOLM?si=7KTMHFLz7jobSd0v) for an excellent talk on this.

</details>
