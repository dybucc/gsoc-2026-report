#import "../template.typ": *

#show: template.with([Daily report (2026-06-28)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on three things.

- Gathering information on yesterday's attempts at solving the function pointer
  mismatches on Windows x86 GNU.
- Fixing up the currenlty open Windows PR. The other Windows PR got merged
  yesterday. This one needs adding a `cfg` to the changes introduced in that PR.
- Looking into the GNU Hurd module. I started checking out `time_t` and file
  offset types.

What little I could find out on the function pointer checks has been added to an
open issue. That's going to be left unattended for the time being. There's
nothing new to add to yesterday's report.

The currently open Windows PR got some feedback. It was mostly about style.
there was also advice on not skipping `time_t` anymore on Windows x86 with GNU.
Defining `_TIME_BITS=32` should have yield the same results as defining
`_USE_32_BIT_TIME_T`. It could be that MinGW is picking up on the host machine's
set of pre-defined macros and not on the compiled binary's target. That would
explain why defining the above macro doesn't work. MinGW won't allow 32-bit
`time_t` on x86\_64. The tests compile to x86 but run on GitHub hosted runners.
These are x86\_64. I haven't tested on an actual x86 machine.

I also requested a compile farm account. It's been approved. I needed to access
AIX machines to cross reference their headers with the definitions we bind to in
the `libc` crate. Though I'm currently working on verifying `time_t` and file
offset types for the GNU Hurd. It will still come in handy to ensure Rust
programs build on that system. I haven't yet tested it out. My hypothesis is
that they won't work. There's duplicate definitions between GNU Hurd bindings
and general UNIX bindings. We currently expose non-LFS64 and LFS64 definitions
no matter the target. The GNU Hurd has two Rust supported targets. They
correspond to the x86 and x86\_64 ISAs. LFS symbols aren't always defined.
Redirecting to the LFS64 symbols is neither the default. And yet we have those
definitions ungated. I've started annotating them with the existing
`gnu_file_offset_bits64` `cfg`. This should do just fine because the Hurd uses
glibc. The types are only deprecated. The routines are going to get gated.
Testing is pending but it seems compile farm has machines set up. We'll see.

= Blockers
None at present.

= Plan for the week
The first half of GSoC ends the next week. My proposal set a hard limit on
verifying `time_t` and file offset types to the seventh week. The GNU Hurd
changes should take me three more days. The last module will be Apache's NuttX.
But i've already looked through that module. There's nothing immediately
apparent to fix there. They already have 64-bit `time_t` and file offset types.
