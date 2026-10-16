# ADR 0005 — Pipeline skills live with the product

- **Status:** accepted (2026-09-07)
- **Date:** 2026-09-07
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`ai-skills` is the harness of a larger programme: devmate, a product that takes a GitHub issue
to a draft pull request through agents. The programme's plan names seven skills its pipeline
needs — triage, plan, implement, verify, review adversarially, judge blast radius, judge a CI
failure — and its first revision put them **here**, through a "fourth door" added to the
admission criterion: *a capability the programme needs*.

The adversarial review of that plan showed the door does not open. The criterion's second gate
says a skill belongs here only if it *would not change in the same pull request as a code
change*. A pipeline skill emits a template — `triage.json`, `findings/*.json` — that a devmate
script parses. Rename a field, and the skill and the script change together, in one pull
request. That is the gate's exact test, failed. And the "rule of three" is an observation —
*I have explained this three times* — where "the programme needs it" is an intention; swapping
one for the other is not a fourth door, it is the criterion giving way.

The `README` had already said where such skills go: *project-scoped skills in the project*.

## Decision

**The seven pipeline skills live in `devmate/skills/`.** Same open format, same conformance
check, same test of runtime-agnosticism — next to the code that defines the schemas they read
and write, for the same reason tests live next to the code they cover.

**`ai-skills` stays craft-only, and its admission criterion is untouched.** No fourth door. A
skill enters here only if no vendor can write it, it would not change with a code change, and
it names capabilities rather than tools — and only after the same thing has been explained to an
agent three times. *Say no by default* stands.

**This repository knows nothing of the programme by design.** `.agents/doc/architecture.md`
says so in one paragraph, and that paragraph is the only place the product is named. Decisions
about the product are recorded in `fmmenchi/devmate`, never here.

## Consequences

The first skill admitted here will be a **craft** skill, not a pipeline one — whatever Fabio
finds himself explaining a third time while building the product. Two candidates surfaced on the
day of this decision, both asked for repeatedly and neither written yet: *how an adversarial
review is conducted with fresh context*, and *how a study note is written in the house style*.
Each waits for its three evals before its prose.

`scripts/check-skills.sh` travels: devmate uses the same gate on its own `skills/`. How it gets
there — copied, referenced, or published — is devmate's decision and belongs in devmate's ADRs.

The pipeline skills will know devmate's schemas and nothing of the API behind them. That is
tracker-agnostic by one indirection, which is the honest claim; it is also why they cannot live
here, where a skill may know nothing of devmate at all.

What this closes: the plan's question **D1**, the only thing the programme asks of this
repository.
