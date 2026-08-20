#import "../template.typ": *

#show: template.with([Daily report (2026-05-03)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
The code for the binary got implemented the pre-rendering logic concerning how
should the terminal layout be manipulated prior to actually entering the
rendering loop. This, as mentioned in yesterday's report, was fairly simple to
execute on. The code for the library also got refactored to reflect the changes
I proposed yesterday in the daily report regarding the storage of constant
symbols. These required being mutable and accessible through a borrowed view,
while also allowing methods taking an exclusive receiver on the owning
container. I've iterated on a few approaches throughout the day that used
wrapper types to leverage certain guarantees about the implicit relationship
between these types, but eventually settled for a bunch of `Arc`s for each pair
of symbol and modified flag, that then uses some `unsafe` to mutate the values,
even with a strong count larger than 1. The reasoning here is that the only real
point of mutation for the container of constants is the borrowed view, as
mutation of the overaching container only invovles the regex cache. Surely this
could have been implemented with some wrappers against raw pointers, but I
eventually settled for the simplest way out, knowing it still encodes my
intentions just fine, even if not completely at the type system level.

Beyond that, I also slightly optimized the process of parsing constants from
disk, which happened to be using multiple potential allocations for each set of
constants parsed from a single source file. Now, at a smaller cost of keeping a
type-erased `Box` into an iterator of constants for each file, only a single
explicit allocation for the final container of symbols is kept around; On each
end of iteration (once all constants of a given file are parsed,) the resulting
iterator extends the explicit allocation. I believe in this instance relying on
more opaque choices by the underlying `std` calls should improve the overall
memory cost.

Progress on the PRs continues as mentioned yesterday.

= Blockers
None at present.

= Plan for the week
By the end of next week, I should have finished the rendering logic. I expect
this to mean that the on-screen rendering can already display constants with the
expected layout, and the prompt is rendered, but I don't think I will make much
progress just yet in setting up events to react to bindings for symbol selection
and toggling of their deprecated state. The deadline on my proposal for the
binary is between the first and second weeks of the GSoC "coding period," and I
believe that to be feasible at my current pace. The week after the next one
should already have me working on the prompt and bindings for selection, which I
should wrap up in the next two weeks to that one.
