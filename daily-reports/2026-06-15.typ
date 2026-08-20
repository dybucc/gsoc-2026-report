#import "../template.typ": *

#show: template.with([Daily report (2026-06-15)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on three main areas; Reviewing the file offset patch for
Linux musl, rebasing currently open PRs to latest `main`, and starting off work
on Linux glibc.

The bulk of it was really the file offset patch. The changes that had been
committed last week were just fine, but did not cover any file offset types
beyond `off_t`. That meant going through all of upstream musl's occurrences of
the `_LARGEFILE64_SOURCE` feature test macro, to deprecate all LFS64 types and
routines.

The decision here was the same as in prior modules; Prepare the removal of all
suffixed symbols and ensure the one and only unsuffixed symbol prevails. This
holds pretty well in musl because their unsuffixed types are already 64-bits
wide, and it is their suffixed variants that are defined as aliases to the
unsuffixed ones.

Beyond that, work went into ensuring this did not cause any issues by testing
out in both QEMU and CI, which went well. After that, a little write up with the
changes and a reference regex search to look up in upstream to check if these
changes were correct did the trick. Another PR will likely be opened later on
once feedback is provided on this one including full removal of the symbols. For
now, only types and the `musl/lfs64` module have been deprecated.

Once that was done, I received a merge conflict notification from rustbot on one
of the currently open PRs, and decided I'd rebase them all. That's just (even
more) plumbing work so I won't go into any details on it.

Finally, I moved past the `musl` module into the `linux/glib` module. So far, no
changes to the `libc` crate have been made as I'm still grokking upstream code.
From what I can gather, the way they handle both file offset types and `time_t`
is very much like uClibc. That does not come as a surprise, as the latter's
sources seemed to be a fork of glibc's. They both use the same feature test
macros to expose LFS64 types and routines, and to expose those by default. The
only difference seems to be in the makefile configuration scripts to make those
`#define`s available. In uClibc they had a fairly straightforward "toggle" but
in glibc they don't seem to expose the possibility to configure LFS64 symbol
availability. They do have, though, a configuration option to ensure the
`__USE_FILE_OFFSET` feature test macro is *not* defined. We'll see about that
tomorrow.

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this front have failed.

= Plan for the week
The first task of the week regarding the Linux musl file offset PR has been
completed. The rest of the week is likely to follow the same pattern as the last
two weeks; Namely, go through the rest of the `unix` submodules and check the
way upstream handles 64-bit file offset types and `time_t`. If any changes are
required, a patch will be prepared. Though unlike last week, if testing on some
platform takes more than two days, that's a hard cap for the platform, and the
PR will be opened as a draft. This will be the case irrespective of progress in
the allotted time span.
