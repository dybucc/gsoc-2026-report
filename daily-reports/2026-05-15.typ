#import "../template.typ": *

#show: template.with([Daily report (2026-05-15)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on getting the issue about the initialization state not
being correctly kept in sync in the borrowed views with respect to the actual
buffers. This bug itself came from previously attempting to solve the issues
with effecting changes to disk, for which further bugs (and patches) have been
found (submitted) today.

Firstly, I decided to refactor the logic behind the non-owning views into the
container, such that instead of getting a resizable container with a fixed
capacity, they just stick with a fixed-size container that alters the
representation of each of its elements whenever it is that a filtering operation
discards some elements from the regex search (or takes them into consideration.)
This meant developing a new type, `BorrowedElem`, that wrapped the weak pointer
that we held inside the borrowed views. This type has an internal representation
that uses `Option` to check whether a given symbol is currently filtered or not.
The filtering operation now does not clear the buffer, nor does it shorten the
length of the iterator over matched/non-matched elements. Instead, it maps those
elements that matched the regex search to that representation in-place by
modifying exclusive references to the borrowed view.

This was fairly finicky to get right, and so most patches today focused on
fixing some other abstractions that relied on the now old behavior of non-owning
containers. Among those that required the most changes, I found the `Visit`
trait that was being used for in-place traversal through the set of constants in
the current view to be the one in need of most of my attention. Because the view
is not "shortened" anymore whenever a filter operation takes place, traversing
elements needs to check whether a given `BorrowedElem` is, indeed, a matched
constant or not. This was quite simply solved by providing a view into the
constant through a method on the new element type that takes a closure with a
reference to the element if, indeed, the element had matched. Because of these
changes, the `BorrowedSubset` type also stopped being of any use, as we cannot
rely anymore on contiguous views into the `BorrowedContainer`. Today's refactor
makes the latter a fixed length, and the matched symbols within it quite
possibly disjoint. This thus meant that prior uses of the subset type had to be
replaced with dedicated traversal methods that were implemented in terms of the
only required method in the `Visit` trait. Because sometimes we also required
mutable traversal, a new `VisitMut` trait has been introduced to mirror the
functionality of the existing trait (a refactor made them both be implemented in
terms of a macro.)

This finally solved the problem with initialization state, but not the entirety
of the issues related to saving changes to disk. Further, the routine that
deprecated symbols was not correctly handling the modified stamp to check
whether a symbol had truly been modified from the last time it got effected to
disk. This has been fixed to the point where now all symbols that have been
somehow modified but possibly not modified with respect to their current state
on-disk (e.g. toggled twice the same symbol, so you're back to the initial
state) will now be unconditionally saved to disk. This was decided because there
were other more pressing issues to solve.

Finally, after a few test runs and some code review, I found out that the code
handling the writing of changes to disk had only been partially fixed (from
yesterday and the day before.) Idiotic me (for the second time in a row) forgot
to remove the check for constants to always require deprecation for them to be
saved to disk (the filtering part, which came before the actual logic to change
the attributes of a given item on disk, fixed yesterday.) This was simple to
solve, but not the only issue in that routine. Additionally, I also forgot to
implement traversal through the bodies of macros where we had parsed constants
(that traversal _is_ implemented in the parser, though.) Currently, work is
focused on getting a generic parser/traversal routine over a given file with a
closure to mutate the constant items fetched on that function. At present, all
functionality but parsing of constants within `cfg_if!` is implemented, and I
don't expect that to be too hard as it was already implemented for the
`parse_constants` routine.

The PRs got rebased a few times today.

= Blockers
None at present.

= Plan for the week
Regretfully, I doubt I will have scrolling implemented by the end of the week. I
believe ironing out all the issues with writing to disk is likely to also take
entirety of tomorrow, and I doubt scrolling is getting implemented in a single
day. The work set out for the week was already finished halfway through it, and
I expect scrolling to be implemented by either one of Monday or Tuesday next
week. Considering that is the last major part (functionally) that needs
implementing, I believe the expected proposal deadlines can be met.
