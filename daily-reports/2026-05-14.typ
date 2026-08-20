#import "../template.typ": *

#show: template.with([Daily report (2026-05-14)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was solely concerned with the issue that yesterday we implemented a
patch for, and which has revealed further bugs (some of which we already have
patches for, and some of which we don't.) We started off by implementing some
type infrastructure around the `Spinner` type that had been used in the `init`
routine, and for which wider use was now needed to report progress on the async
operation that writes out the in-memory representations to disk. This was deemed
necessary because this operation could take enough time for the user to notice a
hang on the program (though only when modifying over thousands of constants at
once.) Most of the work got completed on today's first two commits, while the
third one just refactored it to make the trait bounds on it less restrictive.

The implementation is simple to grasp, but there were some intricacies to the
way the type system was expecting trait bounds to fit together for the async
closure's captured bindings that I could not understand, and had to find some
alternative ways of fixing. The entry point is a single associated function that
takes on an async closure to which the spinner provides a transmitter (as part
of a channel) to communicate strings into it such that progress reporting may be
updated at different intervals. Apparently, async closures require specifying
that the future that is returned from calling the closure is `Send` for us to
use them within contexts that require so. `tokio::task`s always require so, but
the error messages were not simple to grok. Then came the trait bounds, which
were quite finicky in their treatment of subtyping and I didn't completely
understand; The string type I used initially for the async closure was a
`Cow<'static, str>` but the type system complained that that was not a general
enough implementation for any possible lifetime in `Cow`. This was then fixed by
using higher-ranked trait bounds on the `Cow` for any lifetime `'a'`. But then
on all callsites the type system complained that the owning transmitter we get
as part of the async closure was escaping the closure's body, which is just not
possible with the use we were giving it (especially considering this error was
being triggered by a call to `send` on the transmitter.) At the end, I settled
for the slightly less efficient `String` (as often times the spinner was used
with static strings, and this just forces a heap allocation.)

With this implemented, the `init` routine got refactored to use the spinner
type, and its own implementation got removed. The `State::update` routine also
started using the spinner type to better handle the event where changes were
being effected to disk. A `TODO` comment I wanted to solve regarding that one
event was that it was the only reason why the whole method was async, and it
really needed to report something to the user instead of just awaiting and
putting the whole program on hold until the I/O operations were done. The logic
here got quite finicky again, and for the time being, I've had to implement an
`unsafe` wrapper over raw pointers to allow the task that gets launched there
but never awaited to capture the required context from the running state. This
is sound because the state will not be dropped, as the drawing routine keeps the
other half of the channel with the receiver to show a spinner animation while
the constants are saved to disk (and the drawing routine is called as a method
on an instance of the running state.) One way to stop using `unsafe` here would
likely go through using atomically reference-counted shared pointers, but I
decided against it in favor of solving more pressing issues. And the threaded
pointer type used here also ended up being used in other callsites of the
`Spinner::run_while` routine to assert that the trait values could be moved
inside the closure even if they weren't `'static`. This is sound because the
spinner awaits completion of its tasks, and at callsite, we always await
completion of the spinner future itself as soon as it the call is made.

Finally, the bug that yesterday got a patch was found to be correct in its fix,
but insufficient to properly solve the problem. Minutes before I started writing
this report, I found the source of issues, so the fix is not yet implemented,
but considerable tracing information has been added to the logs to diagnose it.
Apparently, the filtering operation that reused a borrowed contaienr cleared and
updated the non-owning container with the new regex-matched results, but forgot
to update as well the other piece of state these views keep over the owning
container; The initial state with which the program is initialized. This then
causes that the amount of symbols in the former buffer ends up (possibly)
smaller than that of the latter buffer, thus causing the initialization state
(concerning modification) to mismatch the current elements in the view with the
elements that were previously in the view.

The PRs got rebased onto latest `main`.

= Blockers
None at present.

= Plan for the week
The issue that was diagnosed today but not fully fixed will likely be solved by
tomorrow. Beyond that, I expect to have finished scrolling support by the end of
the week, which should make next week the last one or the one before the last
one before hotfixes should stop and actual symbol deprecation starts. I'm also
thinking of adding some further indication about the source file of the constant
in the list of filtered symbols, as often times there are multiple constants
with the same identifiers from differing `libc` modules, and it's impossible to
know which one is which.
