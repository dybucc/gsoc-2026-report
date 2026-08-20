#import "../template.typ": *

#show: template.with([Daily report (2026-06-18)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today efforts were centered around two things; Starting work on the BSDs and
fixing up a bunch of the currently open PRs.

Firstly, I started off by finishing the write up for the Android PR and opening
it up. The only thing that was left from yesterday was to link sources.

I then went on to work on the BSD module, where I was quite surprised to see
that most submodules already handle file offset and `time_t`-related
types/routines values nicely. The `apple` module is done, and I'm currently
looking into the `netbsd` module, where things also look quite good as well. I'm
not yet done with all of the supported target architectures, but so far those
modules I've looked into don't contain any file offset types nor `time_t` types
that would require changing. They already expose a 64-bit `off_t` by default and
they don't bind suffixed variants of that (and similar) type(s.) The same thing
applies for `time_t` stuff.

Halfway through the day, I got back from my mentor on a bunch of open PRs.
Regarding the constant deprecation and removal PRs, it seems the `libc` crate is
in the process of updating their SemVer guarantees. These guarantees, which are
yet prone to further changes, relax some of the regular Rust crate SemVer
guarantees, such that users may expect that, among others, records not marked as
non-exhaustive get new fields in what would be non-breaking SemVer releases (so
either a minor release or a fix.) This is to more easily adapt to upstream C
repos hosting the implementation, as things that would imply breakage in Rust
are not always the same as in C.

For constant deprecation, this means that instead of having those symbols be
deprecated and eventually removed in release 1.0, they should rather be
documented as possibly unstable. A small annotation to the upcoming usage
guidelines would seem to suffice in advising users of the `libc` crate about the
expectations they should set for those symbols.

I then went on to change all of the deprecation PRs so as to replace the
deprecation attribute annotation with a documentation comment indicating the
above. I expected this to possibly be something recurring in the future (future
revisions of the POSIX standard could add more pathname variable values or
runtime increasable values,) so I also added a macro for these types of item
declarations. That was submitted in a separate PR.

= Blockers
None at present. Testing on MIPS platforms with Linux uClibc is pending and
input would be very much welcome on setting up a cross-compilation toolchain for
this. Thus far, all efforts on this front have failed.

= Plan for the week
Unexpectedly, the `bsd` module, even though large, is quite well-behaved when it
comes to file offset and `time_t` types/routines. This means we could very well
end it by the end of the week, though the `freebsd` module remains unexplored
and that could have some surprises left for us. Either way, that still makes the
goal achievable. Tomorrow work will start by answering to the rest of the PRs I
got feedback on. Once that's done (and it should probably not take up the whole
day's worth of work,) I'll go back to looking through the `bsd` module. That
should leave at least two and a half days for it, which makes things quite
manageable. We could be moving to the `solaris` (and derivatives) module before
next week.
