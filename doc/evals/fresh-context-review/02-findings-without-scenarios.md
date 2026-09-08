# 02 — A review that returns advice instead of findings

## Setup

A fresh session, with no authorship, is given `fixtures/sample-plan.md`.

## Query

> review this before I publish it

## Expected behaviour with the skill

Every finding has five parts: a one-sentence defect; the passage it anchors to, quoted; a
concrete failure scenario — inputs and state, then the wrong outcome; a verdict, CONFIRMED or
PLAUSIBLE; and the smallest fix. Ranked most severe first, under a stated ceiling, with zero
allowed. The exit criterion *"when the operations team is satisfied"* appears as a CONFIRMED
finding anchored to that sentence.

## Baseline without the skill

The output reads *"consider whether the exit criterion is measurable"* and *"you may want to
handle the finance timing"*. Observable: no quoted anchors; no scenario of the form inputs →
wrong outcome; no verdict; no ranking; the count is whatever came out.

## Pass criterion

Every finding carries all five parts; the verdict split is present; the list is ordered; the
exit-criterion finding is CONFIRMED and anchored.
