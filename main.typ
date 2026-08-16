#set document(
  title: [GSoC 2026 work product: The Rust Foundation's `libc` crate],
  author: [Adam Martinez],
  date: none,
)

#title()

#outline()

= Short description

My work has consisted of moving forward the list of issues and stale
PRs that the rust-lang/libc project needs solving before reaching its
1.0 release. This is a project that provides Rust bindings to
`liblibc` and system libraries.

The rust-lang/libc project has had relatively stable but not
completely well-defined release semantics. Especially when compared
with the rest of the Rust ecosystem, its release versioning sometimes
leads to some confusion.

Its stability largely relies on upstream C projects for which it
provides bindings to maintain such stability. To a large extent,
exposing interfaces that don't break across minor or patch SemVer
releases is not feasible.

Reaching a 1.0 release will allow having a number of notably breaking
changes be finally made to the bindings. We currently have two
branches on the repository; One for the upcoming 1.0, and another for
the 0.2.x releases.

Most changes are backported to the latter, "public-facing" releases.
During GSoC we also improved on some aspects of our usage guidelines
policies, such that users be warned of expected breakage.

= What I did

My initial proposal outlined two main goals; I intended on solving a
long-standing issue concerning certain constant symbols, then solving
some doubts and issues around matters Y2038.

If time allowed, I would follow through with other issues included in
the 1.0 milestone. The above two seemed to be the more pressing
concerns from a first approximation, and had been stale or largely in
need of work for a few years.

The proposal plan was followed to the letter, and the timeline was
even improved by finishing up work on the main two issues I intended
on tackling earlier than expected. A daily report of all my activities
was submitted on the Zulip thread associated with this project [^23].

The first three weeks were spent on the issue concernig constant
deprecation. That issue consisted of going through all supported
targets, ensuring there were no un-deprecated constants left that fit
a given criteria.

Such criteria was not completely well-defined from prior discussion,
but it generally included symbols often used in C to denote the "last"
or "limit" value in a list of other constants and/or enumeration
variants.

Notably, I further narrowed down the "limit" constants to those
classified by the POSIX and SUS standards as being pathname variable
or runtime increasable values under their section on header file
`limits.h`.

All in all, these symbols could be classified as being very much prone
to breakage in upstream C codebases. Versioning schemes akin to SemVer
are not nearly as prevalent in the C world, so these are often changed
across patches.

This was, honestly, a lot of research work. I was fairly aware of how
messy widely-used software really is when inspecting decades-old
codebases, but the sheer amount of cruft and undocumented symbols was
astonishing.

Thankfully, a tool I developed throughout the month prior to the
bonding period and during the bonding period helped me avoid the
headaches of manual deprecation in the rust-lang/libc codebase.

I developed a small CLI utility that scanned the rust-lang/libc
codebase, parsed it into an in-memory representation consisting solely
of constants, and exposed a simple TUI to mark symbols as deprecated.

That allowed me to focus solely on banging my head against Internet
resources to find out the meaning behind some non-obvious constants
used in upstream projects for which we provide C bindings.

Upon finishing work on this, feedback from my mentor started a
discussion around potentially _not_ deprecating the symbols. I didn't
quite participate in that conversation, as it was resolved fairly
quickly.

We eventually ended up settling for adding documentation notes to
those symbols, such that users be advised about upstream potentially
breaking these symbols. I simply found+replaced the deprecation
attribute for a doc comment.

I then moved on to doing another pass through all our bindings to
ensure we correctly handled the Y2038 issue. Y2038 refers to a
widespread C issue about 32-bit integers not fitting dates from the
UNIX Epoch beyond 2038.

Different libc implementations handle this in subtly different ways.
Most solutions were implemented back in the early 2000s, with
exceptions for modern implementations and systems, which provide a
single 64-bit `time_t` value.

`time_t` is the main type behind all this. It's really an alias to an
(often) signed integer, used across calls to C library functions like
`time()` and others using composite data types containing `time_t`
like `ctime()`.

Notably, another issue that was also tackled in parallel to this one
was concerned with LFS bindings. Back in the late 1990s, the _Large
File Summit_ specification started allowed handling files larger than
2 GiB.

These days, providing LFS bindings is often redundant. The musl (a
libc implementation) maintainer themselves could not care less about
LFS @musl-lfs-statement. Most non-LFS types these days are already 64-bits wide.

When it comes to the nitty gritty of ABI details, most libc
implementations simply set up redirects from one non-LFS function to
an LFS function. Still, that means the non-LFS function is getting the
LFS behavior.

This really means there's no reason to keep bindings for the LFS
functions. Once we bind to them, users will be making calls to
function pointers that lead to the LFS functions and not to the
non-LFS functions.

That's why I also set out on an adventure to spot and deprecate types
such as `off64_t` and routines like `statfs64`. This was possibly even
more painful a task, as it almost always meant reading through cryptic
libc header files.

Deserializing a header file into a human-comprehensible format for
each supported libc target in each supported libc implementation is
arguably hard. A combinatorial explosion of mental marshaling
operations is an experience.

Still, I followed through with it, and before the end of week 6 I was
mostly done. PRs were opened, my sanity was barely standing on its
knees, and I was ready to rock even harder.

The expected timeline had me finishing this by week 7, upon which I
would start looking into other issues in the 1.0 release milestone.
Granted, along the way I had already opened some issues concerning
potentially wrong bindings.

Most notably, work on an issue I had opened before even the bonding
period to solve some `time_t` concerns on Windows targets, got
eventually solved. This was mostly related to the default `time_t` bit
width on Windows being wrong.

During week 7 I looked through the remaining issues in the 1.0 release
milestone, and decided on a few that I would be working on. Halfway
through the week, I had already commented on a few stale PRs with
updated patchsets.

What I first decided to do was to close most issues that had not
received any attention in a long time (sometimes more than 5 years.)
These were often mostly resolved or had old PRs that never got merged
but were still open.

I also finished up some general module-wide clean-ups for whole target
families, though some of these remain unmerged and are still actively
receiving feedback.

