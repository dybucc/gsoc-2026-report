#import "../template.typ": *

#show: template.with([Daily report (2026-07-24)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on two things; Further studying the Windows function
pointer issues and tweaking some stuff about the PRs I would be taking over
before submitting them.

I found out yesterday about the potential reason behind the function pointer
issues in Windows targets. Most of today was simply focused on working through
the LLVM documentation and ensuring I understood why was it that `rustc`
performs a certain LLVM IR interface call. I tracked the addition of this piece
of code back to a commit about ten years ago, but no further context was
provided back then on the reason why it was used. After looking into the LLVM
docs, I eventually found out that they didn't really provide a generic interface
for dllimport thunks in Windows. Storage class specifiers in LLVM IR are
literally just for Windows targets. Of course, I didn't get to the LLVM IR
reference documentation until I had already read through all introductory
material in the LLVM docs page. It was a bit of a waste for my initially set
purpose, but I learned a couple of stuff from reading most papers and guides.
Looking through the Rust Reference for an explanation of the semantics behind
unannotated `extern` blocks is still pending.

The rest of the day was centered around tweaking the PRs I took over and
submitting them. I also pinged my mentor on a bunch of similar PRs to see
whether I could also get approval to take over. Work was focused on the PR that
added support for Netlink in FreeBSD systems. As it turns out, the bindings for
these targets needed some more modifications, because they required changing
some other network interfaces so that they didn't collide in our top-level item
reexports. The two PRs I have rebased to latest `main` and added some more
changes from both the plan outlined by another contributor and all of the stuff
that's changed in the two years since the PR was last updated. The new PRs are
already open but there are some issues with the test harness. The idea to solve
this conflict is to provide the `if_mib` interface as a reexport and to have the
`netlink` interface exposed as a public submodule. The problem comes from the
fact the libc crate has never had public submodules reexported. This isn't
handled by ctest, so all tested symbols get added to a single test template file
and so compilation fails on either one of the C or Rust side of things.

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback.

= Blockers
None at present.

= Plan for the week
My current plan is to work in parallel on both the MCP (once it gets feedback,)
the Windows function pointer issues, and possibly extending ctest to handle the
new usecase mentioned in today's summary. I expect the MCP to be mostly ready by
next week if further feedback is received. The implementation steps themselves
are not complex either, so that should be fine. The Windows issue I also believe
to be partially solved, though the fact that some platforms have some odd
behavior around `extern` blocks will likely mean I'll have to think some more
about this. The ctest extension may not be necessary, considering the end goal
is to just have one set of bindings reexported once we reach 1.0, but we'll see.
