# Authoring a skill — agent rules

**A skill is read by a model, not by a person.** Assume the reader is already competent and add
only what it does not already have. Challenge every line: *does this justify its token cost?* If
a line explains a concept, cut it; if it describes surprising behaviour, keep it. That single
test decides most of the content.

Read this before writing or editing anything under `skills/`. Whether a skill belongs here at
all is `architecture.md`, not this file.

## Frontmatter — the only part always paid for

At startup nothing but `name` and `description` is in context. A good skill with a vague
description never fires, and nothing reports why.

```yaml
---
name: same-as-the-directory
description: <What it does, one sentence>. Use when <concrete triggers — the
  words a request actually contains, not the category>. <Never when X; read Y instead.>
---
```

| Field | Hard limit | Rules |
| --- | --- | --- |
| `name` | 64 characters | lowercase letters, digits, hyphens; identical to the directory; no XML tags; never the reserved words `claude` or `anthropic` |
| `description` | 1024 characters | non-empty, no XML tags; says both *what* and *when* |

Gerund reads best (`processing-pdfs`); a noun phrase (`pdf-processing`) is fine. Never `helper`,
`utils`, `tools`, `documents`, `data` — a name that could cover anything routes to nothing.

**Person is taste. The trigger is not.** The published guidance prescribes third person, and the
shipped corpus does not follow it: measured across 108 distinct installed descriptions, 31 use
third-person singular (`Reviews and authors…`), 17 open with `This skill should be used when…`,
5 address the reader directly, and the rest use a bare infinitive (`Build AI agents…`). All four
forms fire. Pick one and hold it within the skill; do not spend effort converting between them.

The one form worth avoiding is a **second-person standing order** — `you MUST invoke this skill
before every X`. The description is injected into a prompt that already addresses the model as
*you*, so it reads as an instruction competing with the harness rather than as a condition for
being selected. Treat this as a suggestion, not a finding: the evidence is that those same
descriptions are the ones shouting **MANDATORY** in bold to be heard, which looks like
compensation — five cases, and no controlled comparison.

What the same measurement does settle: only 58 of those 108 descriptions state *when* at all.
The field that decides activation is under-served in half the corpus, while the question of
person is noise. Spend the effort there.

**Concrete triggers beat categories.** `chat rooms, multiplayer games, booking systems` matches
what a request actually says; *"distributed state"* does not. Include the words the request
would contain.

**The negative scope costs one clause and is the cheapest defence there is.** With few skills the
problem is activation; with many it is collision. Say *never when*, and name the sibling to read
instead — with a criterion that can be checked, not interpreted.

## Body

Under **500 lines**, which the gate warns past. Detail moves into `references/`, linked **one
level deep from `SKILL.md`**: a reference named only by another reference gets previewed rather
than read, so the information arrives incomplete. A reference file over 100 lines opens with its
own table of contents, so a partial read still shows the full scope.

Start with `SKILL.md` alone. Splitting early costs a read and saves nothing.

| Part | When it enters context |
| --- | --- |
| frontmatter | always |
| body | on activation |
| `references/<file>` | only when `SKILL.md` names it |
| `scripts/<file>` | never — only its output |
| `assets/<file>` | never; used in the output |

Nothing below the frontmatter costs anything until it is reached, so bundle the **complete**
reference rather than an abridged one. Name files by content (`form-validation-rules.md`, not
`doc2.md`); when a skill spans domains, split `references/` by domain so an unrelated one never
enters context at all. Forward slashes everywhere, including on Windows.

## Freedom proportional to fragility

| Task | Give | Form |
| --- | --- | --- |
| several valid approaches, context decides | direction, and trust the reader | prose steps |
| a preferred pattern, some variation fine | a template with parameters | pseudocode or a parameterised script |
| fragile, must not vary | the exact command, and say it must not be modified | `scripts/` entry |

Say which you mean: **run** `x.sh`, or **read** `x.sh` for the algorithm. A sequence that must
run in exactly one order is code, not numbered prose a model may reinterpret.

## Granularity

**One skill = one decision boundary** — not a domain, not a language. Two candidates that always
fire together are one skill. Two that fire where the other must not are two skills, and each
states the other's *never when*.

**Sibling skills are written as deltas, not copies.** Open by declaring the difference and name
the sister that still applies for everything else. It is why a skill can be twenty lines instead
of four hundred, and why the two never drift apart.

## Output shape

Where the output has a shape, **show it — do not describe it**.

- **Fixed** — something downstream parses it. Give the literal template and say the structure is
  mandatory.
- **Adaptable** — give the same template as a sensible default and say to adjust it.
- **A matter of style** — give two or three input → output pairs. Examples carry tone and level
  of detail more precisely than any adjective describing them.

**Close the loop wherever a script can judge the result:** produce, validate, fix, repeat, and
proceed only once validation passes. For batch or destructive work, put the plan in a file,
validate the file, then execute it — errors surface before anything has been touched, and a
failed check names the specific problem instead of leaving it to be guessed at.

## Before it is written, and before it is committed

**Write the evaluation first.** Three scenarios where the model fails *without* the skill. If
you cannot name them, the skill documents an imagined problem — and the admission bar in
`architecture.md` has not actually been met.

Then `pnpm run check`. Structure fails the run, style only warns.

## Anti-patterns

| Anti-pattern | Why |
| --- | --- |
| several options, no default | *"use pypdf, or pdfplumber, or PyMuPDF…"* — give one, plus the escape hatch |
| temporal phrasing | *"the new API"*, *"currently"* — goes stale in silence; use an *old patterns* section |
| terminology that drifts | pick one word per concept and keep it |
| assuming a package is installed | state the dependency and how to get it |
| unqualified MCP tool names | `Server:tool`, or it is not found when several servers are present |
| a routing index | the descriptions are the routing; a second catalogue diverges and needs its own drift check |
| vendor tool names | the gate warns; it is what decides whether the skill survives another tool |
