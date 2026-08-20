#import "../template.typ": *

#show: template.with([Daily report (2026-05-17)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was mostly focused on getting something implemented to fix
yesterday's issue with constants not having their spans correctly updated when
saving to disk. This has eventually lead to rethinking the whole approach to
performing the roundtrip from loading a file to memory, parsing it, and then
saving it back to disk.

Initially, some further test runs lead me to believe that just unparsing the
`syn::File` and saving it to disk would be insufficient. This was due to the
fact the way these files get parsed onto memory discards a large amount of
information that is source-irrelevant, like comments and whitespace. To this we
must add the already buggy behavior where constants were not having their spans
updated when a deprecation attribute was added to them while saving to disk.
Ensuring they were would require rerunning the `syn` parsing utilities over the
saved file to get the updated spans, so I decided I could as well improve the
whole pipeline.

Because the tool I'm developping is meant to seamlessly integrate with the
actual `libc` codebase, just saving to disk the `Display` implementation of the
resulting `TokenStream` doesn't do it. Back when I was implementing the initial
version of the core library, I had only thought of keeping whitespace as best as
the `prettyplease` library could keep it, but had completely forgot about
comments. That is why today I first attempted to develop a replacement parser
solely for constant items and the `cfg_if` macro in hopes of replacing `syn`. Of
course, soon enough I realized that was not going to work out because even
though we only parse items and macro invocations at the module scope level, we
also require parsing attributes (more specifically, ensuring that we either
already have a deprecated item or not.) From that point on, I decided to keep
the part of the core libary that parses from disk on entry, and to only
implement a replacement parser that used `syn` in certain areas of the code
(like attributes.) This should allow me to have more control over how does the
output file we save to disk look, as the parser should keep a mutable view over
the byte slice of the file. Then it would parse the contents with `syn`'s help;
We still parse the byte slice into a `File`, but we don't convert that back to a
string and use `prettyplease`. Instead, we go through each of the module items
and macro invocations that have been parsed and provide a mutable view into the
parsed `ItemConst`s. Then, because each of those items also keeps track of the
start and end spans, a formatter type fetches each of those `ItemConst` and
`ItemMacro` after having been modified through the externally sourced closure,
and manually creates a byte vector to replace the start and end spans of the
item prior to modification. This then gets inserted to the output byte vector
that is saved to disk.

Though all of this is mostly just talk, as no work whatsoever has gone into
incorporating it into the codebase. Instead, I started to work on a separate
binary (akin to working in Godbolt in C/C++) to have less overhead from the
entire project as I first tried things out. I first had to figure out whether
spans were updated internally by the `syn` data structures, to then see whether
my plan was feasible. At present, I have uploaded a GitHub Gist with that
isolated work #link(
  "https://gist.github.com/dybucc/0eaeb1ad18c6ddc1795b8b80ecccab13",
)[here].

The PRs got rebased.

= Blockers
None at present.

= Plan for the week
Then again, I have to extend anew the time I have to allot to fixing the issue
with saving constants to disk. This means it will likely take me two more days
to implement everything and test it out. Beyond that, scrolling should come up
next, and then including the path of the parsed constants on the filter list.
The issue with saving to disk can't be left for later, as it's literally the one
thing that must work as best as I can make it work. This means preserving as
much formatting from the codebase as possible, especially inside the `cfg_if`
body, where runnning `rustfmt` afterwards won't work. Considering the "coding
period" starts next week, and from that point on I have one week to finish up
this tool, I still believe I can finish this part of my proposal on time.
