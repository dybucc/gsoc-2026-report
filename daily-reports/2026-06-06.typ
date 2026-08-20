#import "../template.typ": *

#show: template.with([Daily report (2026-06-06)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were focused on testing the newlib patch on `horizon`. This was
pending from last week where testing on both `vita` and `horizon` were set as
tasks to be tackled between june 6th-7th. `vita` is still pending, but the
changes on `horizon` have been both confirmed and fixed.

All in all, things were fairly simple to test. The choice of emulator for
`horizon` was a fork of the now defunct Citra. There was no required set up on
that side, but a few things had to be prepared to make the Rust toolchain work
on the 3DS. As per the guides by the rust3ds org, a recent build of the LLVM
toolchain was required, as well as devkitARM from the devkitPRO team. Those were
also straightforward to configure and soon enough, a template program was
already running in the emulator.

During testing, the changes in the patch (which concerned both `time_t` and
`off_t`) required some modification. Firstly, the decision regarding `time_t`
was correct in `horizon`, where providing a 64-bit type did, indeed, fit the
upstream definition on the newlib fork shipped alongside devkitARM. The test
simply consisted of ensuring that a two-element array of `time_t` values had
only one of the array values modified when providing a pointer to it to the
`time` C routine.

It was while testing `off_t` that issues arose. Testing with this type was not
as straightforward and required some human "inference" to draw conclusions
because no simple test (that I could come up with) could prove the bit-width of
the `off_t` type. `time_t` has bunch of routines where a pointer to it is taken
and one can ensure that a write has been performed with the right bit-width, but
that is not the case with `off_t`. This meant that some way of passing a value
(possibly) larger than the expected `off_t` (if it was 32 bits) had to be found.
The solution ended up using the virtual file system that the 3DS Rust toolchain
provides to create a file larger then 2 GiB and perform a call to `fseeko` with
an `off_t` larger than `2^31`. While building the binary for `horizon` with the
embedded virtual file system, the toolchain was unable to package files within
the FS that were larger than `2^31` bytes. Even though this does not imply a
32-bit `off_t`, it does mean there is no LFS64 support.

Looking again through the source code for newlib in all supported targets, it
turned out that the last submitted patch had missed something. The `off_t` type
is defined as a 64-bit integer in all platforms but espressif's and `vita`. The
newlib fork for `horizon` (part of devkitARM) has a 64-bit declaration. This
meant that the patch, which changed `off_t` to always be a C `long`, was
completely wrong. It is only a C `long` in `esp-32` and `vita`. This, though,
still means some changes are required to the upstream `libc` crate, as under the
latter it is currently exposed as a C `int`.

The open PR has not yet been modified, but will soon enough be.

Beyond that, work on other open PRs continues awaiting contributor/mentor
responses (genuinely not trying to put pressure here, but I don't know a simpler
way to word this.)

= Blockers
None at present.

= Plan for the week
This week was meant to start work on the bit-width transition while looking
through the open PRs for symbol deprecation. No clear goal beyond the
"mini-tasks" regarding tests outlined in each of the newly open PRs was set.
These tasks, though, have all been accomplished except for the ones set for days
June 6th-7th. Testing on newlib with `horizon` is mostly done and the changes to
the PR are only pending a review before getting pushed (and before changing the
write up in the PR.) That leaves tomorrow to test out the changes in `vita`
(which may or may not be as simple as with the 3DS.)
