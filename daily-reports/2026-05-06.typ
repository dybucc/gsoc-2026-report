#import "../template.typ": *

#show: template.with([Daily report (2026-05-06)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we made a bunch of progress on a few areas. I fixed some bugs with respect
to the implementation for basic arithmetic on the `Position` type, which had
until now been modifying its receiver silently. I hadn't noticed this because I
always called those implementations through the compound assignment/subtraction
operators, and so the end result was equivalent but the algorithm was not
correct (not that I think it's correct now, as there's no formal proof.) Beyond
that, the codebase underwent a few refactors to more widely adopt the use of the
`repr` and `repr_impl` macros, as there's quite a few types that align with the
internal representation pattern that I mentioned in yesterday's report.

We also finished handling mode switching events and prompt/list swapping events,
though more on this later.

One of the major refactors was to allow the use of async writers (i.e. in my
particular case, implementors of `tokio::io::AsyncWrite`) to be used alongside
`crossterm`. This crate for terminal manipulation expects sync writers in its
trait implementations for both executable and queuable commands. Today we built
a wrapper type around any implementor of `tokio::io::AsyncWrite` that itself
wraps a `tokio::rt::Runtime` within it, and allows running async code that gets
passed through an async closure within a sync context. This is not so much a way
of running async in sync, but rather a compatiblity shim for everything to type
check. The main goal here was to implement `std::io::Write` on this wrapper, and
thus also get the blanket impl that `crossterm` has to allow running commands on
sync writers. I'm still pending to see how does this fare, considering this
involves having multiple async executors running at the same time; Both the one
I use from `main` and the one we store in the wrapper and block on on every call
to drive async I/O forward. This is more concretely used in the codebase through
a static with a mutex to allow for an interior mutability pattern on the buffer
that we use to draw on the terminal (in this case, `stdout`, but not any
`Stdout` -- `tokio::io::Stdout`.)

I also fixed some issues with the way navigation was being handled, as the side
effects on the running state when in normal mode and when in select mode differ.
This lead to some fairly large new type infrastructure around the way we handle
selection mode. To sum it up, a new `Selection` type wraps behind two
abstraction layers the prior raw `std::ops::Range`, which makes operations that
have to react to the terminal size easier to implement as I can more easily
dispatch certain pieces of data from the running state to the corresponding
routine to read/write to them.

Finally, the last major refactor today involved changing the `update()` method
on `State` to make it shorter. This was going well until I reached the largest
match arm in the main pattern matching expression. This match arm corresponds
with the code handling mode transitions, which I decided would be best left to
the actual `Mode` type to handle (itself requiring further pattern matching to
check whether the transition is not bogus.) Implementing this, though, has
turned out to be harder than exepcted; to avoid repetition in `update()`, we
need to somehow pass all the possible callbacks that we want to run (with side
effects on the state) to the mode transitioning routine, such that upon
matching, it also runs those callbacks. One of the main issues is that closures
behind trait objects seem to be `!Send`. Another problem is that the current
implementation, which uses a table of mode transitions to callbacks, requies the
lifetime associated with the body of the closure in the trait object to be tied
to the running state, but those lifetimes come from the inner components that
the state owns. This may end up requiring to either pin the state and add a
level of indirection, or otherwise build a wrapper around raw function pointers
and see if that gets the job done.

= Blockers
None at present.

= Plan for the week
I continue to believe the rendering loop can be finished within this week. The
above issues with refactoring the state update routine may be ignored if they
seem to take long to solve, as keeping that logic within `update()` has worked
until now. Compared with the infrastructure built thus far, the drawing logic
should not be too hard to implement. All strings to print out and commands to
run through `crossterm` have no issues with the lifetime of the state, and will
only require taking into consideration all of the state we have gathered thus
far.
