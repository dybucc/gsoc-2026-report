#import "../template.typ": *

#show: template.with([Daily report (2026-06-01)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we continued work on reviewing all modules in the `libc` crate that define
`time_t` and `off_t` types. We finished up with all modules except the `unix`
module, and have almost finished work on the `newlib` child module.

Most of the top-level modules that were left already had definitions within
their root scopes for types that were compliant with our current goal of
exposing a single 64-bit type. I found some issues in TEEOS, as there were
notable differences between the definitions in the kernel interface and those
used in the OhOS SDK. For details, see the corresponding PR.

The next PR I submitted addressed a small mismatch between the definition we
expose under WASI for `off_t` and that which appears in the upstream repo.
Still, the current definition is equivalent in terms of effective bit-width, but
unlike upstream, relies on fixed-width Rust integer types and not on C
`long long`s.

Finally, I started looking into child modules of the Unix tree. The newlib C
standard library implementation was conditionally compiling the `time_t` type to
be 32 bits on all platforms but `horizon` and espidf with the corresponding
compatibility shim. All forks of newlib for all targets supported in the `libc`
crate define it by default as a 64-bit wide signed integer. The only exception
to this was triggered by a configuration option at build time or if the host
system was detected to have C `longs`s whose bit-width was larger than 32 bits.
Another PR has been opened addressing these changes, though testing is pending
because there's no automated CI for espressif's ESP-IDF nor `horizon` (which is
known to run in the tier 3 Nintendo 3DS target.)

Other PRs continue open and awaiting input from other contributors/my mentor.

= Blockers
None at present.

= Plan for the week
The revised plan for this week included starting earlier with the time and file
offset deprecations/modifications. This is expected to have been almost
completed by the time we reach the first GSoC evaluation period. Based off of
the current pace, it's quite possible that work is done before that. Still, one
must factor in that there's barely been any feedback to the currently open PRs,
so more work could creep up from there. Either way, the proposal outlined that
work would move on to other issues in the 1.0 release track if such thing were
to happen.
