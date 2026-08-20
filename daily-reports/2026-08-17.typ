#import "../template.typ": *

#show: template.with([Daily report (2026-08-17)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused only on the GSoC work product. I also commented on a
GitHub issue I had received some feedback on.

The first thing that I did was to answer to the GitHub issue on which I
commented on concerning glibc. Yesterday I had gathered some information on our
"supported" glibc version.

The commenter mentioned that I was potentially wrong in assuming glibc 2.29 to
be the lowest supported version, because the source I quoted mentioned that the
contextual lines around it would allow Rust binaries to link with glibc versions
lower than 2.29.

I then pointed out that the next two sources I mention in my report include one
comment where a certain interface had been commented out (and thus left out of
our public API) due to it not being available in versions of glibc lower than
2.26.

I simply went for an optimistic guess when saying that we could support glibc
2.29 as the minimum version, seeing as to how the real (minimum) version is
between 2.26 and 2.29. glibc 2.26 is almost 10 years old now.

Either way, we seem to be adding bindings regardless of actual availability, so
it doesn't matter much whether we go for a newer version or an older one (at
least not at this point in the discussion.)

I then went on to finish up the bibliographic work on my GSoC work product.
That's finished now and the end result is fairly satisfactory. I've also
compiled it to HTML and the page is now served in GitHub Pages.

What I immediately noticed while serving the HTML was that it looked quite bad.
I didn't want to add any stylesheets, but just looking at that lump of text was
as daunting as reading through a 100K lines manpage on a 4K monitor.

I don't have the first idea about web development, so I went for the easy
solution. I recently visited this site for a Gopher/HTTP/Gemini client called
Offpunk (Gemini is an application-layer protocol spec a tad bit older than and
completely unrelated to Google Gemini.)

I liked the minimalism and the fact they're attempting to make the "Internet" a
place that is not browsable, but rather a place where one extracts information.
This means no scripting, and a plain enough stylesheet that a terminal emulator
can display it just fine.

I made a few modifications to the CSS, and embedded it into the HTML. I then
started working on "smartly" handling links to issues and pull requests that
were not part of the bibliographic references.

That's a work in progress, but the `typst` logic is done and the only thing left
is to finish the regex with which to find+replace all the labeled headings with
calls to the function in charge of linking.

= Blockers
None.

= Plan for the week
I expect to also spend most of tomorrow working on the GSoC work product. I'm
also considering scraping the daily reports from this Zulip thread and embedding
them as subpages (or whatever this is called in the web world.)

That is likely to take some more time, but I can wait until the 24th for both
feedback from my mentor on the source text, so i believe this can make for a
nicer experience to whoever reads the report.
