#import "../template.typ": *

#show: template.with([Daily report (2026-06-22)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
The day was dedicated to the Fuchsia PR. It required more changes than expected.

There was a plan yesterday. This was to finish with the file offset types. A
downloadable SDK was found for Fuchsia. This revealed a number of
inconsistencies. These went beyond file offset types.

The PR has been remodeled. It now overhauls the entire `fuchsia` module. It's
done. It needs testing. Testing here is necessary. There's Fuchsia tier 2
targets. There's no CI set up for them. Work on this will start tomorrow.

Changes were wide-ranging. Suffixed file offset types don't exist. Neither do
multiple other types. These have not been removed. They have been deprecated.
Nobody should be using them. There's no libc routines that use them. Some
records were defined wrongly. They had incorrect size and/or alignment. They
sometimes also had missing fields. There were inconsistencies across targets.
There were conditional checks for unsupported targets. Those targets are not
supported by rustc. They're neither supported by upstream Fuchsia. Almost
everything is fixed. Some other constants don't exist. They have not yet been
deprecated.

= Blockers
None at present. Testing on MIPS targets with uClibc is pending. These are all
tier 3 targets. This is low priority. Input would be welcome.

= Plan for the week
The plan continues as expected. Fuchsia is done. Testing will be done tomorrow.
Other PRs needing reviews will be done from Wednesday to Thursday. The Windows
PRs remain unattended. Those were not taken into account in this week's plan.
They went overy my head. The `bsd` module will have to wait. The Windows PRs may
take longer. Work should definitely be done by the end of the week.
