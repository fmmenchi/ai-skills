# ADR 0002 — Node serves the repository, never the skills

- **Status:** accepted (2026-09-07)
- **Date:** 2026-09-07
- **Deciders:** Fabio Menchicchi

## Context and problem statement

The contract required conventional commits and semantic branches, and **nothing checked either**.
Prose is persuasion: it is followed until it is inconvenient, and its breach leaves no trace.

Enforcing it means commitizen, commitlint and husky, which means Node, a package manager and a
lockfile — in a repository that until then was five files of Markdown and one bash script. The
tooling would outweigh the content, and worse, it risked contaminating the thing being shipped:
a skill that needs an install to work is no longer portable, and portability is the property
this repository exists to protect.

## Decision

Node enters, and its reach is bounded explicitly.

- It serves **the repository**: commit tooling, and any future gate that runs here.
- It must never be reachable **from a skill**. A skill is Markdown, plus — where determinism is
  needed — a script that runs with what its reader already has. The moment a skill needs
  `pnpm install`, it has stopped being portable and stops being admissible.

The same bound applies to anything added later: a build step may serve the repository, never the
skills.

The commit-type vocabulary lives in `tools/commit/types.mjs`, read by both commitlint and the
branch-name gate, and is deliberately the **same list as `shared-platform`** — one habit across
the repositories rather than two.

## Consequences

The claim *"Markdown and bash are the whole stack"* is no longer true of the repository, and the
contract now states the narrower thing that is true. The distinction has to be maintained by
attention, because no gate can detect a skill that quietly assumes Node.

A second-order effect, worth naming because it changes an earlier assessment: `package.json` and
a lockfile now exist regardless, so the marginal cost of an Nx workspace has dropped sharply.
The objection that made a plain Docusaurus site look cheaper is weaker than it was — see
[ADR 0004](./0004-a-docs-site-for-this-repository.md).

The hooks that motivated this fail open in silence when a working tree has not been installed.
That is not a reason to skip them, but it means they are advisory: the enforcement that counts
runs in CI. Recorded in `.agents/doc/known-issues.md`.
