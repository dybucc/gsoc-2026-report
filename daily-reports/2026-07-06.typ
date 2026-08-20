#import "../template.typ": *

#show: template.with([Daily report (2026-07-06)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was solely focused on reviewing and making extensive changes to the
AIX patch.

Yesterday everything seemed alright. Indeed, that was in large part due to my
unstable connection to the remote AIX machine from which I was sourcing the
definitions. But today I somehow managed to get a more stable connection.
Apparently, if I switch back and forth between the SFTP mountpoint and some
other directory on my local filesystem, the SSH connection triggers a reconnect.
I have not the slightest idea why that is but i currently don't have the time to
look into it.

With this finding, I decided to go through all commits again, ensuring my
changes were correct. Alas, they were not. The changes that I mentioned
yesterday have already been effected. Only unsuffixed types remain (except in
the cases where the "64"-suffixed types have a different definition.) Work has
also gone into moving the few types that were declared specifically in the
`powerpc64` module back into the top-level `aix` module. This decision was made
after the fact there's only a single supported Rust target with this operating
system.

Then I did a bunch of cross-referencing across routines I had marked with the
large file API `cfg`. Some of them just needed deprecation as they relied on
suffixed (deprecated) types. The fact that we only ever target 64-bit
environments also made me realize that the two other `cfg`s I had added for
configuring the signedness of `time64_t` and for defaulting to 64-bit
definitions on unsuffixed types were not necessary. They have been removed in
favor of the C type definitions (which would yield non-64-bit wide types in
targets whose machine word size was not 64-bits.) There were also quite a few
types I had initially decided to ignore due to my crappy connection to the AIX
machine. Those are being looked into now.

I'm still not satisfied with the end result. This is WIP.

= Blockers
None at present.

= Plan for the week
The AIX work will likely take two more days. The write up for the PR has been
modified but will likleky require further changes. The file references included
in the source list still need updating. Actual work on the patch will likely be
done by tomorrow. Then I will have to reorganize the whole Git shebang. That is
likely going to take an entire day because of the amount of mid-rebase conflicts
I'm going to have to solve as I juggle commits, ammend them, extract
fine-grained patches into separate commits, etc. I expect the PR to be opened in
three days' time.
