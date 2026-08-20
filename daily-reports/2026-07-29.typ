#import "../template.typ": *

#show: template.with([Daily report (2026-07-29)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused mostly on two things; Solving a small issue in the
FreeBSD PR that was causing test failures, and starting work on another issue in
the 1.0 release milestone.

The issue in the FreeBSD PR was failry simple to solve. Yesterday, I had tested
the patchset against a trimmed down version of CI that only ran the FreeBSD
targets' workflows. This made me miss the fact that the `cfg` that got added to
support conditional imports in the ctest-generated tests would produce a warning
in all other targets. The solution was to move the `check-cfg` directive we
issue through Cargo from the FreeBSD test function to the build script's `main`
function.

Afterwards, I started looking again into the issue tracker, and kept going with
the next issue in the list after the OpenBSD issue (for which I've already got
the MCP going.) This time I'm looking into `siginfo_t` in the Linux bindings.
The original issue dates back more than ten years, and the last update to it was
seven years ago. It's been sitting for a long while in the backlog and the
original source source of confusion isn't even the same anymore. Back then,
`siginfo_t` had some funky definition in the Linux kernel and the rust-lang/libc
bindings replicated that. After some time, upstream changed it to better support
32-bit machine word systems, where a certain set of fields and their orderings
would cause ABI breakage. The issue was intended to solve that, but these days
we provide bindings to each Linux system's libc implementation, instead of to
the kernel's definition.

I decided it would be best to go through all definitions in supported Linux
targets to ensure that things were alright. I've started off with the Linux
systems using glibc's definition, and today I'm done with x86. My main goal here
is to provide a definition that closely matches upstream's, as we currently have
a private field that serves only to match the record's size and alignment. This
is flaky and I would prefer to have the full union comprising the main body of
`siginfo_t`. There's also the fact that glibc has architecture-specific
definitions, that are easy to get wrong; For example, x86 will force a 4-byte
alignment over the regular `clock_t` type in an inner union's record's field if
compiling against x86 but running in x86\_64. This usecase, in fact, is one I've
not found a clean solution for in Rust, so I've had to make it unconditionally
use the x86 `clock_t` type, which is always 4-byte aligned.

Today I also got some feedback from other Rust contributors to help move forward
the MCP and pending PRs. You can probably see those messages right above this
one.

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback, but a contributor has tried to move it forward some by pinging
my mentor. The Windows function pointer issue thread remains silent.

= Blockers
None at present.

= Plan for the week
The MCP and pending PRs are sitting in the backburner ready to receive further
feedback or merge; The FreeBSD PR is now added to that list. The new issue I've
started solving today will likely take me a few days to finish up, as I've go to
go through quite a few targets. Still, I believe I could finish it by the end of
the week. That's the goal now.
