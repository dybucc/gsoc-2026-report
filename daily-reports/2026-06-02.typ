#import "../template.typ": *

#show: template.with([Daily report (2026-06-02)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused solely on getting the ESP-IDF toolchain installed and
working. This was a requirement to set up an emulation environment in QEMU with
which to test out the changes that were introduced in yesterday's patch. Thus
far, this has not been accomplished as symbol resolution errors between the
installed toolchain and the Rust compatibility toolchain have not been solved.
This report will thus serve as a backlog of today's attempts, as no other
"official" record exists. It may also come off (at times) as straight line
notes. That's because they were taken as relative "progress" was being made.

Firstly, a regular installation through the Rust toolchain yield satisfactory
results. The steps outlined in the official documentation streamlined the
process as the `cargo` commands provided by the esp-rs org worked just fine.
Still, this did mean that no QEMU support was provided as the official `idf.py`
"build driver" seems to be the only one capable of handling that. Documentation
by the esp-rs org mentions that they do not have any write ups on running the
Rust toolchain in an emulated environment #footnote[#link(
  "https://github.com/esp-rs/std-training/blob/b171a4a23fee36332df03e04631443c4e24efd2b/book/src/01_intro.md?plain=1#L28",
)].

This was then followed by an installation of the official ESP-IDF toolchain. The
goal then became to have a shared Rust/CMake project using the provided build
template (also from the esp-rs org.) This is where the issues started. Upon
finishing the installation and setting up all scripts that had to be sourced for
development, linking errors to the `mqtt` component were found after running the
build command for the default template project. "Components" are the term
espressif uses for something akin to workspace members in Rust. They are also
the way projects refer to their dependencies. The `mqtt` component is one
provided by espressif themselves. The default template to work with both CMake
and Rust in an ESP-IDF environment includes, by default, a wide assortment of
components, including the `mqtt` component. Downloading it and integrating it in
the build should be, according to the espressif docs, automatically managed by
the `idf.py` "build driver." As it turns out, though, it requires further
configuration through an additional manifest file specific to espressif
environments that is read from CMake functions that espressif themselves ship in
their toolchain.

After setting everything up, things were still not working. A build with no
components was attempted but then new issues creeped up. Now there's symbol
reference issues in the headers of the toolchain while compiling. The funny
thing is that all compilation works out just fine except in the Rust crate,
which is configured as a separate build step in the CMake template provided by
the esp-rs org. It's quite likely that the issue is not in the toolchain headers
(as there's no other reported issues while building the bootloader image nor
during other CMake build steps.) There's issues reporting similar problems in
the issue tracker for the esp-rs org #footnote[#link(
  "https://github.com/esp-rs/esp-idf-template/issues/263",
)], but the workarounds they propose do not seem to fix these symbol resolution
errors.

An alternative approach would be to use only the Rust toolchain to compile the
flash file and then use the `idf.py` build driver to run the espressif fork of
QEMU with it. The Rust toolchain works just fine and using `espflash` to create
the binary seems to not cause any issues. But running the `qemu` subcommand of
`idf.py` requires the pwd to be within an ESP-IDF project. This command also
triggers an automatic build of the project even when explitcitly providing a
flash file, which, again, causes the afore mentioned build errors. No CLI flags
nor configuration can override this behavior.

Efforts then went on to removing the latest stable toolchain of ESP-IDF and
replacing it with version 5.2, as that had been reported to cause fewer issues
in the esp-rs issue tracker. After purging the installation, and ensuring the
right toolchain was used when triggering a build, link errors persisted.

A similar approach would target version 5.5.3 (the same as the Rust toolchain if
not otherwise configured). This has also failed, with a missing reference to a
`driver/adc.h` header file. This driver is documented as having been deprecated
in version 5.0 of ESP-IDF. That should not affect the current build, as the Rust
toolchain still uses version 5.5.3. This likely implies that when building the
CMake/Rust template, the C side of things is picking up on the right ESP-IDF
toolchain, while the step that compiles the Rust crate is possibly attempting to
use a newer toolchain. A patch to the upstream `esp-idf-sys` crate changing
`#include`s in their bindings to specify the `deprecated` directory in the
shipped ESP-IDF driver components proved to be useless. The `CMakeLists.txt`
file already adds the `deprecated` path to the included directories during
compilation. Modifying the `sdkconfig` through the `idf.py menuconfig` to allow
use of legacy drivers didn't solve it either.

The CMake logs always mention that the includes for the deprecated drivers are
missing. The error is also triggered on the very first `#include` of a legacy
driver. This prompts the question that the `CMakeLists.txt` of the driver
components are likely not including the directories correctly. The
`CMakeLists.txt` file for that specific component sets a variable for includes
but only registers it through the ESP-IDF-specific CMake functions when the
build is detected to not be a bootloader build. Such detection is likely
performed earlier in the build pipeline through one of the ESP-IDF CMake
functions for what they refer to (or what CMake refers to) as properties. The
`BOOTLOADER_BUILD` property conditionally registers the include directories and
other ESP-IDF-specific stuff. Coincidentlaly, when the Rust crate fails to build
on a fresh build directory, the bootloader build step is first completed before
`ninja` reports the error. This would also make it obvious as to why projects
using the Rust toolchain (with no CMake involved) compile without issues. It is
documented as using a precompiled ESP-IDF bootloader, so that one CMake property
is not set and the included directories are correctly set.

The fix may go through looking into the order in which the 2nd stage bootloader
and the flash image with the actual program are built. This is still a WIP.

Input from Trevor Gross would be very much appreciated. Knowledge of CMake and
the ESP-IDF boards is limited on my side.

Other PRs continue open and awaiting input from other contributors/my mentor.

= Blockers
Building the ESP-IDF toolchain alongside a Rust toolchain for espressif's
`esp-32` is looking pretty dire. The latest debugging sessions have revealed a
possible solution, so hope is not lost.

= Plan for the week
This week was expected to take into consideration both reviews to open PRs
concerned with deprecation of symbols, and bit-width transitions for `time_t`
and `off_t` types. There was no specific goal as work on the latter should have
started next week according to the proposal plan. Still, the current pace at
which modifications to relevant types are done is decent enough. Today's
debugging issues with the build pipeline for ESP-IDF and Rust has proven to be a
challenge. If by tomorrow the default template cannot yet be built, testing on
this platform will be put on halt until days June 6th-June 7th.
