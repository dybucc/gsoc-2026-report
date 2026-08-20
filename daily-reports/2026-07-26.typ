#import "../template.typ": *

#show: template.with([Daily report (2026-07-26)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused entirely on one thing; Doing all the work I initially set
out to do for the Windows function pointer issues. I believe my task here is
done until I get an answer from somebody in the corresponding issue.

I started off by continuing my read through all GitHub issues that matched my
filter in rust-lang/rust. I soon realized I wouldn't be done before I hit the
first half of the day, so I decided to instead look into the specifics of GitHub
filters and realized I could use `OR` operators between labels to allow matching
against a boolean-like formula. This made everything far easier because the
results narrowed down to little over 150 issues (of which I had already gone
through some from yesterday's efforts.)

The first issue that caught my attention was one where there seemed to be open
discussions on exactly how should `raw-dylib` work on Windows, which to this day
seems to give trouble to some folks. But then I decided this was probably not
the type of issue I should be looking into; The whole point of this research was
to see whether somebody had reported inconsitent semantics in `extern` blocks
for platforms like Windows (see yesterday's report for an explanation on this.)

The next issue I looked into was one where users had reported that importing and
exporting some symbol in a DLL under Windows targets would incorrectly have all
calls to the imported symbol be lowered to calls to the exported symbol, iff
both the imported symbol and exported symbol had the same names. This is because
their names don't get mangled. But this was not quite what I needed either;
Still, it seemed like I was getting closer to what I initially seeked out for.

Finally, I found an issue that was opened about two years ago attempting to
stabilize the use of the `link` attribute without requiring a `name` specifier,
and only having a `kind` specifier. This issue, though, seemed stale as no
activity beyond that of the author itself in the first (and only) comments was
present. This seemed like an ideal solution for the issues we were having in
rust-lang/libc, where we're actively attempting to get rid of all explicit
`link` attribute annotations. We could just have the `link` attribute not
specify a library, but rather a `kind`, so that we get right `dllimport`-style
jumps on any call to the bindings inside such an `extern` block. Still, I wasn't
quite sure how would this interact with `extern` blocks from a crate user that
specified the libraries. This prompted me to go read the dedicated issue from
which this proposal was started.

That one source issue turned out to be one 10-year old unsolved issue regarding
exactly these Windows DLL problems. I was fortunate enough to have time to read
through it all. Most of it, though, seemed to just be a back and forth between
contributor solutions and Alex Chrichton's solution (which used a `link_from`
attribute that doesn't seem to have ever been stabilized.) Still, it did teach
me a few things, chief among them that the `name` specifier is actually quite
useless when it comes to having the linker get the job done. Provided some
binding in an `extern` block, the way the linker is invoked in `rustc` (this may
have very well changed since then) makes it so that any symbol that satisfies
the ABI spec specified in the ABI string, as well as the unmangled name, will do
just fine. Of course, specifying the `name` prompts the use of some system
library but that I didn't quite understand in full. This issue, though, was the
source of a change of semantics in the way `kind = dylib` works in Windows,
through RFC 1717. That proposal was the one that added relatively "proper"
support for `dllimport`-style calls. It is also implicitly stated in that
proposal that `extern` blocks should have to be annotated with the `link`
attribute explicitly. This made me think that the Rust Reference text mentioning
the use of one empty such block to "satisfy link requirements" wasn't entirely
wrong; It probably only needed clarification for Windows targets. That's
pending.

My findings have been gathered in the relevant issue, where I hope other
contributors may provide insight into which of the proposed solutions we could
use. In that write up, I mention that we can either attempt to follow through
with the proposal that allows using the `link` attribute using only the `kind`
specifier, or we can go down a simpler route. See, the only reason why we
consider this an issue is not because it's stopping users from using those
bindings (they can use them just fine without `rustc` ever having knowledge of
`dllimport` at a small runtime cost,) but because tests don't pass. So we could
instead have the `link` attribute be used solely in libc-test test runs. Other
issues I've looked into remain mostly unanswered. The MCP hasn't received any
new feedback. I've looked a bit into the ctest stuff, but that's been more of a
secondary task today; Still, we can potentially avoid having ctest extended for
submodules with the proposed approach in the message above this report.

= Blockers
None at present.

= Plan for the week
The MCP is currently sitting waiting for an answer to my latest questions (from
a few days ago.) Other PRs are also paused as I await answers. With today's
progress on the Windows issue, I believe I'm also done until somebody answers in
the relevant issue. This means I will likely switch to working on having a ctest
workaround for the FreeBSD `netlink`/`if_mib` PRs starting tomorrow. I don't
expect this to take more than two to three days, unless, of course, we decide to
extend ctest.
