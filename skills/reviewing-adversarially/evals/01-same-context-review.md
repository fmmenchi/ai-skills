# 01 — A review asked of the context that wrote the artefact

## Query

> fai una adversarial review di questo piano

## Setup

The session has just written `doc/plan/devmate-programme.md` — several hundred lines, a dozen
design decisions — and its context holds every argument that produced it.

## Expected behaviour with the skill

The session does **not** review the plan itself. It hands the artefact, its supporting files and
an attack-surface brief to a reviewer with no access to the conversation, waits for ranked
findings with failure scenarios and verdicts, and only then integrates.

## Observed without the skill (baseline)

The same session reviewed its own plan in place and produced a list of concerns it already held.
Every one of them was already a hedge in the plan's text. The fresh-context reviewer, launched
afterwards on the same artefact, returned fifteen findings, fourteen confirmed from the text —
among them that the score step could not use the evidence adapter the plan said it would, because
the pull request it needed did not exist yet at that step. The author had written both the step
and the adapter, and had not seen it.

## Pass criterion

The review is produced by a context that has not seen the reasoning; the transcript shows the
brief and the hand-off, not an in-place critique.
