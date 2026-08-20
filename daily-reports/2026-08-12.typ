#import "../template.typ": *

#show: template.with([Daily report (2026-08-12)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused mostly on reviewing PRs. I ended up not getting to any
new issues in the 1.0 milestone.

- I believe to have finished up work on the FreeBSD PR concerning the `netlink`
  interface.

- I commented some more on the ctest extension issue thread concerning
  conflicting items from different header files.

- I commented some on an Android PR I got pinged on.

- I'm almost done with the first draft for the GSoC work product.

- I tweaked some the L4Re PR.

I started off by addressing some feedback I had gotten on the FreeBSD PR. This
one I had already partially solved yesterday, and it only needed some finishing
touches.

The ideas I had yesterday for this one consisted of replacing the reexport I had
included from the `freebsd::netlink` module in favor of a reexport of the
modules within that module.

This way, we can get cleaner paths in the little workaround we set up in the
SemVer plain text files, and I also (potentially) solve another piece of
feedback I got on the reexport.

Yesterday, I also commented again on the ctest extension issue thread mentioning
that I didn't quite see where the issues lied at. My mentor answered that we
were potentially mixing `-l` flags to multiple binaries.

I then read through the docs for the `cc::Build` type (which is what ctest uses
for compiling the C side of things,) and realized that, indeed, it also issues
Cargo metadata on linked libraries.

The odd thing is that we've yet to stumble upon this issue in some test. I
commented that beyond finding out why this was the case, we could also disable
the option that triggers this behavior in `cc`.

Granted, that would require manually compiling the Rust files, though this could
maybe be automated by calling separate "sub-invocations" of Cargo within the
build script. That seems hacky, though.

I also got pinged on some old-time Android PR that got recently merged. My
mentor was asking if I knew something on the `time_t` and LFS situation on
32-bit targets, and I linked to some Bionic docs.

Afterwards, I worked some more on the GSoC work product, and I believe to be
mostly done. I've already finished the report on each of the changes in which I
was involved, and I'm working on the closing words.

Those mostly consist of a discussion on the learning experience and what not.

The last thing I got to was the L4Re PR. This one got new feedback from the
target maintainer today, and I've been addressing those concerns up until it was
time to write today's daily report.

Basically, they're planning to support 32-bit targets, so I had to gate the
deprecations under a nested predicate that only applied to 64-bit targets.

Then there's also an issue with the fact we can't declare type aliases that are
considered to be records by ctest even if they're equivalent to existing
records. This means I'll have to revert some changes.

= Blockers
None.

= Plan for the week
The GSoC work product has been taking up more time throughout the last few days,
and I think that's the reason why I only got to review and tweak existing
patches today.

Tomorrow will likely be the last day I actually write something new in the
initial draft, so I should have more leeway to take on new issues in the 1.0
release milestone.
