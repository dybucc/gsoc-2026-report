#import "../template.typ": *

#show: template.with([Daily report (2026-07-05)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has centered on finishing up the `aix` module and on attempting to
test out the changes.

Quite unexpectedly, I finished the `aix` module work earlier than expected. The
initial patch is done. Work on the PR write up is also finished. The sources
ended up only consisting of two files under `/usr/include` in an AIX 7.3
machine. They're not public so that's lightened the workload. Most of the
changes ended up consisting of bindings to new types and records. I've also had
time to divide all of the changes into separate commits.

There were also three new `cfg`s added. AIX seems to allow configuring the
system with either one of a signed or unsigned `time64_t`. That needed a `cfg`on
our side. They also have feature test macros to expose LFS bindings and to make
64-bits be the default width on non-"64"-suffixed types. Those also needed
separate `cfg`s. Though one of those could very well be replaced with the
existing `cfg` to expose equivalent behavior on targets using glibc. I decided
against that to keep things tidy.

Currently work is focused on attempting to build an AIX rustc. That should let
me clone the `libc` crate to the remote AIX machine and test things out directly
there. This is a WIP.

= Blockers
None at present.

= Plan for the week
The AIX work is almost done. The initial patch is done. It's also been split
into separate commits and the PR write up is also done. Only two things remain;
running the `libc-test` test suite, and removing certain redundant types. The
only supported target using this operating system has 64-bit machine word size.
It makes no sense to expose both suffixed and unsuffixed types in the cases
where their effective bit width is equivalent.
