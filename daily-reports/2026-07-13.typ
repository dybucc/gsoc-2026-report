#import "../template.typ": *

#show: template.with([Daily report (2026-07-13)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today efforts were centered around three things.

- finishing work on yesterday's last pr.
- further providing an answer to the recently opened issue i commented on.
- going through other issues in the 1.0 release milestone.

i finished yesterday's work after a few hours. as noted in the last daily
report, i had some concerns over whether the sa\_family\_t type was correctly
represented in all the platforms it was being used in. as it turns out, i found
two cases in which our current type definition is not completely correct. these
correspond to both illumos and gnu/hurd targets. i submitted comments with
citations including the upstream definitions in the already open pr (that
switched the type of AF\_INET and AF\_INET6 from c\_int to sa\_family\_t.) i
also rebased to latest main and solved all merge conflicts.

then i answered to the issue that was opened yesterday concerning possible
safety concerns in the signature of an exposed c binding. my stance remains the
same in that it's not the libc crate's place to encode safety guarantees. the
fact that this (and probably other) c library functions happen to have some
funky semantics isn't quite a -sys crate's business' to solve. but my opinion
could very well change after i read the new answer the issue author left (which
i've not read yet.)

then i moved on to looking through other issues in the 1.0 milestone. i looked
through two issues that attempted to track breaking changes through the android
module and back when the use\_std feature was still a thing. the former has
remained unanswered for some time and the use\_std cargo feature was removed
some time ago so that one really seems like a candidate for closure.

then i started reading through a long issue thread concerning breaking changes
in platforms where any one of backwards or forwards compatibility is really not
a concern. i'm not done yet because there's been extensive discussion (i've read
through all comments from 2017 through 2019 but the discussion seemed active
until 2021.) this seems like the type of thing that's going to take some time to
think through even i after i finish reading everyone's take on it.

other issues i've commented on remain answered. i'm ensuring this is always
included in the daily report so i have an easy way of tracking when should i
make a gentle ping to all issue participants.

= Blockers
none at present.

= Plan for the week
work continues as expected. there's nothing to add to yesterday's comments on my
approach to these 1.0 issues. the current one, though, seems like is going to
require further discussion and i'm expecting it to take up the rest of the week.
this may extend for longer if it really turns out to be a huge thing. but it's
worth the time, as closing it would mean getting rid of one of the largest and
oldest breakage issues.
