v0.6.2 -- Sun Jun 28 22:57:18 EDT 2015
--------------------------------------
- Display condensed version of indices as a range.

v0.6.1 -- Sun Jun 28 22:57:18 EDT 2015
--------------------------------------
- pegged gem in runtime dependency because automatic update broke

v0.6.0 -- Sat Mar 28 22:32:12 EDT 2015
--------------------------------------
- added support for displaying tabular data

v0.5.0 -- Fri Mar 20 20:01:26 EDT 2015
--------------------------------------
- added `Question#reask`.

v0.4.0 -- Thu Mar 19 08:32:20 EDT 2015
--------------------------------------
- added support for stubbing Question#ask RSpec's `instance_double` method.
  (i.e. `instance_double("Interactive::Question", ask: nil)` does not
   throw an error)

v0.3.0 -- Wed Mar 18 11:28:05 EDT 2015
--------------------------------------
- Added support for questions without options
- Aliased `Question#ask_and_wait_for_valid_response` as `Question#ask`

v0.2.0 -- Mon Mar 16 21:52:21 EDT 2015
--------------------------------------

- Added support for handling an array.
- The items of that array gets internally turned into hashes, with keys
  corresponding to the index in the array.
- Putting in an array will eagerly trigger the full explanation of
  the shortcut (i.e. show the full explanation right after the question)

v0.1.0 -- Mon Mar 16 07:17:53 EDT 2015
--------------------------------------
- Added support for handling ranges.
- Useful for processing responses of questions like "Which item do you want to
  use?", where whole number responses such as "1", "2", etc. makes sense.
- Refactored, DRY'er.
