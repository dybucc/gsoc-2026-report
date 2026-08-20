#import "../template.typ": *

#show: template.with([Daily report (2026-08-05)])

#title(context [#document.title \ #html.aside(css-credits)])

#html.blockquote[This report got out of hand quite badly. It has been left
  untouched from when it was first written, but note that by the time I wrote it
  (at the end of the work day, as usual) I was more tired than I should've been
  to appropriately structure my thoughts without exposing an overly pathetic
  perspective on myself in public.]

#divider()

= Summary
Today work was quite miserable; Solving a ton of Git conflicts on stuff that I
had finished working on between yesterday and this morning.

I started off by finishing up the changes on musl and uClibc concerning
`siginfo_t`. This was not the hard part, though. I then started working on
changes to the Git history, which is where I took the longest time.

As I went through the changes, new stuff starting popping out; Chiefly, impl
blocks that I had forgotten to include in some files. I then decided it would be
best if all commits provided a working revision that actually built.

That took me along another fairly large session of Git rebase conflicts to get a
single commit all the way down to the start of the patchset. The details are not
really worth it.

The last thing I did was to separate the patches that handled actually adding
the bindings to the `new` module from those that remove them from the old but
still prevalent module structure. This took the longest, by far.

I first started off by, just in case, creating new branches off of the original
patchset (pre-reorganizing stuff.) Then I dropped those patches from the PR's
branch, and conflicts starting popping in that rebase session.

This took a while to solve and affected all other patches stacked on top of the
now dropped initial patchset. Then I had more conflicts from the one commit I
decided on putting at the start of the patchset to make all revisions build.

After solving all of that, I started on actually splitting the changes from the
patch that had the `new` organization and the reexports at `new/mod.rs`. That
had a few more conflicts, but those were expected.

All along this, my editor starts experiencing bugs and I have to cherry pick
unmerged PRs from upstream to get a custom build that lets me keep working. This
wasn't that time-consuming (10 minutes + 5 minute build) but it was a waste.

Next thing I do is notice the alarm; It's time for the daily report, and I only
got one PR done today (not even a new PR.)

= Blockers
Beyond dangerously useless days like today, none.

= Plan for the week
Today was catastrophic, and I'm not sure anymore that I can finish tomorrow the
small-to-medium work I mentioned yesterday. If I do, then the plan remains
unchanged because I'll then start looking into the MCP implementation.

If I don't (and this is now very likely) then I will have to extend that period
for one more day. This gets us to Friday. It leaves two days for the MCP
implementation.

I honestly think that's doable, but days like this make me doubt.
