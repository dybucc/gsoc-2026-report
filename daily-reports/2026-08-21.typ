#import "../template.typ": *

#show: template.with([Daily report (2026-08-21)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused mostly on taking on another issue in the milestone for
the 1.0 release. I’ve also briefly solved yesterday’s L4Re #(sym.mu + [Clibc])
concerns.

The first thing that I did was to go read the new messages on the L4Re PR. As it
turns out, the target maintainer only wanted me to remove the type definition. I
further insisted on this not being a potentially good idea, as it’s best we
first deprecate it and then let some time for downstream consumers to change
their code if need be.

Afterwards, I went on to review the glibc version issue I had commented on
recently. It hasn’t received any new feedback beyond that addressed in the last
few days. Then I went to the 1.0 milestone list and picked up the next issue.

This time I’m working through all occurrences of padding fields in the codebase
to make them all use a type of our own; `Padding`. This has already been the
accepted approach for some time now (definitely before GSoC) but there’s still
some cruft left.

The biggest two challenges this time are (1) getting to match all the
identifiers used for padding fields requires me to try and guess a few common
identifiers I’ve seen used, and (2) these sometimes get used in rust-lang/libc
itself, like those of NPTL initializers, and I may have missed those.

The search I made eventually narrowed it down to #(sym.approx + [2500]) search
results. As I went through them, I kept updating the search terms to address new
identifiers in padding fields I found in the files. This has increased the
number of search results to #(sym.approx + [2700]).

I’ve gone through almost half of them, but I’ve not yet ran any tests on CI to
reveal potential inconsistencies (referring here to the issues I could find from
the second point I made above.)

= Blockers
None.

= Plan for the week
I expect this work to be mostly done by tomorrow, but I can’t quite put a cap on
it as there could easily be some further refinement left in the search terms.
Either way, I don’t think this is going to go for more than two days.

The date for handing in the report is getting closer but I’ve got the work
product ready and the only thing that remains is to get an answer from my mentor
with feedback on it.
