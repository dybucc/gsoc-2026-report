#import "../template.typ": *

#show: template.with([Daily report (2026-07-02)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on further refining the GNU Hurd patch and preparing the
write up for the PR.

The write up is mostly ready. Some sources still need citing and justifying some
of the reasoning behind the nested sets of conditionally compiled types across
generic headers and architecture-specific headers.

i also split the patch into more manageable commits. This ended up taking quite
longer than expected. There were a bunch of git conflicts that I had to go
through. It's all solved now. but that's taken up the rest of the day.

= Blockers
None at present.

= Plan for the week
The plan today has not gone as expected. The NuttX PR should have also been
ready. I've failed delivering on that. The GNU Hurd PR is not yet open either.
It should be open tomorrow. The NuttX PR will also be open tomorrow. I expect
this to be more feasible because the patch to the `nuttx` module is considerably
smaller than the one targetting the `hurd` module. That should leave half a day
to try to test again on NuttX and one day and a half to cross reference AIX
headers.
