#import "../template.typ": *

#show: template.with([Daily report (2026-05-31)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we worked on getting some work done on the type bit-width side, and on
fixing up some of the currently open PRs targetting deprecation of constants.

After finishing up with the constant deprecation yesterday, I started looking
again into the bit-width transitioning issues with time and file offset types.
On Windows, the currently open PRs are still on halt as I await a response from
my mentor. On other platforms, though, work is still pending. That's why I kept
going through all target OSs we declare at the top-level of the `libc` crate,
after Windows. So far, I believe I'm done with Fuchsia and VxWorks. The former
required some discussion and is still very much an open question whether
deprecation of the `off64_t` type should actually move forward. I won't go into
the details because I already prepared a write up on the PR description, so look
into that if you're interested. On VxWorks, though, things were fairly simple.
The definitions between `off64_t` and `off_t` were straightforward to work
through in their header files, and there were no conflicts with other
symbols/routines using the suffixed variant (now deprecated.) There was, though,
one thing to note about the way the bit-width of that one type is handled when
the operating system is operating in either one of an RTP (Real Time Process
running in user land) or in kernel mode. Though then again, see the
corresponding PR for details. I haven't mentioned the `time_t` type on none of
the above two target OSs because they already define only a single 64-bit
`time_t`.

All through this, I realized I could also submit another PR that more smoothly
allowed users to use the nightly features required in the `libc` crate. I
realized this was a bit of a pain point while solving the style checks on CI in
my open PRs, where a stable `rustfmt` would not recognize the unstable
configuration options used in `libc`'s `.rustfmt.toml` file. This meant a user
was either required to manually configure an override with `rustup` or otherwise
just have the nightly toolchain as their default. The patch I submitted included
a `rust-toolchain.toml` file that would do that "automatically" (with manual
intervention if some component like `rustfmt` was not installed) as `rustup`
will just read that and use the right version. This required some changes in CI
because this takes priority over setting the default toolchain in the current
Rust install scripts, but I believe to have also solved that with some other
changes (CI passes, but we'll see.)

Finally, I got back from one of the regular contributors/maintainers to the
`libc` crate on one of my open PRs, and realized I had idiotically deprecated
constants starting on `1.0.0`. This meant the lint would not trigger until that
version was reached in the crate release, which is, of course, not ideal because
we're trying to move all library users out of deprecated behavior before
removing it altogether in the 1.0 release. That got solved, and now those PRs
are awaiting further comments from maintainers/my mentor.

= Blockers
None at present.

= Plan for the week
Next week was supposed to continue deprecation work. That is, in theory, already
done. But I still need to get feedback on that, so work on this is likely to
continue this week. That does not mean I won't be working, like I have today, on
the bit-width transitioning issues. It just so happens I will be focusing on
this task, while keeping an eye on new comments to the PRs I got open concerning
constant deprecation.
