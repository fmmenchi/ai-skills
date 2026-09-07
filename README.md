# ai-skills

My personal, tool-agnostic agent setup: the user-level operating contract, plus the few skills
no vendor could write for me. Installed by symlink, never by copy — edit a file here and every
tool sees it at once.

## Layout

```
contract/AGENTS.md     the user-level operating contract; applies in every repository I open
skills/<name>/         a skill in the Agent Skills open format
  SKILL.md               required: YAML frontmatter (name, description) + Markdown body
  references/            documentation loaded into context only when the body calls for it
  scripts/               executable code, for work that must be deterministic
  assets/                files used in the output, never loaded into context
install.sh             symlinks the contract and the skills into each tool present
scripts/check-skills.sh conformance check; run it before committing a skill
AGENTS.md              this repository's own contract — never installed anywhere
.agents/doc/*.md       topic rules, opened on demand: architecture, authoring, interop, known issues
doc/adr/               the decisions, and why; an ADR precedes the change it describes
tools/commit/          the commit-type vocabulary, read by commitlint and the branch gate
```

The two `AGENTS.md` are not the same file and must not be merged. `contract/AGENTS.md` is what
this repository **ships**: `install.sh` links it as `~/.claude/CLAUDE.md` and `~/.<tool>/AGENTS.md`,
so it applies everywhere. The root `AGENTS.md` governs work done *inside* this repository — its
gate, and how a skill is written here. Putting the second where the first used to be would
install this repository's build commands into every project on the machine.

A project's own `AGENTS.md` is more specific than the shipped contract and wins where they disagree.

## What is standard here, and what is taste

Worth keeping straight, because the three layers get quoted with equal authority and they do
not deserve it.

**Normative.** A directory containing a file named exactly `SKILL.md`, whose YAML frontmatter
carries `name` and `description`. That is the whole specification. Anthropic published Agent
Skills as an open standard in December 2025; Codex CLI, Gemini CLI, Cursor, Copilot and around
thirty other tools read the same file unmodified. The filename is case-sensitive to every one
of them — and macOS is not, so a `SKILL.MD` passes unnoticed on this machine and is silently
ignored by the tools. `check-skills.sh` tests the real directory entry for exactly this reason.

**Convention, followed everywhere and enforced nowhere.** The `references/`, `scripts/` and
`assets/` split, and the three-level loading model behind it: metadata always in context, the
body on activation, bundled resources on demand. Both Anthropic and OpenAI describe it in the
same terms. Treat it as settled.

**Taste.** Whether the description reads *"This skill should be used when…"* or *"Use when…"*;
word budgets for the body; index files; repository shape. Anthropic's own authoring guide
prescribes the third person, and Anthropic's own shipped skills use the imperative — which is
the measure of how much that rule binds.

Sharper than that: the two Anthropic sources disagree with **each other**. The authoring guide's
own good example reads *"…Use when working with PDF files…"*, and the official
`skill-development` skill marks that exact shape as *"Not third person"*, wanting *"This skill
should be used when…"* instead. A rule whose two authorities contradict one another on the same
field is not a standard.

Measured, rather than argued — with the method stated, because the first attempt at this count
was wrong in the direction that suited the argument. Of the 108 distinct descriptions installed
on this machine, **31 fall below the 40-character floor this repository's own gate calls *too
thin to route on***: documentation placeholders, not shipped skills. Of the 77 that remain, 19
open with *"This skill should be used when…"* and 5 address the reader as *you*. The rest open
with a verb — and whether that verb is an infinitive or a third-person singular **cannot be told
apart mechanically**, since English does not separate *Process* from *Processes* without a
lexicon. Several forms ship side by side, and all of them route.

The number worth keeping from the same count: **60 of the 77 say *when*, and 17 do not.** That
is the field activation is decided on, and the one the gate already warns about.

The one thing every source agrees on, and the only one that changes outcomes: **the
`description` must say when to use the skill, not only what it does.** It is the sole field
loaded at startup, so it is the entire routing contract. Everything else is a preference.

## Admission criterion

A skill belongs here only when all three hold.

1. **No vendor can write it for me.** Nx ships the Nx skills, Cloudflare ships theirs, Argent
   ships theirs. They arrive from their own marketplaces and are never vendored into a
   repository of mine. What is left over is my own workflow and my own conventions.
2. **It would not change in the same pull request as a code change.** If it would, it belongs
   in that repository next to the code it describes, for the same reason tests do.
3. **It names capabilities, not vendor tools.** "Delegate to an isolated subagent" is portable;
   "use the Task tool with `isolation: worktree`" is not, however standard the file format is.
   The format travels between tools on its own; the wording is what decides whether the skill
   survives the trip. `check-skills.sh` warns on the usual offenders.

Everything else has a home already: client-scoped skills in their own repository
(`wishew-skills`), project-scoped skills in the project, vendor skills in the vendor's
marketplace.

Say no by default. An empty `skills/` is the correct state until one earns its place, and the
rule of thumb for that is having explained the same thing to an agent three times.

## Install

```bash
./install.sh
```

Idempotent. Skills are linked one by one, so the vendor packs already installed in each tool's
`skills/` directory are left alone. Anything in the way that is not a symlink is reported and
never overwritten.

Three destinations cover the field, each verified against the vendor's own documentation:

| destination | read by |
| --- | --- |
| `~/.claude/skills` | Claude Code; opencode and Cursor read it too |
| `~/.codex/skills` | Codex CLI; Cursor reads it for compatibility |
| `~/.agents/skills` | the neutral hub of the standard: Cursor, Gemini CLI and opencode |

`~/.agents/skills` is maintained whether or not any of those three are installed — it belongs to
the standard rather than to a tool. Guessing `~/.<tool>/skills` for each tool was the earlier
design and it was wrong: opencode does not read `~/.opencode/skills` at all, it reads
`~/.config/opencode/skills`. The operating contract still follows each tool's own directory,
and the ones with no `~/.<tool>` yet are named in the summary rather than skipped in silence.

## Check

```bash
./scripts/check-skills.sh
```

Structure fails the run: a malformed skill is ignored by the tools without saying so, which is
the worst failure mode available. Style only warns — a check that cries wolf gets switched off.

## Distribution

Symlinks cover this machine. Versioned distribution with auto-update is a separate, optional
layer: a `.claude-plugin/` manifest turns this repository into a Claude Code plugin marketplace,
the way `wishew-skills` already works. It is an adapter, not the foundation — the skills stay in
the neutral layout above, and nothing about them bends to one vendor's packaging.
