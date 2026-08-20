#import "../template.typ": *

#show: template.with([Daily report (2026-07-19)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on solving a few questions that remained in the MCP which
I believed I could solve myself. The GNU/Hurd PR is also ready and the target
maintainer has given his stamp of approval.

I started off by thinking twice about the proposal. Surely if we're aiming to
add the values of the OpenBSD OS+libc version to their `target_env` `cfg`, this
`cfg` must be different across versions of `rustc`. So I started (and finished)
reading through the high-level overview of the compiler and relevant sections
during parsing in the first stages explained on the `rustc` development guide.
I've so far not concluded anything new beyond the fact that it probably does
have different `cfg` values for supported targets. This is pending looking a bit
further into it, but something tells me the answer is obvious and I only have to
find it.

Now, it could be that some user happens to change those `cfg` values by
providing a JSON spec of their own (which is very much possible, considering the
OpenBSD targets are tier 3.) I couldn't find a way around this and decided I
would simply mention it in the MCP.

I was also worried about the possibility some new OpenBSD release dropped
support for an architecture; Should we then drop Rust support as well or should
this target continue being supported with an older `rustc`? Soon after writing
those thoughts down, I realized it was idiotic to consider this; The target
maintainers would know best, and whether upstream continues to support some ISA
or not is completely irrelevant to us. The MCP is aimed at getting some
versioning support in C bindings, which could very well support upstream
unsupported targets (with a predicate matching whichever version the target
maintainers believe works with Rust.)

Concerning the GNU/Hurd PR, it seems done from the target maintainer's comments.
Still, I noticed that they mentioned they had run the `rustc` test suite against
my changes to `libc`, but I digressed in that the `libc-test` test suite was
likely a better fit. Considering `rustc` is more of a regular consumer of the
crate, I don't think their tests are as exhaustive as those we have in-house.

Other issues I've commented on remain unanswered.

= Blockers
None at present.

= Plan for the week
The plan continues as expected. The few things I needed to find out to solve all
of my doubts around the MCP are mostly solved. The only thing that remains is to
figure out whether different `rustc` versions will report different `cfg`s for
supported targets. I've not yet found information on this but something tells me
it's really obvious and I just haven't caught up yet; Still, I'd prefer not to
ask anybody directly. Once that is done, I will open the MCP, and post a comment
on MCP 916 mentioning that this new proposal is likely to replace the older one
as a follow up.
