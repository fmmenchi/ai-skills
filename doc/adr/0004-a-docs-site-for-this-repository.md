# ADR 0004 — A docs site for this repository

- **Status:** proposed (2026-09-07) — deliberately open
- **Date:** 2026-09-07
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`shared-platform` publishes its human documentation and its ADRs through a Docusaurus site under
`apps/docusaurus`, driven by `@fmmenchi/nx-docusaurus` — an Nx plugin written here, versioned
`0.0.19`, released independently to GitHub Packages. Its stated purpose fits this repository
almost exactly:

> *generate a Docusaurus site that serves the repository's human docs **directly from their
> source folder** — no copying, no sync, no multi-instance silos.*

Here those docs would be `skills/*/SKILL.md`, `doc/adr/` and `README.md`.

The question is not whether the plugin works. It is what the site costs, and whether there is
anything to publish yet.

## Options

**A — the Nx plugin.** One command scaffolds it, the docs are served live from their source
folder, and a fix to the plugin helps both repositories. Requires an **Nx workspace**: `nx.json`,
the plugin as a dependency from GitHub Packages, and — since this repository is public — the
question of whether that registry is readable in CI without a token, which is **not yet
verified**.

**B — plain Docusaurus.** No Nx. But it means hand-wiring what the plugin already does, and then
maintaining two divergent Docusaurus configurations, this one and `shared-platform`'s.

**C — no site.** `README.md` and `doc/adr/` are Markdown and render on GitHub already.

## Why this stays open

**`skills/` is empty.** Every option publishes a site with no skills in it today, so the decision
buys nothing now and would be made on guesses about content that does not exist.

One input has already changed since the question was first framed, which is why the ADR exists
rather than a note: [ADR 0002](./0002-node-serves-the-repository-never-the-skills.md) brought
`package.json`, a lockfile and `node_modules` into the repository for the commit tooling. The
argument against A was *"a plugin needs an Nx workspace, and this is six files with no Node"* —
half of that objection is gone. A is more defensible than it was, and B less.

## Decision trigger

Revisit when `skills/` holds enough that a reader would want an index — three is the rough
number, matching the rule that admits a skill in the first place. Before then, this ADR stays
`proposed` on purpose: a framed question is worth more than a decision taken early to close it.

Whatever is chosen must not violate
[ADR 0002](./0002-node-serves-the-repository-never-the-skills.md): a site serves the repository,
and no skill may come to depend on it.
