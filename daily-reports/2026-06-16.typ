#import "../template.typ": *

#show: template.with([Daily report (2026-06-16)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on finishing up work in the `unix/linux_like/{linux, l4re}`
modules.

The first task of the day consisted of ending my read through the glibc upstream
sources and ensuring I understood the way they made symbols (concerning file
offset types and `time_t`-adjacent types) available. This turned out to be
fairly straightforward because there were quite a few similarities with the way
it's handled in uClibc, as briefly mentioned yesterday.

The current set up in the `libc` crate does not require any modifications. There
is preexisting infrastructure to handle both file offset and `time_t`-related
types and routines. Removing the current `cfg`s in the crate and restructuring
stuff to always use 64-bit types by default has not been done. This follows from
the same decision in Linux musl with `time_t`. Input from Trevor Gross here
would be appreciated, as such change would likely require a fairly large patch,
and I am not sure if it is even needed.

The `linux_like/l4re` and (again) the `linux_like/linux_l4re_shared` modules
were reviewed afterwards. They did not require any changes regarding `time_t`
types and routines, but there were some suffixed variants of file offset types
that required being deprecated. This mostly meant going through the l4re-core
repo's vendored sources for their uClibc libc backend, verifying the same
changes previously applied to the Linux uClibc interface could be used here.
Luckily, that turned out to be the case, and a large amount of that patch
applied equally well to L4Re uClibc.

It was also found that the L4Re module exposes definitions for Aarch64 when
there are no supported target triples in upstream rustc that have that
configuration. Still, the maintainer seems to be currently working on getting to
work the current L4Re support in rustc, as that has been broken for some time.
That, and the fact L4Re also has a musl libc backend without bindings in the
`libc` crate, meant that it would likely be best to leave the module layout
untouched (at least for the time being.)

Testing on L4Re was not possible because of the afore mentioned issues in
upstream rustc. Testing on other platforms was not necessary beyond ensuring
uses of now deprecated items were either deprecated themselves or annotated with
an `allow(deprecated)`.

The PR write up is ready, but it has not yet been opened (it will be opened soon
after this report is sent or tomorrow.)

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this front have failed.

= Plan for the week
Work on the `unix` module seems to have taken some traction again. The only
module left in the `linux_like` submodule is `android`. I expect that to take up
at most two or three days, considering there is already CI infra ready to test
most child modules definitions (if changes end up being necessary.) By the end
of the week, it would also be great to have finished with the `unix/bsd` module.
Still, that has quite a few populated submodules, so it's likely that I will
only start off work on it and finish up in next week.
