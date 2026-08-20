#import "../template.typ": *

#show: template.with([Daily report (2026-07-14)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
today efforts were centered around two things.

- finishing up my read on the long thread discussing backwards-incompatible
  changes in upstream oss and whatnot.

- further advancing the discussion about the safety guarantees of mutable
  pointers in certain C functions we bind to.

after finally reading through through the entire thread and related PRs, i
eventually reached another issue where the msrv policy for libc was being
discussed. this turned out to be quite a long-running discussion that by 2024
didn't quite have anything fruitful to show beyond the msrv option in cargo's
manifest file.

the issue had attempted, though, to push forward a number of rfcs and even
implementations for a cfg predicate that would allow checking both the msrv of
the crate and the version of the sdk to which the libc provides bindings. this
didn't quite span out in most cases, even after multiple rfcs were opened, some
of which were only trimming things down.

in theory, solving the msrv issue in libc to allow as much reasonable
compatibility with downstream crates should also provide a way of fetching a
predicate for the target sdk's version. there's an rfc that seems stale but
still open, and two rfcs that seem to have move forward. of the latter, one is
fairly old and got to the implementation stage to check only for the rust msrv
in the crate itself. the latter rfc, though, proposes a more general approach to
a new type of predicate that would allow version checks. this is mentioned to be
extensible to the usecase concerning target os versions. to be honest, it's not
been touched in a few months, but i've yet to read through that pr's comments.

finally, there's also an issue open only targetting the openbsd targets (which
were the ones that had the most backwards- and forwards-compatibility issues
when posed against the libc crate's guarantees.) this proposes to simply change
those target triples to also include the version number of the os in the
target\_os predicate. i've not yet read through that one's comments, though, but
it's still open so i'll have to look there as well.

concerning the discussion on the recently opened issue for c memory search
functions, i believe great progress has been made. i read through the latest
drafts for all C standards from C89 through C23, and realized that this family
of functions had only recently gotten its semantics more accurately described.
the C standard now mentions that this routine is meant to return a pointer to a
const-qualified type iff it takes a pointer to a const-qualified byte array, and
otherwise return a pointer to non-const-qualified type.

achieving this is not specified by the spec and that's awful news for both C and
Rust. glibc has a neat implementation for C++ because they have operator
overloading and that works out just fine with the above semantics. the problem
comes with C. the function is exposed as taking a pointer to const and returning
a pointer (to non-const.) the user is then expected to understand that if they
passed a pointer to const and they really did not have access to an exclusive
alias prior to that, then they better not mutate the output of the routine. of
course, this is very much akin to a binding contract in Rust unsafe code, except
i doubt there's many folks who've read up on the latest C spec. i've proposed a
solution for this in the issue, but i won't go into any details here because i
have no time.

other issues i've commented on remain unanswered.

= Blockers
none at present.

= Plan for the week
as mentioned yesterday, the issue i started looking into yesterday will be a
long-running one. i doubt i'll be done with it by the end of the week because
there's likely to be more conversations with the people that are still involved
in the prs and open rfcs. i also haven't finished reading through all relevant
material, so there's that. still, the expected outcome of this week is to have a
fairly decent overview of everything that's done so far to see in which way
should things be pushed forward.
