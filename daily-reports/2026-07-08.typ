#import "../template.typ": *

#show: template.with([Daily report (2026-07-08)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today work was centered around two things.

- reviewing feedback the hurd pr had received.
- reviewing new feedback from yesterday on the nuttx pr.

the first task was fairly straightforward. i seemed to have gotten the upstream
source wrong. the one i was cross-referencing hadn't been updated since 2021. i
had just assumed this was expected, considering the gnu hurd site and docs
themselves are a bit outdated. but apparently they transitioned to using
upstream glibc. so i went through the patches again and made some tweaks to
adapt it to upstream glibc. this resulted in proper handling of time\_t values
and of the glob and globfree routines. these were redirected to different
routines when the time bits feature test macro was issued. that was not part of
the legacy glibc fork i had initially based my work off of. there were also some
other minor modifications.

the nuttx pr needed a tad bit more work. the target maintainer had gotten back
(from yesterday's ping) and i also received some advice from my mentor on the
rate at which new types/bindings should be added. i need not bother with adding
new types and routines if they are not requested. that was honestly great news.
it made the pr far smaller and digestible to outside readers. i also removed
support for configuring large file support. feedback mentinoed that it was not
really feasible to add cfgs for each configurable option usptream. so much like
the afore mentioned advice on api additions, if nobody complains nor needs it,
then it's staying out. now all types are back to being 64-bit only.

= Blockers
none at present.

= Plan for the week
if tomorrow i don't get any new feedback requiring large changes, i can safely
start with the second part of my proposal. the first part was done yesterday,
but not all prs are closed or merged, so those are going to need some reviewing.
for one, with the new advice i got today on the hurd pr, i'll review the aix pr
to remove all additions to the api and only leave the fixes. that should trim it
down considerably. once that is done, i'll start looking into the issues i had
in mind for the second part of the proposal.
