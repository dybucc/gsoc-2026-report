#import "../template.typ": *

#show: template.with([Daily report (2026-07-16)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
*Edit (the day after:)* I, again #footnote[#link(
  "https://rust-lang.zulipchat.com/#narrow/channel/421156-gsoc/topic/Project.3A.20libc.3A.20transition.20differing.20bit-width.20time/near/610897046",
)], forgot to mention one fairly important even that also took place yesterday;
I got feedback on the GNU/Hurd PR. Overall, it didn't require too many changes
on my side, but I did have to comment on a few things that I wasn't quite sure
of.

Today worked went on to focus on two things:

- Finishing my read over the target version situtation and preparing a small
  write up to check with my mentor how should I proceed further.

- Working on a review I had gotten on the AIX module.

The bulk of today consisted of the former task, as the review only got to me
once the day.

There's not much to update beyond yesterday's plan. I first finished reading
through RFC 3750, and realized that really is stalled for reasons unbeknownst to
me. There does not seem to be any concerning issues (beyond bikeshedding the
`cfg` name) so I was surprised that it had not gotten any attention since
October 2025. The details I already gave in yesterday's report.

I then moved on to looking through RFC 3905, which is bit more tangential to our
purposes but if merged, will quite definetely help in getting some form of
target versioning `cfg` set up. It basically proposes to have `cfg`s be "typed"
in the sense of possibly having a type check between the type of a given `cfg`
key and then the string with which a given binary operation is being made. The
RFC focuses on the `rust_version` and `rust_edition` `cfg`s, which would have a
`version()` type; all other `cfg`s as we know them today would be of the
`default` type. Then it exploits this to add a slightly more diverse set of
operators to `cfg`s that make more sense when comparing versions; Namely, `>=`
and `<`. The system that would have to be implemented here would be potentially
useful in other scenarios like OS-version checking and libc-version checking,
which are the ones the libc crate is most interested in. Still, it doesn't even
have a PoC implementation nor does it seem like the type of thing we would be
using in the short term because it would first have to land on stable (and our
MSRV is fairly far away from that.) The `cfg` should in theory be usable on
older versions but the operators (which are most useful to us) cannot be
backported.

After this, I went through the MCP my mentor had opened on September 2025 to
propose a change to the OpenBSD targets' `target_os` `cfg`. That seems blocked
because updating the targets would have to take place twice a year, which
quickly adds up considering there's 6 OpenBSD targets. The amount of work was
considered too much, and it seems like the best way out would be for these
targets to instead define an extra `cfg` property (like those that are already
target-specific for the `target_cpu` `cfg`.)

With all of this context, I decided to go and ask on Zulip directly to my mentor
whether I should attempt to move forward RFC 3750 or instead focus on revising
the MCP with the feedback it had gotten. I believe my mentor has answered to
this in the message prior to this one, but I've not yet read the answer.

Unexpectedly, I got a GitHub notification on the AIX PR by the end of the day.
As it turns out, there were quite a few test failures with the patchset I had
submitted. Still, it was easy to fix and/or justify, and I've already finished a
review and pushed a new patch. I also asked the target maintainer (who had
tested it out) to try again.

Other issues I've commented on remain unanswered.

= Blockers
None at present.

= Plan for the week
As mentioned yesterday, this week's goal has been finished in advance. The
situation for OpenBSD-like systems seems dire but the MCP could at least solve
that for OpenBSD. The long-term solution goes through having one of (if not
both) RFC 3750 and 3905 approved and merged, but that will take a while. I can't
quite provide a plan for the rest of the week or the next one just yet because
I've not yet read my mentor's answer (should be above this report.)
