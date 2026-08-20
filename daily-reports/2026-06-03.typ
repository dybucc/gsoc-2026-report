#import "../template.typ": *

#show: template.with([Daily report (2026-06-03)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on (finally) getting both the official ESP-IDF toolchain
and the Rust compatibitliy toolchain working together, and on finishin up work
under the `unix/newlib` module. Much like yesterday's report, the write up
reflects notes taken as progress was being made, so at times it may come off as
short scribbles. This was only ever so slightly edited to provide an "official"
record of the bulk of today's work.

Attempting to modify the CMake generated files was futile, as the dependency
graph is complex enough that manual intervention is not feasible. The build
system, Ninja, reads straight from those files, but does not seem check if an
existing (incomplete) build of the bootloader already exists. This triggers a
rebuild of both the 2nd stage bootloader and the flash program. That's where the
issues arise, as the Rust crate is built alongside the bootloader, which does
not include in its compilation pipeline the directories that the Rust bindings
require. Later on, this was found to not be the source of the symbol resolution
errors.

After this, work switched to inspecting the verbose output of Cargo when issuing
the build command to the `idf.py` build driver. It was thought that this could
reveal some way of patching the upstream crate to include certain directories
instead of reading in from the build environment. But debugging the Rust build
in the mixed CMake/Rust template from the esp-rs org did not yield any fruitful
results beyond what was already known. The stack backtraces did not show any
missing headers from the routine in charge of detecting if the any driver
component involved in the build.

Still, the debugging session over the `esp-idf-sys` crate did reveal that the
error does not seem to happen when the header files are processed by the
compiler driver. This followed from inspecting the build script of that crate
(which is a transitive dependency of all espressif Rust-based projects.) The
error does not seem to be in the closure that generates the bindings, but in the
preprocessing step right before it. The header file included in the bindgen
generator is the one under the `src/include` directory of the `esp-idf-sys`
crate. This header is the one causing symbol resolution errors. These errors
take place in an internal parsing routine of the bindgen crate where the AST
produced by the `clang` driver is transformed into their internal
representation. This did confirm the fact that the source of issues is the
unavailability of certain headers in the toolchain that the Rust crate builds
with.

An alternative aproach was then taken to patch the upstream repo for the
official ESP-IDF toolchain. The goal was to unset the `BOOTLOADER_BUILD`
property when the `components/driver` espressif component is built. The
component implementors already took into consideration not using the
corresponding headers during the developemnt process, so it should be alright.
The only exception would've been if there were headers with the same name on
multiple translation units for each compiled component. Even though this did not
end up being an issue, it did not solve the symbol availability errors. Then a
build was attempted by explicitly unsetting the `BOOTLOADER_BUILD` property in
the `CMAKeLists.txt` file. This was done through the `idf_build_unset_property`
CMake function provided by the official ESP-IDF toolchain, but it did not solve
the problems. This also proved that the problems were not coming from compiling
the Rust crate right before the bootloader.

Making the ESP-IDF toolchain installation work through the conventional (but
apparently not recommended) Git repo install scripts did the trick. Thus far,
all attempts had been using the `eim` toolchain manager provided by espressif,
which serves a similar purpose to `rustup`. This installs the toolchain but also
recommends running a few shell scripts when developing in an espressif CMake
project that conflict with the tooling provided by the esp-rs org. Instead, one
must manually run the `install` script and then the `export` scripts (the former
not even mentioned in the regular install, as it's meant to be run only by
`eim`.)

This finally built both the image and the 2nd stage bootloader.

To summarize and for future reference, the following steps did the trick:

1. Install `esp-rs/espup` and ensure the Rust toolchain can build without issues
  (in a project with no mixed support for CMake.) Ensure the `export-esp.sh`
  shell script is ran before all steps following this one.
2. Install the official toolchain through the `eim` toolchain manager. Ensure
  that the toolchain matches the latest stable release for which bindings in the
  `esp-idf-sys` crate are generated.
3. Do not run any of the recommended shell scripts that set up shell definitions
  and environment variables.
4. Run the `install.*` script found in the installation directory of the
  toolchain installed through `eim`. The above wildcard pattern should match the
  user's shell of choice, though support for sligthly unconventional shells like
  nushell is limited. Any shell supporting basic compatibility with the
  POSIX-compliant `sh` should do just fine with the `install.sh` script.
5. Run the `export.*` shell script found in the toolchain installation directory
  (the same as in the previous step.)
6. *(Optional)* Run `idf_tools.py install qemu-xtensa` to install the QEMU
  emulator with support for the Xtensa chip family (which the `esp-32` chips are
  based on.)
7. *(Required only if step 6 was followed)* Run agan the `export.*` shell script
  to make the newly installed QEMU available to the `idf.py` build driver.

#html.blockquote[Before step 1, it is assumed that no installation of ESP-IDF
  nor the tools provided by the esp-rs org are present on the system. If the
  latter is installed and it has been installed though `eim`, then the
  `eim purge` command should remove all installed versions. Steps 6 through 7
  are only required the first time the toolchain is installed. Subsequent runs
  should automatically detect the QEMU binary after going through steps 4
  and 5.]

The flaw in all prior attempts (including the very first one yesterday) was to
mix the installation instructions from the ESP-IDF documentation with those in
the `esp-rs/esp-idf-template` project. The steps above must be followed without
fault, lest one knows better.

The test ran to prove the (relative) correctness of these changes simply
consisted of calling `size_of::<T>()` for `T`s equivalent to the types modified
in the patch. The returned bitwidth was then logged through and output through
the QEMU monitor.

Introducing a CI run for the ESP-IDF toolchain was thought but eventually
discarded as `libc` does not seem to include any tier 3 targets in their CI.

Before the end of the day, work on fixing the `off_t` type under newlib was also
finished and tested on `esp-32`. The issue seemed fairly odd, as the upstream
repo maintained by the Cygwin developers keeps a definition for both types that
is left untouched in the corresponding forks of all three of espressif's
`esp-32`, the VitaSDK and the devkitARM for development on `horizon`. There was
some special casing done on the first two but that did not seem necessary based
off of their definitions. This has been tested under `esp-32` with the emulation
setup that was also used today for `time_t`, and it seems the changes are (then
again, relatively) correct. Testing the changes on `vita` and `horizon` will
have to wait until days June 6th through June 7th.

Other PRs continue open and awaiting input from other contributors/my mentor.

= Blockers
None at present.

= Plan for the week
Currrent progress on the bit-width transition for `time_t` and `off_t` is
progressing at a decent pace. The `unix/newlib` module is done, and only testing
remains on the `horizon` and `vita` tier 3 targets. This will be finished by the
end of the week, though it won't be specifically addressed until days June 6th
through June 7th. Work on other submodules of the `unix` tree shall continue
until Friday. This module is the largest one in the `libc` crate, but finishing
the bit-width transition by weeks 6-7 is feasible.
