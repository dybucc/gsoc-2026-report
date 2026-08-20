#import "../template.typ": *

#show: template.with([Daily report (2026-05-16)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on getting the issue with effecting changes to disk
completely ironed out, but today's efforts were insufficient in accomplishing
this. The major patch today solved yesterday's bug with constants from macro
bodies not being correctly taken into consideration when saving to disk. I
decided to tackle this by designing and implementing a container and iterator
over the constants that could be (potentially) parsed from the `cfg_if` macro
body. This required mirroring some parser functionality I had already
implemented for initial scanning of the codebase, as well as some type
infrastructure to unify parsed constant items and macros into a single, unified
view that was passed to an externally-sourced closure to manipulate.

THe rest of today's work was focused on refactoring this by reducing
fragmentation in some abstraction layers of the underlying implementation.
Beyond that, work has focused on attempting to completely fix issues with saving
to disk, though this has not yet been solved. The issue now lies in that going
from a state opposite to the one with which the symbol is loaded into memory,
and then going back to the initial state (irrespective of whether this is
"deprecated" or "undeprecated") does not correctly perform the roundtrip.
Minutes before writing this report, I realized that was caused by the spans of
the constants under consideration changing from when they get
deprecated/undeprecated to the opposite state. When parsing the file in which
the constant is contained to find a match and modify it prior to effecting
changes to disk, this skips the constant and thus no changes are actually
effected. The tracked span is based off of line numbers and columns, so adding
the attribute or removing it changes this information about the symbol.

A patch has not yet been implemented, but will be coming tomorrow.

Work on the PRs continues on halt.

= Blockers
None at present.

= Plan for the week
What yesterday I expected to be one day's worth of work will become two days'
worth of work, which means scrolling won't be finished until at least Wednesday
next week. This is all, of course, under the assumption that fixing the current
bug does not reveal further inconsistencies in the way we handle saving to disk.
This week's goal was modified halfway through the week to also aim for scrolling
support. That expectation was set while solving one of the first bugs that I
discovered when saving changes to disk, and ever since, I have continued finding
more bugs and submitting more patches. Still, the minimal features required to
actually deprecate constants continue to include scrolling, as that is needed
for regex filter results that contain more than 10 items, so I won't be giving
up on that just yet. Considering the expected timeline is to finish the binary
by the first to second weeks of the "coding period," this still seems feasible.
