#import "../template.typ": *

#show: template.with([Daily report (2026-06-19)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were centered around solving all of the new feedback I got on my
open PRs. This was both great and unexpected, as I initially thought that I
would have finished with it before the end of the day, but things turned out
differently.

The bulk of it consisted of trying to understand the feedback, answering back if
I didn't quite get what was my mentor getting at, or just getting to work and
fixing stuff.

One of the simplest things to fix was incorrect naming of commits and pull
requests. Admittedly, at some point along the way, I just submitted everything
tagged as a refactor, when ofttimes it was a modification that would
considerably alter behavior. That was not as high priorty as other fixes, so
I've been going through it as I fixed/answered pull requests that I had gotten
other types of feedback from.

Beyond that, there were quite a few cases where the patch submitted in the PR
was deprecating the symbols but not necessarily providing a way of easily
backporting this to the stable release. Some of these PRs actually did solve the
issue simply because the upstream libc implementation was already providing
64-bit types by default, and only aliasing the suffixed types to the unsuffixed
types. An example of this is musl or Android (the latter of which only applies
for targets with a 64-bit ABI.) These should only make downstream code depending
on the `libc` crate get some warnings from having deprecated LFS types, but no
breakage is expected.

Then there were some documentation fixes that I have not gone through in full
just yet, but should be fairly simple to fix. Work is currently focused on
implementing `cfg`s and possibly integrating them with both the build script and
CI. I say "possibly," because some of the target triples that would need those
(such as the tier 3 targets using uClibc) are not tested in CI, so I only have
to worry about correctly exposing the `cfg` (the `libc` crate does not use
feature flags for making this particular type of functionality available.)
There's also some missing docs on current `cfg`s (meaning I didn't add them, but
it'd be nice to have some usage indications) that I have to add on a separate
PR.

On that note, I also found out that thoroughly testing on tier 3 targets was not
really necessary, so I've relaxed those requirements on my open PRs. Now I can
breath easier knowing the issue I had with building a toolchain to test tier 3
mips targets with uClibc does not need immediate solving.

I also got feedback on my original (pre-GSoC bonding period) PRs on Windows, but
those I've yet to go through.

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this front have failed. This is low-priority,
though.

= Plan for the week
For the third time in a row this week, I found myself with an unexpected work
load. Tuesday and Wednesday brought me great news from both `android` and `bsd`
modules seeming simple to go through, but today I just got new work from the
open PRs. This means this week will quite definitely not be the week I finish up
the `bsd` module. Hopefully, I can get all of the `cfg`s set up by the start of
next week and possibly round up answering/fixing PR reviews halfway through next
week. If nothing comes up then, i'll move on to the `bsd` module.
