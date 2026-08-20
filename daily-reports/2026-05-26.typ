#import "../template.typ": *

#show: template.with([Daily report (2026-05-26)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on finishing yesterday's refactor concerning the tracing logic
that the core library features, as well as a few other refactors regarding the
error handling module and some of the async logic. All throughout this, we also
tweaked some documentation on the public interface to make it clearer that
there's certain things that may become a source of `Result::Err`s.

Efforts were initially focused on finishing the refactor that gated behind the
`tracing` feature flag all statements and attribute annotations that required
running under `tracing`. This meant continuing yesteday's work on the `scanner`
and `parser` modules. Overall, this was fairly simple, and I believe I can say
the end result looks quite satisfactory. Most of the changes were concerned with
adding a bunch of conditionally-compiled `cfg` attribute annotations and
decreasing the total sum of information we forward to the logs (last week's
debugging had been brutal.)

Once I was done with those modules, the only ones left were the `ConstContainer`
methods and the `error` module. The latter also got a fairly large refactor
where I (want to believe) improved the implementation ergonomics for code on the
reporting side of things. This has no impact whatsoever to the public interface,
but did make the code in the `parser` module quite a bit cleaner. The changes
themselves were concerned with using dedicated constructor methods, without
reyling at all on internal types used by the error types.

All along the way, I replaced a bunch of (boring) imperative logic with
(beautiful) combinator chains and single-expression evaluations on both
iterators and streams. This mostly meant replacing straight liners with
iterators over small ranges that check the iteration counter to perform some
functionality in a reduction operation, but also included more involved logic
with streams over synchronization channel receivers. The one notable change here
was some tweaking I made to the scanner logic to decrease the resource
consumption of the program when the repo was to be cloned locally and not just
parsed.

This was genuinely engaging as I've personally had a recent interest in array
programming languages and have started to feel an apprehension towards coding in
semicolon-separated statements that aren't just a cascade of single-expression
reductions and transformations. I have not yet finished this latest refactor but
I'm almost there.

= Blockers
None at present.

= Plan for the week
As mentioned yesterday, today's goal was to finish the tracing refactor and
start working on actual research and deprecation of relevant symbols. I have
accomplished the former, and will likely not immediately start with the latter
until the current refactor concerning the combinator-based logic is done. This I
know will not take more than a half hour, so tomorrow will be \_deprecation
day\_. I expect the rest of the week to continue being a back-and-forth between
deprecation, possibly fixing bugs, and more refactors. This fits in well with
the expected timeline in the proposal, where the tool was to be finished this
week.
