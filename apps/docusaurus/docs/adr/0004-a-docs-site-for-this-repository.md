# ADR 0004 — A docs site for this repository

- **Status:** accepted (2026-10-15) — option A, ahead of its own trigger; see *Decision*
- **Date:** 2026-09-07, decided 2026-10-15
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

## Decision

**Option A, taken on 2026-10-15 by Fabio — and taken against this ADR's own trigger.** The
trigger above says to revisit at about three skills; `skills/` holds one. The override is
deliberate and recorded here rather than smoothed over: the reason is not that the content now
asks for a site, it is to bring this repository onto the same model as `shared-platform` — one
Nx workspace shape, one docs plugin, one CI toolkit across the repositories
([ADR 0008](./0008-agentic-workspace-on-the-shared-platform-model.md)). The argument *"the
decision buys nothing now"* still holds, and is accepted as the price of that alignment.

What was adopted, and where it departs from the plugin's generated output:

- `@fmmenchi/nx-docusaurus` **0.0.20** (not the 0.0.19 named above), generating the site under
  `apps/docusaurus` with its `site` generator.
- **The site has the generator's standard shape, the same as `shared-platform`'s and devmate's:**
  one docs instance over the co-located `apps/docusaurus/docs/`. Fabio chose symmetry across the
  three repositories over keeping files where they were, so the human documentation that is
  this repository's own moved into it: the ADRs to `docs/adr/` (this index became
  `docs/adr/index.md`) and the skill reviews to `docs/reviews/`
  ([ADR 0008](./0008-agentic-workspace-on-the-shared-platform-model.md)). Commit messages written
  before the move still name `doc/adr/`; they are history and stay as they are.
- **The skills are linked, never copied.** The home page links each skill to its `SKILL.md` on
  GitHub. A skill directory ships whole (ADR 0006), so it gains no site file, and a copy in the
  site would be a second source that drifts. `README.md` stays at the root, where GitHub shows
  it; the home page is adapted from it and links to it.
- The generated site depends on the plugin as `workspace:*`, which only resolves inside
  `shared-platform`; here it is the published version.

The question this ADR left open — whether GitHub Packages is readable from this repository's CI —
is **still open**. The install passes the job's token with `packages: read`; whether the
package grants this repository access is a package setting in `shared-platform`, and only the
first CI run answers it.

## Consequences

[ADR 0002](./0002-node-serves-the-repository-never-the-skills.md) holds: the site reads the
skills, and nothing in a skill reads the site. No file under `skills/` changed.

The docs build becomes a gate: `onBrokenLinks: 'throw'` turns a dead link between ADRs into a
red build, which nothing checked before. A link from the site to a skill or to the README
points at GitHub, and that check cannot see it. It runs in CI and in the definition of done, not in the
`pre-push` hook, which stays bash and Node-only and fast.

The cost is the one the context named: `pnpm install` now pulls a docs toolchain, and needs a
GitHub Packages token, for a repository whose shipped content is Markdown and bash. That includes
a clone that wants nothing but the commit hooks.
