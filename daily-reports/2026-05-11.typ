#import "../template.typ": *

#show: template.with([Daily report (2026-05-11)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today we got quite a lot of work done with respect to the rendering loop. We
fixed the issue that yesterday I didn't get to fix about the pre-rendering logic
not setting up correctly the cursor position to save for later use in the
drawing routine of the rendering loop. This was fairly simple in that I relied
mostly on using cooked mode instead of raw mode, which as mentioned yesterday,
allowed certain events like line feeds to be buffer flushing triggers. This
seemed to be in odds with the order with which a terminal escape sequence saved
the current position on-screen, and so that has now been fixed. Then we went on
to refactoring some more the error handling module of the core library,
motivated by further changes I made to auxiliary routines to the `scan` public
function, which seemed to be requiring async without really there being a need
for it. These routines were doing purely blocking work, and the task that
launched them was already a separately launched task itself, so going again for
a `spawn_blocking` instead of a `block_in_place` when the blocking operations in
that particular context would be running sequentially did not make sense. The
refactor in the error handling module reflected the now non-existent need for a
synchronization error varint in handling the tasks.

We then moved on to improving the drawing routine, which is now quite fully
featured and correctly reacts to most of the running state we keep. From the get
go, and until now, I have used a two-stage pipeline approach to drawing, which
has meant implementing less type infrastructure than with the `State::update`
routine. It first draws everything on screen (without diffing, for the time
being,) and then moves on to performing a second pass over the buffer that adds
some visual feedback for the user, such as cursor positioning and overall
styling to make navigation reactive. This has been implemented through two sets
of routines; The printers and the finalizers. The former are in charge of the
"static" drawing side of things, ensuring that on entry they always keep the
cursor back in the saved position (the very first column of the prompt.) The
latter set of routines is in charge of going through the constant symbols and
either highlighting the one currentlty selected, or otherwise getting the
regular cursor to change shapes depending on the currently active mode.

After a few test runs, this got all ironed out, and seems to be working decently
well. Along the way, I found some bugs related to the allowed navigation
"bounds" when in the prompt; While in insert mode, navigation bindings were
allowed to move all through the single row that the prompt lives in, even if
there were no characters under the cursor. This was fixed with a single-liner in
the `State::update` method. As I was running some more tests, I also decided to
change the way constant symbols got printed to the terminal buffer by creating a
dedicated type to have all styling needs centralized in it. It is a simple
wrapper around the identifier and the deprecation state of the symbol that
implements the required traits from `crossterm` to make for an ergonomic
combinator-based API, while ensuring that the constant symbols always get
printed to reflect their state of deprecation in the desired formatting.

Finally, once all drawing functionality seemed complete, I've moved on to fixing
the issues with the selection bounds whenever the user extended the selection
from above. This is still a WIP, and I've yet to come up with a good
implementation, but the idea is clear; Beyond the current cursor position and
the range of the selection, there's need for a pivot that keeps track of the
index where the user entered select mode. This was already mentioned a few days
ago when the problem got diagnosed.

= Blockers
None at present.

= Plan for the week
The goal of the week seems to be more than just feasible, and it just also may
be that we are done before Sunday. I am hesitant to belive that I won't find
some nasty bug that will make for some long debugging session, but for the time
being, that has not yet happened. This week's goal was to get the rendering loop
complete, which meant having the drawing calls working correclty and selection
fixed up. The former seems to be doing just fine, and I'm currently working on
the latter. This selection patch is likely also going to require some
refactoring to the drawing routines we implemented today, so there's taht to
look out for.
