#import "../template.typ": *

#show: template.with([Daily report (2026-07-25)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on two things; Solving a little something in the newlib
PR, and working on the Windows function pointer issues.

The newlib PR needed rebasing because recently one of the contributors that
commented on my PR submitted a new PR where some generic symbols that the `vita`
target previously used now had `vita`-specific defintions. This didn't require
much work.

I then went on to looking into the Windows function pointer issues. Most of the
stuff here seems clear at this point. I've now been looking into the Rust
Reference, which was the one thing that remained to be done before I potentially
reported a slight underspecification of the semantics behind `extern` blocks.
Following I provide some brief context.

Platforms like Windows behave a bit differently when linking against a DLL,
which itself requires what's called an import library. This library ensures the
symbols that some executable will use from the DLL are exported through what's
referred to in LLVM IR as storage class specifiers. This isn't so much a need as
it is a small optimization, because either way the executable will work. It just
so happens that if this annotation is present at compile time, you can skip a
double jump to get the target routine in the DLL. Now, the way this is
implemented is by having the first jump be to one of the Windows PE format's
header tables, called the \_Import Address Table\_. This contains a bunch of
information on the addresses of different symbols exposed from the DLL. You can
think of it as an array of address slots that only get resolved at runtime. Once
the program is mapped into memory, the loader switches pages to ensure those
address slots are filled in with the actual addresses of the DLL's exported
symbols.

In Rust, the Reference from latest `nightly` says the following under #link(
  "https://doc.rust-lang.org/nightly/reference/items/external-blocks.html#r-items.extern.attributes.link.empty-block",
)[items.extern.attributes.link.empty-block].

#html.blockquote[It is valid to add the link attribute on an empty extern block.
  You can use this to satisfy the linking requirements of extern blocks
  elsewhere in your code (including upstream crates) instead of adding the
  attribute to each extern block.]

This is not completely correct in cases like Windows. That's because the way
`rustc` (or LLVM, I'm not sure yet) lowers a call from a C function in an
`extern` block that has not specified the `#[link]` attribute with a dynamic
library kind, is by simply issuing a `call` instruction. This happens even if
there is another, separate `extern` block whose "linkage kind" has been
specified as `dylib`. See #link("https://rust.godbolt.org/z/f379YrhqM")[this]
for a minimal reproducible example. This doesn't happen when you start off by
already including that function within an `extern` block whose "linkage kind" is
`dylib`. The right jump to the IAT's pointer symbol (the symbol gets appended a
`__imp`) is used then.

So to sum it up; Including the `extern` block and bindings to routines in a
separate `extern` block is not equivalent to including the routines in the same
`extern` block. Though maybe this is not what the Rust Reference implies.

The solution I have so far thought about is to put up an issue in the
rust-lang/rust GitHub, and then follow up by researching both the `rustc` code
and the LLVM code. I've so far only gotten to the point where I'm looking
through open issues in GitHub to check I'm not opening up a new one. There's
about 500 from my filtered search, so that's taking a while.

Other issues I've looked into remain mostly unanswered. The MCP hasn't received
any new feedback.

= Blockers
None at present.

= Plan for the week
The MCP is still pending. The other PRs are also pending. That I can put on halt
for the time being as I focus on the Windows issues and ctest. The Windows
issues I believe I understand and the only thing that's left is to both spark
discussion in rust-lang/rust if there wasn't any precedent, and to start
researching why is it that these semantics are encoded this way. Ultimately, I
don't expect I will be submitting a PR changing code to `rustc` because it's
unlikely that this needs a fix beyond documentation in the Rust Reference.
