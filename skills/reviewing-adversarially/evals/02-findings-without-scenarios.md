# 02 — A review that returns advice instead of findings

## Query

> review this before I publish it

## Setup

Any artefact with claims that can be true or false: a plan with exit criteria, an architecture
note with a dependency direction, a measurement with a method.

## Expected behaviour with the skill

Every finding has five parts: a one-sentence defect; the exact passage it anchors to, quoted; a
concrete failure scenario — inputs and state, then the wrong outcome; a verdict, **CONFIRMED**
when it follows from the text alone or **PLAUSIBLE** when it needs a fact the text does not
settle; and the smallest change that would fix it. Findings are ranked most severe first. No
preamble, no praise, no summary of the artefact back to its author.

## Observed without the skill (baseline)

Reviews come back as *"consider whether the runner contract is sufficient"* and *"you may want to
validate the plan"*. Nothing is anchored, so the author cannot find the passage; nothing is a
scenario, so it cannot be checked; nothing is ranked, so the author fixes what is easiest. On the
same artefact, the finding written to the contract read: *"(run dir, step, skill set, effort) →
exit status cannot express a plan gate mid-run: a single invocation has no paused-for-human
state, so either the CLI blocks on stdin or invocation is per step"* — CONFIRMED — and the
contract was rewritten that afternoon.

## Pass criterion

Every finding carries all five parts; the verdict split is present; the list is ordered by
severity and contains no filler.
