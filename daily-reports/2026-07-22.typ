#import "../template.typ": *

#show: template.with([Daily report (2026-07-22)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was mostly centered around reviewing feedback on older PRs I had
received in the past few days.

I actually started off by answering to the Zulip thread where the MCP is being
discussed. I commented on some concerns I had about this proposal potentially
only serving as a future-proof and not as a solution for the current OpenBSD
issues. This applies equally if we end up using one of RFC 3750 or RFC 3905,
because the `libc` MSRV is likely not to be bumped enough times in the next few
years to reach the `rustc` version where either one of the MCP or the above RFCs
get implemented. Implementation-wise, I went through it all again, and added a
couple of new sections to the MCP where I both answer some questions I had
myself, and provide what I believe to be a step-by-step implementation plan.
Beyond that, though, no further discussion has taken place.

The next thing I did was to go through most of the PRs I had recently received
new feedback on. I'm done with all of them except for the GNU/Hurd PR, which I
haven't yet taken a look at, and the issue I opened concerning function pointer
mismatches under Windows GNU. There weren't too many things to fix; It was
mostly just me commenting on stuff and fiddling with the patchset. I've split
the Linux uClibc PR so that the changes concerning LFS and the new `cfg` are now
on a separate PR. I've also asked for feedback from current and past maintainers
for Rust targets using uClibc, as it's not entirely clear the degree to which we
should support upstream build options (which is how uClibc manages LFS.)

I don't currently remember (nor have the time to look up) which other PRs I
commented on nor exactly what did I say.

Other issues I've commented on remain mostly unanswered. I've yet to open the PR
where the original author approved of somebody else continuing their work, but
that's a trivial task. The actual work was done last week.

= Blockers
None at present.

= Plan for the week
The MCP has taken up far less time than I expected, and going through the PRs
has also been far easier than expected. This means I can probably finish them up
by either tomorrow or the day after, assuming no relatively large changes are
required in future feedback. Afterwards, I will proceed to open up PRs for the
issues I had been waiting to hear back from their authors for a week. Of those,
there's already one where the original author has given thumbs up to my taking
over. That will be done soon.
