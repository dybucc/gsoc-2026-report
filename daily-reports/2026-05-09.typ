#import "../template.typ": *

#show: template.with([Daily report (2026-05-09)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Work today was focused on solving yesterday's open issues. This turned out
pretty well, as most of them were fixed and have been proven to work out just
fine (and the only one that didn't get tested still got a patch.) Firstly, we
tackled implementing the `ensure_libc` routine to fail in the library routine
`scan` whenever the given path existed but did not correspond with `libc`'s
codebase. This was very simple, and it made testing easier. While implementing
this, a bug in the way the routine handling the second layer of event processing
was found; Upon absence of events, it would just issue a termination event. The
fix for this was also fairly simple and itself involved refactoring the code
into simpler logic.

We then went on to fix the issues with CPU consumption in the rendering loop.
The solution was again fairly straightforward, as we only had to stop looping on
repeat to avoid adding up all those cycles. This was done by changing the same
routine that we just refactored for event processing such that it awaited events
from the first event processing layer; This makes it so that the async scheduler
just waits on hold as no tasks can progress lest the input handler receives an
event.

Finally, as I was testing things out, I found a new bug. This consisted of
synchronization issues related to the way we handled thread-unsafe types from
`syn` (and more specifically, from `proc-macro2`) within the parsing routines of
the library with the core logic. As it turns out, my reasoning about `syn` types
having fallback implementations that were thread-safe was not in the wrong, but
did miss the fact that there's some span-related functionality that relies on
globals with TLS. Because we scanned the files, stored them in a type of our own
and then parsed them, this caused issues whenever one task happened to run in a
different thread from the one where the backing source map (an implementation
detail of `proc-macro2` to keep track of file span information) was filled
during file scanning. The solution I went for was to reduce the surface API of
the backing library to offer only one entry point routine; The `scan` function.
Previously, this parsed files, and then allowed the user to scan the constants
from those files with a separate routine, which caused issues with the locality
of storage between the thread in which files were scanned and the thread in
which constants were parsed from. Now, the whole thing is done all at once; This
has required some further refactoring of the core library but has both solved
the issue and made for less instances of `unsafe` code to be used all throughout
it (for the always-`Send + Sync` wrapper types.) This has not yet been tested,
but `tracing` diagnostics lead to believe the issue lied in parsing constants
(which fetched their spans when constructing our own abstractions over them,)
and I think this issue should be solved, but of course, we'll see.

Work on the PRs continues on halt.

= Blockers
None at present.

= Plan for the week
The goal of this week was already accomplished yesterday, and ever since it's
all been about debugging issues to actually get a working rendering loop with
something feasible on-screen. I believe I can get that done by tomorrow if no
major issues arise. Beyond that, I plan next week to be dedicated to getting
proper handling of all state in the drawing routine, as state updates are mostly
done (only have to solve some issues with selection extension.) This should not
take long, and so I hope I can debug some more stuff along the week, as well as
throughout the week after the next.
