#import "../template.typ": *

#show: template.with([Daily report (2026-06-11)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were centered around continuing yesterday's uClibc file offset
types transition, and attempting to build a functional MIPS toolchain to test
both those changes and the `time_t` patch. This has gone fairly well, and the
latter task has quite definitely been met with more success (thus far) than this
week's initial attempts with OpenADK.

Much like yesterday, work started with the current patch for file offset types
under Linux uClibc. This has been completely finished, which is great because
this was expected to take up possibly two more days. Still, just attempting a
cross-compiled build for each of the affected targets already produced multiple
errors. Except for one error concerning the `dirent` record, which had been
moved across modules because of the similarity in its field layout, all other
item resolution errors seemed to be currently present in upstream libc (and thus
unrelated to the file offset patch.)

Efforts on fixing these have already started, but are still unfinished. So far,
it's been fairly simple stuff to fix. Those changes are currently commited in
the same branch but will be separated later on. At the time of writing, this has
involved removing definitions for multiple constants from the uClibc module
related to the `langinfo` header file. These are already defined in the
`linux_l4re_shared` module top-level module, so they end up conflicting. The
latter's were kept, because the former actually mismatched the upstream
uclibc-ng declarations.

A few errors were found on imports used by the standard library but these have
not been fixed just yet nor will they be for the time being. They are part of
the `l4re/uclibc` module, for which no changes have yet been made. That module
follows from the current one (`linux`) so the errors will be fixed soon either
way (after reviewing the Linux musl patch and finishing Linux glibc.)

Efforts on the toolchain bootstrapping side of things were met with a fair
amount of success. After setting up Buildroot on a Linux virtual machine, the
first few attempts at building failed but the reason was related to missing
configuration settings. After more thoroughly reading the docs, the required
configuration for the specific board to build the Linux kernel and the packaged
bootloader was simple to set up. Buildroot uses the concept of boards because
it's mostly geared towards embedded development, but it also supports a wide
array of QEMU "boards," which include the MIPS platforms on which the uClibc
patches need to be tested on.

At the time of writing, no build errors have happened, and all required
binaries/libraries have been built successfully. The toolchain should leave me
with a bootloader image and a kernel image that should be ready to plug into
QEMU for emulating the system with uClibc as the default C standard library
implementation. Still, the build is likely bound to fail. It's been a few hours
already and it's not done (which is expected,) but my computer is going off the
grid soon after this report is finished. If some dependency requires fetching
from remote servers, the build will fail. Hopefully all of the compiled tools
are cached and don't have to be recompiled from scratch tomorrow. If that is the
case, though, the build will instead be started from early morning instead of
early evening (as it was today.)

There's no news on other open PRs.

= Blockers
None at present.

= Plan for the week
Yesterday it was expected for the file offset task to take up longer than it
ended up taking. This is great, but I must not get ahead of myself. The task
remains unfinished as long as there are build errors, and testing is still
pending. Still, thorough testing seems to now be more viable than it was at the
start of the week and that is, indeed, another parallel task I'm actively
working on. The pending review to the changes to Linux musl that was left for
later may even fit in this week's schedule. But we'll see.
