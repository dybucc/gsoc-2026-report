#import "../template.typ": *

#show: template.with([Daily report (2026-06-17)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around finishing up the `unix/linux_like/android`
module.

Efforts started out with `time_t`-related types and routines. As it turns out,
the `android` module already handles this well. There were no suffixed types
that had equivalent definitions to their unsuffixed types; Whenever there were
some differences, it was due to actual memory representation variations between
the types exposed in targets with a 32-bit ABI, and targets with a 64-bit ABI.

Work then went on to file offset types. In this case, the same thing applied
(for the most part.) Apparently, Android defines aliases irrespective of feature
test macro availability. The definitions are useful and somewhat wrong in some
of their older API versions for platforms with a 32-bit ABI. Otherwise, they
explicitly mention that all 64-suffixed symbols are mere aliases.

This is exactly the type of thing we want to deprecate in the `libc` crate.

So they got deprecated. There's not much else to comment here; Just plumbing
work and a ton of code searches across upstream repos trying to make sense of
the monorepo structure that the Android developers have set up. After a bunch of
failing tests, and finally realizing there was this one file deep in one of
their worktrees where my new definition for a type was proven wrong, CI finally
passed. Fortunately enough, there are already targets set up in the `libc`'s' CI
infra for both the 32-bit and the 64-bit ABIs. There was no need to test on
specific targets because no changes were narrowly aimed at, say, Android with
RISC-V64 as its target architecture.

The write up for the PR is done (mostly because it's just as short as today's
report.) The only thing left is to finish annotating the list of sources
reflecting the aliasing upstream for which certain types have been deprecated in
the `libc` crate, and the PR should be ready.

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this front have failed.

= Plan for the week
Today's task was finished earlier than expected, as yesterday it was planned for
the `android` module to take up at least two days. This is great news, because
that means work on the `bsd` module will start eariler and that's a large one.
If all things go well, the PR for android should be opened early tomorrow, and
if things go really well, we may even finish with the BSDs before the end of the
week. In all honesty, the earlier the deprecation work is ready, the better.
This was the last well defined goal of the proposal, and that just means I may
even get some non-plumbing work into my contributions. There's also the fact
most of the open PRs have barely gotten any feeback just yet, and may very well
require non-trivial changes. As per the usual, we'll see.
