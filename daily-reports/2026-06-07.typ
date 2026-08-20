#import "../template.typ": *

#show: template.with([Daily report (2026-06-07)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around testing the rest of the sligthly exotic platforms
under the `newlib` module. These included both the `vita` platform that was
meant to be tested this weekend, as well as the unplanned Nintendo Switch
platform under `aarch64` through devkitA64. The end result was not quite
satisfactory on the testing side of things, but the PR targetting newlib has
finally moved on from a draft PR.

Testing started with `vita`, which was initially the only platform that had been
planned for. As it turns out, the only PC emulator for it does not support the
type of homebrew package that the Rust toolchain for `vita` builds. Of course,
without any way of running programs in it, there's just no way of running a
test. Acquiring the type of domain-specific knowledge required to patch the
upstream sources of the emulator to possibly make the Rust binary compatible
with it would require dedicating a large amount of time. After reading through
the documentation for that project, it was decided that simply inspecting the
newlib fork again and ensuring the changes included in the patch were fitting
would have to suffice (at least for now.)

Reading through the upstream sources and the newlib forks, an issue was found in
the way changes had been made. The submitted patch had modified the one and only
definition of the type to be a C `long`, but that was not the default in all
platforms. The way they handle it upstream (in the Cygwin repo) makes it so that
the first definition for `off_t` is as a 64-bit signed integer. Then, on a
different header file, it is tested whether that definition has already been
effected (through a macro that is defined during declaration.) If it has not
been defined, then it is type-deffed as a C `long`. Looking again through the
forks, it seems there's only a few cases where the first definition is removed,
and instead `off_t` is made a C `long`.

Among the affected platforms were espressif's, `vita`, RTEMS and the Nintendo
Switch under `aarch64` with devkitA64. That part of the patch was changed, but
the part concerned with `time_t` was left unmodified, as that seemed to be
correct (of course, without actual proof of correctness.)

A consequence of the new patch was that testing was now also required while
running in the Nintendo Switch under `aarch64`. Doing so was again impossible
for the same reasons as mentioned above for `vita`.

Still, it was found that the current way the `libc` crate handles `cfg` option
values/identifiers for supported platforms may not be ideal. `horizon` is used
as a target OS and has separate definitions from both `arm` and `aarch64`. That
seems fine until you find out the child modules to the `newlib` module are layed
out (and noted on a comment) as corresponding with the different SDKs shipped by
devkitPro. If this is, indeed, the case, then adding Nintendo Switch- and
Nintendo 3DS-specific definitions to those architecture-specific files could
cause issues in the future. This is because other platforms could be targetting
the `aarch64` ISA while quite possibly not being any one of those specific
target triples. Then there's the fact that the `horizon` operating system uses
the same identifier for both the one shipped in the Nintendo 3DS (`arm`) and in
the Nintendo Switch (`aarch64`.) Further disambiguation may be necessary, but no
changes have been made on that side. Input from Trevor Gross would be
appreciated.

A few comments were left on open PRs concerning symbol deprecation. Those have
been partially addressed, and will be finished tomorrow, as they only require
updating the list of SemVer-tracked symbols and altogether removing them in
separate PRs.

= Blockers
None at present.

= Plan for the week
This week was meant to start the bit-width transition while also reviewing the
open PRs and updating them following discussion with other contributors/my
mentor. This has been accomplished, and the more fine-grained tasks set
throughout the week for testing on platforms requiring emulation have also been
finished on time. Next week will really only repeat the process again, further
advancing in the `unix` module in terms of the bit-width transition, which is
the only one left. More specifically, there's two clear tasks that will be
tackled first. Firstly, the open PRs concerning symbol deprecation will have new
PRs opened where the symbols are altogether removed. Then the changes in the
`uclibc` module are still pending testing, which should hopefully be made easier
by the OpenADK tool. This was found to be a fairly simple and useful way to
package a bootloader, a kernel and a custom libc implementation, which should
make emulating and testing in platforms like MIPS32 easier.
