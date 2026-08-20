#import "../template.typ": *

#show: template.with([Daily report (2026-07-04)])

#title(context [#document.title \ #html.aside(css-credits)])

= Summary
Today work has been centered solely on one thing; Starting to cross-reference
the AIX headers with our bindings.

We currently support only one AIX target, and that's a 64-bit PowerPC. The first
part of today's work was about getting actual access to the headers. Last week,
I had gotten access to cfarm, and with it came SSH access to one AIX machine
they provide. It just so happened to also be a PowerPC64-compatible target. The
machine also seemed considerably better outfit that the GNU/Hurd machines I had
previously SSHed into. I even thought the SSH experience wouldn't be too laggy.
So I SSHed into the machine. It was as slow as the Hurd machines.

Clearly, this was not going to cut it for the rate of work I needed. I instead
decided to set up an SFTP mount over the SSH connection. What I needed was
access to only one part of the filesystem in the AIX machine; The system headers
(which are not publicly available.) So I started looking into how did `libfuse`
(a library acting as a shim over kernel filesystem interactions in userland)
work on my machine. This took quite a while because it needed me to enable
"untrusted" kernel extensions. There was also a pretty dumb mistake on my side
in the SSH config.

Once all of that was solved, I finally got to mount `/usr/include` from the AIX
remote on my machine. The filesystem operations were still fairly slow. The
connection was also quite unstable, as there seemed to be open issues in the
implementation of `libfuse` on my system. This made it tedious to work with the
mountpoint. Every so often, The connection would just get shut down. So as soon
as I needed to make another regex search on another file, there were no files
anymore. The connection was still supposedly open and the filesystem was still
supposedly mounted. It just so happens that inactivity on the SSH conection
causes unreported disconnection to SSHFS (the program using `libfuse` to mount
SFTP over SSH.) The end result: an ever so slight improvement in my workflow
speed when compared to just SSHing into the machine.

The approach I've ended up taking is to copy over to my machine whatever file I
happen to be inspecting at the moment, then close the SSH connection, and keep a
list of TODOs on which other files I need to look through. Then I repeat with
each of those files, opening up the connection again and mouting SFTP. It's
slow, but it is what it is.

In terms of actual work done, I've so far fixed and added a few type aliases,
added a few configurations for large file support (which was exposing bindings
when it sometimes shouldn't) and gated a few symbols. I've decided against
providing support for anything but the 64-bit Rust target, so any definitions
only available under 32-bit targets have been either skipped or removed.

= Blockers
None at present.

= Plan for the week
The AIX work is likely to take me a while. Not being capable of quickly moving
through the machine's headers is quite a drawback. But at least I've got access
to the headers. I estimate this should take me about two to three more days.
That's, of course, not counting further reviews, the write up for the PR, and
listing sources.
