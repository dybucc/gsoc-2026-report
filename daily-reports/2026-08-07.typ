#import "../template.typ": *

#show: template.with([Daily report (2026-08-07)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on three things; Getting stuff on the L4Re PR a bit more
sorted out, looking through the Android issue and (possibly) solving it, and
(possibly) finishing the MCP implementation.

The L4Re PR was straightforward to look through, but the current status is not
satisfactory. I have received new feedback on it, but I've to look into it. It's
a bit unsettling because a certain macro that should expose some symbols isn't.

To expand some more on this, in L4Re header files, one can get LFS support by
either defininig the explicit macro for that or setting some other macro that
serves as a flag that enables further macros (among which we find LFS support.)

The funny part is that the "general" macro that does just that is already
defined in CI test infra, and yet we're not getting the symbols exposed. This is
the reason behind the errors that the target maintainer reported on.

The Android issue was actually straightforward to solve as the target maintainer
mentioned that we should just follow the POSIX definition. Following my mentor's
advice on the issue thread, I tried disabling the `ioctl` skip in ctest tests.

At present, only doing that won't pass muster. I additionally added another
`#define` for the macro that Bionic libc uses to skip the overloaded version
taking a request parameter constant of differing signedness.

After another CI test run on the Cuttlefish emulator, things seem to work
without skipping `ioctl` from ctest. I've opened a PR with this and reported
back on the issue thread.

The last thing I went through today was the MCP. This was so much simpler than I
had initially thought. The changes were bound to be small, so that's expected.
Still, I haven't opened a PR just yet.

My work can be found in the `main` branch of my fork of `rust-lang/rust`.

I actually intended on doing some more stuff today, but I decided to instead
spend some time switching editors to avoid issues I've had in the last few days.
I also had some pressing real life concerns in the morning.

= Blockers
None.

= Plan for the week
Things have gone better than expected. The MCP patch is ready to have a PR
opened and almost everything I wanted to tackle is done. Now only the FreeBSD
`netlink` stuff concerning ctest and the non-exhaustive macro remain.

I plan on working on the non-exhaustive macro tomorrow, and hopefully finishing
up work on it. I initially intended that to be part of today's work, but that
ended up not being the case.

Sorry for not answering to the Zulip messages. I will be doing so promptly.
