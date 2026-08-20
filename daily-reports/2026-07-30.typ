#import "../template.typ": *

#show: template.with([Daily report (2026-07-30)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around continuing (and almost finishing) the `siginfo_t`
matters on Linux targets that I kicked off yesterday.

I began by looking into `clangd` and more specifically, configuring target
options to get accurate type size and alignment information. This made the task
of ensuring not only the right types were exposed, but also the right size and
alignment, far easier. This did serve me well in one of the two modifications I
ended up making. The workflow mostly consisted of checking glibc's
`sysdeps/unix/sysv/linux/bits/types/siginfo.h` file, while ensuring the target
in question didn't have overrides living under
`sysdeps/unix/sysv/linux/{arch}/bits/siginfo-arch.h`.

Most of the targets had fairly correct bindings in Rust, except for the M68K and
RISCV32 targets. The former specified `si_errno` and `si_code` in the wrong
order. In fact, the glibc codebase itself mentions that only MIPS targets (both
32-bit and 64-bit) have a different ordering. The 32-bit RISCV target had an
8-byte alignment requirement in `siginfo_t`, while it has a 4-byte alignment
requirement upstream. With the full definition (counter to mere padding fields,)
this is fixed.

As an extra (though unrelated to Rust,) there were some funny definitions for
SPARC targets that added whole fields. There's also the fact that I decided to
use `sigval` instead of declaring a `sigval_t` type because they're actually
equivalent but the former is part of POSIX and the latter is not (though its use
is prevalent across glibc.)

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback. The Windows function pointer issue thread remains silent.

= Blockers
None at present.

= Plan for the week
The MCP and pending PRs continue on halt. I think it's going to be best if I
wait until tomorrow and if no new feedback is received, I will seek for outside
help. Beyond that, I am fairly confident the `siginfo_t` issue can have a PR
opened before the end of week. Today I finished through all targets using glibc,
which made up the bulk of it. Now only the uClibc targets (less than five) and
musl (Heaven on Earth; a single shared definition for all targets) are left. Of
course, once I open the PR, we'll see about the relative correctness of my
changes.
