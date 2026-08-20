#import "../template.typ": *

#show: template.with([Daily report (2026-08-02)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around reading through a bunch of issues and ensuring
they either get a PR ready or a comment justifying why they should be closed as
solved.

Yesterday, I was fortunate enough to have some time left before clocking out to
finish up the write up for the PR where I finally got rid of some cruft from
back when Rust didn't have `union`s.

I reviewed the write up again, just in case, and quite strangely found nothing
out of place. I guess I wasn't tired enough when I finished it. I then messaged
my mentor about whether they'd be active next week.

If my mentor is ready for more action, then I think we can move forward with a
bunch of pending PRs. If not, then I'll just ask for some other outside help and
see how far can we get.

Concerning the issues I went through, these were all older issues that I really
would love to see closed. The first one I worked on was about some
argument-passing issues with `ioctl` in certain Linux and Linux-like targets.

Apparently, even though "native" Linux constants passed as requests are 32-bits
wide, Android has some funny symbols that require an _unsigned_ 32-bit wide
integer.

This is further complicated by the fact Android has set up function overloading
in C through some compiler-specific attribute annotations. I didn't quite see
how should we handle this, so I decided to just go for documentation notes.

I've commented on the issue mentioning just that and pinging my mentor.

The next issue I went through reported that (a few years ago) NetBSD targets
wouldn't pass the libc-test test suite. This is not the case anymore because
there's been CI infra running on the x86\_64 target for about 10 months now.

I commented on the issue thread mentioning that this can be closed now, as we
don't often merge PRs that don't pass all workflow jobs, including NetBSD. I
also pinged my mentor on this one, because I can't close it myself.

Then I went on to another (old) issue concerning `sighandler_t` on BSD and Apple
targets. As it turns out, those use `sig_t` as the identifier, because the
former is actually a GNU-specific extension (though it's only a type alias.)

There was an associated PR that tried to solve this but I realized that it
hadn't been touched in almost six months. It had some conflicts and I decided to
rebase onto latest `main` and tweak it some.

Among the changes I made, I added a few comments around the Rust type alias
mentioning that this will likely change once we have a better solution for
`sighandler_t`. This is another long-standing issue that I've yet to review.

I also changed the new `sig_t` type alias to be a `*const sighandler_t`. In the
FreeBSD tree, `sighandler_t` is defined as a function "alias" that delays
decaying to a function pointer. Then `sig_t` is a pointer to this "alias."

This is quite unsound in Rust because raw pointers to functions aren't quite a
thing (just yet.) I've also commented on this. I then commented on the old PR
that I had a patchset ready if the contributor wasn't following through.

The last issue I went through (and potentially solved) today was one concerning
`wchar_t` in BSD and Apple targets. Again, the issue dates back a few years, and
it mentions that there's some wrong aliases in Rust concerning signedness.

I decided to go through all of the targets, cross-referencing with upstream
sources and some test runs in Godbolt to verify pre-defined compiler macros.
From this, I can say there's no such mismatch anymore.

I thus commented on the issue and pinged my mentor.

The Windows function pointer issue thread remains silent. Other issues I've
commented on also remain silent. I did finally get approval for the MCP from the
OpenBSD target maintainer, so that should be ready for an implementation.

The MCP news came in at the last minute today, so I've yet to do something about
it.

= Blockers
None at present.

= Plan for the week
The MCP is officially ready to be accepted if no party is against it, though
it's pending seconding by (possibly) my mentor. That should make this next week
a bit more interesting as we may potentially be implementing it in rustc.

Beyond that, I'll just continue going through all issues in the 1.0 milestone,
commenting on them if I believe they should be closed or otherwise getting
patchsets ready. Pending PRs are, of course, still under my radar.
