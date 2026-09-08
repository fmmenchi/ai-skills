# Evals — fresh-context-review

Two layers, and they answer different questions.

**The scenarios** — `01`, `02`, `03` — are the evidence the skill was needed: three situations
in which an agent failed *without* it, observed on 2026-09-07 rather than invented, each with a
fixture, a query, an observable baseline and a pass criterion. The admission criterion asks for
them before the prose, and no test replaces them.

**`promptfooconfig.yaml`** is what runs. It tests **activation**: does the skill fire when it
should, and stay quiet when it should not. That is the failure with no other detector, because a
skill with a vague description never runs and nothing reports why.

```bash
pnpm run evals
```

The suite runs on the local Claude Code session rather than an API key, so it costs subscription
time and not credits. It is run by hand when the skill or its evals changed, never in CI: the
verdict of an eval is not a semaphore (ADR 0007).

## What is not tested yet

**Whether the work gets better.** Outcome tests need fixtures, a working directory and rubric
graders, and they are the next config. Saying so plainly matters here, because the first attempt
at these evals did not: it ran shell checks for a file called `reviews/*.brief.md` and for the
word CONFIRMED, which are conventions the skill itself invents, and reported 14 of 14 against 2
of 14 as if it were a measure of quality. It was a measure of compliance with a format.

What that run did show, and what still stands: **both sessions without the skill found the
planted defect on their own.** The plan's 02:00 job verifying against figures published at 06:00
was caught either way. What the skill changed was the method, a brief on disk, a reader that did
not write the artefact, findings a script can count, a record a script can check. The claim that
it finds *more* defects has never been supported and is not made.

Two observations worth carrying into the skill's next revision, from that same run: a ceiling of
*at most 8 findings* made a reviewer demote a ninth, real, anchored finding to an uncounted
addendum with no verdict, so the skill should say what to do past the ceiling; and every agent
placed `reviews/` inside its working directory because the prompt confined it there, and each
said so, which is the behaviour wanted.

## Running against a second runtime

The point of promptfoo here is that the same tests run elsewhere. Adding a provider block for
`openai:codex-sdk` or `opencode:sdk`, with the tests untouched, is how this skill's portability
stops being a claim about the file format and becomes a measurement.
