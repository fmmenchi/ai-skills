# AGENTS.md

Operating contract for this repository, and the only one: there is no `CLAUDE.md` and no
symlink to one. This file is the always-on hub: what `ai-skills` is, the commands, the gates that
must pass, and an index of topic rules. Open a `.agents/doc/*.md` spoke only when your task
touches that topic. Human-facing documentation is `README.md`, the ADRs in `doc/adr/` and the
skills themselves, published together by the docs site in `apps/docusaurus` from where they are
written — `pnpm nx run docs:start` to read it locally.

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
pnpm install               # dev dependencies, and the git hooks — husky runs on prepare
pnpm run check             # the skills gate — structure fails, style warns
pnpm run evals             # a skill's evals, on promptfoo — by hand, never in CI
pnpm nx run docs:build     # the docs site — fails on any broken link
pnpm nx run docs:start     # the docs site, live, while editing
pnpm run commit            # commitizen: builds a conventional message interactively
./install.sh               # idempotent; links the contract and each skill, one by one
```

**Done means both gates are green:** `pnpm run check` and `pnpm nx run docs:build`. The `pre-push`
hook runs the first, so nothing leaves the machine with a malformed skill; CI runs both.
`pnpm install` needs a GitHub Packages token once per machine — see
[workspace](./.agents/doc/workspace.md).

Node is here for the repository — the commit tooling, Nx, the docs site — and nothing else.
**No skill may depend on it** — the moment a skill needs `pnpm install` to work, it has stopped
being portable, which is the one property this repository exists to protect.

## Topic rules

| Spoke | Open it when |
| --- | --- |
| [architecture](./.agents/doc/architecture.md) | deciding what belongs here, where a file goes, or touching `install.sh` |
| [authoring](./.agents/doc/authoring.md) | writing or editing anything under `skills/` |
| [evals](./.agents/doc/evals.md) | writing, running or reading the result of a skill's evals |
| [interop](./.agents/doc/interop.md) | a question about which tool reads what, or whether something is portable |
| [workspace](./.agents/doc/workspace.md) | touching Nx, the docs site in `apps/docusaurus`, CI, `.npmrc`, or an agent's settings in `.claude/` or `.gemini/` |
| [known-issues](./.agents/doc/known-issues.md) | something behaves unexpectedly — read it *before* debugging |

Not spokes, and opened the same way — on demand: [doc/adr/](./doc/adr/README.md), the
decisions and why, before any structural change; `README.md`, the human account of the same
rules.

Two rules from the spokes are worth carrying even when you never open one, because breaking
either is silent: **the `description` is the whole routing contract** — it is the only field in
context at startup, so a skill with a vague one never fires and nothing says why — and
**`SKILL.md` is case-sensitive to the tools while macOS is not**, so a `SKILL.MD` installs
cleanly and is never loaded.

## How we work

- **A structural decision gets an ADR first, and is not made until it is written.** Before
  changing the shape of the repository, what it ships, what a skill may depend on, or any rule
  that binds every future skill: write `doc/adr/NNNN-<kebab-title>.md`. The `.agents/doc/*.md`
  spokes **state** what was decided; they are never where it is decided, and a decision that
  lives only in a conversation will be re-litigated. The test is whether reversing it later
  would cost more than the decision itself. An ADR may stay `proposed` indefinitely — a framed
  open question is worth more than a decision taken early to close it. Conventions in
  [doc/adr/README.md](./doc/adr/README.md).
- **Conventional commits, always.** `pnpm run commit` builds the message; the `commit-msg` hook
  runs commitlint and refuses anything else. The type vocabulary lives in
  `tools/commit/types.mjs` — one list, read by both the hook and the branch gate, so the two
  can never disagree.
- **Semantic branches** — `<type>/<kebab-description>`, the type from that same list, ending
  with the issue number when there is one. Never work on `main`. The `pre-push` hook rejects
  anything else.
- **Rebase and merge — the history stays linear.** No merge commits.
- **Never bypass a hook.** `--no-verify` and its friends are forbidden; a failing gate gets
  fixed, and time pressure is not a justification.
- **Always wait for CI.** A green run on this machine is evidence about this machine — and the
  hooks behind it fail open in silence when a working tree has not been installed, so it may be
  evidence about nothing. `.github/workflows/ci.yml` re-runs the same gates and is the only
  enforcement that cannot be skipped from a laptop. It is worth the wait.
- **Never push.** Fabio pushes.
