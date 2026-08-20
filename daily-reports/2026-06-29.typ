#import "../template.typ": *

#show: template.with([Daily report (2026-06-29)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on two things.

- Finishing up the `hurd` module.
- Starting work on the `nuttx` module.

The GNU Hurd module turned out to be a bit different to other glibc-based
modules. All suffixed types except `stat` are deprecated in 64-bit targets.
That's because the effective bit width is the same. The difference with
previously reviewed modules is that this doesn't apply when the
`gnu_file_offset_bits64` `cfg` is set. The suffixed types need to continue
existing then. They have a different bit width on 32-bit targets irrespective of
`_USE_FILE_OFFSET64` being defined. Though there's some exceptions to this.
Those are only sum types with conditionally defined fields. All file offset
related routines that were present in both the `unix` and `unix/hurd` module
have been removed in favor of those in the former's. Signatures were verified to
be the same. The `unix` module also adds the right link names to redirect to the
64-bit interfaces when applicable.

Tests are pending. I'll use the cfarm machines with the Hurd for that.

I also started work on the `nuttx` module. It was a bit surprising (in both a
good and a bad way.) There were quite a few definitions that were not completely
correct. Upstream allows configuring the build much in the same way as uClibc.
The default is not to expose 64-bit bindings to file offset types. And yet we
expose 64-bit bindings to file offset types. This is a WIP. Though upstream
seems to have a pretty clean codebase. All relevant definitions are under
`include/sys/types.h` with no machine-specific overrides. I wish all `libc`
implementations had so little technical debt. I'm also adding missing types that
were neither declared on the `unix` nor on the `unix/nuttx` modules. My current
work is centered around attempting to somehow add a `cfg` that allows the user
to set the number of CPU cores on the target. NuttX has a conditional definition
of `cpu_set_t` based on that metric that switches definitions starting on some
threshold. Rust conditional compilation does not seem to allow that in code but
I can probably check for a user-exposed `cfg`'s value and then set another
internal `cfg` representing the theshold binary state.

= Blockers
None at present.

= Plan for the week
Yesterday's plan follows as expected. The GNU Hurd testing will start tomorrow
but I'm likely to find issues. The cfarm machines aren't too powerful either.
We'll see how that goes. The NuttX work will be done in three to four days from
now. That's accounting for the time I have to spent on the GNU Hurd and the time
I have to spend testing on NuttX. The NuttX docs seem to have straightforward
Rust instructions. But the last few weeks' worth of experience tell me
otherwise. AIX header cross-referencing will be left the the end of the week.
