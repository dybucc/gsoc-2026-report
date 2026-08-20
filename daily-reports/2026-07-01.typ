#import "../template.typ": *

#show: template.with([Daily report (2026-07-01)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused solely on attempting to run tests on the GNU Hurd. I've
again failed miserably.

Efforts initially continued from yesterday's attempts at building a Rust
toolchain. I thought I had a lead on what was going on with the build errors. It
was apparent that the linker used while building did not recognize certain
arguments. I believed this to be due to the linker pointing to a wrong binary on
my system. But the issues still persisted after I prepended a newer LLVM linker
on my user PATH. I also tried to set the environment variables read by `cc-rs`.
Nothing worked. The LLVM release notes for the linker version I was using
mentioned they had added support for those flags in prior releases. It should
have worked.

I then switched to attempting to build only the `libc-test` test suite. This was
also met failure. In this instance I had to provide a GCC cross-compiler. The
issue here is that I could only find precompiled artifacts for freestanding
environments. So the build failed because no sysroot was provided so the
system-specific headers used in `libc` were not available. I tried building a
sysroot for the prebuilt cross-compiler I had found for x86\_64 with ELF
support. This meant building the GNU Hurd's glibc sources. Suffice to say that
went terribly bad. As it turns out the libiconv shipped with my system may be
the source of issues. though I decided against any further attempts to build on
my system because I ran out of disk space. I then went on to try to build a
cross-compiling `gcc` from GitHub Actions following the official GCC docs. This
is a WIP.

Write ups for the GNU Hurd and NuttX PRs are not yet ready.

= Blockers
None at present.

= Plan for the week
It seems like testing on the GNU Hurd is going to be take longer than expected.
Building the `libc-test` test suite seems like the only way out. but a
cross-compiling `gcc` is needed for that. I will temporarily put these efforts
on halt. Tomorrow I will prepare the write ups for the NuttX and GNU Hurd PRs.
Then I will resume work on building the cross-compiler. If this is not met with
success in two days' time I will put testing on the GNU Hurd on halt. This
should leave two days for inspecting the AIX headers.
