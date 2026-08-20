#import "../template.typ": *

#show: template.with([Daily report (2026-06-14)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today worked was entirely focused on attempting to build (for the last time) the
cross-compilation toolchain to test out the uClibc patches on MIPS targets.

Following up from yesterday, further efforts went into solving the binary object
format error that popped up in the latest builds. Suffice to say, the reason for
this has not been found. Testing the same build steps in the zlib codebase with
what should be the same compiler driver interface does not seem to cause any
issues. Though it was found that the libtool in use by crosstool-ng is not the
one shipped in PATH but the system libtool. In my case, that means it used
Darwin's libtool instead of GNU libtool.

Still, this should not have made a difference for the purposes of building, as
the command in question performs the same steps in both flavours.

This actually made for more plumbing work concerned with environment variables
on my host machine not being set right during the build steps of crosstool-ng's
makefile. This ended up taking the rest of the day and is yet unsolved either.
It's mostly been about figuring out why is it that there's paths set to tools
that don't figure in any shell init scripts. No further details will be provided
because it's really not worth it, and it's not getting past today.

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this side have failed.

= Plan for the week
This last week's worth of work went into both opening up new PRs for full
removal of the symbols that got deprecated in prior PRs, as well as opening up
the file offset patch PR in Linux uClibc. We also got work done in Linux musl
concerning file offset types/routines, but that is pending a review. This
weekend was the last chance to set up a cross-compilation toolchain with which
to test the changes in both patches affecting MIPS target triples under Linux
uClibc. That has failed so such efforts will be put on halt. Next week will
start off by reviewing the Linux musl patch and opening up a PR with it. Next
will be the `linux/glib` module.
