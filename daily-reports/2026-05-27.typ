#import "../template.typ": *

#show: template.with([Daily report (2026-05-27)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on finishing up yesterday's refactor, starting to deprecate
symbols and issue patches to the `libc` PR tracker, and fixing some bugs I found
along the way.

Firstly, the refactor concerning the combinator logic was fairly straightforward
to finish up and was a true gift of the galactic emperor. Getting a set of
futures produced from an iterator into a stream that folds down to a task pool
and then unfolds back the whole thing into another stream that reduces all
fallible task results is genuine bliss. Once that was done, though, I realized I
didn't quite get through with the `tracing` refactor, as the dependency was
still being pulled unconditionally. The fix was simple, though, as just making
it optional and transitively adding it to the set of "after-effects" the
`tracing` feature has on both the core library and the binary did the trick.

Beyond that, I started out with actual deprecation work, and found two bugs so
far (both of which have been fixed and "tested.") As I was writing some regexes,
I realized that the program just bailed out when syntax parsing failed. This was
far from ideal, and has now been changed to instead report an error message that
the user can exit out of with any key press. The prompt is then cleared and the
deprecation session resumes with the prior search results.

The other bug was also fairly simple to fix; The flag that keeps track of the
modified constant was not getting updated after saving changes to disk. This
then caused constants that had already been modified (but not had their
modification stamp reset) to be deprecated again (in the case of undeprecation,
nothing happened as there is no attribute to remove.) The end result was having
multiple deprecation attributes annotating the same item. Patching this simply
required updating the modified flag alongside the spans of modified constants in
the `ConstContainer::update_spans` routine, which has now been renamed to
`ConstContainer::update` to reflect its new responsibilities.

Finally, deprecation work today was light as I focused first on getting rid of
constants that had already been identified to cause issues. At present, this has
meant looking through the source code of the different BSDs for which the
`ELAST` constant was defined, and ensuring they all use it for the same purpose;
Namely, as the largest `errno` value one may find after calling into library
routines. A PR has been opened with these changes in #link(
  "https://github.com/rust-lang/rust/issues/5118",
)[\#5118].

I did want to ask Trevor Gross, though, about one other constant I've been
looking into. The `RAND_MAX` constant (present in tree hierarchies other than
that of the BSDs) seems to have been changed in FreeBSD 12 but not ever since
FreeBSD 13. I've not yet looked into the `git blame` of changes to other target
OSs where the constant is defined so I can't say for sure if it should be
deprecated in other modules.

I would like to mention that the `libc-constant-deprecator` is potentially ready
for external use. This was the plan all along in the written proposal, and bug
reports are very much welcome.

= Blockers
None at present.

= Plan for the week
As per the stated weekly plan, deprecation work has started, and alongside it
bugs have started to pop up. I expect tomorrow to repeat the same routine as
today; Look into some constants that are already known to have caused SemVer
issues, look into their upstream source code and repeat again with constants
(possibly) declared alongside those. For the time being, I'm focusing on the BSD
family, and more specifically, on the FreeBSD tree, where there seems to have
been quite a few changes across releases 11-15.
