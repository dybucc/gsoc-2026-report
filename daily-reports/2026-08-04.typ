#import "../template.typ": *

#show: template.with([Daily report (2026-08-04)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was mostly focused on answering to issues and PRs.

The newlib and Fuchsia PRs got merged, which ironically has meant that other of
my currently open PRs are now in need of rebasing to solve conflicts. There's
also a bunch of comments that I have not yet answered to.

On the Zulip side of things, the regression that Cargo had experimented with the
new internal build directory artifacts seems to be solved. Now there's a new
issue about a regression on rustc itself.

Still, it seems the contributor that originally tackled the Cargo issue has
proposed a changed based off of that submitted in rust-lang/rust, so that seems
done. I was aware of this because I initially got pinged.

The solution they reached was to pin nightly to the latest working release while
rust-lang/rust merges the fix.

I then went on to review the comments I had received on unifying a certain
symbol across libc implementations in supported Linux targets. This was one of
the stale PRs I picked up.

I had set up some symbol skipping stuff in the SemVer tests, but that was
apparently the wrong way of going about stuff. My mentor recommended me to
instead skip the symbols in ctest.

I initially didn't understand what they meant. Skipping on ctest won't affect
the SemVer tests. But then they noted that I missed the part about _not_ gating
the symbol itself.

Being a constant, there's no ABI concerns on this. So letting the symbol we
always exposed on all targets is harmless and gets the SemVer tests passing
without having to set up skips on those routines.

It should be done now, but there's new comments I've yet to get to.

The next thing I did was to read through the comments on the issue that I
implemented the `non_exhaustive` stuff on yesterday. My mentor answered saying
that there's new macros to replace the ones I based myself off of.

These new macros already increase the complexity of the logic by recursively
detecting some non-existent attributes on record fields. This was to implement
`Default` automatically or otherwise provide a custom "inline" implementation.

The net sum of changes on my side should be changing the attribute name used to
opt-out, and replacing the `non_exhaustive` annotation with a private field.
There's unresolved concerns about a lint on records used for FFI.

Then I'm supposed to find out a way of getting all records in the codebase that
don't have private fields and annotate them with the attribute to opt out of
having this new private field added.

This is all still only a plan that my mentor proposed and I had to make sure I
understood right. There's already new comments on this, but I haven't gotten to
it just yet.

The next thing I did was to look through the Windows issue thread. My mentor and
the contributor that proposed the solution I mentioned in rust-lang/rust have
started talking about it.

Indeed, that solution (which requires stabilizing a tracking issue for a change
to the behavior of the `link` attribute) is pending. My mentor nominated it for
T-lang to address it. The implementation is also pending.

Thus far, though, a partial solution for all targets but Windows' is to just
remove all `link` attributes, and document that they will be removed on Windows
in the (hopefully) near future.

I've done that already and asked if I should submit the patchset.

The last thing I did was to review feedback I got on the Linux PR concerning
`siginfo_t`. This is another one of the stale PRs that I had recently picked up.
The review basically consisted of having to reorganize everything.

The way we structure stuff now, the patchset is huge and has very subtle
differences across very similar chunks of code. If we moved it to the `new`
module structure, this situation would greatly improve.

I've already made the transition for glibc, which was the one with the most
changes. I didn't get to uClibc and musl just yet. There's also a few things I
wanted to note about the module structure I have doubts on.

Those will be included in the PR description.

The MCP is ready for an implementation, but I've not yet had time to get to
that.

= Blockers
None at present.

= Plan for the week
The MCP will be getting a draft implementation before the end of the week. I
first want to get out of the way all of the small to medium changes in my open
PRs. I should be done with the `siginfo_t` one by tomorrow.

The other ones are mostly pending on my end, and I think I'll also finish them
by either tomorrow or the day after. Then I can start on the MCP, which should
only require changing the OpenBSD target specs and the `spec::Env` type.
