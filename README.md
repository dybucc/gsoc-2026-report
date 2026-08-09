# GSoC 2026 work product: The Rust Foundation's `libc` crate

<!-- [todo]: add a TOC. -->

## Short description

My work has consisted of moving forward the list of issues and stale PRs that
the rust-lang/libc project needs solving before reaching its 1.0 release. This
is a project that provides Rust bindings to `liblibc` and system libraries.

The rust-lang/libc project has had relatively stable but not completely
well-defined release semantics. Especially when compared with the rest of the
Rust ecosystem, its release versioning sometimes leads to some confusion.

Its stability largely relies on upstream C projects for which it provides
bindings to maintain such stability. To a large extent, exposing interfaces that
don't break across minor or patch SemVer releases is not feasible.

Reaching a 1.0 release will allow having a number of notably breaking changes
be finally made to the bindings. We currently have two branches on the
repository; One for the upcoming 1.0, and another for the 0.2.x releases.

Most changes are backported to the latter, "public-facing" releases. During
GSoC we also improved on some aspects of our usage guidelines policies, such
that users be warned of expected breakage.

## What I did

My initial proposal outlined two main goals; I intended on solving a
long-standing issue concerning certain constant symbols, then solving some
doubts and issues around matters Y2038.

If time allowed, I would follow through with other issues included in the 1.0
milestone. The above two seemed to be the more pressing concerns from a first
approximation, and had been stale or largely in need of work for a few years.

The proposal plan was followed to the letter, and the timeline was even
improved by finishing up work on the main two issues I intended on tackling
earlier than expected.

The first three weeks were spent on the issue concernig constant deprecation.
That issue consisted of going through all supported targets, ensuring there
were no un-deprecated constants left that fit a given criteria.

Such criteria was not completely well-defined from prior discussion, but it
generally included symbols often used in C to denote the "last" or "limit"
value in a list of other constants and/or enumeration variants.

Notably, I further narrowed down the "limit" constants to those classified by
the POSIX and SUS standards as being pathname variable or runtime increasable
values under their section on header file `limits.h`.

All in all, these symbols could be classified as being very much prone to
breakage in upstream C codebases. Versioning schemes akin to SemVer are not
nearly as prevalent in the C world, so these are often changed across patches.

This was, honestly, a lot of research work. I was fairly aware of how messy
widely-used software really is when inspecting decades-old codebases, but the
sheer amount of cruft and undocumented symbols was astonishing.

Thankfully, a tool I developed throughout the month prior to the bonding period
and during the bonding period helped me avoid the headaches of manual
deprecation in the rust-lang/libc codebase.

I developed a small CLI utility that scanned the rust-lang/libc codebase,
parsed it into an in-memory representation consisting solely of constants, and
exposed a simple TUI to mark symbols as deprecated.

That allowed me to focus solely on banging my head against Internet resources
to find out the meaning behind some non-obvious constants used in upstream
projects for which we provide C bindings.

Upon finishing work on this, feedback from my mentor started a discussion
around potentially _not_ deprecating the symbols. I didn't quite participate in
that conversation, as it was resolved fairly quickly.

We eventually ended up settling for adding documentation notes to those
symbols, such that users be advised about upstream potentially breaking these
symbols. I simply found+replaced the deprecation attribute for a doc comment.

I then moved on to doing another pass through all our bindings to ensure we
correctly handled the Y2038 issue. Y2038 refers to a widespread C issue about
32-bit integers not fitting dates from the UNIX Epoch beyond 2038.

Different libc implementations handle this in subtly different ways. Most
solutions were implemented back in the early 2000s, with exceptions for modern
implementations and systems, which provide a single 64-bit `time_t` value.

`time_t` is the main type behind all this. It's really an alias to an (often)
signed integer, used across calls to C library functions like `time()` and
others using composite data types containing `time_t` like `ctime()`.

Notably, another issue that was also tackled in parallel to this one was
concerned with LFS bindings. Back in the late 1990s, _Large File Support_ was
described in certain specifications to allow handling files larger than 2 GiB.

These days, providing LFS bindings is often redundant. The musl (a libc
implementation) maintainer themselves could not care less about LFS [^1]. Most
non-LFS types these days are already 64-bits wide.

When it comes to the nitty gritty of ABI details, most libc implementations
simply set up redirects from one non-LFS function to an LFS function. Still,
that means the non-LFS function is getting the LFS behavior.

This really means there's no reason to keep bindings for the LFS functions.
Once we bind to them, users will be making calls to function pointers that lead
to the LFS functions and not to the non-LFS functions.

