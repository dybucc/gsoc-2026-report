#import "../template.typ": *

#show: template.with([Daily report (2026-07-23)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has centered around four things. I've taken special care of
annotating what I do throughout the day to avoid what happened in yesterday's
report.

- Reviewing the Fuchsia PR.
- Reviewing the GNU/Hurd PR.
- Reviewing the newlib PR.
- Studying the Windows function pointer mismatch issues.

The Fuchsia PR needed a little tweak that I had forgotten to address in the last
two days. It's only concerned with having `ssize_t`, which I made a `c_long`, go
back to being an `isize`. This is because even though it's a `c_long` upstream
(all supportred Fuchsia targets follow LP64,) it's best if we leave it as is;
The effective bit width is the same.

The GNU/Hurd PR is mostly done. I already mentioned a few days ago that the
target maintainer had approved the changes. The only thing that remained was for
me to answer to some concerns my mentor had with the `glob` family of library
functions. Those now conditionally redirect to different symbols, because that's
the way it is in glibc. In this patchset, though, there are no changes
concerning `time_t` or records that use `time_t`. That's because `glob_t` and
`glob64_t` are effectively equivalent in our bindings. The fields that differ
upstream are function pointers directly or indirectly involved with `time_t`. Of
course, this means there's bound to be different behavior if the user's got the
time64 feature test macros and corresponding `cfg` set. But that doesn't apply
here because those fields of `glob_t` and `glob64_t` (which are the types that
the `glob` function family takes in) are private and declared as `*mut c_void`
in our bindings.

The newlib PR didn't need much attention either. I got back from my mentor in
answer to yesterday's small fix. They've put up a script that should make
checking if some target builds easier.

Then comes the Windows function pointer issues. This was by far the highlight of
the day. Two contributors chipped in and provided a fairly good explanation on
why function pointers were comparing unequal between linked C functions in Rust
and actual C. I decided I would use this chance to read through a bunch of the
Microsof docs and some random folks' findings on the inner workings of Windows
executable files to study this a bit more. As it turns out, image files (the way
Microsoft refers to what we'd call executable object files/modules in ELF) have
a set of addressing tables in the PE header (which is much like the ELF program
header.) One of these tables is called the Import Address Table, and is used to
have one centralized place from which the loader can switch pages at runtime to
provide resolved addresses for external DLL symbols. When you call some function
from an external DLL (and assuming you're not compiling with a certain
optimization option that makes MSVC behave much like `rustc` with a single
codegen unit,) this function gets replaced by the linker with an assembly thunk
that performs a jump to a slot in the Import Address Table. The linker doesn't
have the slightest idea about the address of a symbol in an external DLL, so it
resources to having that be determined at runtime. Then the loader fills in that
slot of the Import Address Table with the resolved (exported) function from the
external DLL. And so you end up with two jumps to call a function. Well, to
avoid this, Microsoft allows you to annotate with an attribute the function that
will be imported in the DLL (not the main executable) so that the compiler can
already lower that to assembly that jumps straight into the Import Address
Table. The details of this last part I'm still not entirely sure of, so take
this with a grain of salt.

In Rust, the problem comes from the type of library we're linking to through the
`extern` block. Without any `#[link]` directives, the `extern` block just
defaults to having any call to this routine in Rust code be a call to a static
function. When you annotate such block with `#[link]` (and don't add the type of
library you're linking against) this gets resolved to linking with a dynamic
library. Then and only then, do we get the right jumps to the dllimport thunk
that eventually gets us to the IAT slot and thus to the external DLL's function.

This I only learned today, so I could very well be corrected or find out
something new in the next few days.

This has prompted some discussion about the semantics that Rust implicitly
encodes in the assembly calls that it makes on `extern` blocks that are not
annotated with a `#[link]` attribute. But that is only preliminary.

Other issues I've commented on remain mostly unanswered. The PR I would be
taking over is still pending.

= Blockers
None at present.

= Plan for the week
The MCP hasn't received any new comments today so that's allowed me to work on
the rest of the PRs that were pending and to finally get my hands dirty with the
Windows function pointer issues. The plan for the rest of the week is to post
the updated PR for the stale PR I took over with, and to potentially have the
Windows issue resolved.
