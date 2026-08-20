#import "../template.typ": *

#show: template.with([Daily report (2026-07-03)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on three things.

- Reviewing some of the changes in the GNU Hurd patch.
- Opening the NuttX PR.
- Attempting (one more time) to test on both NuttX and the GNU Hurd.

I got to both finish gathering sources and touch up the GNU Hurd PR yesterday.
Today I simply went through it again just in case yesterday's hurry had left
something pending. Admittedly, I had forgotten two things. I had to run the
style checker to ensure macro invocations used for conditional compilation were
correctly formatted. On a more relevant note, I did miss a subtle detail in the
memory layout of the `stat` and `stat64` records. In most systems I've reviewed
these are the same so long as the target has a 64-bit machine word size, or has
otherwise indicated through feature test macros that large file support should
be the default (i.e. not just used for suffixed types/routines.) In the GNU Hurd
this only holds if the the feature test macros are enabled. Under the x86\_64
target, this structure has different trailing padding on each of the two. This
meant that some C routine bindings also needed proper indication of equivalence
(or inequivalence) if they expected or produced a value of such type.

The NuttX PR has also been opened. Much like yesterday, it was divided into more
digestible commits. The patch was far smaller than the GNU Hurd's so I made
quick work of it. See the PR or prior daily reports for the list of included
changes. It mostly just adds proper support for LFS bindings and correct widths
for pointer-sized c types (`size_t` and `ssize_t`) under the NuttX small memory
model.

Testing on both of these target groups has failed miserably. This was the second
and last attempt I would make as they are tier 3 targets. Testing on NuttX was
not possible because I again failed to cross compile to it. There's nothing new
to add here compared to the last time I attempted this. Testing on the GNU Hurd
went through quite a few stages (each making testing seem less feasible.)

- I first realized that gcc had no support for the Hurd kernel. This meant that
  I couldn't use a cross-compiling gcc to build and link the `libc-test` test
  suite.

- I then tried to emulate the GNU Hurd on a virtual machine. This went quite
  badly. A combination of Guix GNU/Hurd didn't boot up in QEMU. A combination of
  Debian GNU/Hurd booted up but didn't get past the boot manager.

I eventually gave up on testing on the GNU Hurd. I have access to cfarm machines
but it's not feasible to build a Rust toolchain there (the GNU/Hurd systems are
quite weak and have very little disk space.) I need to get a GNU Hurd toolchain
compiled or otherwise have the `libc-test` test binary compiled for any one of
(through preferably both) x86 and x86\_64 targets.

= Blockers
None at present.

= Plan for the week
We're back on track. The original plan remains untouched. Having opened the GNU
Hurd PR yesterday and the NuttX PR today, I got enough time to attempt to test
on both today. This will be now put on halt. Work will be centered around cross
referencing the AIX headers (from the cfarm machines) with the existing `libc`
crate bindings. I hope to have a PR open in the next to days but that may take a
little longer.
