#import "../template.typ": *

#show: template.with([Daily report (2026-06-27)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on three things.

- Trying to figure out why function pointer checks are skipped in Windows. This
  happens in the `libc` crate's test suite. It ensures the function pointers we
  get from C are equivalent to those we bind to in Rust. This makes it possible
  to catch mismatches in identifier link names and expected ABIs.

- Trying to test on Fuchsia. This follows from yesterday's attempts. The goal
  here is to make sure the changes in my Fuchsia PR are relatively correct.

- Trying to find the AIX headers. This is part of ongoing efforts to check
  `time_t` and file offset types across all supported targets.

I've miserably failed on all three fronts.

The function pointer checks on Windows remain a mystery. A number of routines
follow the `cdecl` convention. Others expecte a "C" calling convention. This is
supposed to be documented in the MSVC docs. Yet for some reason the function
pointers are mismatched between Rust and C. We currently bind to them all under
the "C" ABI. This is potentially wrong. The symbol is meant to have both a
decorated name and an undecorated name. The latter does not seem to correspond
with the symbol's link name. Otherwise just changing that in Rust would do. I've
also tried gating a number of those routines under `extern "cdecl"` blocks for
x86 only. This doesn't work either. It yields undefined references at link time
on the C side of things (from the generated C test files using the link name.)
I've also tried using the ctest methods for renaming functions on the Rust side
of things. This doesn't work either. The routines link just fine under the `"C"`
ABI. all other ABIs (applicable mostly to x86) cause linking errors even on
supported x86 Windows targets.

A question from my mentor propmted me to attempt to solve this. It's not part of
the proposed timeline. I won't be attempting to solve it again in some time.

Testing on Fuchsia seemed simple. It is simple. It just so happens the
instructions don't align with the (my) reality. They seem to have a
binary/package/repo pipeline set up in Fuchsia. You have to configure a bunch of
Fuchsia-specific files after compiling your Rust crate. These are all package
metadata-related files. You're then meant to create a local repository of
packages. These are then registered on the repository. The emulator is then
launched with parameters specifying both your local repository and the package.
It's a bit involved. The issue lies in a mismatch between the compiled artifacts
I get from the Fuchsia-specific metadata compiler and the artifacts the
instructions get. There's meant to be a package that can be registered with the
repository. That's just nowhere to be found in my metadata compilation
artifacts.

I've not found the AIX headers. I genuinely don't know why IBM doesn't provide a
downloadable SDK with native headers. They already have a bunch of pages
documenting the headers. Those are insufficient to ensure we bind to the correct
definitions.

= Blockers
None at present.

= Plan for the week
The timeline will quite definetely be met. The only modules remaining in the
`unix` module are the `hurd` and `nuttx` modules. These should be fairly simple
to go through. The proposal expected this to be finished by the sixth to seventh
week. It will be finished by the sixth week. Work on the `aix` module will stop.
This should leave plenty of time for the GNU Hurd and NuttX.
