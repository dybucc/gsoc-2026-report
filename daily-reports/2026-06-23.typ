#import "../template.typ": *

#show: template.with([Daily report (2026-06-23)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Most work on the PRs is done. The reviews have been answered. The fixes have
been mostly implemented.

The Fuchsia PR needed separating into smaller commits. This is mostly done. It
will be finished tomorrow. The Android PR needed fixing the title. It mentioned
bit width changes. It only deprecated types. The L4Re PR is blocked. The Linux
uClibc PR needs solving first. Otherwise it's all good.

The Linux uClibc PR seems done to me. The maintainer for a target intervened.
They mentioned the importance of backwards compatiblity. I've looked as far back
as uclibc-ng v1.0.0. This dates back to 2017. The file offset macros did not
exist in the original uClibc. That one has been unmaintained for years.

The emscripten PR is done. It will not be merged until we near 1.0. Otherwise
there's user concerns. These are due to mass deprecation.

The newlib PR seems done. Multiple target maintainers have intervened. They have
provided insight. They have also tested on actual hardware. The patch should be
ready now.

The VxWorks PR got reworked. The target maintainer intervened. Rust programs
can't compile to VxWorks kernels. They only compile to RTPs. Some changes are
now unnecessary. Documentation has also been added. This did not seem to appear
in the rustc book either.

All minor PRs have been updated. These are concerned with constant deprecation.

The Windows PRs seem done. One adds a `cfg` for `time_t`. It should not be
necessary. Windows has 64-bit `time_t` by default. `libc` exposed it as 32-bit
in Windows with GNU. The `cfg` exposes the correct definition. This is necessary
for stable. A separate PR changes the way `cfg`s are handled. That one has to
get merged first. The other Windows PR depends on the first one. It's
transitevely blocked.

TIL tier 2 targets only have to build. Testing is still nice.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

= Plan for the week
Work today has progressed greatly. The plan seemed at risk. This was due to the
larger Fuchsia rework. But all other PRs have been addressed ahead of time.
Fuchsia will be finished tomorrow. It only needs splliting changes into multiple
commits. That is mostly done. We will come back to the `bsd` module sooner than
expected. Though there's still feedback to be received on open PRs.
