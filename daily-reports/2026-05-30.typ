#import "../template.typ": *

#show: template.with([Daily report (2026-05-30)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on finishing up work on constant deprecation. I've already
covered all of the constants I had in mind; All `*MAX` constants, as well as all
`*NUM` constants.

Yesterday's efforts on the former group has finally culminated in a final PR
(meaning it stopped being a draft PR.) This meant a bunch more research into
both kernel and standard library implementation source code, though I won't go
into any details in this report. See #link(
  "https://github.com/rust-lang/libc/issues/5122",
)[rust-lang/libc\#5122] for notes on each and every constant (or set of
constants). Of note is that I couldn't get my hands on the QNX Neutrino SDK so I
could not have a look into the header files for that one target. I did get to
deprecate the constants that I realized matched those values POSIX defines as
non-runtime invariant.

The latter group of constants was fairly easy to go through. I did short work of
it, and another PR with those batched changes is ready.

At this point, I would like to ask for some input by Trevor Gross, as I believe
I have went through most if not all constants with an immediately obvious
SemVer-breakage issue.

= Blockers
None at present.

= Plan for the week
This week's goal has been met, and I've even gotten to finish up what I expected
would take me all of next week. This does not mean that I can just move on to
the next part of the proposal, but it does mean I can start work on it. I
believe next week I will get some response back from other `libc` maintainers on
comments I made across the different PRs I submitted concerned with deprecation
work. Either way, I will start working on the bit-width transition issues again
starting tomorrow (following from the changes I already made prior to GSoC.)
