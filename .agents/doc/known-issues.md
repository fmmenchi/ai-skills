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

## The git hooks do not exist until `pnpm install` runs

husky installs them from the `prepare` script. On a fresh clone — or a fresh worktree — commits
and pushes are unguarded until the first `pnpm install`. A green commit therefore proves nothing
about hook coverage unless the install has happened.

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
