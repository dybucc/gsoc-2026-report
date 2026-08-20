#import "../template.typ": *

#show: template.with([Daily report (2026-06-26)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on more PR reviews. Testing attempts on Fuchsia have also
resumed.

The Windows PRs seem solved. The PR concerning linking the right routines is
done. That one needed some reorganizing. I just cherry picked a custom patch
over one of the commits and applied it to the other Windows PR. This other PR
also seems done. It needed simplifying some code in the build script.

The Fuchsia PR also seems done. Small fixes were needed. Some polyfills for C
macros were exposing implementation details. That's fixed. Then a bunch of
fields were public when they probably shouldn't. You can't really tell in C
without opaque types so we're taking a guess here. The only other thing left is
to test the changes out. That's what I've started doing.

Testing on Fuchsia seems straightforward with FEMU. FEMU is their fork of QEMU.
The Rust _Platform Support_ page has instructions on the expected package
format. It should hopefully be simple. This is a WIP.

The newlib PR got some modifications. The `aarch64` module got removed. There's
just no supported Rust target with that triple combination. Other changes
include being more stringent in the type definitions. Conditionally defined file
offset types now give a compilation error if the target is not supported.

Work on the `aix` module is pending.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

Today the report has been submitted earlier than usual. I've got some stuff to
deal with later on.

= Plan for the week
The expected timeline is being met. The `unix` module is almost done. All PRs
concerned with this are also almost done. The Windows PRs are right around the
corner. Reviews are mostly done. The one pain point is the Linux uClibc PR.
Hopefully that gets resolved soon. The `aix` module and other child modules to
the `unix` module should be done by next week. The hard cap in the proposal was
week 7. Things look well. But something's surely bound to come up.
