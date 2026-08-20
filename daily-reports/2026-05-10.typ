#import "../template.typ": *

#show: template.with([Daily report (2026-05-10)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on two main things; Refactoring the code from yesterday's
overhaul of the core library, and tweaking some details of both the
pre-rendering terminal manipulation logic, and the (still bare) drawing logic.
The refactor was required because yesterday we had to change the public API, and
that meant tweaking some symbol availability across the crate, as well as moving
some docs and refining some interfaces. This also allowed me to refactor the
error handling module to be more modular in its internal implementation, such
that there's less reliance on direct construction and inner value matching for
types that have sources of errors represented as enumeration variants.

Beyond that, the fix we implemented yesteryday for the synchronization issues
proved to be correct, and multiple test runs show that there are no more panics
during initialization due to missing span information. This meant that I could
finally focus fully on the rendering loop, as well as fixing up other parts of
the codebase that were still not working just fine. Work has started with a
refactor of the routine in charge of making space for the TUI, which so far was
attempting to get a similar effect to getting the terminal in cooked mode to
move the entire contents of the terminal buffer up, to allow space for the TUI.
I finally concluded that was infeasible; I delayed enabling raw mode until right
before entering the rendering loop, and reworked the `prepare_space` routine to
exploit the line buffering and line feed events in cooked mode. This allowed
making code simpler in that routine, providing a very straigthforward way of
getting the terminal emulator to "make space" for the 11 rows the TUI needs.
Alongside these changes, the actual drawing routine within the rendering loop
got refactored to coordinate with the escape sequences that we issued in the
`prepare_space` routine (and thus require fewer commands to be issued anew.) As
I was testing this out, one edge case uncovered a bug in the order of commands
issued w.r.t. the time when the `SavePosition` command is issued. This caused
the TUI to render incompletely once it entered the rendering loop whenever the
user shell launched the program with less than 11 rows left in the terminal grid
of their terminal emulator. This has not yet been fixed but should be fairly
simple to patch up.

= Blockers
None at present.

= Plan for the week
The goal of the week had already been accomplished two days ago, and today test
runs have proven that the TUI layout looks as expected, except for the one edge
case mentioned in the summary. This should be easily fixable, and so I plan next
week to be dedicated to fixing issues with the selection logic, to then proceed
to both implement and test out how does the drawing routine handle state updates
(which themselves were already implemented this week.) I'm not sure if next week
I can also fit in scrolling support, but we'll see. Either way, the proposal
plan continues as expected; By the first to second weeks of the "coding period,"
the binary should be finished and actual deprecation of symbols should have
started/finished.
