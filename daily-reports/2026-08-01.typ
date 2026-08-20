#import "../template.typ": *

#show: template.with([Daily report (2026-08-01)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused around two things; Looking into a new issue I got pinged
in Zulip, and (possibly) finishing up the new issue I set my eyes on yesterday.

At the start of the day, I noticed a ping in Zulip on a new issue concerned with
ctest's own test suite. Apparently, Cargo has changed some build internals and
some code (unidiomatically) handling build paths broke.

I noticed this while I answered to the MCP thread, where I believe my concerns
are now solved. I believe it's mostly done; The only thing left should be for
the target maintainer to approve the proposal.

Back to the above issue, I was pinged by my mentor as I had been recently
looking into ctest internals to extend it (see prior reports on the FreeBSD PR
that needed this.) Another contributor has already opened up a PR with a fix.

I simply reviewed the PR and pinged my mentor on it to get some final approval
from someone presently more experienced than me. It replaced the manual code
handling paths to using Cargo's `CARGO_BIN_EXE_*`'s environment variables.

I then went on to focus on the issue that yesterday I had only decided to take
up on but didn't quite get to read through. It tried to replace all instances of
`struct`s for `union`s when a `union` was used upstream.

This dates back to Rust 1.19 and it hasn't received any attention since it was
opened and some comments were made six years ago. These days, I don't think I've
seen this happenning. Still, I decided to inspect further.

Following the advice on the issue, I looked through the libc-test build script
and realized that there was some cruft left. It was mostly `struct`s with fields
that only reflected a single field of the upstream C `union`.

I cleaned those up, but also noticed that both Haiku and Illumos targets still
had more than just build script cruft left over. They had actual records that
used other records instead of proper `union`s.

I fixed those and the PR is ready to be opened. I may open it after I finish
writing this report or it may have to wait until tomorrow. Either way, there's
also some things to note about other targets that I need more guidance on.

Those concerns will be included in the PR description.

The Windows function pointer issue thread remains silent. Other issues I've
commented on also remain silent.

= Blockers
None at present.

= Plan for the week
The MCP should now be ready for the target maintainer's review before getting
merged. Other issues continue to remain silent but those I'll just have to
continue periodically pinging all subscribers on as weeks go by.

Tomorrow I'll open the patchset I finished today, which should hopefully close
that old issue. Beyond that, I think this week's goals have been accomplished
and surpassed.

I'll message my mentor again tomorrow to see whether they'll be inactive next
week as well.
