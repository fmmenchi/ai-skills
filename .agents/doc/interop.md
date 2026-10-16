# Interoperability — agent rules

Agent Skills is an open standard: the same `SKILL.md` is read unmodified by Claude Code, Codex
CLI, Cursor, Gemini CLI, opencode and the rest. What differs is only **where each one looks**,
and that is the whole reason `install.sh` exists.

## Destinations — verified against each vendor's own docs, not guessed

| Destination | Read by |
| --- | --- |
| `~/.claude/skills` | Claude Code; opencode and Cursor read it too |
| `~/.codex/skills` | Codex CLI; Cursor reads it for compatibility |
| `~/.agents/skills` | the neutral hub of the standard: Cursor, Gemini CLI and opencode |

**Three destinations cover five tools.** `~/.agents` is maintained whether or not those tools
are installed — it belongs to the standard rather than to a vendor.

Per-tool guessing was the earlier design and it was **wrong**: opencode does not read
`~/.opencode/skills` at all. See `known-issues.md`.

The operating contract is the exception that does follow each tool's own directory, because
what each tool reads there is not settled:

| Level | Claude Code | Gemini CLI | the rest |
| --- | --- | --- | --- |
| project (a repository's root) | `AGENTS.md` — **verified**: it loaded this repository's with no `CLAUDE.md` present | `GEMINI.md` by default; `.gemini/settings.json` names `AGENTS.md` | `AGENTS.md` |
| user (`~/.<tool>/`) | **not verified**; `install.sh` links the contract as `~/.claude/CLAUDE.md` until it is | — | `AGENTS.md` |

So in this repository there is no `CLAUDE.md` and no symlink to one: `AGENTS.md` is the only
contract ([ADR 0008](../../doc/adr/0008-agentic-workspace-on-the-shared-platform-model.md)). At
user level the older belief stands until it is tested — see `known-issues.md`.

## What crosses the boundary

| Portable | Not portable |
| --- | --- |
| `SKILL.md` and its frontmatter | `allowed-tools:` — a Claude Code field, not part of the standard |
| the `references/` `scripts/` `assets/` split | `mcp__*` tool names, and any vendor tool name |
| plain Markdown in the body | distribution via a marketplace |
| a script that runs with what the reader has | the contract filename at user level (`CLAUDE.md` vs `AGENTS.md`, unverified) |

The format travels between tools on its own. **The wording is what decides whether the skill
survives the trip** — which is why the admission gate in `architecture.md` requires naming
capabilities rather than tools, and why the gate warns on the usual offenders.

## Consequences when writing

- Describe the capability, then let the reader find it in its own toolbox: *"delegate to an
  isolated subagent"*, not the name of one tool's parameter for doing so.
- A skill that only works under one tool is not wrong — it is simply **not admissible here**. It
  belongs in that tool's plugin, where `wishew:issue` already lives.
- Never assume a path inside a skill resolves relative to the repository: skills are read through
  a symlink, and a reference that points outside the skill directory will not resolve. The gate
  distinguishes a missing reference from one that escapes the skill.
