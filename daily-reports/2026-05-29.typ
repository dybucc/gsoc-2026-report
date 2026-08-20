#import "../template.typ": *

#show: template.with([Daily report (2026-05-29)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on deprecating the `*MAX`-suffixed constants. This was a change
of plans from yesterday's report, where I mentioned I would leave this for
later, but I just thought it'd best if I tackled the larger group first.

There was relatively extensive research done throughout the deprecation process,
and it is still unfinished. Still, a great amount of progress has been made and
deprecation of those symbols is nearing its end. All of the notes relative to
whether I took one decision or another are included in the newly opened PR
addressing this set of constants at #link(
  "https://github.com/rust-lang/rust/issues/5122",
)[\#5122].

Something to note was that I finally had a read through the POSIX standard's
spec for the `limits.h` file, which defines quite a few constants with the
above-matching suffix. As it turns out, there's some symbols that are runtime
invariant, and should thus be considered stable enough that one can check them
out directly from the exposed C interface in the `libc` crate. But then there's
a wide assortment of symbols that are either pathname variable or straight up
meant for their values to be increased at compile time. Having definitions for
these is fundamentally useless and only motivates the creation of non-portable
applications. The standard recommends using one of multiple routines to fetch
those values from the system, such as `sysconf`. I decided this set of constants
should quite definitely be deprecated, and that has served me as guidance with
quite a few symbols. Though I'm not sure about some of which are deprecated in
the standard itself (not pinging my mentor because I already did in the PR.)

= Blockers
None at present.

= Plan for the week
Yesterday's plan was ever so slightly modified. This has no negative impact
whatsoever, and in fact, lets me address the larger set of constants earlier on.
I expect to continue these efforts all through tomorrow and possible the day
after. I don't think I will take this to next week, so I could have finished all
deprecation by then. Still, I prefer not to get ahead of myself. The proposal
plan set the week after (week 3) as the limit for that, so it may just be that
something else pops up. I don't anticipate that to be the case, so I will likely
start working on the time/file offset bit transition earlier than expected.
