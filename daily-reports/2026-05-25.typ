#import "../template.typ": *

#show: template.with([Daily report (2026-05-25)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on two main things; Patching up the edge case for the improved
filter list implementation that was introduced yesterday, and starting a
refactor to both lighten the dependency load and clean up tracing functionality
in the core library.

The first task we tackled was fixing the bug. That was fairly simple, as solving
for that one edge case only required modifying some assumptions when resolving
the constraints on how much space should be left for the stringified
representation of the identifier. Previously, we were subtracting the entirety
of the terminal grid size to the total sum of columns required to fill a full
row in the tabular display. Now we subtract to this latter sum the result of
subtracting the terminal grid size (column-wise) to itself. This may seem
idiotic, but is required as we then check if the result is still larger than the
sum of columns occupied right before adding up the space the identifier would
take up. If some space remains, we take a slice of the stringified identifier
corresponding to the computed offset. Handling the edge case also meant special
casing the times where the identifier proved to not fit in the screen by taking
a subslice with a range that stopped one unit before the computed offset, such
that we could then append the ellipsis without forcing the line to wrap.

As I was going through this, I realized the routine where this was implemented
would be repeatedly called everytime a symbol was to be output. Performing a
potentially blocking (and fallible) operation such as requesting the terminal
size from the user's terminal emulator by issuing the corresponding escape
sequence wasn't exactly ideal. So now we just cache the terminal size during
state initialization, and have a new resizing event that we react to by updating
that one component of the `State` instance. I have not and likely will not (for
the time being) implement resizing support when the grid size proves to be
smaller than 10 rows large. The one downside to all of this is that I did not
implement an event debouncer for this type of event, which is, according to the
`crossterm` docs, likely to come in bursts.

Solving this also required refactoring some implementation details of the `repr`
and `repr_impl` macros.

Once that was done and "tested," I decided I would next go for a refactor of the
binary crate. This meant restructuring everything into separate modules, such
that I don't cram all functionality into the `main.rs` file.

Beyond that, the most notable changes included tweaking the enabled features of
the `tokio` and `gix` crates in the core library crate, and starting a refactor
of the logging facilities in it. The former vastly improved compile times, as I
had been bogged down by over 500 dependencies when I could've done just fine
with little less than 300. The latter is still a WIP. The refactor is focused on
gating behind a feature flag of the core library all tracing functionality. This
also means getting rid of whatever tracing I added to internal routines, as well
as refactoring fairly large pieces of constified code into
conditionally-compiled sections that are not `const` when running under that
feature flag. The binary then has a feature of its own that transitively enables
the same feature from the core library.

= Blockers
None at present.

= Plan for the week
This week's goals, as set yesterday, were to continue refactoring and start
actual deprecation work to iron out the last few obvious bugs. So far, I have
fixed the bug I planned on patching yesterday, and will likely complete the
current refactor by tomorrow. I may or may not refactor the spinner
functionality, as triggering the write-to-disk event does not seem to
automatically trigger the spinner animation, thus requiring another input event
to actually start off. This, though, is purely cosmetic, so I plan on first
having a go at researching and deprecating constants related to the tracked
issue.
