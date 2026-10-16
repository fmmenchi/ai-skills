# ADR 0008 — An agentic workspace on the shared-platform model

- **Status:** accepted (2026-10-15)
- **Date:** 2026-10-15
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`shared-platform` is where the conventions for an agent-driven repository were worked out: one
`AGENTS.md` hub with topic spokes, an Nx workspace, a Docusaurus site from its own plugin, CI
assembled from its `@fmmenchi/gh-actions` bricks, commitlint and husky. `ai-skills` took part of
that already — the hub and spokes, the commit tooling — and diverged on the rest. Two
repositories with two shapes means two habits, and every difference is a place an agent
carries a rule from one into the other where it does not hold.

Fabio decided to align this repository on that model. What has to be written down is what
"align" includes, and — as much — what it deliberately leaves out, because the model also
carries things that are wrong or that this repository has already fixed.

## Decision

**`AGENTS.md` is the only agent contract in this repository.** No `CLAUDE.md`, and no symlink
to one. Verified at project level: Claude Code loaded this repository's `AGENTS.md` with no
`CLAUDE.md` present. Gemini CLI defaults to `GEMINI.md`, so `.gemini/settings.json` names
`AGENTS.md` as its context file. **Not verified at user level**: `install.sh` still links the
shipped contract as `~/.claude/CLAUDE.md`, and that does not change until it is — recorded in
`.agents/doc/known-issues.md`.

**Agent documentation is indexed, never monolithic.** `AGENTS.md` is a hub; each topic lives in
`.agents/doc/<topic>.md` and is opened only when a task touches it. Every spoke appears in the
hub's index with an *open it when* line, and the hub also points at the human documentation.

**An Nx workspace, entered the least invasive way.** `nx init` with no plugins, no Nx Cloud and
no agent-configuration generation; `nx` and `@nx/devkit` pinned to the versions
`shared-platform` uses (23.2.1); a pnpm workspace whose only member is `apps/*`. The repository
root is itself a project, so its scripts are Nx targets, but `pnpm run check` stays the entry
point of the skills gate: the `pre-push` hook and any consumer pinning `check-skills.sh` run it
without Nx.

**The docs site** is [ADR 0004](./0004-a-docs-site-for-this-repository.md), option A.

**CI uses the `setup` brick of `@fmmenchi/gh-actions`, pinned by commit SHA**, not by tag — a tag
can be moved, a SHA cannot. The job keeps the name `check`, because branch protection on `main`
requires a check of exactly that name, and renaming it would leave every pull request waiting
on a check that never reports.

**Agent settings are tracked; agent state is not.** A tool's project settings are part of the
repository's contract with that tool, and are committed when they carry something real:
`.gemini/settings.json` does. `.claude/settings.json` does not exist, because nothing needs to be
in it, and an empty one would claim otherwise. Per-machine and per-session state is ignored:
`.claude/settings.local.json`, `.claude/worktrees/`, `.cache/`.

### Not copied from the model, and why

- **Skills mirrored as copies into `.cursor/`, `.github/` and `.opencode/`.** This repository
  installs skills by symlink into the user-level directories each tool reads (ADR 0001,
  `install.sh`). A committed copy is a second source that drifts from the first, in the one
  repository whose purpose is to have one. `nx init` offers to generate per-tool agent files;
  that was declined for the same reason.
- **`shared-platform`'s `pre-push` hook.** It checks the branch checked out, not the refs being
  pushed, so `git push origin HEAD:refs/heads/anything` passes it. The hook here was fixed in
  `ca6af02` to read the refs git hands it, and it stays.
- **`CLAUDE.md` symlinks beside every `AGENTS.md`.** Superseded by the first decision above.
- **ADRs inside the docs site.** They stay in `doc/adr/`; ADR 0004 has the reasons.

## Consequences

The Node boundary of [ADR 0002](./0002-node-serves-the-repository-never-the-skills.md) is
unchanged in principle and larger in practice: Nx and a docs toolchain serve the repository, and
no skill may depend on either. `scripts/check-skills.sh` stays bash.

A clone now needs a GitHub Packages token to `pnpm install`, because the lockfile holds a
package from that registry — including a clone that only wants the commit hooks. Without the
install the hooks are not installed either, and they fail open in silence
(`.agents/doc/known-issues.md`), so the cost lands exactly where nothing reports it. CI is the
backstop, and CI needs the same token.
