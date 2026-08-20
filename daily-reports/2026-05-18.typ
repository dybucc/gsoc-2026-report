#import "../template.typ": *

#show: template.with([Daily report (2026-05-18)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was mostly focused around getting an implementation for the plan that
I already implemented yesterday in an isolated manner. The first half of today's
work was still done in an #link(
  "https://gist.github.com/dybucc/0eaeb1ad18c6ddc1795b8b80ecccab13",
)[isolated environment] as I figured out the type infrastructure required to
keep track of both the `syn`-parsed contents of a file, and of the string with
source-irrelevant information (comments/whitespace.) This ended up being
implemented and (in theory) working with a `FormatFile` type, that initially
parses the file into a `syn::File`, but then on construction also takes note of
the spans of all constants (both at module level scope and within the bodies of
`cfg_if` macro invocations.) Beyond that, it also takes care of keeping the
original string that was read from the filesystem. Then, a new `Parser` type was
implemented to allow resolving each of the branches of the `cfg_if` macro
invocation to a set of potential constants found within them. This was
implemented through an ordered hash table, as in theory, one would not expect
the condition attributes in the branches of the `cfg_if` body to ever be
equivalent. This type also handles the roundtrip to a token stream, which fixed
an issue that had completely gone over my head previously; Replacing the tokens
of the body of the `cfg_if` macro solely with the (possibly modified) constants
does not leave the macro as it was.

With that done, the next thing that got implemented was the routine to mutate
the contents of the `FormatFile`, which took quite a lot of back-and-forth to
find out under which conditions do the spans gathered by `syn`'s parsed symbols
are lost. Eventually, the solution I settled for was one where the constants are
modified, and immediately after running the closure over them, a "nice" string
representation of them is produced, and the inner string of the original file in
the overarching `FormatFile` is updated. This update is performed by taking the
starting index of the old span (which is lost in the symbol but was copied over
during construction to the internal data structure `FormatFile` keeps) and
copying over the entire contents of the original string up to that byte offset
into a new string. Then, the new string is appended the stringified
representation of the (possibly modified) constant, and then the contents of the
old string from the old span's end byte offset up to the end of the original
string are appended back to the new string. Finally, the new string replaces the
old string, and once all constants have been traversed, we parse anew the now
modified internal string, taking note of the new spans that `syn` parsed.

Getting this to work was quite a bit of work, and even then, I could only get it
to work in an isolated environment, as testing in the actual codebase is
pending. The hardest problem to figure out (and the simplest in its solution)
was to get the spans of later modified constants to work correctly after having
updated the internal string with prior (modified) constants. This was simple to
solve once I realized I could just iterate through the file items and the
`cfg_if` branch bodies in reverse.

Finally, I got to integrate all of this in the actual codebase, after which I
got to work on getting the spans of each of the `Const`s in the `ConstContainer`
that performs the write-to-disk operation updated. This is still to be solved,
as I also had to tweak some more stuff while porting the implementation. At
present, I have implemented a basic system to add in advance the constants that
we are searching for to the `FormatFile`, which then internally searches the
constants during traversal, such that whenever the externally-sourced closure
executes, it's guaranteed to have found a matching constant. This should then
allow me to (somehow; I've not yet thought about it) update the spans of the
constants, as we keep pointers to them. This has required creating a thread-safe
wrapper over `FormatFile` that gives up on the span information of the internal
`syn::File`, but keeps everything else, which should be enough, but we'll see.
This should cross thread boundaries by being the return value of the tasks where
the save-to-disk operations take place for each modified constant.

The PRs got rebased a few times today.

= Blockers
None at present.

= Plan for the week
Getting everything to work is going to take a while, but I expect to have
finished by Wednesday, which leaves the deadline for this bugfix untouched from
yesterday's estimate. Once that is done, implementing scrolling support should
come up next. Considering the tool developed in this part of the proposal is
meant to be finished by next week, I still believe this can be accomplished.
