#import "../template.typ": *

#show: template.with([Daily report (2026-07-15)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
*Edit (one day after:)* I completely forgot to mention that one of the Fuchsia
target maintainers answered back on the Fuchsia PR and I've already reviewed the
changes and submitted them back. I also forgot to mention that the other issue I
had commented on concerning raw pointer mutability in a C function signature has
been put on halt while my mentor looks through the issue itself. The author has
already approved of my understanding.

Today efforts were centered around further reading through the issues and PRs
concerning MSRV compile-time and run-time checks in code, as well as `cfg`
predicate detection for target OS/libc versions.

The bulk of the work was to continue yesterday's research into prior art on RFCs
attempting to modify or add in some way a `cfg` predicate that would help with
target versioning. I've so far looked into RFC 3036, the comments on Zulip that
accompanied it and have since jumped to the more recent RFC 3750.

This latter RFC seems still open but there has not been any activity since
October 2025. I've not yet finished reading through the whole thread but I have
gone through a related RFC (3857) that attempted to establish a `cfg` for MSRV
checks. That one seemed to be going somewhere but the author decided against
continuing work due to time constraints. There is still an open PR that could
potentially improve the way not just this type of versioning `cfg` is handled,
but also the way any other `cfg` is used by providing a type to the values of
`cfg`s (e.g. providing a `version` type for certain predicates that would check
for supported MSRV or for the target OS's version.) That one I've yet to go
through, but I will prioritize finishing my read on RFC 3750, as these efforts
are not as tangential to our concerns in the libc crate.

Thus far, I believe the proposed changes in RFC 3750 are the best chance we have
at getting something nice working for our purposes in the libc crate. The
proposal presents a single new `cfg`, `target_version`, which would allow taking
some string such as `target_os` or `libc` and would subsequently check another
string following in its parameters against a set of possible values defined by
the target. This is far better than prior proposals where multiple `cfg`s where
added with the potential for extending those for OS-specific stuff (e.g. Windows
build version through a `min_windows_build_version` predicate.)

I've yet to read through the issue opened by my mentor specifically requesting
to the T-compiler team to change the OpenBSD target triples' `target_os` `cfg`
to something that would reflect the kernel version number. That would
potentially solve one of the biggest pain points, but ideally we'd have
something that would work on all current and future targets (who knows if some
other yet unsupported environment makes the same type of backwards- and
forwards-incompatible changes?)

Other issues I've commented on remain unanswered.

= Blockers
None at present.

= Plan for the week
I have considered again yesterday's goal for the week and I believe it could be
done my either tomorrow or the day after. That was to familiarize myself enough
with the current situation so as to know which efforts to push forward. I am
further lead to believe that RFC 3750 needs merging before if not immediately
after RFC 3905 (the one proposing typed `cfg`s.) This concern has also been
raised by other members of the community as target versioning is critical in
scenarios beyond those of checking for which APIs to bind.