I also opened an MCP (Major Change Proposal) that tried to follow
through on a prior attempt to solve a certain issue on OpenBSD
targets. These targets often end up with non-backward- nor
foward-compatible changes upstream.

This in turn leads to some pretty dire situations in rust-lang/libc.
We don't know which version of the OS the user is running and so we
don't really know whether the bindings we're exposing are supposed to
target the latest release.

The proposal attempts to encode in a certain compile-time key specific
to each target, the version of the latest `-current` release channel
for OpenBSD. This way, it's far easier for us to expose the right
bindings across releases.

Another highlight of these last few weeks was (and still is) a Windows
issue in the way functions get called. This is still an open issue but
progress is actively being made on that front and the solution seems
clear.

The issue itself was due to the fact we've had failing tests on
Windows targets whenever we compared the addresses of function
pointers from the Rust side of things to the C side of things.

Apparently, there's some funny ways in which Windows handles calls to
routines that ought make a jump to a separate DLL (Dynamically Linked
Library.) Research into this made me realize this had been an ongoing
issue for over a decade.

Basically, if we don't explicitly annotate our `extern` blocks to bind
to a dynamically-linked library, the codegen in the Rust compiler
won't jump to the right symbol, but will only the perform the first
jump in the equivalent MSVC codegen.

This isn't an issue to users becaues the codegen is right whether we
specify the library kind or not. It just so happens that Windows can
optimize out a double jump in the codegen if the attribute is there.

Granted, when comparing function pointer addresses, whether there's
one jump or two makes all the difference. That's why tests had been
failing. But annotating the `extern` blocks to link to a dynamic
library wasn't going to do it.

See, we have plans to completely remove in the 1.0 release all
explicit linking we make in rust-lang/libc to system libraries like
`libutil`. This conflicts with the obvious solution to the above
problem.

Due to a current limitation in the way Rust links to libraries while
also specifying the type of library to link to, this is also going to
need a change proposal to the Rust compiler.

I found out about a two-year old proposal and revived discussion on it
as it seemed to fit our purposes just fine. It's currently in the
process of getting approved by some of the Rust teams.

More work on other issues is commented on in Section Code that got merged @pr-list.

= Current state

All of the issues I intended on solving have been solved. The new ones
I tackled from week 7 on are either solved, or in the process of being
solved. I've not once dropped an issue without completely solving it.

At present, there's about 38% of the "main" issues for the 1.0 release
solved. When I started off, that number was about 25%, but that is not
to say I raised it that much. I point this out because there's
actually a ton of stuff to do; Not because I was in charge of that
progress.

Notably, rust-lang/libc finally got some documentation written about
expected breakage across theoretically non-breaking SemVer releases.
This wasn't done by me, but it did happen as part of discussion for
some of the issues I tackled.

= What's left to do

There's still a ton of issues to either close as solved because
they've been sitting there gathering dust for years, or to finally
find a solution for. I expect these to take at least another year's
worth of work.

Beyond that, there's nothing specific left to do. It's all issues and
stale PRs that need picking up and solving. There's only two active
maintainers in the rust-lang/libc repo these days, so work piles up
quickly.

Though I must admit there's not many new issues opened. It's often the
maintainers themselves ensuring something that popped up while solving
another issue isn't forgotten, even though solving it is not a current
priority.

= Code that got merged <pr-list>

The following is a list of PRs/issues that got merged/solved during
GSoC. It's ordered from oldest to newest, where the creation date of
the issue or PR itself is used to sort it in the list.

For all of the issues where there's no associated PR, see the issue
thread for my comments on it. They all contain whatever research and
report I prepared for it.

I haven't included the bonding period project I worked on and used
throughout the first three weeks of GSoC, but that one can be found
here [^22].

Following my mentor's suggestion, I plan on eventually refactoring
that tool into a more modular tool to allow a number of LSP-like code
actions to be performed on any codebase.

== _Remove use_std feature_ <657>

  This issue was one of the older ones. It tried to remove the
  `use_std` feature that was once part of rust-lang/libc. This is
  because the Rust API guidelines expect features not to be named
  `use_*`, but rather `*`.

  We've had that feature renamed to `std` for a few years now, and
  it's either way bound to be removed in 1.0. That is now tracked in
  another issue @github-remove-link-std.

== _Outdated non-POSIX FreeBSD API used by tests_ <938>

  This issue reported that a certain FreeBSD routine was not providing
  bindings for the latest upstream version. Ever since then, we've had
  a splitting of the FreeBSD versions into separate modules (outside
  of GSoC.)

  That specific API is also fixed and now correctly refletcs the
  latest version on all supported FreeBSD versions. We presently
  support FreeBSD 11-15.

== _ioctl request arg size for Android aarch64 is wrong?_ <1036>

  This issue reported that there were problems in the way we handled a
  certain argument for Android targets, and possibly some other libc
  implementations used on Linux.

  As it turns out, `ioctl` is meant to be a routine that takes a
  request constant that is often (but not always) a signed 32-bit
  integer. POSIX dictates so, but popular implementations like glibc
  make it unsigned.

  The issue, though, lies in the fact some of these constants could be
  64-bits wide and not just 32-bits wide. This is actually quite a
  pain point because that one argument neither has well-defined
  semantics.

  The solution basically went through praying some driver implementor
  didn't decide in favor of using a 64-bit constant. I got a PR merged
  for this one that also removed the skip we have in our test
  infrastructure.

  In that patch, I also added a `#define` for a certain symbol that
  makes, at least in Bionic libc, a certain overload for that routine
  unavailable. This made it so that tests passed again, and we know
  have _some_ better guarantees.

  The PR for that patch can be found here @github-skip-ioctl.

== _Libc-test fails on NetBSD_ <1197>

  This issue reported that there were issues in our test
  infrastructure a few years ago, as tests for NetBSD were not
  passing. This has not been the case for the last ten months, as
  there's been a CI job set up since.

  We don't often merge some PR until it passes all CI jobs, so tests
  are almost always guaranteed to pass in NetBSD. And even if they
  don't, most targets using that OS are tier 2, which means they're
  only guaranteed to build.

