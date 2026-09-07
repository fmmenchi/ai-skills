# AGENTS.md

Operating contract for this repository. It is the always-on hub: what `ai-skills` is, the gate
that must pass, and how a skill is written here.

Do not confuse it with `contract/AGENTS.md`. That file is the **product**: the user-level
contract this repository ships and symlinks into every tool on the machine. This file governs
only work done *inside* this repository and is never installed anywhere.

## Project

`ai-skills` — the user-level operating contract plus the few skills no vendor could write for
me, in the Agent Skills open format, installed by symlink and never by copy.

A skill belongs here only if all three hold: no vendor can write it, it would not change in the
same pull request as a code change, and it names capabilities rather than vendor tools. The
reasoning is in `README.md`. **Say no by default** — an empty `skills/` is the correct state
until one earns its place, and the bar for that is having explained the same thing to an agent
three times.

Everything else has a home already: client work in `wishew-skills`, project-scoped skills in the
project, vendor skills in the vendor's marketplace.

## Commands

```bash
./scripts/check-skills.sh   # the gate — structure fails, style warns
./install.sh                # idempotent; links the contract and each skill, one by one
```

`check-skills.sh` is the project's own gate and passes before anything is reported done. Nothing
else runs here: no Node, no package manager, no build. Markdown and bash are the whole stack.

## Writing a skill

**A skill is read by a model, not by a person.** Assume the reader is already competent and add
only what it does not already have. Challenge every line: *does this justify its token cost?* If
a line explains a concept, cut it; if it describes surprising behaviour, keep it. That single
test decides most of the content.

**Frontmatter — the only part always paid for.** It is the whole routing contract: at startup
nothing but `name` and `description` is in context, so a good skill with a vague description
never fires and nothing reports why.

```yaml
---
name: same-as-the-directory
description: <What it does, one sentence, third person>. Use when <concrete triggers — the
  words a request actually contains, not the category>. <Never when X; read Y instead.>
---
```

- `name` — at most 64 characters, lowercase letters, digits and hyphens, identical to the
  directory. Gerund reads best (`processing-pdfs`); a noun phrase is fine. Never `helper`,
  `utils`, `tools`, and never the reserved words `claude` or `anthropic`.
- `description` — at most 1024 characters, **third person**: it is injected into the system
  prompt, and a mixed point of view measurably hurts discovery. Concrete triggers beat
  categories — `chat rooms, multiplayer games, booking systems` matches what a request says,
  *"distributed state"* does not. The negative scope costs one clause and is what stops sibling
  skills colliding.

**Body under 500 lines**, which the gate warns past. Detail moves into `references/`, linked
**one level deep from `SKILL.md`** — a reference that only another reference names gets read
partially, or not at all. A reference file over 100 lines opens with its own table of contents.
Start with `SKILL.md` alone: splitting early costs a read and saves nothing.

**Match freedom to fragility.** Where several approaches are valid, give direction and let the
model choose. Where the sequence is fragile and must not vary, give the exact command and say so
— that is a `scripts/` entry, not numbered prose a model may reinterpret. Scripts are executed
without entering context, so state which you mean: *run* `x.sh`, or *read* `x.sh` for the
algorithm.

**One skill = one decision boundary**, not a domain and not a language. Two candidates that
always fire together are one skill. Two that fire where the other must not are two skills, and
each states the other's *never when*.

**Sibling skills are written as deltas, not copies.** Open by declaring the difference and name
the sister that still applies for everything else. It is why a skill can be twenty lines instead
of four hundred, and why the two never drift apart.

**Write the evaluation before the prose.** Three scenarios where the model fails *without* the
skill; if you cannot name them, the skill is documenting an imagined problem.

Anti-patterns, all of them cheap to avoid: offering several options with no default; temporal
phrasing (*"the new API"*, *"currently"*) that goes stale in silence; terminology that drifts
within one file; backslashes in paths; assuming a package is installed; unqualified MCP tool
names. And the one specific to this repository — **name capabilities, not vendor tools**, which
the gate warns on, because it is what decides whether the skill survives being read by a
different tool.

## Git

Conventional commits, semantic branch, never `main`, never `--no-verify`. I push.
