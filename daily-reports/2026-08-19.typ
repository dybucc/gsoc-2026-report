#import "../template.typ": *

#show: template.with([Daily report (2026-08-19)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on figuring out the scraping matters and getting a third
of that work done.

I first tried out experimenting with curl and the request format that Zulip
expects. As it turns out, the rust-lang instance seems to have disabled bots,
and apparently also API access.

I tried some more at this, thinking that the authentication error I was getting
back stemmed from an issue on my side, but that didn't go anywhere. So instead I
tried coming at it from a different angle.

I wasn't going to manually copy each message, so I figured that I could instead
perform a regular GET request to the Zulip site. Granted, I first inspected the
returned response body to ensure that Zulip loaded all messages in one go.

Then I automated this as much as I could. I scraped the HTML in one go and
parsed it to then filter it by `class` to ensure I only kept the elements giving
out the dates and the bodies of the messages.

The only unfortunate part here is that, unlike native Zulip API access, I only
get access to the rendered Markdown (as HTML.) I then found a fairly good
converter but I couldn't get their API to work.

To avoid spending more time on the solution to the solution, I decided that I
had automated enough and that I would do the rest of the work mostly by hand.

I now manually perform the conversion from the HTML I gathered into Markdown,
but then use a macro I wrote for my editor to get that output Markdown
automatically converted into Typst (which is simple, given the structured nature
of my reports.)

I'm so far done with all posts from May to early June.

= Blockers
None.

= Plan for the week
The scraper I was thinking on implementing has been reduced to a mere HTML
filter, which has already served its purpose. This is actually great news
because I estimate I should have all daily reports nicely rendered in HTML by
tomorrow.

Then I'll just mention that the reports can be found in a subpage of the main
report's page, which itself will gather links to each entry in the daily reports
(themselves separate subpages.)
