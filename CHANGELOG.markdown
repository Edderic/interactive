v0.1.0 -- Mon Mar 16 07:17:53 EDT 2015
--------------------------------------
- Added support for handling ranges.
- Useful for processing responses of questions like "Which item do you want to
  use?", where whole number responses such as "1", "2", etc. makes sense.
- Refactored, DRY'er.

v0.2.0 -- Mon Mar 16 21:52:21 EDT 2015
--------------------------------------

- Added support for handling an array.
- The items of that array gets internally turned into hashes, with keys
  corresponding to the index in the array.
- Putting in an array will eagerly trigger the full explanation of
  the shortcut (i.e. show the full explanation right after the question)
