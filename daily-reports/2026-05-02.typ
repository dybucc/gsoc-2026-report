#import "../template.typ": *

#show: template.with([Daily report (2026-05-02)])

#title(context [#document.title \ #html.aside(css-credits)])

This daily report reflects the current progress of my proposal plan as of today,
focusing on three main sections that I gathered from GSoC guides and readings; A
summary on today's work, a list of possible blockers, and the expected outcome
of the week.

This structure is not set in stone, though, as the first report reached my
mentor yesterday but no conversations on it have taken place just yet. A message
following this one should provide an archived version of that report, as this
channel did not exist yesterday at this same time.

= Summary
Today I kept staring at the code of the binary that will back the second part of
my proposal; Namely, the constant symbol deprecator. This binary is meant to be
implemented as a fzf-like picker to ease interactive and bulk deprecation of
such symbols in the `libc` codebase, and currently I have developed a library to
back the core functionality of parsing the codebase and getting set up basic
utilities to filter out symbols from regexes.

Work on the rendering logic in the binary is progressing slowly. I realized that
the way constants were fetched from the underlying container when getting a
borrowed, disjoint view of some regex-filtered symbols was not quite efficient.
Inspired by the capture groups of the `regex` crate itself, I implemented
similar functionality to allow reusing the same borrowed view of the overarching
container. This has yet to yield acceptable results when used in the
implementation of the actual picker, as I didn't think through Rust's need for a
single point of mutability for a given type, so yielding a borrowed view from a
mutable routine that does not fill the view with any exclusive references
already conflicts with calling the routine (with a mutable receiver) that
actually filters and fetches a set of constants into the borrowed view. A
possible solution might be to replace the use of references with shared
pointers, though that would also require changing the way such symbols are
stored in the overarching `ConstContainer`.

Beyond that, I have thought through the pre-rendering logic, which should be a
simple one-off `crossterm` command to set up 11 lines down the user shell's
prompt with the filtered symbols, and the prompt. The idea is to replicate the
fish prompt you get when you toggle command search mode in the regular prompt.
Nothing fancy, but just useful enough to get the job done.

Work on the first part of my proposal is still pending further review/comments
by other `libc` contributors. The three relevant PRs on GitHub currently address
the transition into a single `time_t` value in Windows while also solving other
platform issues that were uncovered along the way. My plan, as outlined in the
proposal, is to keep working on the constant deprecator and only once I'm
finished, continue with the transition on other platforms.

= Blockers
None at present. I have been sick today, so other than the usual long sessions
of code staring, my thinking was slowed down, which resulted in overall subpar
performance.

= Plan for the week
Considering the reports started by the end of this week, I plan that the
rendering logic should be fully done by the end of next week. This seems
achievable, but the only reason for that is that I have faith in the power of
code staring and thinking to yield the right answers for the problems I require
solving. The plan for the TUI is already decided, and should be relatively
simple to execute without having to use something like `ratatui`. My proposal
expects the binary to be done by the first or second week of the actual "coding
period" in GSoC, and I still believe that to be possible.
