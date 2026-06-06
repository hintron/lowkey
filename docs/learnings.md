# Learnings

The following are various notes I learned about Odin while implementing the steps.

## Step 10 - Maps don't allocate keys!

In step 10, I was trying to save a value for every variable name, so I made a `map[string]int`. In the REPL mode, the `string` keys were all pulled from the same buffer used for `os.read()`. I started getting weird results when I would do the `state` REPL command to print the state, and all my one-letter variables started with `s`.

It turned out that all the strings used as keys were still pointing to the original `os.read()` buffer! So my one-letter variables were reading the `s` in `state`, the latest text in the buffer.

This was surprising to me, because I just assumed that the keys would have been allocated using the allocator for the map. Instead, I had to put in a cloned string when creating a new value into the map.

I want to look at the implementation of a map in Odin - I believe that it does NOT allocate keys, so if a string's data was allocated on the stack (not sure if that's even possible) or if it's backed by a buffer that is being reused (my case) then that will cause problems.probably should just look at the map delete procedure to see what it tries to delete. I'm guessing it doesn't delete the keys.
