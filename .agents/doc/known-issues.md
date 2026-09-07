# Known issues — agent rules

Each entry cost real debugging. None is guessed; where one was measured, the observation is
stated rather than the conclusion alone.

## `SKILL.MD` passes on this machine and is ignored by every tool

The filename is case-sensitive to the tools and **macOS is not**. A skill named `SKILL.MD`
therefore looks fine locally, installs without complaint, and is silently never loaded — the
worst failure mode available, because nothing reports it.

Both `check-skills.sh` and `install.sh` test the **real directory entry** with `find … -name
'SKILL.md'` rather than `[ -f SKILL.md ]`, which a case-insensitive filesystem would accept.
Keep that shape if either is rewritten.

## opencode does not read `~/.opencode/skills`

It reads `~/.config/opencode/skills`. The original installer guessed `~/.<tool>/skills` for each
tool and linked skills into a directory nobody reads.

The fix that matters is not the corrected path but the discovery behind it: `~/.agents/skills`
is the **neutral hub** and is read by Cursor, Gemini CLI and opencode alike, so one link there
serves three tools. See `interop.md`.

## The contract is not installed until `install.sh` is run

Verified 2026-09-07: `~/.claude/CLAUDE.md`, `~/.agents/AGENTS.md` and `~/.codex/AGENTS.md` do
not exist on this machine. The user-level contract in `contract/AGENTS.md` is therefore inert
until `./install.sh` runs — editing it changes nothing anywhere until then.

Corollary: moving that file cannot break a symlink that was never created. It *will* break one
once the installer has run, so re-run `./install.sh` after any move.

## The hooks fail open, silently, and look installed while doing nothing

`core.hooksPath` is written to the **shared** `.git/config` — verified with `git config
--show-origin core.hooksPath`, which reports `.git/config` and the value `.husky/_`. But
`.husky/_` is created by `pnpm install` **per working tree**.

So a checkout that has the branch but not the install has `.husky/commit-msg` and
`.husky/pre-push` sitting in plain view, a config pointing at them, and **no hook running at
all**: git finds no directory and skips without a word. Observed 2026-09-07 on the main checkout,
which had every file and neither `node_modules` nor `.husky/_`.

Run `pnpm install` once per working tree — including every new worktree — and treat a green
commit as evidence of nothing until you have. CI re-runs the same gates precisely because this
one cannot be trusted.

## `pre-push` checks the branch you are on, not the ref you push

It reads `git rev-parse --abbrev-ref HEAD` and ignores the refs git hands it on stdin, so
`git push origin HEAD:refs/heads/anything` satisfies the gate and creates a non-semantic remote
branch. Inherited from `shared-platform`, where the same hole is open.

The branch pattern is also only a charset: `feat/---` and `feat/a` both pass.

Neither is fixed. CI validates `github.head_ref` on a pull request, which closes the path that
matters for merging, and leaves direct pushes to other refs unguarded.

## Nothing local can enforce `--no-verify`

A hook cannot prevent its own bypass, and the contract's prohibition is prose. The workflow in
`.github/workflows/ci.yml` is the only enforcement that survives a laptop — and even that only
*reports* until the job is marked required in branch protection, which is repository
configuration and lives outside this repository.

## A harness-created worktree gets a branch name the gate rejects

Observed 2026-09-07: an isolated worktree was created on `worktree-feat+project-contract-split`,
which `tools/commit/check-branch-name.mjs` rejects (`+` is not in the allowed set, and the name
has no `<type>/` prefix). Rename the branch to a semantic one **before** pushing, or the
`pre-push` hook stops the push.

Worse, and easy to miss: such a worktree branches from `origin/<default>` by default, so it does
**not** contain unpushed local commits. Check `git log` on entering one, and reset onto the
intended tip before working.

## macOS ships bash 3.2

Expanding an empty array under `set -u` is an error there, and an empty `skills/` is the normal
state. `install.sh` accumulates plain strings instead of arrays for exactly this reason — do not
"modernise" it.
