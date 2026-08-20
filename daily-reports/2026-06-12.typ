#import "../template.typ": *

#show: template.with([Daily report (2026-06-12)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were centered around solving the errors that started popping up
from building the `libc` crate with the file offset patch, and getting a working
toolchain to test those out in MIPS targets.

The first task has been completed. As it turns out, the last few errors that I
read through yesterday before writing the report were actually spurious errors.
There seems to be a long-standing issue in L4Re targets where not even std
builds. This seems to be related to issues in the types used in std from `libc`.
There's still an open issue in upstream `rust-lang/rust` about it, but the new
maintainer does not yet seem to have his working std merged. His changes on the
libc crate, though, are causing the current build failures. But then again, it
could be his changes have only been merged in `libc` and not in std.

After realizing all errors from building std were unrelated and not meant to be
solved, I ended up with two patches; The one for file offsets, and one that
solves the conflicting definitions between symbols of the `uclibc` module and
the top-level `linux_l4re_shared` module. The latter is believed to be unrelated
to the current state of L4Re targets, and has already had a corresponding PR
open. The one concerning file offsets is in the process of having its PR open.
The write up is ready but the sources must still be gathered. I quite badly
forgot to take note of them as I was making changes so now i have to go through
the whole patch looking them up in upstream uclibc-ng.

Beyond that, all work has gone into attempting to compile the toolchain
packaging a full bootloader, kernel and compiler tools. Yesterday's attempt
failed (though the compilation results got cached.) This ended up not being due
to connection resolution errors to remote servers, but rather due to the same
`libcoddy` errors found while using OpenADK. For some reason, there's unresolved
symbols in the final object file's `.text` section of the library's object
files, and there's no issues upstream tracking it. Because building anew did not
yield any results, I instead went for the option that Builroot offers for
externally sourced toolchains (prepackaged toolchains that don't require
building.)

The toolchain I got from bootlin's toolchain repository, but even then,
Buildroot still found errors in the compilation pipeline. This time, they were
due to executable mismatch errors. At the end of the build, Builroot ensures
everything is working by running a few shell scripts on the host machine
attempting to run the cross-compilation compilers shipped in the toolchain. In
the VM I was doing this in, there seems to be an incompatibility in the format
of the object file ran. Later on, I found out that the toolchains distributed by
bootlin are cross-compilation toolchains were the host is meant to be using the
x86\_64 ISA. My host (both my actual machine and the VM I mounted) where
Aarch64.

While researching into the bootlin docs to solve the above issue, I found their
training manuals for testing out in QEMU the cross-compilation toolchain.
There's not yet been time to go through it all, but this will be the next
solution (and possibly the last) i will try to get the toolchain working for
MIPS targets and test the file offset patch.

There's not been any progress on other open PRs.

= Blockers
None at present.

= Plan for the week
The file offset patch is done and only requires annotating sources. That will be
done by tomorrow. Testing for this patch and last week's `time_t` patch on MIPS
uClibc is pending and will be put on halt if I don't get the toolchain and QEMU
working by the end of the week. Those PRs will be left as drafts then with the
corresponding tests checkbox unmarked. That should about do it for this week's
work.
