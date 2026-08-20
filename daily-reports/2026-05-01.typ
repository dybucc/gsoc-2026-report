#import "../template.typ": *

#show: template.with([Archived daily report (2026-05-01)])

#title(context [#document.title \ #html.aside(css-credits)])

#quote[This report was the only one that was not published the same day as it
  was written. It was first messaged to my mentor, and the day after, coupled
  with the report for that day.]

#divider()

At present, I believe to have finished the core functionality in the library
backing the constant deprecator. Work on the binary started a few days ago,
though today I have been staring at the code and thinking, so minimal changes
have been made to the codebase. One change I made to the project plan since I
presented my proposal was to remove support for keeping a record of constants on
disk, as I deemed it unnecessary (deprecation of a set of selected, narrowed
down constants is not dependent on anything else, and be effected on the
codebase immediately) and quite possibly error-prone to keep track of in
addition to version control.

Beyond that, the currently open PRs I have in the `libc` GitHub repo are
up-to-date and ever since I last commented on them, I have been awaiting further
review/comments. I believe the work on all three PRs is complete, and each
addresses one of the issues I found during `time_t` deprecation on Windows x86
GNU. According to my proposal plan, I should have finished the constant
deprecator by the first to second weeks, and have already deprecated/tested it
on the codebase for a fairly large amount of constants. At my current pace, I
still believe that to be achievable; By the end of next week, I should have
finished the logic around the renderer and input handler, but possibly not
around the navigation modes in the deprecator's prompt.
