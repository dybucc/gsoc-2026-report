#import "../template.typ": *

#show: template.with([Daily report (2026-06-04)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Work on inspecting possible changes to the `unix/emscripten` module has failed
to find a solution to the fact the current interface exposes symbols that are
possibly not present in the target. The definitions in upstream use both the
`_GNU_SOURCE` and `_LARGEFILE64_SOURCE` feature test macros to gate symbols and
routines concerned with the LFS64 "spec." These symbols are unconditionally
exposed in the `libc` crate. This was found out after inspecting the definition
of the `off64_t` type in emscripten's repo.

A PR has been open to fix this, as tests seem to have not had any issues with
the way it is currently handled. Still, a separate branch an attempt has been
made to more gracefully handle these symbols. Though tests don't pass. The way
it's been implemented uses the `gnu_file_offset_bits64` `cfg` option. No
dedicated `cfg` was made available because the `_LARGEFILE64_SOURCE` macro seems
deprecated as per #footnote[#link(
  "https://linux.die.net/man/7/feature_test_macros",
)]. Instead, it's recommended to set `FILE_OFFSET_BITS=64`, for which we already
have the afore mentioned `cfg` in the `libc` crate.

No further efforts have gone into making CI pass tests as the changes introduced
in the forked branch may not turn out to be useful. Input from Trevor Gross
would be appreciated here. The core changes do not affect tests as they only
deprecate the symbols relative to file offsets, and do not fiddle with exposed
function interfaces. That's the part that's currently failing the tests for the
emscripten target. CI also seems to fail during style checking because the crate
output on which the formatting script is run seems to be a post-macro expanded
output. Because this patch uses an attribute in the declaration of the item that
is provided to the `extern_ty` macro, one of the expanded routines concerning
this macro has a wrongly indented function block. This has been deemed to be
low-priority, so no work has gone into fixing it.

Efforts then went on to verifying the `unix/linux_like` module, starting witht
the `uclibc` module. No obvious issues were found there in terms of file offset
types, but the `time_t` type did have a wrong bit-width. There were also some
symbol availability issues concerning LFS64 like those mentioned at the start of
the report, but those have not been fixed. Those changes made to the interface
exposed to emscripten were already quite flaky. Until confirmation from other
contributors is given in the currently open PR, no changes to the LFS64
interface of other targets will be made. The definition for `time_t` in uClibc
defines it in terms of multiple other types, but the "end type" is always a C
`long`. The interface we expose in the `libc` crate under x86\_64 has its
`time_t` defined in terms of a C `int`. Considering this type is common to all
target architectures in the uClibc upstream repo, this change is likely
necessary. This patch is still pending review, though, as the currently
maintained fork of the uClibc implementation supports both 32-bit and 64-bit
`time_t`. This functionality is gated behind a macro akin to `__USE_TIME_BITS64`
in the Linux kernel user API. It may just be that this is the end of the day and
something's not catching on, but the type with which the `time_t` is ultimately
defined ends up being 64-bit wide in all systems. It just so happens that in
systems whose machine word size is 4 bytes, it will have a 4-byte alignment but
an 8-byte size.

The decision taken (at least for the time being) has been to define it as the
same type one would expect were the afore mentioned macro not be defined in a
pure C environment. This implies that all such types are defined as C `long`s
now. Such patch has required changes in the x86\_64 and MIPS modules for uClibc.
Still, this was based on the definition of the mantained uclibc-ng project, and
not on the older uClibc. Testing is still pending, though.

Input on this from Trevor Gross would be greatly appreaciated.

= Blockers
None at present.

= Plan for the week
The proposal plan expected the bit-width transition to finish by weeks 6-7. By
week 2 all modules but the `unix` module have been completed, though no reviews
(and possibly changes) have been made to the open PRs. Because the submitted
patches are quite likely to be modified once external input is received, this
does mean work on the bit-width transition in the `unix` module should have
finished by week 5. This would allow two more weeks of further research to fix
up whatever's been deemed to be wrong in PRs for all other targets.
