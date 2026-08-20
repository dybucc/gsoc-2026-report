#import "../template.typ": *

#show: template.with([Daily report (2026-07-20)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on two things; Touching up the MCP and submitting it, and
starting to look into the `rustc` code for handling target information.

The MCP was done and only needed another quick review before I submitted it, and
posted on the prior MCP about it. I also concluded that the `target_env` and any
other target-specific `cfg`s are likely specific to `rustc` versions; This would
make the most sense, as there's versions of the Rust compiler without support
for certain targets. The old MCP has been closed.

Of course, it was far from ideal to simply dump the idea and expect feedback
from T-compiler, so I started looking into the `rustc_target` crate (part of the
compiler codebase.) Thus far, I've concluded that the infrastructure to automate
the changes is there; The central record holding information on each target
contains itself a field that keeps the LLVM target triple. In LLVM, the OpenBSD
targets already have their release versions appended to the end of the tuple's
stringified representation. In theory, one could automate changes to the in-tree
Rust targets by only updating the LLVM targets, and scrape the value of that one
field. That would be possible if the field's value were already something
automated. But it's not, so that solution doesn't quite cut it. I also
considered the possibility for a bunch of OpenBSD-specific code to end up in
that internal crate due to implementation detals; I believe we will have to cope
with that and provide a small `FIXME` comment to remove this little hack once
either one of (or both) RFC 3750 and 3905 are stabilized.

I gathered these notes and some others under the comments of the new MCP. My
goal here is to see into having a PoC implementation where the `target_env` for
OpenBSD targets specifies their release version. Then I'd have to look into
setting up some CI workflow to update an isolated part of the code concerning
the available versions. I'm thinking expanding the `rustc_crate` with another
module that has a macro whose body is defined by an external (maybe `awk`)
script. Still, all of this is just an idea; Implementation details will be
ironed out later on.

Today I also commented again on the GNU/Hurd PR to, at the huge risk of
overstepping my boundaries, tell the target maintainer that the bulk of the test
suite in the rust-lang/libc codebase are generated at run-time and are not to be
"found" anywhere. I got the impression they were testing the wrong things when
they mentioned that the `rustc` test suite seemed more complete than the
dedicated `libc` test suite.

Other issues I've commented on remain mostly unanswered. One of the issues has
been answered by my mentor, which mentioned that I could just start opening up
PRs if the original author didn't answer back in a week's time.

= Blockers
None at present.

= Plan for the week
As originally mentioned at the start of last week, the plan was to have the MCP
done and start working on the implementation this week. This has been
accomplished. I expect to actually have something worth providing feedback to in
a couple days' time; possibly by the end of the week. I don't think I will
strike the right implementation by then, and neither do I expect to have set up
automation for OpenBSD version updates. That will have to wait until next week.
