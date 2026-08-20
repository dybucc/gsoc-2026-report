#import "../template.typ": *

#show: template.with([Daily report (2026-05-12)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on quite a few things, chief among them getting the entirety of
the selection bugs solved. Firstly, we tackled the issues that had been put on
hold during last week concerning the implementation of a pivot mechanism to
actually make sense of the selection range we kept in the running state. This
meant going through a few more bugs related to the way constants were drawn, for
which we've got more to say later on.

The way we ended up implementing selection was quite neat in that the pivot is
assummed to be a fixed point from the moment the user enters the selection.
Beyond that, there's not much else to it; The current position of the cursor and
an indication of whether the motion is upwards or downwards serve to implement a
small state machine to check whether the start bound or the end bound of the
underlying range should be modified. Throughout testing, a few cases we didn't
handle correclty popped up and were fixed accordingly, though they were all
admittedly silly one-liners. Along the way, I also got to tweak the `tracing`
configuration for the logs we keep in debug builds to use far less formatting
bloat; This actually sped up all the rest of the debugging that I went through
afterwards.

While fixing this, I also spotted a bug with regex filtering that I thought was
purely cosmetic at first, but as it turns out, required a patch in the core
library. The issue lied in the way we gathered regex-filtered symbols into the
reusable borrowed view that gets passed onto the corresponding routine;
`collect_into` seems to use the `Extend` trait without clearing up the contents
of the container that it is collecting into. This made quite a lot of sense when
thinking about it, as being iterator-implementor agnostic, it cannot make
assumptions about how should the collection be "cleared" (or where is it that it
is gathering items into.) Because the container was not being cleared, but
rather appended into, the set of constants displayed in the TUI corresponded
with the first 10 symbols in the collection -- the symbols that were in it prior
to the regex search. This was fixed by simply clearing the buffer before filling
it anew with the regex match results.

As I was solving this, I found two more bugs; Constants were not being properly
toggled when pressing the corresponding binding, and search results with fewer
than 10 matches would not get properly rendered. The latter issue I already
expected, as I delayed implementing support for lists with less than 10 symbols
to do it once I added support for scrolling. The former issue was quite odd, as
the problem seemed to be in the way we checked whether we should perform the
toggling operation used in select mode or the one meant for normal mode. The
differences between the two lie in that normal mode toggles all symbols in the
search results, while select mode cuts it down to only the symbols under the
current selection range. Of course, when attempting to toggle in normal mode,
and instead getting the operation for select mode, the only symbol to be
deprecated is the first one (as that is the default selection when not in select
mode). The fix was simple, because the source of issues itself was odd; To
determine whether we were in select mode, I checked for the underlying range of
the running state's selection to be empty. This invariant did not hold up after
the refactor/fix to the selection system that I did today. Now we just check for
the active mode, and call it a day.

The issue with rendering lists wiht fewer than 10 elements has been "partially"
fixed, as rendering itself is not complete, but the part of the program that
panicked has been fixed. As I was doing this, I also noticed that the current
way of displaying visual feedback when in select mode was subpar (to put it
midly,) so I slightly refactored the type that I implemented yesterday for the
purposes of isolating formatting and printing of list items (symbols) to allow
separately setting the style of the deprecation mark and of the constant's
identifier. Now we don't use colors, and only dim an item's identifier when
selected.

Work on the currently open PRs continues on halt.

= Blockers
None at present.

= Plan for the week
With today's work, I both expect this week's goal to be accomplished before
time, and to find a bunch more bugs in other parts of the code. Support for
lists with less than 10 items should probably be done by tomorrow, and then
there will likely be a bunch more bugs solved. Beyond that, implementing
scrolling is the next step, and will likely require a tad bit more time, as
unlike selection, there is no prior type infrastructure nor existing integration
in the running state to improve upon. Though as per the usual, we'll see.
