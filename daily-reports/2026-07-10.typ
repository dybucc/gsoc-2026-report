#import "../template.typ": *

#show: template.with([Daily report (2026-07-10)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today work has centered around three things.

- going through new feedback i had gotten on the aix pr.

- going through new feedback i had gotten on the hurd pr.

- starting to look through the rest of the currently open issues/stale prs for
  the 1.0 release.

concerning the aix pr, i went through the header files again and realized there
was no need for a cfg gating certain lfs types. as it turns out, the ones i had
gated didn't need to. they instead needed to also be annotated with the comment
that will be used later on to find+replace it with a deprecation notice (once
we've reached the next stage of the time\_t/file offset plan.) additionally, a
"parameter" to that fixme comment (that we can probably filter for once we
replace them) was added to mention that only under certain target triples are
those records prone to deprecation.

then i made some types that only seemed to be exposed when programming against
the kernel have private types. there's also some types that were already exposed
before that pr which shouldn't have public fields. those have been annotated
with a doc comment that should hopefully steer users away from accessing the
fields until we can make the fields private on a future release.

then i got some feedback from the target maintainer. as it turns out, the ibm
folks seem to consider the possibility for a 32-bit target feasible. they also
mentioned i should hold off on the module clean up, but i'm not sure about this.
so i asked them if i could keep all changes but move back the 64-bit conditional
definitions/routines into the powerpc64 submodule.

the hurd pr got feedback from the target maintainer. i also replaced the
deprecations here with a fixme comment that will serve the same purpose as
mentioned above. then i made some fields private to match the glibc definitions
and inlined some symbols on the target maintainer's request. then i reorganized
some commits so make the structure of the changes clearer. the one thing that
remains unanswered here is one function where we had been using link name
redirection until this pr. i removed the attribute annotation because that
redirect only exists when a certain feature test macro is not defined upstream,
and that one macro we assume is defined in quite a few places. i've had some
back and forth with the target maintainer but matters should hopefully clear up
soon.

finally, i starting looking through the open issues in the 1.0 release
milestone. the ones i've gone through either seem to (1) already have
in-progress work, (2) have been "abandoned" for some time in discussion, or (3)
have had some work done but there's been no news from the contributor in some
time. i've commented on the stale issues that i thought were fundamentally
already solved and have started looking into one pull request that's been open
for quite some time.

= Blockers
none at present.

= Plan for the week
as mentioned yesterday, today i would outline the roadmap for the second part of
the proposal. though there's not much to outline beyond the obvious; i'll
continue looking through the pr mentioned in today's summary and see how much
time that will take up. meanwhile, i will continue addressing feedback i get
from all other open prs.
