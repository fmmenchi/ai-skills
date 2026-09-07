# ADR 0001 — Two contracts, one repository

- **Status:** accepted (2026-09-07)
- **Date:** 2026-09-07
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`AGENTS.md` at the root meant two incompatible things at once.

`install.sh` symlinks it as `~/.claude/CLAUDE.md` and `~/.<tool>/AGENTS.md`, so its contents
apply in **every repository on the machine**. That is the product: the user-level operating
contract this repository exists to distribute.

But `ai-skills` is also a repository someone works *in*, and it has its own gate, its own
commands and its own conventions for writing a skill. There was nowhere to state them. Adding
them to the root file would have installed this repository's build commands into every project
opened on this machine — a failure that is silent and would have been noticed late, in an
unrelated repository, as instructions that make no sense there.

## Decision

Two files, with the names deciding which is which.

- **`contract/AGENTS.md`** — the product. Installed by symlink; applies everywhere. It sits
  beside `skills/`, the other thing this repository distributes.
- **`AGENTS.md`** at the root — this repository's own project contract. Installed nowhere. It
  follows the convention every other repository uses, so an agent opening `ai-skills` finds what
  it expects at the path it expects.

`install.sh` reads the contract from `contract/AGENTS.md` through a single `CONTRACT` variable,
so there is one place to change if the layout moves again.

## Consequences

A project's own `AGENTS.md` being more specific than the shipped contract is now literally true
here as well as everywhere else, rather than a special case this repository had to explain.

The two files must never be merged, and the reason is not obvious from either one alone — so
both say so at the top, and `.agents/doc/architecture.md` opens with it.

Moving the file cannot break an existing symlink today, because `install.sh` has never been run
on this machine and the links do not exist. It **will** break them once it has: re-run
`./install.sh` after any future move. Recorded in `.agents/doc/known-issues.md`.
