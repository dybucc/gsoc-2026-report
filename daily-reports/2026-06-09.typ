#import "../template.typ": *

#show: template.with([Daily report (2026-06-09)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around three main areas; Namely, solving the linking
issues in the OpenADK make recipes to build the custom libc toolchain, tackling
the `off_t` transition under Linux musl, and finally, transitioning the `off_t`
type in Linux uClibc.

The linking issues remain unsolved and the toolchain still does not build. A few
settings from the provided make configuration scripts were tweaked, but this
still turned out in errors. Only this time the errors were mostly unknown and
now unrelated to symbol availability across translation units. For reasons yet
unbeknownst, building gcc as part of the cross-compiling toolchain fails due to
errors in the libcoddy library. This seems to be a library shipped to provide
some support for C++ 20 modules, but it's also having trouble disambiguating
between multiple options when processing templates in its source code. OpenADK
seems to provide an option to opt out of building support for `g++`, but that
option seems to not be toggleable, so there's that. It's quite likely that
testing with MIPS on Linux and uClibc will fail, because unlike last week's
efforts with espressif's ESP-IDF, no progress has been made beyond this.

Testing on x86\_64 and arm, on the other hand, has sucessfully proven that the
changes in the patch were not incorrect. It's fairly simple to set up GitHub
Actions with a CI job for these ISAs, so unlike MIPS, testing on them is
complete. Still, yesterday's limit on this task were set for one day and half,
and there's half a day left. Maybe tomorrow a solution is found.

While waiting for the openADK toolchain to finish building and bail out with an
error, efforts shifted to the next submodule in the `unix` module; the
`linux/musl` module. This one was fairly simple to tackle, as there was already
existing infrastructure for supporting `time_t`s of differing bit-widths, so
work went mostly to the file offset types. At present, no PR has been open yet
but the branch with the patch is public and currently only deprecates some
`off_t` definitions and LFS routines. This decision was made as part of the
`libc` crate's transition into exposing a single fixed-width type for file
offsets, which is already the default in usptream musl. There was no reason to
provide suffixed variants of functions because the idiomatic thing would be to
just use the unsuffixed versions. An accompanying (small) write up for the PR
has also been finished, but a review is still pending.

Back to the OpenADK toolchain, after realizing that the errors did not seem
trivial to solve, and there did not seem to be a simple fix from reading the
upstream gcc repo for release 15.2, it was decided that it'd be best to move on
to the file offset types. Initially, changes akin to those submitted in other
PRs were made, but soon enough, keeping track of all of the
architecture-specific definitions started getting messy. It was then decided
that these changes would be best done by manually going through all occurrences
of any one of the `__USE_LARGEFILE64` or the `__USE_FILE_OFFSET64` feature test
macros. These are always checked for whenever some symbol is meant to have LFS64
interfaces and when it's meant to automatically redirect the unsuffixed variants
to the suffixed ones, respectively. The corresponding option in the upstream
uclibc-ng make scripts sets this by default. A decision was then made to
deprecate all instances of types that were redirected to their 64-bit variants,
such that our exposed unsuffixed records in the `libc` crate already use a
definition fitting the suffixed variants upstream.

This is slow, but out of the 3000 lines in the resulting `stdout` of running
ripgrep on the `main` worktree of the uclibc-ng repo, 28% of it is done.

Currently open PRs have been rebased onto latest `main`, but no further
developments have taken place on that side of things.

= Blockers
None at present.

= Plan for the week
This week's first two goals are almost complete. Solving the OpenADK toolchain
issues to have a fully packaged bootloader, kernel and custom libc
implementation is taking some time. It's also likely to fail, and will be put on
halt for the time being. The corresponding PRs have already been edited to
mention that testing has taken place in all affected platforms (by the Linux
uClibc patch) except for MIPS. Beyond that, this week is likely to go on with
the uClibc file offset transition (as mentioned in today's summary) and
reviewing the Linux musl patch.
