#import "../template.typ": *

#show: template.with([Daily report (2026-08-03)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has centered mostly on answering to PR reviews I had received. I've
also worked on the patch for a new issue.

I kicked off the day by going through some comments. A bunch of PRs got merged,
which is great. The Fuchsia PR needed a little tweak to extend the functionlity
of a macro we use to both declare and annotate data structures.

This was fairly simple to do because I had already come up with two possible
solutions three weeks ago. I, of course, went for the simplest one (which meant
the complexity of the macro subtrees is kept intact.)

The PR for getting rid of `union`s has been merged but will not reach the next
stable release in full. Most of the patchset is going to be there, but there's
some patches that we didn't backport on Linux either. Those won't be backported.

The Android `ioctl` issue thread has also received some attention. The original
poster surprisingly still answered back (even after having been dormant for 7
years.)

The solution seems fairly clear, though to some extent, it relies on praying
upstream doesn't break stuff. The short version is that `ioctl` takes a
pre-defined set of constants for which there's (mostly) no defined semantics.

Some platforms decide they're going to extend the bitwidth of the argument
taking this request constant from 32 bits wide to 64 bits wide. Now, nobody
quite knows whether some driver implementor is using the full 64 bits.

According to POSIX and the Linux manpages, it should be 32 bits. So we just pray
no driver implementor used a 64-bit constant and call it a day. Of course, this
is still pending review from the Android target maintainer.

The only thing we might do is to switch the signedness of the integer that we
take in the `ioctl` call. This would sort of be halfway through the standard
(`c_int`) and the non-standard but common (`c_ulong`) behavior.

Next I answered to the PR that I had rebased to latest `main` and tweaked some
yesterday. That one had been inactive for a few months so I thought I'd pick it
up and resolve the issue it targeted.

The author answered back that they actually intended on finishing it all up, so
I just provided some humble advice on some changes I made, and called it. It's
mostly concerned with incosistencies between C function pointers and Rust.

Finally, I looked into a new issue that has been open for seven years and tries
to find some workaround for the fact we often break ABI by adding fields (at the
same pace as upstream.)

These days, we have the new usage guidelines, which cover the fact our SemVer
stability commitment is unlike that of other crates in the Rust ecosystem.
There's a newer issue tracking the use of `non_exhaustive` in all of our types.

I commented on the newer one whether we were still looking out to annotate most
of our types with this attribute. In case we do, then I also started looking
into implementing that. I believe I got it right.

We use a macro to declare all our types except type aliases. This is to ensure
we have them all deriving the right traits under the right feature flags. To add
this new `non_exhaustive` annotation, we also need to provide a way to opt out.

This is in the form of a non-existent attribute, `not_non_exhaustive`, that we
detect by recursing through the macro subtree while keeping a packed matcher of
prior attributes.

This works a bit like recursively destructuring a list in OCaml, where the cons
operator gets you the head and tail of the list. In our case, we recursively
extract one attribute at a time from the initially packed set of attributes.

Eventually, we reach the base case in one of the subtrees, where there's no more
attributes to be parsed. At this point, we apply all of the attributes (if any)
that we kept in the other packed matcher.

All through this, if we ever detect (through another subtree) that the "head"
macro we extracted from the input packed matcher is `not_non_exhaustive`, we
switch to recursing with a slightly different subtree.

This alternative subtree does the same things, but keeps a different literal
matcher that eventually converges to a different base case. This base case
expands to the input item with `non_exhaustive` annotated on it.

The Windows function pointer issue thread remains silent. Other issues I've
commented on also remain silent. The MCP has entered FCP, and I guess that means
I'm meant to wait for further comments.

= Blockers
None at present.

= Plan for the week
The MCP should be ready to receive an implementation in 10 days time. I've
already gone through it so I don't expect it to be complex in any way. The issue
I tackled today concerning the macro is mostly done.

The only thing left is to extend this logic to other variants of the same macro.
I don't anticipate this to be complex at all, because the macro I worked on
today is barely any different than those.

Beyond that, I'll just keep looking through other issues and
answering/commenting on issues and stale PRs. This includes older pending PRs.
