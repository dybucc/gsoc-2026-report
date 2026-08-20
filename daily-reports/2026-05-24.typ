#import "../template.typ": *

#show: template.with([Daily report (2026-05-24)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on finishing this week's goal and setting up some minimal
infrastructure for some (possible, but not assured) future addition to display
the values of constants.

The initial idea I had implemented for path display got scratched in favor of an
approach that focuses on tabulating the contents of the list such that we get
column-like formatting. This makes the end result look fairly clean, though of
course, forces whitespace-padding of elements whose identifiers are not as
(byte-wise) long as the largest identifier. This then caused issues when
displaying paths because there would sometimes be line wrapping, which itself
would become another source of issues.

The solution was fairly simple; Switch the order in which columns are printed,
and add an ellipsis to identifiers that are too long to fit the terminal grid.
This change meant getting the path displayed right after the deprecation mark
and before the identifier. To some small extent, this also reduced the max
padding required as the largest identifier among parsed symbols is still a bit
shorter than the path being displayed. We always print the full path, but then
we check if the identifier can fit in whatever remains of the line. This check
is still pending some more work to cover some edge case, but it's already
working nicely with the vast majority of constants in the `libc` codebase.

Another improvement to the path display was to properly format the path.
Previously, we were showing the fully parsed path to the constant, which is good
enough for purely functional purposes but no so much when put on display. At
present, the path is sanitized before being show on screen such that it only
outputs the module and eventual trailing source file from which the symbol was
parsed. This was a bit finicky to get right as some edge cases concerning
separators in user-provided paths could get the formatting to look inconsistent.

Beyond that, there's not much else to comment on. If at some point next week we
get to add support for displaying the values of constants, there's now dedicated
events for that. Though for the time being, these are ignored.

= Blockers
None at present.

= Plan for the week
This week's goals were sucessfully accomplished two days ago. Ever since then,
the refactors to the codebase have made the core library be far more organized
and have completely rid it of `unsafe` (which is _almost_ also the case in the
binary.) Next week, I expect work to be focused on ironing out bugs and actually
using the tool for deprecation of symbols. The first problem that I plan on
solving, though, is the afore mentioned edge case when displaying large
identifiers. Beyond that, I believe the tool is ready for "production"-use.