That's why I also set out on an adventure to spot and deprecate types such as
`off64_t` and routines like `statfs64`. This was possibly even more painful a
task, as it almost always meant reading through cryptic libc header files.

Deserializing a header file into a human-comprehensible format for each
supported libc target in each supported libc implementation is arguably hard.
A combinatorial explosion of mental marshaling operations is an experience.

Still, I followed through with it, and before the end of week 6 I was mostly
done. PRs were opened, my sanity was barely standing on its knees, and I was
ready to rock even harder.

The expected timeline had me finishing this by week 7, upon which I would start
looking into other issues in the 1.0 release milestone. Granted, along the way
I had already opened some issues concerning potentially wrong bindings.

Most notably, work on an issue I had opened before even the bonding period to
solve some `time_t` concerns on Windows targets, got eventually solved. This
was mostly related to the default `time_t` bit width on Windows being wrong.

During week 7 I looked through the remaining issues in the 1.0 release
milestone, and decided on a few that I would be working on. Halfway through the
week, I had already commented on a few stale PRs with updated patchsets.

What I first decided to do was to close most issues that had not received any
attention in a long time (sometimes more than 5 years.) These were often mostly
resolved or had old PRs that never got merged but were still open.

I also finished up some general module-wide clean-ups for whole target
families, though some of these remain unmerged and are still actively receiving
feedback.

I also opened an MCP (Major Change Proposal) that tried to follow through on a
prior attempt to solve a certain issue on OpenBSD targets. These targets often
end up with non-backward- nor foward-compatible changes upstream.

This in turn leads to some pretty dire situations in rust-lang/libc. We don't
know which version of the OS the user is running and so we don't really know
whether the bindings we're exposing are supposed to target the latest release.

The proposal attempts to encode in a certain compile-time key specific to each
target, the version of the latest `-current` release channel for OpenBSD. This
way, it's far easier for us to expose the right bindings across releases.

Another highlight of these last few weeks was (and still is) a Windows issue in
the way functions get called. This is still open but progress is actively being
made on that front and the solution seems clear.

The issue itself was due to the fact we've had failing tests on Windows targets
whenever we compared the addresses of function pointers from the Rust side of
things to the C side of things.

Apparently, there's some funny ways in which Windows handles calls to routines
that ought make a jump to a separate DLL (Dynamically Linked Library.) Research
into this made me realize this had been an ongoing issue for over a decade.

Basically, if we don't explicitly annotate our `extern` blocks to bind to a
dynamically-linked library, the codegen in the Rust compiler won't annotate the
call with a special Windows attribute that makes the right call.

This isn't an issue to users becaues the codgen is right whether we specify the
library kind or not. It just so happens that Windows can optimize out a double
jump in the codegen if the attribute is there.

Granted, when comparing function pointer addresses, whether there's one jump or
two makes all the difference. That's why tests had been failing. But annotating
the `extern` blocks to link to a dynamic library wasn't going to do it.

See, we have plans to completely remove in the 1.0 release all explicit linking
we make in rust-lang/libc to system libraries like `libutil`. This conflicts
with the obvious solution to the above problem.

Due to a current limitation in the way Rust links to libraries while also
specifying the type of library to link to, this is also going to need a change
proposal to the Rust compiler.

I found out about a two-year old proposal and revived discussion on it as it
seemed to fit our purposes just fine. It's currently in the process of getting
approved by some of the Rust teams.

More work on other issues is commented on in Section [Code that got merged][a].

[^1]: pending
[a]: <code-that-got-merged>

## Current state

All of the issues I intended on solving have been solved. The new ones I
tackled from week 7 on are either solved, or in the process of being solved.
I've not once dropped an issue without completely solving it.

At present, there's about 38% of the "main" issues for the 1.0 release solved.
When I started off, that number was about 25%, but that is not to say I raised
it that much. I point this out because there's actually a ton of stuff to do.

Notably, rust-lang/libc finally got some documentation written about expected
breakage across theoretically non-breaking SemVer releases. This wasn't done by
me, but it did happen as part of discussion for some of the issues I tackled.

## What's left to do

There's still a ton of issues to either close as solved because they've been
sitting there gathering dust for years, or to finally find a solution for. I
expect these to take at least another year's worth of work.

Beyond that, there's nothing specific left to do. It's all issues and stale PRs
that need picking up and solving. There's only two active maintainers in the
rust-lang/libc repo these days, so work piles up quickly.

Though I must admit there's not many new issues opened. It's often the
maintainers themselves ensuring something that popped up while solving another
issue isn't forgotten, even though solving it is not a current priority.

## Code that got merged

The following is a list of PRs/issues that got merged/solved during GSoC. It's
ordered from oldest to newest, where the creation date of the issue or PR
itself is used to sort it in the list.

