#import "../template.typ": *

#show: template.with([Daily report (2026-07-17)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work went on to focus on only one thing; Taking notes on my readings thus
far and preparing an MCP for OpenBSD targets to include their OS+libc version in
the `target_env` `cfg`. Other minor tasks are detailed last.

This has been met with decent success in that I've finished taking most notes
and I've discarded multiple alternatives to the `target_env` solution. To sum it
up, RFCs 3750 and 3905 continue being the ones that can make it the easiest for
us but that will likely take multiple years to land on `libc` due to our MSRV
policy. I instead attempted to see whether prior (accepted) RFCs could fit our
purpose. I read through RFC 3716 but soon realized that (1) there does not seem
to be a simple way of exposing this to crate authors beyond command line flags,
and (2) the purpose of that RFC seems to be aimed towards something like
`target_feature`, which exposes architecture-specific features rather than OS
versioning. Granted, the RFC attempts to avoid unsoundness issues from ABI
differences due to the use of certain conflicting features, but I don't think
that's enough of a reason to have OS versioning be added as a target modifier
(the internal name for these flags proposed in the RFC.)

The most viable solution seems to simply go for a `target_env` override every
six months, which should align with the OpenBSD release cadence. This would add
some overhead to the target maintainer(s) but should hopefully be an automatable
task. This also happened to be the last solution proposed in the Zulip thread
for MCP 916 and is the one alternative that T-compiler seems to has some
confidence in if it gets pushed forward.

Today I also commented on some feedback the GNU/Hurd PR had gotten and have
since made some small changes to it. These were fairly surprising to me, as I
had previously thought we generally assumed users to have `#define`d
`_GNU_SOURCE`. This macro and a few others actually gate an alternative
non-POSIX compliant version of the `strerror_r` function, but apparently (even
though the bindings initially indicatd otherwise) it's preferable that the
GNU/Hurd bindings are as close as possible to what "the rest of the world does."

I also got an update on yesterday's AIX tests. The patchset I had submitted
worked out just fine and the only errors that remain are the sort that we would
have skipped on CI if AIX were a tier 1/2 target.

Other issues I've commented on remain unanswered.

= Blockers
None at present.

= Plan for the week
The plan is now clear. I've read through my mentor's answer and have formulated
what I believe should provide a short-term solution for #link(
  "https://github.com/rust-lang/libc/issues/570",
)[rust-lang/libc\#570]. The MCP I will open in the next few days should attempt
to address the need for `target_env` in OpenBSD targets to reflect the
`Major.minor` versioning scheme alongside (possibly) the OS name. Once that is
done, I may look into RFC 3750 again and ping all participants to see whether
something needs pushing for this to at least reach nightly. Hopefully, the
former approach will solve the above issue's original author's concerns, while
the latter should maybe provide a better long-term solution to other targets.
