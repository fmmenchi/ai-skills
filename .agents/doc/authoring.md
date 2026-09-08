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

**Person is two questions, not one — and only one of them has a settled answer.**
[ADR 0003](../../doc/adr/0003-description-point-of-view-is-not-a-standard.md).

*In the body:* imperative or infinitive, **never second person**. `To do X, do Y`, not `You
should do X`. Every source agrees, and the official skill-authoring skill puts it in its own
review checklist. Follow it.

*In the `description`:* every source prescribes third person and **no source recommends second
person** — but the two that prescribe it disagree on what it means. The authoring guide's own
good example reads `Extract text and tables from PDF files… Use when working with PDF files…`,
while the official `skill-development` skill marks that exact shape (`Load when user needs hook
help.`) as *"Not third person"* and wants `This skill should be used when…` instead.

The corpus follows neither consistently. Of 108 distinct installed descriptions, 31 sit below
the 40-character floor the gate calls *too thin to route on* — documentation placeholders, not
shipped skills. Of the remaining 77, 19 open with `This skill should be used when…`, 5 address
the reader, and the rest open with a verb whose form cannot be classified mechanically (English
does not separate `Process` from `Processes` without a lexicon). Several forms ship side by side
and all of them route. **So: pick one form, hold it within the skill, and do not spend effort
converting between them.** The stated mechanism — the description lands in a prompt written in
third person, and pronouns break the voice — is plausible and nowhere demonstrated.

One caveat, offered as a suspicion rather than a finding: a **second-person standing order**
(`you MUST invoke this skill before every X`) reads as an instruction competing with the harness
rather than as a condition for being selected. The only evidence is that those descriptions are
also the ones shouting **MANDATORY** in bold to be heard — five cases, no controlled comparison.

What the same measurement does settle: 60 of those 77 descriptions state *when*, and 17 do not.
Roughly a fifth of shipped skills leave out the only field activation is decided on, while the
question of person is noise. Spend the effort there.

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
`architecture.md` has not actually been met. They live in `evals/<skill-name>/` at the
repository root, one file each plus any fixture — **outside** the skill directory, which is
symlinked whole into every tool — and each must be runnable by a stranger: a fixture, a query,
an observable baseline, a pass criterion. Reviews of a skill go to `doc/reviews/` for the same
reason. [ADR 0006](../../doc/adr/0006-evals-and-reviews-live-outside-the-skill.md).

Beside them, `promptfooconfig.yaml` is what **executes**: the scenarios are the evidence the
skill was needed, the config is the suite. Start with **activation** — `skill-used` on the
requests that should fire it, `not-skill-used` on the near misses that belong to a sibling —
because a skill with a vague description never fires and nothing reports why. Run it by hand
with `pnpm run evals` when something changed, never in CI. The gate warns under three scenarios
and when the config is missing; neither blocks.
[ADR 0007](../../doc/adr/0007-evals-run-on-promptfoo.md).

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
