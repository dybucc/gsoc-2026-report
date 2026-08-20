#import "../template.typ": *

#show: template.with([Daily report (2026-05-08)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work was focused on getting the rendering loop to actually show something
when running the program. This revealed multiple issues, some of which have
already been fixed. Firstly, the compatibility shim that was developed for the
purposes of getting an async writer to work in a sync context turned out
insufficient (apparently, blocking on a future from a runtime spawned within the
future that another runtime is already blocking on is not possible) and was
refactored. Initially, I thought of using a `tokio::rt::Handle` instead of a
`tokio::rt::Runtime`, but that turned out to amount to almost the same thing. I
eventually settled for a sync writer wrapped in a `tokio::sync::Mutex` that I
could hold locked across `.await` points. This decision was made based on the
fact getting a quick solution out was not possible, and the only real need here
is for `crossterm::Command`s to run reasonably efficently. The sync buffer
continues being a `Stdout` instance, which I gave up on locking with
`StdoutLock`, and simply wrapped in a `BufWriter`, itself within the `Mutex` and
`LazyLock` of a static.

After this, I stopped implementing code for the rendering loop and instead went
on to set up `tracing` logs, because something told me I'd need them. Once I got
this to work by writing to a log file on debug builds (which seemed like the
simplest option for a TUI,) I also implemented a small initialization routine to
keep a progress report on cloning the `libc` repo if such thing was needed.
After I finished with this, I started testing the program again, and stumbled
upon two new issues; The path that I passed to the library I implemented for the
core logic is not really being verified to contain the `libc` codebase, and the
program seems to have a severely high CPU utilization. The first of the issues
I've started to work on but have quite definitely not finished, though the
solution is straightforward. Now, the latter issue is the one that, to some
extent, worries me. The debug logs show that beyond the logic that is executed
prior to entering the rendering loop, the program currently is not reacting to
any events (as expected for this week's work, despite having implemented all the
code for it,) but is still overheating my machine on a less than 30 second test
run. This means I'm going to either have to get the rendering loop to sleep and
not consume useless CPU cycles, or otherwise switch to a TUI library that
handles redrawing for me. I am hesitant to go for the latter option, and I think
I can implement a relatively decent one-off solution by switching the event
listening routine from being executed as part of the update to being executed as
part of the actual rendering loop; I believe this way it would just await on
hold until the input handler (itself awaiting) got an event worth sending.

= Blockers
None at present. Today I've got some stuff to deal with in the evening so I had
to submit the report earlier than usual.

= Plan for the week
Considering I'm already working on the rendering loop and more specifically, on
the drawing routine, I believe I should have a solution for the above problems
by the end of the week. This should still accomplish the goal of getting
something reasonable drawn on-screen, even if state-change triggered redraws are
not yet implemented.
