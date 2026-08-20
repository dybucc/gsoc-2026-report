#import "../template.typ": *

#show: template.with([Daily report (2026-06-20)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were again focused on answering back and fixing stuff from
feedback on open PRs.

There's no news from what was commented yesterday. I've not yet reached the
Windows PRs. The patches that got changed today were concerned with Linux musl,
Linux uClibc, L4Re uClibc and emscripten. Work has started on changing the
newlib PR. That remains unfinished.

The Linux musl and emscripten changes are the same. Emscripten's implementation
is largely based off of musl's. musl defines file offset types as being 64-bits
no matter the target or defined feature test macros. Deprecating the suffixed
types is thus a natural decision. They don't provide any value whatsoever over
the suffixed types.

The L4Re uClibc PR needed adding a `cfg` to serve the same purpose as upstream's
`__USE_FILE_OFFSET` feature test macro. This macro allows 32-bit targets
upstream to have 64-bit definitions on their unsuffixed types. The default in
the makefile scripts is to toggle it. The PR was assumming this behavior until
now. The `cfg` allows configuring the same thing for the exposed LFS64 bindings.
It also removes the deprecation annotations. I'm yet to understand the reason
for this. A pinged contributor to a target using uClibc should at some point
provide background on it.

There was also another Linux uClibc PR that got slightly modified. This was
aiming to change the bit width with which `time_t` bindings are exposed. Another
patch got merged recently with similar goals. This patch added a `cfg` option
but only used it in 32-bit arm targets. My PR extends that to the top-level
`linux/uclibc` module. `time_t` is configurable across all targets irrespective
of machine word size or memory model.

= Blockers
None at present. Testing on MIPS targets using uClibc as the libc implementation
is pending. An attempt has been made at building a cross-compilation toolchain
but it's repeatedly failed. Input would be welcome here but this is low
priority.

= Plan for the week
Yesterday's plan for the rest of the week and the start of the next one remains
unchanged. The PRs needing larger changes will likely take up a few more days.
The lighter ones should be done in one or two days. That should let me go back
to the `unix/bsd` module either on Thursday or Friday. This is all under the
assumption no new large changes to open PRs pop up.
