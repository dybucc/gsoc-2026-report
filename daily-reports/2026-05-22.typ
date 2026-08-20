#import "../template.typ": *

#show: template.with([Daily report (2026-05-22)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on getting scrolling completely working and refactoring the
crate with the core library. The scrolling implementation was already working
correctly in normal mode and a basic implementation when in select mode had been
finished yesterday. An issue had also been identified in the way constants were
being toggled while in select mode, which has been addressed today.

As mentioned in the last report, solving the afore mentioned issue had to go
through refactoring the implementaiton for the `Visit` trait (and the
overarching type infrastructure around it.) This required reimplementing the
trait for `BorrowedContainer`, to adapt it with its now more generic interface,
accepting a closure returning any type implementing `std::ops::Try`. Getting
this to work, though, was quite finicky, as I did everything from within the
macro body of the `visit_def` recursive macro used to define shared
functionality in both `Visit` and `VisitMut`. Still, the end result was great
and the solution was neat. Most of the provided methods expect to return a value
of the same type as that implementing `Try`. Of course, simply calling the
provided closure is insufficient as further prep-work must be done while already
inside the closure with which we call the required method of the trait. This
meant that the required method, itself expecting a closure returning some type
implementing `Try`, had to return `ControlFlow<Option<R>>` where `R` was the
type implementing `Try` from the closure of the provided method. Then some
combinators map the two branches to the values resulting from calling
`<R as FromResidual>::from_residual` and `<R as Try>::from_output`, where the
latter is always provided the unit tuple as part of the constraints imposed by
the `Visit` trait.

After implementing this, the issue still remained, though in this case, it was
due to the fact the constants being traversed did not carry with them
information on their modification stamp nor on the initial state since the last
save-to-disk operation. This was handled initially by embedding those two pieces
of information into the closures that get passed, as they had so far been
ignored but were actually part of the `BorrowedElement` type of which
`BorrowedContainer` is composed. After realizing that just passing two more
boolean flags was not quite doing it, I decided to refactor that part of the
interface to provide a more precisely typed view into those two pieces of state.
This ended up with the `VisitOptions` type, which holds either one of the
modified stamp and the initial state stamp as exclusive references or as owned
values (depending on whether the traversal is mutable or immutable through
`Visit` or `VisitMut`.) The neat thing here was that I realized traversal was
always known statically to be immutable or mutable, so embedding an enumeration
into this new type was a waste. Instead, I replaced it with a union and a
polymorphic type over which `VisitOptions` exists, that implements the sealed
trait `TraversalMarker`. This trait is then implemented for two new ZSTs,
`OwnedTraversal` and `ReferenceTraversal`. The `TypeId`s of each of these types
then serve as the discriminant to ensure which of the two fields of the union we
ought consider at a time; The owned boolean or the reference to a boolean. This
also makes implementing certain methods like mutable getters exclusive to
instances of `VisitOptions` that are parameterized with `ReferenceTraversal`.

Beyond that, work has gone into some fairly large restructuring of the core
library crate, to ensure everything is cleanly organized. There's really not
much else to say in this front. This refactor, even though largely finished, is
still pending some other changes I would like to see in the exposed interface.
Of note is the removal of the `BorrowedSubset` type, which did not serve any
purpose no more, as the `BorrowedContainer` has been a fixed-size container for
a few patches already, and getting a contiguous view into it does not
necessarily yield regex-matched symbold anymore.

= Blockers
None at present.

= Plan for the week
Scrolling support is officially completed and with it, the fundamental
functionality of both the binary and the core library. I believe by tomorrow I
should have finished the refactors I intend on doing, and quite possibly have
started (if not finished) a refactor to improve the looks of the displayed path
for items in the filter list. This is the last goal I'm setting for the week,
and I believe next week should really be dedicated to straight deprecation to
really diagnose usability bugs. I would also like to implement display of the
constant's value, though we'll see.
