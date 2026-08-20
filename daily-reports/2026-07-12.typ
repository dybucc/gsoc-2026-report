#import "../template.typ": *

#show: template.with([Daily report (2026-07-12)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today work was centered around three things.

- finishing up work on yesterday's pr.
- starting and finishing up work on a new 1.0 pr.
- starting work on another 1.0 pr.

work on yesterday's two prs addressing a long standing item resolution conflict
is done. the first pr only needed some rebasing and restructuring the module
contents to have the bindings be moved to the new module. that i finished
yesterday. the second pr needed the same treatment. these patchsets have not
been submitted as new prs but rather they've been linked through comments on the
existing (old) prs. this is because i'm not sure if the original author intends
on finishing up work.

then i moved on to another old pr that had been stale for some time. this one
was about an api addition to targets using musl as their libc implementations.
the symbol being added was only available on versions of musl greater than or
equal to 1.2. support for this musl version had been added last year but this pr
had for some reason not yet been merged. beyond rebasing (this time without
conflicts,) it needed some work to pass tests. at present, we still have tests
running on ci that use older musl versions, so the semver tests we run to ensure
a set of listed symbols remains available across releases needed skipping this
one symbol. that's done now and much like the above pr, a comment was left
mentioning that work has been continued and possibly finished.

finally, i started looking through another pr that solves some tcp/ip address
family constants (really macros) being declared as being C ints in our codebase,
when they're really "used as" sa\_family\_t types. a pr was opened some time ago
for this but has not had much activity and has had pending merge conflicts for a
few weeks. i'm currently ensuring all platforms where this was changed actually
comply by the POSIX definition. if so, then i'll just rebase, solve the
conflicts, and comment on the pr again.

i also commented on a newly opened issue addressing potential undefined behavior
from a certain c library function accepting a const raw pointer but returning a
mutable raw pointer that aliases a part of the same allocation as the former.
the issue description proposed changing the input parameter to be a mutable raw
pointer instead, because folks could very well cast a shared reference into a
const raw pointer to the c routine, which would possibly create aliasing issues
with the mutable output pointer that refers to the same underlying allocation.
this contradicts the c function signature and further encodes a (small) safety
guarantee on the bindings the crate provides (one can still cast from a shared
reference to a const pointer and then to mutable pointer, but they're likely to
think twice about that.) i believe the implicit contract in using unsafe c
bindings is that one must read relevant documentation (e.g. manpages) to
correclty use any of the routines we bind to. we should in no way attempt to
improve possibly unsound aliasing assumptions in c. that's work for higher-level
crates.

other issues i've commented on remain unanswered.

= Blockers
none at present.

= Plan for the week
work continues as expected. the new pr i'm addressing should be done tomorrow.
it may take a bit to go through all affected targets' upstream definitions but i
believe it's worth it. once that is done, i'll move on to another issue/stale
pr. which one i will address next is not something i plan for.
