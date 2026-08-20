#import "../template.typ": *

#show: template.with([Daily report (2026-06-21)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Efforts were centered around two things.

The newlib PR is done. This required going through all targets again. I wrongly
used 32-bit file offset types in RTEMS. This is now fixed. I made the
description more terse.

The VxWorks PR came up next. This needed more changes. I originally missed all
file offset types but `off_t`. This is now fixed. A `cfg` has been added to
ensure the right types are exposed. VxWorks has different bit widths depending
on the compiled programs. The following are the possible programs one can
compile.

- A real time process.
- A VxWorks kernel.

Work has started on reviwing the Fuchsia PR. The patch has been again extended.
The original changes were insufficient. Supported Rust targets all have 64-bit
machine word size. The same changes as in android should thus suffice. See the
relevant pr or daily report for details on those changes.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

= Plan for the week
The plan is progressing as expected. The last large PR is the Fuchsia PR. That
will be done tomorrow. It's likely all PRs will be reviewed before Wednesday.
This should leave time to further answer/solve related matters. These are coming
from both my mentor and target maintainers. They're mostly concerned with the
musl and uClibc PRs. The goal for the first half of the week is to solve those.
I should have come back to the `bsd` module half way through the week.
