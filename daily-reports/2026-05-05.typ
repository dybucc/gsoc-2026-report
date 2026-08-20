#import "../template.typ": *

#show: template.with([Daily report (2026-05-05)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today was mostly a day of refactors. A large amount of code that we implemented
yesterday for the purposes of input handling got moved into a macro that more
gracefully deals with all things related to types that use an internal
representation, while still allowing for extensibility of such types. This made
the implementation of other utility types easier, and allowed me to improve some
parts of the input handling and state update routines. The main difference with
the initial implementation is that the pattern of keeping a public-facing type
with an internal representation and another public-facing implementation has
been finally implemented in full. Previously, I was hesitant to do this due to
the amount of code bloat that it would require, but some macro wizardry got most
things out of the way. Moreover, I also refactored another macro that generated
accessor, checker and consumer methods for the above types to make it far easier
to repeatedly implement them. All of this has not only unified greatly the
public interface (even though a binary and not a library crate, I prefer to keep
some degree of separation of concerns,) but has also allowed me to detect a few
places where my manual implementation was not covering edge cases, like the
types of input events that I was transforming between their lower-level, raw
forms to their higher-level, nicely formatted types.

Beyond that, I have also made good progress on the state updating side. All
events that yesterday did not have proper input handling now have a complete
implementation, which itself has been made modular by creating a bunch of other
types using the internal representation pattern mentioned earlier. Among these,
the `Position` type is of special relevance, as it required further refactoring
the macro for type generation and trivial implementations to allow the inclusion
of fields other than the internal representation. This type is used in the
running state to keep track of the current position in the terminal grid; Both
as raw cell coordinates, and as parsed coordinate offsets into the area under
consideration for the TUI. A new event that I have added but for which there is
no complete implementation just yet is the `Switch` event, which allows the user
to move between the prompt and the list of filtered constants. I decided to
include this command to make implementation matters easier when it came to
deciding whether existing motion commands should also allow moving between
layout containers. There's also another event that is not even caught yet, but
for which I have left a `TODO` comment; Backspace for character removal.

The PRs' state continue as mentioned yesterday. There was a new commit in the
`libc` repo, so I rebased them to latest `main`.

= Blockers
None at present.

= Plan for the week
As commented yesterday, it seems like the rendering loop may not take as long to
implement after all. Though, of course, I have not yet properly started the
on-screen drawing implementation, and that will likely require as much if not
more type infrastructure as the update part. Either way, the priority continues
to be this drawing loop, so events like `Backspace` (mentioned as not yet being
implemented in the summary) won't receive any attention for the time being.
