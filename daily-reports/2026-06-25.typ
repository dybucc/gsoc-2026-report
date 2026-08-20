#import "../template.typ": *

#show: template.with([Daily report (2026-06-25)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on two things. We finished up fixes in PRs. We also
continued work in file offset types and `time_t` in other modules. The latter
has progressed greatly.

A bunch of PRs got rebased. The VxWorks PR got merged. All of the constant
deprecation PRs also got merged. The latter needed fixing broken doc links. The
former needed some rephrasing.

The L4Re uClibc PR got reviewed. I may end up removing the AArch64 module.
There's no Rust supported target with that target triple combination. That's
been held off for the time being. The priority is solving the Linux uClibc PR.

The Windows PR fixing 32-bit symbols is done. It was blocked. The PR changing
the way `cfg`s are set got merged recently. That was its only dependency. Now
it's not blocked anymore. Changes have been made. A review is pending.

I finally moved back to the `bsd` module. that's done. No changes have been
deemed necessary. Both `time_t` and file offset types only exist as 64-bit
unsuffixed types. I then moved on to other `unix` submodules. The following have
all been reviewed. No changes were deemed necessary.

- Solaris and Solaris-like systems.
- Haiku.
- Redox.
- Cygwin.

I removed some stub submodules. They supported target architectures that don't
have Rust support. The patch is not ready. It needs a write up and a PR. That
should be done tomorrow. Though this may not be worth it.

The `nto` module couldn't be reviewed. I couldn't get a hold of the QNX neutrino
SDK. Either i'm missing something or their download center is broken. This also
happened while deprecating constants.

I'm currently working on the `aix` module. I don't know where to get system
headers. I'll look some more into this.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

= Plan for the week
Work today has provided some relief. Almost the entirety of the `unix` module is
done. That means the proposal deadline will be met. It should be completely
finished by next week. That even leaves some room for reviewing PRs (if there's
need for them.) A number of the currently open PRs also got merged. The Android
one should be straightforward to merge. The musl and emscripten ones also apply.
Though they will likely be blocked until we near 1.0. That leaves the Fuchsia
and uClibc PRs. The latter seems done to me. The former also seems complete.
Testing is pending on both.
