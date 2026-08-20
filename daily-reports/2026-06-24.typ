#import "../template.typ": *

#show: template.with([Daily report (2026-06-24)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on fixing PRs.

The emscripten PR got rebased to latest `main`. The changes are fine. It needs
some documentation modifications. Those are pending.

The Linux musl PR also got rebased. No changes have taken place there.

The Fuchsia PR got the most attention. It needed a few tweaks. It also needed to
clarify some Fuchsia-specific definitions in commit messages. This is mostly
done. Another PR stemmed from this one. It's concerned with `sigaction`. This
type seems troublesome across targets. See the relevant comments for details.

The deprecation PRs all got rebased. They also got some documentation fixes.
They should be ready now.

The oldest Windows PR remains unattended. Linux uClibc and VxWorks PRs remain
unattended.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

= Plan for the week
Work has progressed as expected. The rest of the reviews should take one to two
days. I can move on to the `bsd` module then. The remaining PRs are mostly
concerned with minor changes. The exception is the Linux uClibc PR. It needs
splitting some changes into a separate PR. This still seems doable in the
allotted time. It will be finished before the end of the week.
