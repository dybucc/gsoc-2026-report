#import "../template.typ": *

#show: template.with([Daily report (2026-08-16)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has focused on two things; Commenting on yesterday's issue thread on
glibc, and starting work on the final cosmetic touches to my GSoC work product.

Yesterday I had left the glibc issue pending. I started off by first reviewing
the comments in the libc-test build script, and taking some notes on that.
Afterwards, I looked through the list of merged PRs mentioning glibc.

The point here was to try and find whether there had been any precedent on us
limitting the glibc symbols we exposed for the sake of keeping compatiblity with
a baseline version.

From my read on those threads and the fact we have a ton of API that is skipped
on certain glibc versions when testing on CI, I guessed that wasn't the case.

I gathered this into a response to the glibc thread where I proposed to simply
document in our usage guidelines the lowest glibc version in which one of
currently exposed bindings was introduced.

This is the type of thing that would benefit greatly from having RFC 3905
implemented and extended to work with target-specific `cfg`s. I also commented
on that, though that's more of a long-term plan.

The next thing I did was to start formatting the GSoC work product. I initially
intended on typesetting a PDF, but then I realized that could very well trigger
a download on somebody's computer.

I've settled instead on serving it as plain HTML (no stylesheets whatsoever)
after producing those same compilation artifacts with my typsetting tool of
choice (`typst`.)

`typst` has a fairly similar syntax to Markdown, so the only noticeable changes
are the list of references and links, which get proper support through a
bibliography file. That's the only thing that's taking up some more time.

= Blockers
None.

= Plan for the week
GSoC is nearing its end, and the report is ready text-wise. Following this daily
report, I should notify my mentor for review of the text, which continues being
available for easy access through a Markdown file in the repo.

Beyond that, I'll just keep doing the same things I've done so far; Working on
libc issues and touching up cosmetic aspects of the GSoC report. Of course, I
could actually receive feedback requiring more from my mentor concerning the
report, but that should be manageable.
