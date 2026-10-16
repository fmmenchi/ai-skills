# AGENTS.md

Operating contract for this repository, and the only one: there is no `CLAUDE.md` and no
symlink to one. This file is the always-on hub: what `ai-skills` is, the commands, the gates that
must pass, and an index of topic rules. Open a `.agents/doc/*.md` spoke only when your task
touches that topic. Human-facing documentation is `README.md` and the docs site in
`apps/docusaurus` — the ADRs, the skill reviews, and a home page linking each skill's `SKILL.md`
— `pnpm nx run @fmmenchi/ai-skills-docs:start` to read it locally.

Do not confuse it with `contract/AGENTS.md`. That file is the **product**: the user-level
contract this repository ships and symlinks into every tool on the machine. This file governs
only work done *inside* this repository and is installed nowhere.

## Project

`ai-skills` — the user-level operating contract plus the few skills no vendor could write for
me, in the Agent Skills open format, installed by symlink and never by copy. Edit a file here
and every tool sees it at once.

A skill is admitted only if no vendor can write it, it would not change in the same pull request
as a code change, and it names capabilities rather than vendor tools. **Say no by default** — an
empty `skills/` is the correct state until one earns its place, and the bar is having explained
the same thing to an agent three times. The gates are in
[architecture](./.agents/doc/architecture.md).

## Setup & commands

```bash
pnpm install                                   # dev dependencies, and the git hooks
pnpm run check                                 # the skills gate — structure fails, style warns
pnpm run evals                                 # a skill's evals, on promptfoo — by hand, never in CI
pnpm nx run @fmmenchi/ai-skills-docs:build     # the docs site — fails on any broken link
pnpm nx run @fmmenchi/ai-skills-docs:start     # the docs site, live, while editing
pnpm run commit                                # commitizen: builds a conventional message
./install.sh                                   # idempotent; links the contract and each skill
```

**Done means both gates are green:** `pnpm run check` and the docs build. The `pre-push` hook
runs the first, so nothing leaves the machine with a malformed skill; CI runs both.
`pnpm install` needs a GitHub Packages token once per machine — see
[architecture](./.agents/doc/architecture.md).

Node is here for the repository — the commit tooling, Nx, the docs site — and nothing else.
**No skill may depend on it** — the moment a skill needs `pnpm install` to work, it has stopped
being portable, which is the one property this repository exists to protect.

## Topic rules

| Spoke | Open it when |
| --- | --- |
| [architecture](./.agents/doc/architecture.md) | deciding what belongs here or where a file goes; touching `install.sh`, Nx, the docs site, `.npmrc`, or an agent's settings in `.claude/` or `.gemini/` |
| [workflow](./.agents/doc/workflow.md) | writing an ADR, committing, naming a branch, a hook or the gates, CI, merging |
| [authoring](./.agents/doc/authoring.md) | writing or editing anything under `skills/` |
| [evals](./.agents/doc/evals.md) | writing, running or reading the result of a skill's evals |
| [interop](./.agents/doc/interop.md) | a question about which tool reads what, or whether something is portable |
| [known-issues](./.agents/doc/known-issues.md) | something behaves unexpectedly — read it *before* debugging |

Not spokes, and opened the same way — on demand: the
[ADR index](./apps/docusaurus/docs/adr/index.md), the decisions and why, before any structural
change; `README.md`, the human account of the same rules.

Two rules from the spokes are worth carrying even when you never open one, because breaking
either is silent: **the `description` is the whole routing contract** — it is the only field in
context at startup, so a skill with a vague one never fires and nothing says why — and
**`SKILL.md` is case-sensitive to the tools while macOS is not**, so a `SKILL.MD` installs
cleanly and is never loaded.

## How we work

The short version of the rules whose breach is silent. The full rule, and the reasoning, is in
[workflow](./.agents/doc/workflow.md).

- **A structural decision gets an ADR first, and is not made until it is written** — in
  `apps/docusaurus/docs/adr/`. Spokes state decisions; they never make them.
- **Conventional commits, always**, from the vocabulary in `tools/commit/types.mjs`.
- **Semantic branches** — `<type>/<kebab-description>`. Never work on `main`.
- **Rebase and merge — the history stays linear.** No merge commits.
- **Never bypass a hook.** `--no-verify` and its friends are forbidden; a failing gate gets
  fixed, and time pressure is not a justification.
- **Always wait for CI.** The hooks fail open in a working tree that has not run
  `pnpm install`; CI is the only enforcement a laptop cannot skip.
- **Never push.** Fabio pushes.
