#import "../template.typ": *

#show: template.with([Daily report (2026-05-07)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on getting yesterday's initial implementation of a table
of closures to handle mode transitions in a more modular fashion (sort of) done.
This was eventually scratched in favor of keeping all the logic within the
`State::update` routine. As mentioned in yesterday's report, getting this to
work was not high-priority but rather part of a refactor of the afore mentioned
method. Because other refactors already tidied up the method nicely, I decided
I'd leave things be for now.

I then moved on to veryfing whether selection handling within select mode was
correct, and realized that there were a few issues with the current
implementation. Fortunately enough, the type infrastructure built around it is
still very much usable, and I believe I will be keeping it around. The bugs were
found in the code that processes whether a selection should be extended by the
same events that change the currently stored cursor position in the TUI. This
was previously handled by just bunching up the same code, irrespective of active
mode. Now we react accordingly to each of the modes that the user can be in, by
only changing the active cursor position and extending the selection if the
event is one of moving up or down the cursor.

This also revealed another bug in the way determining which of the `start` or
`end` bounds of the underlying range in the selection should be used when
extending it. As it turns out, the proposed reasoning within the
`Selection::extend` method was only allowing selections to move downwards, as
otherwise the selection would expand once upwards and immediately recede by
going back to a single selection instead of extending the selection further
upwards (assumming subsequent events correspond with such expansion.) The fix,
even though not yet implemented, likely goes through keeping track of a pivot in
the selection, such that we determine whether the selection should expand
upwards only when the resolved index of the element in the list of buffered
symbols (after applying the offset that the selection represents) turns out to
compare smaller than the pivot index itself. Simply put, surpassing the index of
the pivot would mean expanding the selection continuously with the `start`
bound; Otherwise, the selection would have to be expanded with the `end` bound.

The currently open PRs on GitHub have been rebased to latest `main`.

= Blockers
None at present. Today I had some stuff to deal with in the morning and well
into the evening, so I couldn't get as much work done.

= Plan for the week
The fix for the bug I mentioned in the summary will not be implemented just yet
as it only affects the update logic, and that is not this week's priority. Work
on the drawing part of the rendering loop should start tomorrow, and I expect it
to take about two day's worth of work to get the layout right. Of course, this
does not go through getting all events to respond as they should, so by Sunday I
still believe I should have the prompt and the initial list of parsed
symbols(without filtering) displayed on the TUI.
