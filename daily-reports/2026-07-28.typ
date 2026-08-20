#import "../template.typ": *

#show: template.with([Daily report (2026-07-28)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work focused mostly on one thing; Getting the patch to make tests pass on
the FreeBSD PR finished. I've also looked a bit into the CI failures of the
other FreeBSD PR, which has been approved.

I started off by reading through the logs of the PR that got approved, to see
whether it was a mistake on my side. That didn't turn out to be the case, as it
seemed the real issue was in the peer connection that curl opened disconnecting
over 5 times (which is the configured set of attempts for the FreeBSD scripts.)
That's pending but I don't think I will be looking any more into it as it's
happened in the past (hence the 5 attempts) and no fix was found.

The next thing I did was to continue working on the FreeBSD PR that had the
tests failing because of the new (and only) public submodule. This is now
completely fixed, and the final solution has been almost the same as the one I
proposed yesterday. Still, new errors popped up in the ctest-generated tests, as
those are generated onto a file that gets `include!`d into another Rust file
that we manually provide where there's a glob import of the sort `libc::*`.
This, of course, meant that it wasn't enough to simply get the right symbols
included (and excluded.) So I simply added a `cfg` that runs in those files to
gate a new import using a more fine-grained path to the public submodules. This
is good enough because having all items at the root level is alright in those
tests; We avoid conlifcts by excluding symbols altogether from being considered
in the automatically generated tests. It's also the simplest thing to get rid
of; Remove the import and `cfg`, and remove the code that adds the `cfg` to the
list of recognized check-cfg `cfg`s, as well as the `cfg` setting itself.

While doing this, I found out about some major but fairly idiotic mistake. I
noticed that I was completely skipping through all items that were _not_ part of
the affected bindings. The fix was simple enough, though.

I've not looked into avoiding running the tests twice, but I'd prefer to get
outside input on whether this way things are working just fine.

I also squashed all commits and remade the commit history on the above PR a bit
to get the thing nicely tidied up.

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback. The Windows function pointer issue thread also remains silent.

= Blockers
None at present.

= Plan for the week
I expect to get new comments on the Windows issue thread and the MCP Zulip
thread throughout the week. This should align fairly well with the schedule I
had planned for, as the FreeBSD PRs are fundamentally ready now. I don't know
yet what I'm going to be working through tomorrow but I do know that there's
more issues that remain to be solved in the 1.0 milestone, so I'll keep going
with those.
