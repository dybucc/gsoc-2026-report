#import "../template.typ": *

#show: template.with([Daily report (2026-06-05)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were mostly focused on refining yesterday's changes and attempting
to test them.

The patch that got submitted had some of the `time_t` removals in submodules
modified. Instead of solely making the type available at the MIPS level, while
also providing the same definition in other sibiling modules, it is now declared
at the top-level `uclibc` module. This was deemed valid because the same
definition (i.e. in terms of the `c_long` type) was being used across all
modules.

Afterwards, an attempt to test on MIPS was made. The rustc documentation for the
tier 3 target that is MIPS with uClibc as the target environment does not
provide any pointers as to how to build the Rust toolchain for it. For that
matter, no page even documents it under the "Platform support" section. There
are no shipped binaries to cross-compile either. So far, that's been a dead end.

Attempts to instantiate a VM to test in MIPS have also been met with failure.
There do not seem to be many Linux distros that support MIPS these days. A raw
kernel has not been built because beyond OS support on the guest VM, interaction
with the system will be required to compile uclibc-ng and link to it in the Rust
test. Still, a possibly simpler way of handling this may have been found (read
on.)

Efforts then went on to set up an x86\_64 VM and compile uclibc-ng to link to it
in the Rust crate with the test. This lead to the discovery of the OpenADK tool
for packaging in a single toolchain a bootloader, a minimal Linux kernel and a
custom C library implementation. All three can be customized to run on quite a
few different target architecturectures, which fit the current testing needs
just fine. Setting this up is still a WIP.

= Blockers
None at present. Today the report got submitted earlier than usual because I've
got stuff to deal with in the evening.

= Plan for the week
This week was meant to start the bit-width transition and to review whatever
changes were required in the currently open PRs concerning symbol deprecation.
The latter has every so sligthly progressed as some feedback was provided on the
version in which constants were meant to be deprecated. Beyond that, the
bit-width transition is done on all modules except the `unix` module. A few PRs
are already open targetting those. Other modules are a WIP, but as mentioned in
the yesterday's report, they will likely have an (initial) PR in two to three
weeks from now. This fits with the expected timeline in the proposal.