== _wchar_t is i32 for all bsd targets_ <1282>

  This issue was another one of the old issues that was not up to date
  with the current bindings. I verified the problem reported there was
  fixed, and the issue got closed shortly after.

== _msghdr.msg_iovlen is inconsistently declared in gnu and musl_ <2971>

  This issue reported some incorrect bindings a few years ago. Much
  like other unsolved issues, it wasn't up-to-date with our current
  bindings and was closed shortly after I reported so.

== _Remove "placeholder constants"_ <3131>

  This issue was the original issue regarding the first goal in my
  proposal; Namely, the deprecation of bug-prone and SemVer-breaking
  constants. Following I include the associated list of PRs.

  - https://github.com/rust-lang/libc/pull/5123
  - https://github.com/rust-lang/libc/pull/5122
  - https://github.com/rust-lang/libc/pull/5121
  - https://github.com/rust-lang/libc/pull/5120
  - https://github.com/rust-lang/libc/pull/5119
  - https://github.com/rust-lang/libc/pull/5118

  The deprecation patchsets eventually got repurposed to annotate with
  documentation those items, as our new usage guidelines already
  ensured users didn't blindly use them without expecting breakage in
  non-breaking releases.

  There were also analogous PRs I opened right after deprecation were
  I completely removed them, expecting the deprecation to be
  backported to the next stable release, while the removal would stay
  in store for the 1.0 release.

  Those were eventually closed because it was decided that removing
  them could be left for later, as the maintenance efforts then
  wouldn't be too high. The work of finding which to remove was done
  and the doc comment could be found+replaced.

== _Netlink support on FreeBSD 13.2+_ <3194>

  This issue originally both reported that there were missing
  interfaces for the netlink interface in our FreeBSD bindings, and
  proposed a patchset for those in what is now a stale PR.

  I picked up the original patchset and tweaked it some to get the
  tests to pass. This hasn't been merged yet because there's some
  nifty item resolution conflicts that remain to be solved.

  These mostly consist of the `netlink/netlink.h` interfaces
  interfering with those of `net/if_mib.h`. In C, there's sort of
  "scoping" set in place for this by simply having each of those exist
  in separate header files.

  In rust-lang/libc, though, we reexport all items that a given
  platform provides at the crate root level, which means we end up
  with item resolution conflicts on the Rust side of things.

  The initial solution I came up with was to set up some hacky
  workarounds in our test infrastructure that would let us run
  multiple times the test suite for FreeBSD targets, each with a
  different network interface.

  My mentor recommended against this when they gave an initial review.
  I'm currently looking into either (1) extending our custom test
  harness to allow referring to submodule paths, or (2) improving the
  current workaround.

  I've had moderate success with the latter option. Ideally, we would
  just extend our test harness as this is not the the first time we've
  found ourselves with this usecase (though it has been during GSoC.)

  My two associated PRs can be found in @github-ifmib-to-new and @github-netlink-support.

== _linux_like: unify SIGEV_THREAD_ID support_ <3661>

  This was a stale PR in the 1.0 milestone that I picked up on and got
  merged quite easily. There's not much to comment here, it's simply a
  symbol that we were not exposing on our bindings to musl libc.

  My associated PR can be found in @github-sigevthreadid-unify.

== _Mark all structs `non_exhaustive` for 1.0_ <4080>

  This issue initially attempted to further improve the usage
  guidelines by having most of our public types be marked with the
  `non_exhaustive` attribute. This forces downstream consumers to
  initialize them field-by-field.

  For some time now, there's been open discussion in rust-lang/rust
  about a certain lint that is triggered by the compiler when using
  this type of records in FFI contexts. This is yet unsolved.

  That's why we recently decided to instead have a private field be
  added to all our records such that we use that as a workaround while
  the afore-mentioned discussion gets resolved.

  The strategy here is to use our pre-existing macros for declaring
  all of our types (which ensure they all use a C representation and
  they derive the right traits under the right feature flags) expand
  to modify the inner types.

  This really means we now automatically add the private field to all
  such records unless the macro detects a certain attribute with which
  the type is annotated. This attribute is of our own choosing and
  it's removed post-expansion.

  That I implemented recently and have had a PR open since in @github-exhaustive-macro.
  After that, there's going to be need for annotating all the types
  where we didn't already have private fields (for other reasons) with
  the attribute.

  This is so that we can backport those changes to the next stable
  release, while then immediately reverting them in the 1.0 branch.
  We'd prefer it if users had a stronger "no-guarantees" guarantee
  once we reach 1.0.

== _Split the `-openbsd*` targets by version_ <916>

  This issue was the one that I originally found after digging through
  the possible solutions to this other issue [^8]. That one tried to
  solve the fact that we've had a bit of a hard time dealing with
  platforms like OpenBSD.

  This type of platforms don't provide any backward- nor
  forward-compatibility guarantees. This means a new release could
  very well just drop support for older API.

  Of course, each platform's practices are completely up to them, but
  trying to adapt a SemVer-like approach (prevalent in rust-lang/libc)
  to those release habits is hard.

  Without a clear way of knowing which target we're compiling for,
  this proposal attempted to add the supported OpenBSD version to each
  target's tuple. This, though, was deemed too heavy a maintenance
  burden.

  The solution I proposed in a separate MCP at [^9] followed from
  comments by my mentor and comments left by the compiler team in the
  accompanying Zulip [^10]. That MCP got approved and I've submitted a
  reference implementation in [^11].

  This solution instead embeds OpenBSD's `-current` release channel
  version into each target's `target_env`. This then allows us to bind
  against interfaces depending on that compile-time value.

  This compile-time "property" of each target is then meant to be
  updated each time a new release is made upstream by OpenBSD. That
  way, older Rust compiler versions keep the older values (maintained
  in the OpenBSD ports collection.)

  This seemed fairly satisfactory from discussions in the Zulip thread
  for the newest version of the MCP [^12]. At the time of writing,
  this is yet to be merged, so it's not yet possible to use it in
  rust-lang/libc.

