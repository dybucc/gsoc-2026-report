#import "../template.typ": *

#show: template.with([Daily report (2026-06-30)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on three things.

- Finishing up work on the `nuttx` module.
- Attempting to test libc with the NuttX "simulator."
- Fixing up some stuff in the GNU Hurd patch and attempting to test it.

The `nuttx` module should be done. Everything that I could make better in the
allotted time has been improved. Yesterday's attempts at providing a `cfg` to
expose the number of CPUs on the host machine have not been followed through.
Upstream just produces a compilation error when that happens. I have decided to
unconditionally expose `cpu_set_t`. This may or may not be the right choice. A
new NuttX-specific `cfg` has been added to allow configuring `size_t` and
`ssize_t` for a small memory model. Upstream allows configuration of this
through Kconfig. It makes those two be 16-bit unsigned and signed integers,
respectively. They would otherwise default to the pre-defined compiler macro
`__SIZE_TYPE__`. At least under NuttX targets in clang, this macro expands to
one of `c_ulong` or `c_int` depending on the target's machine word size.

I also decided to make those types be `isize` and `usize` when building as a
dependency of `std`.

i then tried to test things out. I first followed the documentation to build
NuttX images that I could launch in QEMU. They seem to have certain more
convenient configurations to do that. They package a custom shell that lets you
interactively run the programs once the system's booted up. i couldn't get past
the toolchain configuration step. There's some Kconfig tool that I don't seem to
have on my user `PATH`. I've tried both with kconfiglib (a python
implementation) and with a port of the Linux upstream Kconfig implementation.
None seem to provide me with the tool NuttX uses in one of the build-step shell
scripts.

I looked through the GNU Hurd patch again. I fixed some stuff that broke the
`libc` build. Then I went on to attempt a build in the cfarm machine i SSHed
into. I then realized that there was no Rust shipped on that machine. So I went
back to my local machine to attempt to cross-compile Rust from source for the
GNU Hurd. I should then have the redistributable tarball pushed to some repo and
cloned from the SSH remote. I've so far been met with failure when building Rust
from source.

= Blockers
None at present.

= Plan for the week
The NuttX testing efforts will halt tomorrow if no progress is made. A PR will
be opened either tomorrow or the day after. GNU Hurd testing seems more
promising. There has been some struggle with building Rust from source but I can
see a path forward. Attempts will resume tomorrow. Unlike yesterday's outlook
for the week, the NuttX PR will likely be opened before the GNU Hurd PR.
