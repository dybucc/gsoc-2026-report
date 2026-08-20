#import "../template.typ": *

#show: template.with([Daily report (2026-08-06)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on a bunch of stuff; I can't quite enumerate anything
because I didn't take note of it as I usually do. There's probably stuff I did
today that won't be included in this report.

I'm done with yesterday's PR and I'm almost done reviewing all of the feedback I
had received thus far. I've only got 5 emails left, not counting the Zulip
messages (which, with all due respect, I'm going to leave last.)

I'm not sure what's the next thing I did. I know I worked on the AIX PR to clean
it up and get it separated into three separate PRs as it's individually a bit
much. I can thank my (post-yesterday) leveled-up Git skills for that.

I also worked on the L4Re PR to get the simple stuff out of the way. I was
actually looking into the test failures that the target maintainer reported
right before starting today's report, but that's still a WIP.

The FreeBSD `netlink` PR needs some attention but it will require more than just
a medium amount of work. This is because I've got to implement a so-called
`TestGroup` for ctest's new functionality concerning testing submodules.

Then I also rebased the musl PR removing support for LFS, which seemed to be the
only thing left for it to get merged. Upstream already intended on removing
support, to this one should be fairly straightforward.

Then I worked on getting the non-exhaustive macro refactored into using the new
macros for implementing more traits. The set up logic there for attribute
munching was not of any use to me, but the job is mostly done.

The one blocker here (which I've yet to think more thoroughly about) is
concerned with getting one of the recursive macro invocations to match on the
right subtree.

According to the Rust reference, there's no specified order in which the
expander will go through each of the subtrees in the macro body. It simply
mentions that it will "try each macro rule in turn."

Thus far, I've had success in assuming this meant a subtree that uses a literal
token and not an NT will take priority over some other subtree coming up later
on that has a simple NT that could stand in for the `tt` in the above match.

But for some reason, this does not work the same way with token trees that are
equivalent to a `meta` fragment specifier. This I've been staring at for more
time than I'd like to admit, but as per the usual, I'll figure it out.

The Android issue concerning the request parameter to `ioctl` also got some
comments, but I've yet to look into that one.

= Blockers
None.

= Plan for the week
I'm mostly done with all of the new feedback I got. I estimate I should be
capable of finishing up work tomorrow. In the best case scenario, I'll finish up
half-way through the day, and so I'll have some more time for the MCP.

Beyond that, I have no other plans for the week. Once the MCP is done, I'll keep
going with the `TestGroup` stuff in the FreeBSD `netlink` PR and we'll see about
submodule support in ctest.

That could very well be solved, but I'm not up-to-date on that front.
