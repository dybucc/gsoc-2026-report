#import "../template.typ": *

#show: template.with([Daily report (2026-06-08)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was centered around finishing up the first goal set for this week and
starting work on the second goal concerning testing in target triples using
uClibc. The former involved going through all open PRs with deprecated symbols
and creating new PRs that are not meant for stabilization and instead remove the
constants.

There was a fair bit of work involved in removing the symbols, but it was purely
mechanical so it was half finished in a few hours. The only trouble found while
removing the symbols and updating them in the SemVer-tracking files, was that
there were other symbols (not meant for deprecation) that depended on them. This
was solved by also removing those transitively deprecated items, though this may
very well not be the way out. There were even entire routines that had to be
completely removed from the exposed bindings. Because these changes were a bit
flaky, the removed symbols have not been included in the deprecation PRs (with
`allow(deprecated)`,) as they could end up being excluded from the final patch.
Input from Trevor Gross would be appreciated here.

Once that was finished and CI passed, work moved on to reading the docs for
OpenADK. This tool had been found last week and seemed to be a good fit for our
multiplatform (emulated) testing purposes. It packages a bootloader image, a
Linux kernel and a custom C library implementation in different types of images
(among them, ones usable in QEMU) to lessen the hassle of setting it all up. The
goal here would be to finish up the PR that was opened last week concerning
uClibc in Linux. That had been put on halt during the weekend to focus on
testing on more exotic platforms the changes made in the patch for newlib. That
was finished yesterday.

So far, the manual seems clear, but no images have been successfully built just
yet. Running OpenADK already required setting up a virtual machine as the
program was not compatible with my host system. After setting up a Linux VM and
preparing all the requirements, the tool started having some issues with symbol
availability between static and shared libraries available in the host system
(the VM.) Still, hope is far from lost, as it's quite possibly related to some
settings that got tweaked in the `make` scripts which should've likely been left
with their default values set. At the time of writing, it seems to not have
bailed out as early as before, but the latest `make` run hasn't finished yet. No
progress can be reported either because `stdout` and `stderr` had to be
redirected to a local file to inspect possible errors in a pager later on (as
the VM it's running on is on a VTTY.)

Beyond that, work has also gone into updating some other PRs in the `libc` repo.
This invovled both rebasing to latest `main` and changing a few things in the
submitted patches from received feedback. Last week, a fairly unrelated PR had
been opened that would make the formatting experience for onboarding
contributors a bit smoother. Previously, the `.rustfmt.toml` would be configured
with unstable settings that required a nightly toolchain, which sometimes made
PRs not pass the CI style check. This forced contributors to set up a toolchain
override with rustup or otherwise change their default toolchain (if it wasn't
already nightly.) The PR addressed this by introducing a `rust-toolchain.toml`
tracked upstream, which also required a few changes on CI to ensure workflows
that did not require the nightly toolchain didn't wrongly use it.

One of the PRs concerning deprecation has been approved by a maintainer, so
there's hope in the rest of them getting merged soon.

= Blockers
None at present.

= Plan for the week
This week was meant to start the bit-width transition. That has already seen
great progress from last week's efforts, where all top-level modules but the
`unix` module were finished. The expected timeline in the proposal sets a hard
cap on week 7 of the "coding period" for the transition. This is very much
feasible. There have been so far a few platforms that made work on them take two
to three days (which shouldn't be the case) but those have always been met with
deadlines of their own (as commented in prior reports.) The same can be said
about the current efforts centered around uClibc. If OpenADK does not build a
working QEMU image by one day and a half from now, then testing on the platforms
affected by the corresponding PR will be put on halt.
