#import "../template.typ": *

#show: template.with([Daily report (2026-07-27)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has shifted towards getting the new ctest usecase that appeared in
the FreeBSD `netlink` PR patched.

I didn't get any answer just yet from yesterday's query, but I needed to solve
this before moving on to something else. That's why I decided I would try to
solve the problem in the simplest possible way; Patch the libc-test build
script, and avoid having to extend the test harness. I believe this to be the
best approach because this usecase is not something we ever expect to support
(even on 1.0,) and the FreeBSD PR itself only requires this as sort of hack.

I first started off by changing the main routine in charge of generating the
tests in FreeBSD targets, so that it took an input variable that determined
whether the currently tested interface was that of `net/if_mib.h` or that of
`netlink/netlink.h`. Yes, this currently means we're running the whole test
suite twice but it's a WIP and CI runs quick enough while I work through the
solution.

This input variable is then used in the predicate for the macro we use for
including headers in ctest's test generator, so that we avoid having the
`#include`s from both of the above headers collide in the C template. This same
variable is then used to selectively skip certain symbols corresponding with
those of either one of the two interfaces on the Rust side of things. This is
necessary because ctest itself will try to generate C tests from the Rust items
it parses (it doesn't parse the C headers.)

This solved most of the test failures, but it needed some further tweaking to
avoid testing other types that don't conflict between headers but that just
aren't there when the `#include` is skipped.

The last thing I worked on was the SemVer tests. These get generated from plain
text files that include a single symbol per line. Each of these is then parsed
and included verbatim as an item import in a generated Rust file that contains
nothing but the imports themselves. This is to ensure that the surface API of
the bindings isn't accidentally removed. The generator isn't smart about the
items, so it assumes all symbols are reexported at the crate root level. This
means having a public submodule like that of the afore mentioned PR causes
spurious errors.

The nifty thing here was that there's no precedent of platforms tweaking these
tests. We just removed the symbols from the plain text file when removal was in
order. Ideally, I would want not to skip them because that would either way
require setting up skipping logic (as this doesn't rely on ctest.) The solution
I'm working through right now is to keep a list of symbols that need to be
imported not through a `libc::<symbol>` import statement, but through a more
fine-grained `libc::netlink::<symbol>` import. This is still a WIP but I believe
it to be the simplest solution that we can get rid of fairly simply once we
settle on which interface to keep post-1.0.

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback. The Windows function pointer issue thread also remains silent.

= Blockers
None at present.

= Plan for the week
Both the MCP and the Windows issue are currently on halt. I'm expecting to get
an answer at some point throughout the week, and the same applies to the rest of
open PRs. Still, it seems like folks have been laying low in the rust-lang/libc
repo for the last few days, so I hope to finish up work on the ctest stuff by
tomorrow. I expect the only thing left is to finish the SemVer tests' patch, and
tweak the FreeBSD test routine to avoid having it run everything but the
affected bindings twice. Both of those should be simple tasks.
