#import "../template.typ": *

#show: template.with([Daily report (2026-05-13)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on getting some details of the implementation of certain drawing
routines changed. We also completely implemented support for lists with fewer
than 10 items. All of this came with quite a few refactors and fixes for other
bugs that I found along the way.

The refactoring to the drawing routines was fairly straightforward; The core
library provided a trait for traversing through the constants of a given
borrowed view, and now that trait has been extended to automatically provide
default implementations for multiple usecases that I have found to be common
across the codebase (related to traversal, and akin to `std::iter::Iterator`.)
This has also allowed the binary to make all uses of the trait far shorter in
code length, and possibly clearer to the reader. This also came with an
implementation for range selection of constants to allow having fewer than 10
symbols on the list, in preparation for the support we adder later on to
variably-sized lists.

We then went on to actually implement those types of lists. The bulk of the work
consisted of special casing a list with no items, and modifying the
implementation for advacing or retracting the position of the cursor in the
list. The former simply added a new routine; `print_empty`, which is now part of
the printer routines that we mentioned on yesterday's report. While testing
this, though, we also added support for character removal in the prompt through
the backspace key, which was lacking and now became very much necessary to
quickly test things out. The implementation for altering the active cusor
position was changed from using overloaded operators to having dedicated support
through its corresponding methods, as now determining whether the position is on
any one of the list's bounds requires having knowledge about external state
concerning the amount of items currently on display. This also came with a bunch
of QoL changes to navigation, such that is is more predictable in the way it
behaves (e.g. having the binding for the "down" motion not trigger a navigation
event while in the prompt.) Some other bugfixes that got solved include lacking
support for character insertion and removal at random byte indices of the
prompt, which was previously implemented by just popping or pushing to the
underlying string. This is, of course, insufficient when handling Vim-like
emulation, as insertion can cause removal at random positions.

The last major fix today (which has not yet been tested) consisted of fixing the
way the core library routine in charge of effecting changes to disk handled
symbols that were not meant for deprecation, but rather for \_undeprecation\_.
Apparently, idiotic me decided it was a great idea to just skip removing the
corresponding `deprecated` attribute to those constants that were modified from
being deprecated to not being deprecated anymore. That has been fixed, but
testing is pending. Finally, as I was attempting to test the "effect-to-disk"
event, I realized that `crossterm` required the keyboard enhancement protocol to
be active for certain events like a combo of `Shift` and `Return` to actually be
picked up. That has now been fixed by using the corresponding bitflags to
properly configure the features of the protocol we require.

Work on the currently open PRs continues on halt.

= Blockers
None at present.

= Plan for the week
Today's work has further proven yesterday's point; There is quite possibly some
more bugfixes pending that will likely hinder (to some extent) making further
progress this week. The goal of the week was accomplished today when support for
selection (completed yesterday) and support for variably-sized lists (completed
today) was finished. The only thing left is to test out the fix that I
implemented today for "effect-to-disk" events, and to implement scrolling
support. The former I can probably finish tomorrow, but the latter may take a
bit longer to polish. I expect that by the end of the week all of these will
have been implemented and the tool is already either ready for use or fixing up
the last few obvious bugs. I have thought, though, of adding the path to the
symbols as complementary information to each of the constants in the list, so
there's that.
