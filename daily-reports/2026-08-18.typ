#import "../template.typ": *

#show: template.with([Daily report (2026-08-18)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was again only focused on the GSoC work product.

This time I've finished up reviewing the whole document again, removing the
original version of the document from the repo README, tweaked some the
stylesheets to make the references more readable, and started looking into the
Zulip API for scraping my daily reports.

The first thing I did was to address some of the remaining PR comments that
yesterday still hadn't had their headings linking to the relevant issue/PR.

Then I proofread the report again and found a few mistakes in both the way I was
phrasing some stuff as well as the accuracy of the events retold.

Afterwards, I realized the spacing between items in the bibliographic reference
was too tight to comfortably associate which link belonged to which reference. I
tweaked some the stylesheets for that, but that took longer than expected (I
barely knew css before this.)

The last thing I did today was to start looking into scraping the daily reports
in this Zulip thread. I plan on then reformatting them from Markdown to Typst
and to serve them as subpages in the report's site.

I first tried to see whether there was an easy solution from Zulip's own
settings. Maybe there'd be some settings page to export your messages or even
narrow them down to a single stream.

Apparently, doing this is only possible through one of the Zulip API endpoints,
for which I'll have to use my account as bots seem to be disabled in the
rust-lang instance.

I've started working on this, but I've decided to do it in OCaml (which I have
little experience with) and it's taking a while to read through the docs of
relevant HTTP client and JSON marshaling libraries.

= Blockers
None.

= Plan for the week
I expect the scraping work to take a few days for two reasons: (1) I have only
ever implemented applicative data structures and algorithms in OCaml, and (2) I
would like to use effect handlers (I've also recently started studying Kleisli
categories, which tie in with this quite nicely.)

Beyond that, I'll just keep answering to feedback on open PRs and issues, until
next week, where I'll hand in the report and keep working on new issues.
