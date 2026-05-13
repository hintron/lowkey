This was originally based on this walkthrough from Jonathan Blow:

[Discussion with Casey Muratori about how easy precedence is...](https://youtu.be/fIPO4G42wYE?si=MaMlMQjjCxqD0rUE)

The goal of the video is to show how to properly parse the expression `a > b + c * d + e` with proper precedence without having to "fix it in post" and go back and rewrite the AST with proper precedence after the fact.

This project will implement this with Odin.



