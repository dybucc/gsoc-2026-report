#import "../template.typ": *

#show: template.with([Daily report (2026-05-04)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today multiple changes have been made to the codebase. Progress on the rendering
loop has advanced greatly, as it now is already capable of parsing raw input
events into actual events that can be interpreted more easily. To this extent,
the prior infrastructure for input handling has been kept around as the barrier
between the user and the application; Then, two more layers of abstraction have
been added. The first one corresponds with handling how should input events be
processed with respect to the currently active mode. This has also added a new
mode, visual mode, to allow selection of constant symbols in the filter list.
Beyond that, the final layer abstracts the meaning of each action within each
mode, such that the routine in charge of actually modifying the running state is
also kept small and nicely modular.

A few other utilities throughout that process have been built to handle graceful
termination of the program. These types report their values "halfway through"
the transition between the above two abstraction layers. Beyond that, work has
gone into implementing a new type to further enhance the degree of granularity
with which a subset of constants can be fetched from the borrowed view into the
owning container. The new type, `BorrowedSubset`, implements a range-based,
continuous selection of the constants already gathered within
`BorrowedContainer`. Even though further filtering through another regex is not
implemented and not planned, this has allowed implementing the logic for
handling selection of constants within already filtered symbols.

The state of the PRs continues as mentioned yesterday.

= Blockers
None at present.

= Plan for the week
Today a lot of progress was made, and it may just be that the rendering loop
gets finished before the end of the week, so long as the current pace is kept
and not a lot of debugging is required once I start testing everything out.
Because (my lacking) experience tells me that's exactly the sign of a week's
worth of work, I continue believing that it will take me the rest of the week to
nicely wrap up this part of the binary. The proposal plan did also mention that
I wanted to check out whether other potential issues in the 1.0 release track
for `libc` would require implementing tests, such that I changed my plans for
the final two weeks of work, but for the time being, I will not be looking into
that.
