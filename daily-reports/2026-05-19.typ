#import "../template.typ": *

#show: template.with([Daily report (2026-05-19)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was purely focused on debugging the (ever present) issues with saving
symbols to disk and keeping their spans updated after the fact. This has proven
to be quite hard to solve, but so far the bug is likely in that the deprecation
attribute of the traversed constant we get access to through the
`change_constants_in` routine is not really having any effects. It may also be
that this is working just fine, but the routine in charge of updating spans is
the one at fault. For the time being, these are the two main culprits I can
point to, but no patch has been implemented just yet.

Beyond that, work has also gone into adding the source file path of the
constants to their visual display when shown in the filter list. This was
already planned, but has become a necessity as I was trying out whether the
latest major patch we submitted (concerning formatting when the file is writtten
back to the file system) worked correctly. Thus far, that bugfix has proven to
be acceptable (but not demonstrably correct) in its implementation. The problems
arise in the additional routines I added to the `FormatFile` type to allow
updating the spans of constants that were parsed from the same source file.
This, as mentioned above, is still a WIP, but potential sources have been
diagnosed. Do note, though, that the path feature is still very much in its
early phases, as no formatting whatsoever beyond mere output printing of the
path (as parsed by `syn`) has been added.

No work on implementing scrolling has taken place today.

The PRs got rebased a few times today.

= Blockers
None at present. The one issue that's taken some days to solve all related bugs
has been the save-to-disk `effect_changes` routine, though I have submitted
multiple patches for different bugs as I came across them, and I expect the one
I'm currently working on to be no different.

= Plan for the week
With the looming deadline, it may just be that either scrolling support is
scratched completely in favor of modifying the list of regex-filetered symbols
to the size of the terminal buffer grid (in rows,) or that it gets implemented
in a hurry. I believe that the current bug is likely to take me two more days to
fix, and make sure everything works just fine. This means that we won't be
working on scrolling support starting from Thursday, but rather from Friday or
even Saturday. The proposal plan mentioned that the tool should be complete by
the first week of the coding period, and that's still feasible. The only things
left to finish up a working implementation are to fix this save-to-disk bug and
to implement scrolling support. Both of those should quite definitely be
complete by next week. It just so happened that I would have preferred to kept a
hard cap on both of those this week, to then go on to iron out whatever bugs
were left on the last week that I planned to allot to this part of the proposal.
