# Evals — agent rules

An eval answers one of three different questions, and conflating them is how a run comes back
with a number that means less than it looks like.

| question | breaks when | detector |
| --- | --- | --- |
| **Does it fire?** | the description is vague, so the skill never runs and nothing reports why | `skill-used` / `not-skill-used` on realistic requests |
| **Can it be followed?** | the body is ambiguous, contradictory, or asks for the impossible | the artefacts the run produced |
| **Does it help?** | the skill changes nothing a competent agent would not do anyway | a task with a known answer, against an honest baseline |

**The first is the one that breaks**, it is the cheapest to test, and it is where the suite
starts. The third is the hardest and the easiest to fake.

## Layout

```
evals/<skill-name>/
  01-….md 02-….md 03-….md   the scenarios: fixture, query, observable baseline, pass criterion
  fixtures/                  what a scenario hands the agent
  promptfooconfig.yaml       what executes
```

At the repository root, never inside `skills/<name>/`, which `install.sh` symlinks whole into
every tool ([ADR 0006](../../doc/adr/0006-evals-and-reviews-live-outside-the-skill.md)). What
runs them is [ADR 0007](../../doc/adr/0007-evals-run-on-promptfoo.md).

The **scenarios are the evidence the skill was needed** — three situations where an agent failed
without it, observed rather than invented. The admission criterion asks for them before the
prose, and no test replaces them. The **config is the suite**. Keep the queries in one place: the
config is what runs, the scenario is why.

## Running

```bash
pnpm run evals            # every skill's config
pnpm run evals:view       # the last run, in a browser
```

**By hand, when something changed. Never in CI.** A run costs model time and its verdict is a
judgement; a red light built on it would be muted within a month. The gate warns and does not
block: fewer than three scenarios, or no config beside them.

Authentication is the local Claude Code session, not `ANTHROPIC_API_KEY`: that is what
`apiKeyRequired: false` in the provider block buys, and it means a run spends subscription time
rather than credits. The same suite runs against `openai:codex-sdk`, which reuses a ChatGPT
login the same way. **A second provider block, with the tests untouched, is how a skill's
portability stops being a claim about the file format.**

## Writing the activation suite

Six or so requests that **should** fire it, in the words a request would actually contain,
including the language it was first asked in. Then four that **should not**: the near misses
that belong to a sibling, and the trivial cases where a hundred lines of context would be waste.
The negative half is not optional. A skill that fires on everything is as broken as one that
never fires, and costs more.

```yaml
- description: the intent without the words
  vars:
    request: try to break this plan before I send it to the team
  assert:
    - type: skill-used
      value: fresh-context-review
```

Keep `max_turns` low. Activation is decided in the first turn or two, and a suite that lets each
case run to completion costs many times more for the same answer.

## Writing outcome tests

Harder, and worth being honest about. Three rules, each learned from getting it wrong:

- **Do not grade the skill's own conventions.** A check for a file the skill invented passes
  with it and fails without it by construction. That measures compliance with a format and says
  nothing about quality.
- **The baseline is not "no skill".** It is a competent agent asked to do the same task well.
  Otherwise the comparison is instructions against nothing, which every skill wins.
- **Test the skill's thesis.** If the claim is that a fresh context finds what the author cannot,
  the fixture has to be built so the author is genuinely blind. A defect printed in the text that
  any reader would catch tests nothing.

Use a rubric grader for what a script cannot judge, and a deterministic one for what it can.

## When a run is worth recording

Put in the eval README what a run **showed** and what it **does not show**, in a few lines. A
number without its limits is worse than no number: the first run of this repository's own suite
reported 14 of 14 against 2 of 14 and was measuring file names.
