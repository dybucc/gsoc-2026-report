#import "../template.typ": *

#show: template.with([Daily report (2026-05-28)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on getting a bunch of constants deprecated. I won't be
discussing the specifics of each of the constants because a summary of that
research was already included alongside the opened PRs.

Still, I can say that work started by deprecating `RAND_MAX` constants in the
FreeBSD tree, as that one seemed to have changed between releases 12-13. That
followed up from yesterday's changes to the `ELAST` constant across all BSDs.
Then I moved on to deprecating constants that matched the `*LAST` naming scheme,
and then to constants fitting the `*COUNT` naming scheme. Both of those required
a fair amount of looking into the sources for each of the upstream repos, as
well as taking into consideration prior efforts by Lilit0x and comments by
Amanieu. There were, though, some hurdles I coulnd't get through; Namely,
understanding whether certain constants under `mach/host_info.h` should be
deprecated, and pinpointing the `DLFO_STRUCT_HAS_EH_COUNT` in the GNU Hurd
repos.

= Blockers
None at present.

= Plan for the week
Looking back at the proposal plan, things are going quite well. The expected
timeline for deprecation work was meant to start next week, and I've already
went through a bunch of the constants before the end of week 1 of the "coding
period." Tomorrow I will continue working on constants matching the `*NUM`
regex, and from there on, I will look into the larger group of `*MAX` constants.
I believe researching all of the constants in the latter group is going to take
a little bit longer.