- [rust-lang/libc#4867][4867] _Change type of `AF_INET` and `AF_INET6`
  to `sa_family_t`_

  This PR was one of the stale PRs I picked up after week 7. I rebased
  it to latest `main` and ensured it still did what it was meant to
  (as our current bindings could have changed since it was first
  opened.)

  This one is not included directly in the 1.0 milestone but does try
  to solve an issue [^13] in the 1.0 milestone. I've yet to receive a
  response from the original author and to get further approval from
  maintainers to move it forward.

  My work can be found in the latest patch of this commit history
  [^14].

- [rust-lang/libc#5008][5008] _Fix: Replace sighandler_t with sig_t
  for Apple and BSDs_

  This PR was one I initially believed to be stale as it tried to
  solve one of the issues in the 1.0 release milestone [^15], but
  seemed to not have been touched in almost six months.

  I rebased it to latest tip-of-tree and commented on it, but the
  author mentioned that they were actually waiting for a review. I
  then decided to simply leave some possible improvements to the
  patchset, and called it.

  Recently, the author got back from one of the rust-lang/libc
  maintainers, and has modified the patch I rebased and tweaked back
  when I first commented on the PR thread. For details, see their work
  on that in the above reference.

- [rust-lang/libc#5010][5010] _feat: add support for 32 bit `time_t`
  in Windows_

  This was one of the PRs I originally submitted before GSoC to
  rust-lang/libc concerning the fact `time_t` was only exposed as
  32-bits wide on Windows. There's a macro in Windows that can be used
  to toggle the old behavior.

  Granted, the whole point of the transition I eventually settled on
  for one of my GSoC goals was to move towards full 64-bit `time_t`
  and LFS types. This PR was closed shortly after one of the
  maintainers made that clear to me.

  Still, it serves as good recollection.

- [rust-lang/libc#5032][5032] _Deprecate windows `time64_t`_

  This was one of the PRs I originally opened before I even got
  accepted into GSoC to familirize myself with the repo. It addressed
  the fact that we still had a 64-suffixed `time_t` in Windows.

  Because the whole point of the transition is to have a single,
  64-bits wide `time_t`, providing a "variant" of this data type that
  is guaranteed to be 64-bits wide becomes redundant.

  This PR is currently on hold and will continue being so until we see
  whether the 1.0 release is really nearing. There's similar patchsets
  that are also on hold for the same reason.

  It'll be easier to justify the mass deprecations on a proper SemVer
  breaking release.

- [rust-lang/libc#5050][5050] _feat: add back support for GNU Windows
  x86 in CI_

  This PR I opened while solving other Windows issues and testing on
  each of our supported Rust targets. I found that there didn't seem
  to be any issues with Windows x86 running with a GNU-based libc
  implementation.

  The CI job for this target had been disabled due to some segfaults
  caused by the generated C tests, but the only apparent issue was
  that a certain data type, `max_align_t`, had the wrong alignment
  requirement.

  This added back support for this target in CI, and it seems to have
  been stable ever since.

- [rust-lang/libc#5059][5059] _windows(gnu): link to 32-bit time
  routines in x86 and add test_

  This issue is one of the Windows patchsets I prepared after
  initially working on `time_t` matters to introduce myself to the
  repository. While looking through both MSVC and MinGW headers, I
  noticed that there were mismatches.

  For about ten years, the bindings for MinGW on x86 targets have been
  reflecting a `time_t` that defaults to having a 32-bit bit width.
  This was wrong, but we couldn't just break users with a change in
  the data type of a type alias.

  This PR ensured that at least the routines that use this data type
  link to the right (also 32-bit) symbols. This is necessary because
  Windows has variants for certain functions involving `time_t` that
  expect a 32-bit integer.

  Without this fix, we wouldn't have run into any issues so long as
  the argument passed to the routine were not part of an input-output
  parameter whose effective address were taken.

  Now, for routines like `time()`, this does mean that a load on the
  `time_t` value will attempt to write 64-bits worth of data instead
  of only 32. This is unsound, as it touches on allocations with
  potentially differing provenance.

  While testing the changes in this PR, I also started digging into
  what seemed to have been long-standing issues on Windows concerning
  function pointer comparison tests for bindings to UCRT routines.

  Further comments on that PR can be found in another item of this
  section of the report.

- [rust-lang/libc#5062][5062] _windows: expose `cfg` for 64-bit
  `time_t`_

  This PR was one of the Windows PRs that followed up from my work
  before being selected for GSoC. It addressed the fact Windows x86
  targets using GNU's libc implementation exposed a 32-bit `time_t`
  instead of a 64-bit `time_t`.

  We can't just break users by changing this data type, a few PRs
  (including this one and others commented on in this report) ensured
  users both had a way to opt in to the correct behavior or otherwise
  had 32-bit routines linked.

  The former was the goal of this patch. It reused one of the existing
  `cfg`s we had for similar purposes under GNU/Linux systems, such
  that users could toggle that by passing it to an invocation of the
  Rust compiler.

- [rust-lang/libc#5127][5127] _fuchsia: clean up module_

  This was a fairly large patchset that I initially set out on as part
  of my `time_t` and LFS goals, but that easily went on to be a
  partial verification of most of the bindings we provide for the
  Fuchsia operating system.

  There's not much to comment here. This was possibly the PR that took
  the longest to merge, as it had to go through multiple reviews,
  painful source control history clean ups, and had to get approval
  from the target maintainer.

  For details on the specific changes, see the PR and the each patch's
  accompanying message.

- [rust-lang/libc#5128][5128] _build: add `rust-toolchain.toml` file_

  This was a PR I opened while working on other stuff in the repo, and
  noticing that the build setup for contributors wasn't quite as
  declarative as I would like it to be.

  I myself build a bunch of software from source through the Nix build
  system and package manager. It takes a declarative approach to
  package management that ensures you get reproducible builds across
  runs and (sometimes) machines.

  In rust-lang/libc, though, we contributors seemed to be needing to
  set up manual toolchain overrides to get scripts using `nightly` to
  pass. I thought this could be improved by having a `rust-toolchain`
  file.

  `rustup` (the Rust toolchain and component manager) can detect this
  file and either switch or otherwise install the toolchain specified
  in that file. This is automatic and ensures the user doesn't have to
  worry about overrides.

  What I failed to realize was that this file is also considered to be
  a form of commitment to downstream users on the toolchain required
  for the project to even build in the first place.

  Users also clone this repo by virtue of this being open source
  without necessarily wanting to hack on it, so using that file as a
  form of developer tooling wouldn't quite cut it. That's why this PR
  got closed without merging.

- [rust-lang/libc#5129][5129] _vxworks: add `cfg` to definition of
  `off64_t` and `off_t`_

  This PR was initially part of my main goals during GSoC to address
  LFS types. In this case, it affected VxWorks targets, but the target
  maintainer eventually expressed that they would rather keep these
  symbols.

  This patch then got repurposed into a small clean up. It removed
  some stubbed symbols that returned errors in our bindings because
  they didn't really exist in the SDK shipped upstream.

  It also removed symbols that were only available when programming
  against the kernel. The target maintainer confirmed that, at least
  in the short term, Rust support in VxWorks would be limited to RTPs
  (Real Time Processes) and not kernel applications.

- [rust-lang/libc#5130][5130] _TEEOS: Change the definition of
  `time_t` to `i64`_

  This PR was another one of the the changes that I made as I went
  through all supported targets looking for defects in the types we
  used in our bindings for both `time_t` and LFS.

  There's not much to comment here. What I initially submitted was
  exactly what got merged in the end.

- [rust-lang/libc#5131][5131] _refactor: adjust definition of `off_t`
  in wasi_

  This PR was another one of the changes that I deemed necessary while
  verifying that all of our LFS-related types fit those exposed
  usptream. There's not much to discuss here; What I initially
  submitted was merged as-is.

- [rust-lang/libc#5132][5132] _newlib: fix definition of `time_t` and
  `off_t`_

  This PR submitted another patchset to more accurately map the types
  used in our bindings to those used in upstream projects using
  newlib. This PR took a while to merge and it went through multiple
  revisions.

  The issue was two-fold; (1) I submitted too large a patch and that
  had to undergo multiple source control history clean ups, and (2)
  newlib is not tied to any particular target but rather used by
  multiple targets.

  newlib is a minimal libc implementation that is used by a number of
  tier 2 and tier 3 Rust targets often working in either embedded
  environments or otherwise slightly exotic contexts. Getting
  confirmation on all the changes took a while.

  On my side of things, I realized as time went on that I had made a
  few mistakes on the bindings, and so had to both go back and fix
  those, as well as report on the issue thread clarifying what the new
  set of changes were.

  The changes that eventually got merged were a mix of clean ups
  unrelated to LFS, and of a small change to both RTEMS targets and PS
  Vita targets concerning LFS.

- [rust-lang/libc#5142][5142] _emscripten: deprecate file offset
  types_

  This PR was part of my two initial goals on GSoC for verifying the
  "correctness" of the types we used in LFS bindings. Between this
  patch being submitted and it getting merged, discussions took place
  across other issues and PRs.

  We eventually settled for "marker" comments instead of deprecation
  notices, so the initial patch only got modified in that respect. The
  plan here (and in other similar PRs) is to avoid mass deprecation
  from forcing users into allowing warnings.

  The solution my mentor came up with was to instead have them all
  annotated with a simple `FIXME` comment that would be used later on
  to find+replace those with actual deprecations once we neared the
  1.0 release.

  Otherwise, having these deprecations scattered throughout stable
  0.2.x releases just doesn't quite make for an easy time updating
  dependencies in downstream crates.

- [rust-lang/libc#5144][5144] _linux(uclibc): move definition of
  `time_t`_

  This PR was remade from an older patch I submitted making extensive
  changes to our bindings to the uClibc implementation of libc. The
  changes were aimed at having an accurate definition for `time_t`
  fitting upstream's build-time options.

  This got eventually refactored into a patch that used a recent patch
  by another contributor adding support for the one build option that
  I used in my initial patch. That PR got merged first, and addressed
  only a subset of uClibc targets.

  I remade my PR into extending that to support all uClibc targets, as
  the afore-mentioned build-time option is available no matter the
  target triple combination.

- [rust-lang/libc#5164][5164] _fix: remove conflicting items in L4Re
  uClibc_

  This PR I submitted while working on reviewing all targets, and more
  specifically, once I reached the Linux-like targets. I noticed some
  mismatches between the types that we made available under L4Re, as
  we share some of those with Linux.

  Thankfully, another contributor noticed that there was already a
  larger PR addressing some L4Re-specific facts, and among the changes
  in that patchset, mine were already included. I closed the PR after
  checking that one out.

- [rust-lang/libc#5165][5165] _linux(uclibc): remove redundant records
  and explicit linking to `libutil`_

  This PR I initially submitted a patchset for that didn't quite pass
  muster. I added support for a new `cfg` that mapped to an upstream
  build option, but that was something we eventually decided against.

  Among our final discussions, we settled for splitting the patchset
  into two; One containing uncontroversial changes that would ensure
  our bindings fit those of a defualt build of uClibc, and another one
  necessitating maintainer approval.

  The latter one is still pending at [^16]. The target maintainers are
  yet to answer to that one, and I'm currently assuming this to be low
  priority as our current bindings work just fine with the default
  uClibc build options.

- [rust-lang/libc#5170][5170] _linux(musl): deprecate LFS64 bindings_

  This PR deprecated the LFS types we used in our musl libc bindings,
  such that we could soon remove them altogether. Upstream makes no
  difference whatsoever between targets with a 64- or 32-bit machine
  word size, so they're always 64 bits.

  This, like many other PRs, got refactored into using `FIXME`
  comments instead of adding deprecation warnings. These are part of a
  larger plan to mark the items that we plan on removing, but only
  deprecate them once we near 1.0.

- [rust-lang/libc#5173][5173] _l4re: change bit widths of file offset
  types_

  This PR was originally held off almost as soon as it was submitted
  because we thought it best to first address the other uClibc PR.
  That one got eventually merged (though the larger part of the patch
  got split into another, still open, PR.)

  The latest revision of this PR adds deprecation notices to types,
  and at least at the time of writing, it seems like these are
  actually getting deprecated and not just marked for future
  deprecation.

  Still, some stuff around testing and symbol availability on the C
  side of things needs further discussion with the target maintainers.
  That's currently ongoing.

- [rust-lang/libc#5178][5178] _android: deprecate file offset types in
  targets with 64-bit abis_

  This PR addressed the fact that Android targets with a 64-bit
  machine word size are getting LFS-suffixed types exposed even though
  their unsuffixed types are already equivalent.

  The initial patch added deprecation warnings, but the revision that
  eventually got merged uses `FIXME` comments to ensure we can easily
  deprecate those items once we actually near the 1.0 release.

- [rust-lang/libc#5180][5180] _feat: add macro to declare unstable
  constants_

  This PR I submitted while working on deprecating constants. Unlike
  the LFS matters, these we didn't plan on ever deprecating, but
  rather on documenting for downstream users to take note of potential
  breakage.

  I thought it would be best if the type of unstable symbol I went
  through in the PRs concerned with constants got a dedicated macro
  with which to automatically annotate it with a documentation comment
  to indicate its unstable guarantees.

  This wasn't quite a great idea, and the increased maintenance burden
  was not worth it. The PR got subsequently closed. The discussion for
  this, though, took place in a separate issue/PR thread.

- [rust-lang/libc#5213][5213] _fuchsia: propose `sigaction`
  definition_

  This PR I submitted while working on the Fuchsia PR. It stemmed off
  of discussions on its comments with my mentor. The goal here was to
  propose another solution for the, to this day, still faulty bindings
  we have for `sigaction`.

  This type is one that we've had trouble with across most Unix-based
  targets, and we've yet to find a good solution for it. The main
  issue is in that almost every target has some other symbol that
  casts integer literal `0` to this type.

  In theory, this type is an alias to a function pointer in C, but
  that means a cast such as the above would get you a null function
  pointer. In Rust, there's no way of getting that without immediate
  Undefined Behavior.

  Matters concerning "raw function pointers," akin to the existing raw
  pointers Rust has to deal with, among others, situations like this
  one, are being discussed in rust-lang/rust. They're still a WIP,
  though.

- [rust-lang/libc#5219][5219] _freebsd: fix docs links and wording_

  This PR I submitted while we were finally merging the patchsets
  concerning constant deprecations. Those eventually settled for
  documentation, such that users would be advised against expecting
  any form of stability.

  As those PRs were being merged, both me and my mentor noticed some
  issues in the wording of those docs. This PR fixed most of those.

- [rust-lang/libc#5227][5227] _Windows MSVC/GNU function pointer check
  issues_

  This issue I opened as part of my initial work on Windows. After
  testing out the changes I made for those PRs concerning `time_t`, I
  started looking into why is it that function pointer tests had been
  failing for some time now.

  I didn't quite find out much until two other contributors came in
  and further explained the potential reason behind the failures. As
  it turns out, Windows has some funny ways of handling calls to
  symbols defined in external DLLs.

  By default (without enabling global optimization) in MSVC, a call to
  a symbol in an external DLL will be lowered to essentially two
  instruction jumps. The first one goes to the Import Adress Table of
  the executable.

  This table is akin to the Global Offset Table in ELF and basically
  serves to have the loader switch fewer pages when resolving the
  addresses of symbols that can only be determined at runtime (like
  DLLs.)

  This table contains a set of stubs that don't point to jack, but to
  which there's pointers from each call site in the binary containing
  the table. At runtime, the loader ensures those table slots get
  filled in with the function pointers from the DLL.

  This doesn't quite cause any issues for users, but when comparing
  function pointer addresses, we end up comparing the address of the
  stub instead of the value stored in the stub (which contains the
  address of the function pointer in the DLL.)

  The solution to this is to explicitly link with a dynamic library in
  Windows, such that the resulting codegen on the Rust side of things
  gets things right. The issue is that we would like to avoid that for
  the 1.0 release.

  Currently, in Rust we need to always explicitly link with a library
  to be able to specify the codegen we want once each call site gets
  lowered to assembly. That conflicts with our eventual goal of
  getting rid of all explicit linking in rust-lang/libc.

  After reading through some issues and possible solutions in
  rust-lang/rust, I found a two-year-old proposal that tried to add
  support for specifying the library kind without specifying a library
  with which to link in the target system.

  This is currently pending language team approval. Both my mentor and
  the original author of that proposal have shown interest in solving
  things this way, so it's likely this will eventually become the
  solution.

- [rust-lang/libc#5242][5242] _hurd: clean up module_

  This was one of the PRs I opened as part of my going through all
  targets' bindings, ensuring there were no issues with their LFS
  types nor `time_t`. This patchset, though, like some others,
  eventually became a general clean-up.

  As I went through the bindings and cross-referenced them with those
  of the upstream repo, I noticed there were some other issues in the
  way we handled some of those bindings.

  This took quite a while to merge because it went through a bunch of
  back-and-forth with the target maintainer, as well as with my
  mentor. Multiple reviews later and a bunch of source control history
  clean ups later, it got merged.

  Admittedly, this would have taken far less work on the reviewers'
  side of things if I had started off by splitting the patchset into
  smaller chunks (possibly across different PRs.)

- [rust-lang/libc#5245][5245] _nuttx: clean up module_

  This PR was part of the my review of bindings for all supported
  targets and, in this instance, affected Apache's NuttX operating
  system. Most the bindings here were unaffected.

  The initial patch for this PR was extensively modified after a few
  reviews with both my mentor and the target maintainer. The changes
  that affected symbol availability were mostly reduced to none.

  The initial patch included adding support for two build-time
  configuration options that NuttX allows setting up in their
  implementation of libc.

  The fact those were non-standard meant we decided against supporting
  them, as it isn't libc's place to take into account all possible
  build-time options a given target supports.

- [rust-lang/libc#5248][5248] _build: replace checking for host `cfg`
  with checking for target `cfg`_

  This PR I opened while working on other patchsets and noticing that
  there was something odd with the way in which we were setting up a
  target-dependent piece of logic in our test crate's build script.

  Apparently, we had been checking for a compile-time property in the
  host machine's instead of in the target, which thus far hadn't given
  us any issues but would've quite surely bitten us back later on.

- [rust-lang/libc#5259][5259] _aix: clean up module_

  This was one of the patchsets I submitted while going through all
  supported targets, ensuring they didn't have mismatched `time_t`
  definitions and that LFS functionality was correctly bound.

  As it happened with other patchsets, this ended up spiralling out
  into a full-on clean up of the module where we keep these bindings,
  and that eventually got split into three separate PRs.

  The first few reviews from both my mentor and the target maintainer
  were made on the original patch. As mentioned above, that one got
  split; Out of the three current PRs, one has been merged.

  The one that got merged only added some `FIXME` comments for LFS
  symbols such that we can more easily mass-deprecate those once we
  near the 1.0 release.

  The other ones, including this one, need further review from the
  target maintainer (see [^20] for the other pending PR and [^21] for
  the patchset that got merged.)

- [rust-lang/libc#5276][5276] _memchr signature invites mutability
  bugs_

  This issue I hadn't initially planned on tackling as it's quite new
  and I've been so far addressing fairly old issues. I don't remember
  why I decided to pick this one up.

  Initially, I was against the change proposed by the contributor
  because I believed we were simply meant to provide C bindings,
  without caring at all for soundness.

  But then I read through all major draft proposals in the C ISO
  standards, and realized that there were some issues in the way we
  handled the `memchr()` signature with respecto the latest C23
  revision.

  In C23, ISO WG15 decided it would be best to address the fact that
  this routine takes and returns a pointer to the same allocation,
  without specifying the const-qualification of the pointer.

  In Rustland, fetching a raw const pointer to some allocation should
  under all circumstances be avoided from being cast into a raw
  mutable pointer, lest that allocation could be safely and mutably
  aliased at call site (e.g. through a regular reference.)

  But the signature doesn't encode those semantics, and it's unlikely
  that users have read through the relevant sections of the C
  standard. I proposed three solutions in the issue thread.

  This is pending an answer from my mentor or some other
  rust-lang/libc maintainer.

- [rust-lang/libc#5325][5325] _freebsd: move `net/if_mib.h` to
  `src/new` module_

  This PR is a follow up to another stale PR that added support for
  `netlink` bindings in FreeBSD targets. The stale PR's author didn't
  mind me picking it up and they still had interest in this getting
  merged.

  The reason why this PR got stalled in the first place was that it
  needed more than just adding the bindings to make things work. This
  one introduced a symbol resolution conflict.

  The `netlink` bindings in FreeBSD provide symbols that effectively
  map to the same symbols as those of the `if_mib` interface. In C,
  you can just take care of not including the two headers at once.

  In Rust, that won't do; We reexport at the crate root all items
  declared in private submodules. My mentor outlined a plan for this
  not too long ago on the original PR, and I executed on it.

  The changes were divided into two patches; One moved the `if_mib`
  bindings (which already existed) into our `new` module (which keeps
  them all more aligned with the same structure as used upstream.)

  This PR carried the patch that did that.

  The other change (which didn't yet get merged) lives at [^17]. That
  one deals with the `netlink` bindings. It also implements a bit of a
  workaround in our test infrastructure to get both interfaces tested.

  Once the above is merged, the `netlink` interfaces will be exposed
  in a public submodule, while the `if_mib` interfaces will continue
  living as the "default" crate-root-exported interfaces.

  As 1.0 approaches, we'll switch to having both the `if_mib` and
  `netlink` modules be public submodules, and once we hit 1.0, the
  default set of root-exported symbols will be removed.

  The fact that our current support for testing submodules without
  reexporting their items is limited in ctest, has sparked some debate
  in this issue [^18]. I also discussed it some there.

- [rust-lang/libc#5345][5345] _linux: complete `siginfo_t` definition_

  This PR I submitted while solving another old-time issue [^19]. This
  one was fairly simple to solve, but it's not yet merged because
  we're trying to move the definition to our `new` submodule.

  The history with this type and other `signal.h`-related types is
  that there are a bunch of target-specific and macro-dependent
  definitions that we had to replicate from upstream.

  The difference with usptream is that the maintenability of our
  current module organization is hard in these cases. As soon as some
  definition needs special-casing, the definitions across all sibling
  nodes in the module tree now also need special-casing.

  That's why, on top of completing the definition of the type to
  reflect the right fields from upstream libc implementations used on
  Linux, this patchset also moves it to the `new` submodule.

  We keep there a module structure that more closely matches that of
  each upstream repo for a given target's libc implementaion.

- [rust-lang/libc#5347][5347] _t1 t2 lookup in ctest-test_

  This PR I didn't author myself but did get pinged on to provide some
  feedback as some other contributor had been redirected to me. I gave
  what little advice I could, and pinged back my mentor.

- [rust-lang/libc#5351][5351] _crate: clean up leftovers from
  pre-rustc 1.19 without `unions`_

  This PR solved another old-time issue concerning the transition
  towards using native Rust `union` types instead of workarounds for C
  `union`s.

  For a few years now, Rust has had support `union`s as built-in data
  structures, so the issue really only needed some small-time
  clean-ups and some unfortunate breaking changes.

  Those are merged now.

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
[4867]: <https://github.com/rust-lang/libc/issues/4867>
[5008]: <https://github.com/rust-lang/libc/issues/5008>
[5010]: <https://github.com/rust-lang/libc/issues/5010>
[5032]: <https://github.com/rust-lang/libc/issues/5032>
[5050]: <https://github.com/rust-lang/libc/issues/5050>
[5059]: <https://github.com/rust-lang/libc/issues/5059>
[5062]: <https://github.com/rust-lang/libc/issues/5062>
[5127]: <https://github.com/rust-lang/libc/issues/5127>
[5128]: <https://github.com/rust-lang/libc/issues/5128>
[5129]: <https://github.com/rust-lang/libc/issues/5129>
[5130]: <https://github.com/rust-lang/libc/issues/5130>
[5131]: <https://github.com/rust-lang/libc/issues/5131>
[5132]: <https://github.com/rust-lang/libc/issues/5132>
[5142]: <https://github.com/rust-lang/libc/issues/5142>
[5144]: <https://github.com/rust-lang/libc/issues/5144>
[5164]: <https://github.com/rust-lang/libc/issues/5164>
[5165]: <https://github.com/rust-lang/libc/issues/5165>
[5170]: <https://github.com/rust-lang/libc/issues/5170>
[5173]: <https://github.com/rust-lang/libc/issues/5173>
[5178]: <https://github.com/rust-lang/libc/issues/5178>
[5180]: <https://github.com/rust-lang/libc/issues/5180>
[5213]: <https://github.com/rust-lang/libc/issues/5213>
[5219]: <https://github.com/rust-lang/libc/issues/5219>
[5227]: <https://github.com/rust-lang/libc/issues/5227>
[5242]: <https://github.com/rust-lang/libc/issues/5242>
[5245]: <https://github.com/rust-lang/libc/issues/5245>
[5248]: <https://github.com/rust-lang/libc/issues/5248>
[5259]: <https://github.com/rust-lang/libc/issues/5259>
[5276]: <https://github.com/rust-lang/libc/issues/5276>
[5325]: <https://github.com/rust-lang/libc/issues/5325>
[5345]: <https://github.com/rust-lang/libc/issues/5345>
[5347]: <https://github.com/rust-lang/libc/issues/5347>
[5351]: <https://github.com/rust-lang/libc/issues/5351>
[^2]: <https://github.com/rust-lang/libc/issues/5265>
[^3]: <https://github.com/rust-lang/libc/issues/5384>
[^4]: <https://github.com/rust-lang/libc/issues/5325>
[^5]: <https://github.com/rust-lang/libc/issues/5326>
[^6]: <https://github.com/rust-lang/libc/issues/5375>
[^7]: <https://github.com/rust-lang/libc/issues/5390>
[^8]: <https://github.com/rust-lang/libc/issues/570>
[^9]: <https://github.com/rust-lang/libc/issues/1018>
[^10]: <https://rust-lang.zulipchat.com/#narrow/stream/233931-xxx/topic/Split.20the.20.60-openbsd.2A.60.20targets.20by.20version.20compiler-team.23916>
[^11]: <https://github.com/rust-lang/rust/issues/160739>
[^12]: <https://rust-lang.zulipchat.com/#narrow/stream/233931-xxx/topic/Encode.20OpenBSD.20.60-current.60.20version.20in.20tar.E2.80.A6.20compiler-team.231018/with/611628084>
[^13]: <https://github.com/rust-lang/libc/issues/468>
[^14]: <https://github.com/dybucc/libc/commits/change-type/>
[^15]: <https://github.com/rust-lang/libc/issues/1273>
[^16]: <https://github.com/rust-lang/libc/issues/5315>
[^17]: <https://github.com/rust-lang/libc/issues/5326>
[^18]: <https://github.com/rust-lang/libc/issues/5344>
[^19]: <https://github.com/rust-lang/libc/issues/716>
[^20]: <https://github.com/rust-lang/libc/issues/5380>
[^21]: <https://github.com/rust-lang/libc/issues/5382>
[^22]: <https://github.com/dybucc/libc-constant-deprecator>
[^23]: <https://rust-lang.zulipchat.com/#narrow/channel/421156-gsoc/topic/Project.3A.20libc.3A.20transition.20differing.20bit-width.20time/with/616718790>

= Challenges and the learning experience

This summer was quite definitely the one in which I learnt the most
about project maintenance. Back when I first started off, I thought
all that mattered was delivering correctness in the implementation.

After many reviews across most of the patchsets I submitted, I've been
slowly learning about the way Rust guarantees as much stability as
possible across the table.

Though I personally would still completely break my entire API if I
think it's best that I start from scratch, and I could not care less
about downstream consumers of my library.

This summer I also learnt that the BSDs align far better with my take
on project maintenance than does, say, Linux. They care not about
breakage, and will do what's best to keep the system lean and mean.

Still, I see the value in stability, and there's a reason why the 1.0
stability commitment from foundational Rust crates is known across
other language ecosystems.

One thing that I can say I was impacted enough by that I changed my
mind on was the importance of discussion prior to implementation. I've
always thought that almost all talk is useless small talk.

I've also always thought that text is mostly filler needed for
bureaucratic reasons. I even overstepped my boundaries in a certain
discussion on Zulip when the MCP concerning OpenBSD targets was being
discussed.

But thankfully my mentor had more patience with me than I probably
would've had in their place. Time and again, changes that I thought
were ready or could be immediately executed upon, were proven to
require more careful thinking.

Hopefully, I'll keep getting better at this patience business.

This summer I also learnt about the _Compile Farm_ project and the
AnyVM CI service. The former allowed me to cross-reference headers
from closed-source platforms like AIX and to test on more exotic
platforms like the GNU Hurd.

The latter is now another tool I can keep under my belt to consider
for testing on target OSs such as the GNU Hurd or any modern flavor of
the BSDs.

I also got to properly set up SSH authentication as I had to use this
to access the remote machines that cfarm provided. That was overall
quite fun to mess with.

The things I learnt from researching the Windows function pointer
issues were also quite interesting. My knowledge thus far had been
limited to the way ELF does things, so this was my first exposition to
both the COFF and PE formats.

Beyond that, I can only thank enough my org admin, Jakub Beránek, my
mentor, Trevor Gross, and Google for giving me this chance to be
involved and work with a Rust Foundation project.

#bibliography("bib.yml")
