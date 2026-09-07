# AGENTS.md

Operating contract for this repository. This file is the always-on hub: what `ai-skills` is, the
commands, the gates that must pass, and an index of topic rules. Open a `.agents/doc/*.md` spoke
only when your task touches that topic. Human-facing documentation lives in `README.md`.

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
pnpm install       # dev dependencies, and the git hooks — husky runs on prepare
pnpm run check     # the gate — structure fails, style warns
pnpm run commit    # commitizen: builds a conventional message interactively
./install.sh       # idempotent; links the contract and each skill, one by one
```

`check-skills.sh` is the project's own gate and passes before anything is reported done. The
`pre-push` hook runs it too, so nothing leaves the machine with a malformed skill.

Node is here for the commit tooling and nothing else. **No skill may depend on it** — the moment
a skill needs `pnpm install` to work, it has stopped being portable, which is the one property
this repository exists to protect.

## Topic rules

| Spoke | Open it when |
| --- | --- |
| [architecture](./.agents/doc/architecture.md) | deciding what belongs here, where a file goes, or touching `install.sh` |
| [authoring](./.agents/doc/authoring.md) | writing or editing anything under `skills/` |
| [interop](./.agents/doc/interop.md) | a question about which tool reads what, or whether something is portable |
| [known-issues](./.agents/doc/known-issues.md) | something behaves unexpectedly — read it *before* debugging |

Two rules from the spokes are worth carrying even when you never open one, because breaking
either is silent: **the `description` is the whole routing contract** — it is the only field in
context at startup, so a skill with a vague one never fires and nothing says why — and
**`SKILL.md` is case-sensitive to the tools while macOS is not**, so a `SKILL.MD` installs
cleanly and is never loaded.

## How we work

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
- **Always wait for CI.** A green run on this machine is evidence about this machine. The
  pipeline is the answer, and it is worth the wait.
- **Never push.** Fabio pushes.
