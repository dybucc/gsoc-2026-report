# GSoC 2026 work product: The Rust Foundation's `libc` crate

This repository hosts the source files for my final report (also known
as work product) to the GSoC 2026 programme.

To read the report, you have two simple options:

- Read it online at <https://dybucc.github.io/gsoc-2026-report>
- Read it offline through the `index.html` file at `main`'s root

The exact same content can be found by accessing the report through
any one of the above two means.

Alternatively, you may compile the Typst file `main.typ` to produce a
HTML file equivalent to the `index.html` found at `main`'s root.

For that, use the following command on your shell, ensuring file
`bib.yml` is kept in the same directory as file `main.typ`. We assume
the command is being run from the same directory as `main`'s root.

```shell
typst compile --features=html -f html ./main.typ ./index.html
```
