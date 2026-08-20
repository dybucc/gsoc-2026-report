#import "../template.typ": *

#show: template.with([Daily report (2026-05-21)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on getting the scrolling implementation finished. This was
actually far easier than I expected, and at present, all cases that were not
handled in yesterday's patch are now fixed.

The implementation itself is fairly straightforward, though I have refrained
from refactoring it into a simpler, single-index based representation for the
time being (following up on yesterday's talk about there being a far simpler way
of doing things here.) The first patch today addressed the possibility to scroll
while in select mode. This required another refactor of the selection
implementation itself, as I intended on keeping its underlying range to be a
representation of the actual range of constants in the data container. This
required reimplementing a few primitives of the `Selection` type, such that it
used `usize`s instead of `u16`s. This, though, was fairly simple to adapt in
most callsites. Of course, because the bounds of the selection are not made up
of the visible area of the list anymore, there had to be some tweaking of the
`Selection::extend` routine. Though, by far, the one routine that required the
largest rework was the `finalize_select_list` function. This is used as part of
the drawing routine to highlight some items of the list after having already
printed the filter list out. Still, the changes were mostly related to ensuring
I understood right the relationship between the offsets into the container, the
position on the visible area of the list, and the selection range within the
container. Combining those three to produce offsets into the visible list took a
while, but the end result is satisfactory.

Once I went thorugh a few test runs, everything seemed to work, except for
toggling, which was oddly setting the deprecation state right but not unsetting
it. Fortunately, this is not related to the write-to-disk issue, as I speak only
of the in-memory state in this instance. A patch has not yet been implemented
but it should be fairly simple to fix. As I was trying to solve this, though, I
realized that the `Visit` and `VisitMut` trait implementations were in dire need
of some refactoring, so I got to it but have so far not finished. I believe I
can get it done by tomorrow, and it just may be that the refactor fixes the
toggling issues altogether.

All through this, the code for the core library also got a bit of a clean up, as
there were some stray modules with prior implementations of patches to the
write-to-disk bug that I ended up scratching. I also `const`ified a bunch of
things.

= Blockers
None at present.

= Plan for the week
Scrolling support is virtually done, and the only thing left is to fix the
toggling operation, which I am completely sure is unrelated to the selection
implementation itself (and for that matter, I don't even believe it's tied to
the logic implemented in the binary.) This means I should have finished by
tomorrow unless some nasty new bug creeps up, but I don't expect that to happen.
If everything goes as planned, I should have finished not only this week's goal
before time, but also have two more days to enhance some visuals of the TUI. One
of the first things that I would like to improve is the display of source paths
for the list items, which at present is only appended to the constant's
identifier (with no path post-processing, so you get the raw path and not just
the path relative to the `src` directory in the repo.) It would also be great if
the value of the constant could be displayed.
