#import "../template.typ": *

#show: template.with([Daily report (2026-07-11)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today work has cenetred around three things.

- tweaking the aix pr after i got confirmation on some changes from the target
  maintainer.

- pushign some last commits into the nuttx pr.

- working on a new issue for the 1.0 release.

the aix pr is pretty much done. the target maintainer mentioned that they didn't
mind the changes but that they would like to keep the aix/powerpc64 module. with
that in mind, i moved all of the changes concerning the powerpc64 module and the
module itself back into the powerpc64 child module. this took a bit longer than
expected because i also decided to further split the changes that were initially
included in that one patch.

the nuttx pr didn't need any more work. the target maintainer approved the
changes and i pushed some commits i had fixed from prior feedback.

the new issue i've tackled today is concerned with a symbol conflict in the
freebsd header files. as it turns out, freebsd has some "constants" which are
repeated between header files. of course, when we reexport these symbols in the
libc crate we get item resolution errors. the solution was already proposed a
few years back but that pr has since not had much activity. that changed three
weeks ago when a libc maintainer picked it back up and proposed a roadmap that
should hopefully smooth things out.

to sum it up, we should provide the "older" bindings under the new module (which
is meant to eventually replace the root module organization.) these are
reexported at the crate root. then we add (also in the new module) a submodule
with the "newer" bindings. these are then not reexported, but rather provided as
a public submodule. whoever is worried about this downstream will eventually
notice it and once we're past the 1.0 release, we can break everybody's code by
removing the reexport to the older bindings. some time later the newer bindings
would start being reexported instead.

i've finished rebasing (also solving conflicts) and tweaking some stuff from the
pr that was opened a few years ago for the first part; namely, the one
concerning the older bindings. i've also solved the conflicts for the other pr
that was opened to more specifically address the newer bindings, but i've yet to
finish touching up some stuff before it's ready to be merged.

other issues i commented on yesterday remain unanswered.

= Blockers
none at present.

= Plan for the week
i believe i will have finished work with the second pr tomorrow. that shouldn't
take long and i will be done early. beyond that, and assuming there's no new
feedback on already open prs, i'll start looking into other 1.0 release issues.
