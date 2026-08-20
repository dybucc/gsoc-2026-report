#import "../template.typ": *

#show: template.with([Daily report (2026-07-09)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today work was centered around four things.

- reviewing feedback i got on the nuttx pr.
- reviewing feedback i got on the aix pr.
- changing some stuff about the linux musl pr.
- reviewing feedback i got on the linux uclibc pr.

the nuttx pr didn't need much attention. the target maintainer had asked another
question on a change i had made to a type alias definition. i believe the change
need not be reverted as it more closely replicates upstream in that it uses
(non-fixed-width) c types and not fixed-width integer types.

the aix pr needed more work. following yesterday's plan, i removed a large
amount of api additions. this thinned it down quite a bit and left only the
fixes. then i commented on some feedback i had gotten about the new cfg for
aix's lfs api. other prs have had the deprecations replaced for fixme comments.
this follows the new multi-stage plan for the 64-bit time\_t and file offset
transition outlined by my mentor. we're currently on stage 2, which really means
we're not meant to deprecate these bindings just yet. the thing with the cfg i
added on aix is that the now cfg-gated types need to be different (and thus the
cfg can't be replaced with a fixme comment for 1.0;) under no circumstances are
they equivalent.

following the now clearer plan to annotate with comments and not deprecate, i
reviewed the linux musl pr (which i had to do anyway because of recent merge
conflicts.)

i also answered some questions on my changes in the uclibc pr and rebased to
latest main (because there were merge conflicts.) i haven't yet gotten back to
commenting on all feedback i've received.

= Blockers
none at present.

= Plan for the week
today i ended up still not starting work on the second part of the proposal. no
matter. i've reviewed a bunch of prs, and should probably have the linux uclibc
review ready by tomorrow. then i can start with the second part of the proposal.
if and once that happens, i'll further comment on the roadmap for that.
