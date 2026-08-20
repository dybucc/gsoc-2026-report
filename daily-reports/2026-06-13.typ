#import "../template.typ": *

#show: template.with([Daily report (2026-06-13)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on finally opening the PR concerning file offset
bitwidths in Linux uClibc, and on getting a toolchain compiled to test those out
in MIPS targets.

The only thing that was left from yesterday concerning the file offset patch was
to gather the list of sources that justify the submitted changes. This was
tedious work, but fairly simple in essence. The PR is now open and on draft mode
as testing on affected MIPS platforms is pending.

Yesterday's PR regarding symbol conflicts across modules from the bindings to
the `langinfo` header file got a comment from another `libc` contributor. As it
turns out, an older but still unmerged PR already addressed this and more. This
makes yesterday's PR a duplicate, so it has been closed.

On the testing side of things, building the toolchain by following bootlin's
training manuals with crosstool-ng has failed once again. After mounting a case
senstive file system on my host machine and getting all required GNU-specific
utilities forwarded in my `PATH`, things were still not working. This time, the
issue is truly quite odd.

Everything compiles just fine, except zlib. The build steps for this library
make use of aliases to my host compiler. But for some reason, the produced
object files are not Mach-O object files so packaging them back in a static
archive and linking them into the test programs that have to be run just doesn't
work. This is still being investigated, as all paths to the compiler and other
build tools seem to point to correct versions. it really does not make any sense
that the produced object files would not be in Mach-O when the compiler driver
interface is made for Mach-O targets.

= Blockers
None at present.

= Plan for the week
This weekend was meant to provide the last few attempts at building the
toolchain and testing on MIPS targets. If the toolchain builds by tomorrow, then
those efforts will be followed up next week with the actual tests. Otherwise,
testing on those platforms will be put on halt to continue working through other
child modules to the `unix` module requiring file offset type/routine
transitions.
