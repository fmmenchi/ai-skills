# Architecture — agent rules

**Two contracts, one repository.** `contract/AGENTS.md` is the product: `install.sh` symlinks it
as `~/.claude/CLAUDE.md` and `~/.<tool>/AGENTS.md`, so it applies in every repository on the
machine. The root `AGENTS.md` governs work done *inside* here and is installed nowhere. Merging
them would install this repository's build commands into every project. Human rationale:
`../../README.md`.

## Layout

| Path | Ships | Read by | Notes |
| --- | --- | --- | --- |
| `contract/AGENTS.md` | **yes**, by symlink | every tool, in every repository | the product; edit it and every tool sees the change at once |
| `skills/<name>/` | **yes**, one symlink per skill | the tool that activates it | empty is the correct state; see the admission gates below |
| `AGENTS.md` | no | agents working in this repository | hub; the spokes in `.agents/doc/` are opened on demand |
| `.agents/doc/*.md` | no | on demand, when a task touches the topic | this file and its siblings |
| `scripts/check-skills.sh` | no | the `pre-push` hook, and `pnpm run check` | the gate |
| `tools/commit/` | no | commitlint and the branch-name gate | one vocabulary, two enforcement points |
| `.github/workflows/ci.yml` | no | GitHub Actions | re-runs the three gates; the only one a laptop cannot skip |
| `install.sh` | no | run by hand | idempotent; never overwrites a non-symlink |

Skills are linked **one by one**, never by linking `skills/` itself: the destination directories
already hold vendor packs, and those must survive.

## Admission — settled, don't relitigate

A skill belongs here only if **all three** hold:

1. **No vendor can write it.** Nx ships the Nx skills, Cloudflare theirs, Argent theirs. They
   arrive from their own marketplaces and are never vendored into a repository of mine.
2. **It would not change in the same pull request as a code change.** If it would, it belongs in
   that repository next to the code it describes, for the same reason tests do.
3. **It names capabilities, not vendor tools.** The file format travels between tools on its
   own; the wording decides whether the skill survives the trip. The gate warns on the usual
   offenders.

Fail any gate and it has a home already: client work in `wishew-skills`, project-scoped skills
in the project, vendor skills in the vendor's marketplace. **Say no by default** — the bar is
having explained the same thing to an agent three times.

## The Node boundary

Node is here for the commit tooling and nothing else. **No skill may depend on it.** A skill is
Markdown, plus — where it needs determinism — a script that runs with what its reader already
has. The moment a skill needs `pnpm install`, it has stopped being portable, which is the one
property this repository exists to protect.

The same reasoning bounds any future build step: it may serve the repository, never the skills.

## What is standard, and what is not

Normative, and the whole specification: a directory containing a file named exactly `SKILL.md`,
whose YAML frontmatter carries `name` and `description`. The filename is case-sensitive to every
tool, and macOS is not — see `known-issues.md`.

Convention, followed everywhere and enforced nowhere: the `references/` `scripts/` `assets/`
split, and the three-level loading model behind it. Treat as settled.

Everything else — the phrasing of a description, word budgets, index files, repository shape —
is preference. See `authoring.md` for the rules that do change outcomes.