For all of the issues where there's no associated PR, see the issue thread for
my comments on it. They all contain whatever research and report I prepared for
it.

- [rust-lang/libc#657][657] _Remove use_std feature_

  This issue was one of the older ones. It tried to remove the `use_std` feature
  that was once part of rust-lang/libc. This is because the Rust API guidelines
  expect features not to be named `use_*`, but rather `*`.

  We've had that feature renamed to `std` for a few years now, and it's either
  way bound to be removed in 1.0. That is now tracked in another issue [^2].

- [rust-lang/libc#938][938] _Outdated non-POSIX FreeBSD API used by tests_

  This issue reported that a certain FreeBSD routine was not providing bindings
  for the latest upstream version. Ever since then, we've had a splitting of the
  FreeBSD versions into separate modules (outside of GSoC.)

  That specific API is also fixed and now correctly refletcs the latest version
  on all supported FreeBSD versions. We presently support FreeBSD 11-15.

- [rust-lang/libc#1036][1036] _ioctl request arg size for Android aarch64 is
wrong?_

  This issue reported that there were issues in the way we handled a certain
  argument for Android targets, and possibly some other libc implementations
  used on Linux.

  As it turns out, `ioctl` is meant to be a routine that takes a request
  constant that is often (but not always) a signed 32-bit integer. POSIX
  dictates so, but popular implementations like glibc make it unsigned.

  The issue, though, lies in the fact some of these constants could be 64-bits
  wide and not just 32-bits wide. This is actually quite a pain point because
  that one argument neither has well-defined semantics.

  The solution basically went through praying some driver implementor didn't
  decide against using a 64-bit constant and moving on. I got a PR merged for
  this one that also removed the skip we have in our test infrastructure.

  In that patch, I also added a `#define` for a certain symbol that makes, at
  least in Bionic libc, a certain overload for that routine unavailable. This
  made it so that tests passed again, and we know have _some_ better guarantees.

  The PR for that patch can be found here [^3].

- [rust-lang/libc#1197][1197] _Libc-test fails on NetBSD_

  This issue reported that there were issues in our test infrastructure a few
  years ago, as tests for NetBSD were not passing. This has not been the case
  for some time now as we've had a job running in CI for almost a year.

  We don't often merge some PR until it passes al CI jobs, so tests are almost
  always guaranteed to pass in NetBSD. And even if they don't, most targets
  using that OS are tier 2, which means they're only guaranteed to build.

  The issue was closed shortly after I pointed out it was not up-to-date.

- [rust-lang/libc#1282][1282] _wchar_t is i32 for all bsd targets_

  This issue was another one of the old issues that was not up to date with the
  current bindings. I verified the problem reported there was fixed, and the
  issue got closed shortly after.

- [rust-lang/libc#2971][2971]
  _msghdr.msg_iovlen is inconsistently declared in gnu and musl_

  This issue reported some incorrect bindings a few years ago. Much like other
  unsolved issues, it wasn't up-to-date with our current bindings and was closed
  shortly after I reported so.

- [rust-lang/libc#3131][3131] _Remove "placeholder constants"_

  This issue was the original issue regarding the first goal in my proposal;
  Namely, the deprecation of bug-prone and SemVer-breaking constants. The
  associated PRs in which I deprecated them follow.

  - <https://github.com/rust-lang/libc/pull/5123>
  - <https://github.com/rust-lang/libc/pull/5122>
  - <https://github.com/rust-lang/libc/pull/5121>
  - <https://github.com/rust-lang/libc/pull/5120>
  - <https://github.com/rust-lang/libc/pull/5119>
  - <https://github.com/rust-lang/libc/pull/5118>

  The deprecation patchsets eventually got repurposed to annotate with
  documentation those items, as our new usage guidelines already ensured users
  didn't blindly used them without expecting breakage in non-breaking releases.

  There were also analogous PRs I opened right after deprecation were I completely
  removed them, expecting the deprecation to be backported to the next stable
  release, while the removal would stay in store for the 1.0 release.

  Those were eventually closed because it was decided that removing them could be
  left for later, as the maintenance efforts then wouldn't be too high. The work
  of finding which to remove was done and the doc comment could be found+replaced.

- [rust-lang/libc#3194][3194] _Netlink support on FreeBSD 13.2+_

  This issue originally both reported that there were missing interfaces for the
  netlink `if_addr` family in our FreeBSD bindings, and proposed a patchset for
  those in what is now a stale PR.

  I picked up the original patchset and tweaked it some to get the tests to
  pass. This hasn't been merged yet because there's some nifty item resolution
  conflicts that remain to be solved.

  These mostly consist of the `netlink/netlink.h` interfaces interfering with
  those of the `net/if_mib.h`. In C, there's sort of "scoping" set in place for
  this by simply having each of those exist in separate header files.

  In rust-lang/libc, though, we reexport all items that a given platform
  provides at the crate root level, which means we end up with item resolution
  conflicts on the Rust side of things.

  The initial solution I came up with was to set up some hacky workarounds in
  our test infrastructure that would let us run multiple times the test suite
  for FreeBSD targets, each with a different network interface.

  My mentor recommended against this when they gave the first review. I'm
  currently looking into either (1) extending our custom test harness to allow
  referring to submodule paths, or (2) improving the current workaround.

  I've had moderate success with the latter option. Ideally, we would just
  extend our test harness as this is not the the first time we've found
  ourselves with this usecase (though it has been during GSoC.)

  My two associated PRs can be found in [^4] and [^5].

- [rust-lang/libc#3661][3661] _linux_like: unify SIGEV_THREAD_ID support_

  This was a stale PR in the 1.0 milestone that I picked up on and got merged
  quite easily. There's not much to comment here, it's simply a symbol that we
  were not exposing on our bindings to musl libc.

  My associated PR can be found in [^6].

- [rust-lang/libc#4080][4080] _Mark all structs `non_exhaustive` for 1.0_

  This issue initially attempted to further improve the usage guidelines by
  having most of our public types be marked with the `non_exhaustive` attribute.
  This forces downstream consumers initialize them field-by-field.

  For some time now, there's been open discussion in rust-lang/rust about a
  certain lint that is triggered by the compiler when using this type of records
  in FFI contexts. This is yet unsolved.

  That's why we recently decided to instead have a private field be added to all
  our records such that we use that as a workaround while the afore-mentioned
  discussion gets resolved.

  The strategy here is to use our pre-existing macros for declaring all of our
  types (which ensure they all use a C representation and they derive the right
  traits under the right feature flags) expand to modify the inner types.

  This really means we now automatically add the private to all such records
  unless the macro detects a certain attribute with which the type is annotated.
  This attribute is of our own choosing and it's removed post-expansion.

  That I implemented recently and have had a PR open since in [^7]. After that,
  there's going to be need for annotating all the types where we didn't already
  have private fields (for other reasons) with the attribute.

  This is so that we can backport those changes to the next stable release,
  while then immediately reverting them in the 1.0 branch. We'd prefer it if
  users had a stronger "no-guarantees" guarantee once we reach 1.0.

- [rust-lang/compiler-team#916][916] _Split the `-openbsd*` targets by version_

  This issue was the one that I originally found after digging through the
  possible solutions to this other issue [^8]. That one tried to solve the fact
  that we've had a bit of a hard time dealing with platforms like OpenBSD.

  This type of platforms don't provide any backward- nor forward-compatibility
  guarantees. This means a new release could very well just drop support for
  older API.

  Of course, each platform's practices are completely up to them, but trying to
  adapt a SemVer-like approach (prevalent in rust-lang/libc) to that makes it a
  bit hard.

  Without a clear way of knowing which target we're compiling for, this issue
  attempted to add the supported OpenBSD version to each target's tuple. This,
  though, was deemed to suppose too heavy a maintenance burden.

  <!-- [todo]: finish explaining your solution and link to the MCP and the implementation. -->

[657]: <https://github.com/rust-lang/libc/issues/657>
[938]: <https://github.com/rust-lang/libc/issues/938>
[1036]: <https://github.com/rust-lang/libc/issues/1036>
[1197]: <https://github.com/rust-lang/libc/issues/1197>
[1282]: <https://github.com/rust-lang/libc/issues/1282>
[2971]: <https://github.com/rust-lang/libc/issues/2971>
[3131]: <https://github.com/rust-lang/libc/issues/3131>
[3194]: <https://github.com/rust-lang/libc/issues/3194>
[3661]: <https://github.com/rust-lang/libc/issues/3661>
[4080]: <https://github.com/rust-lang/libc/issues/4080>
[916]: <https://github.com/rust-lang/compiler-team/issues/916>
[^2]: <https://github.com/rust-lang/libc/issues/5265>
[^3]: <https://github.com/rust-lang/libc/issues/5384>
[^4]: <https://github.com/rust-lang/libc/issues/5325>
[^5]: <https://github.com/rust-lang/libc/issues/5326>
[^6]: <https://github.com/rust-lang/libc/issues/5375>
[^7]: <https://github.com/rust-lang/libc/issues/5390>
[^8]: <https://github.com/rust-lang/libc/issues/570>

## Challenges and the learning experience
