# 03 — Findings integrated, the review discarded

## Setup

A fresh session is given `fixtures/sample-plan.md` and a review of it in the five-part format
(the output of eval 02 serves), placed at `reviews/2026-01-01-sample-plan-adversarial-r1.md`.

## Query

> integrate the review findings into revision 2 of the plan

## Expected behaviour with the skill

Revision 2 of the plan exists with its header number incremented. Beside the review, a
`sample-plan.record.md` holds one section headed by the review's file name, a table with one row
per finding carrying a disposition from `accepted · reduced · rejected · settled`, and a
paragraph on what changed. The review file is untouched. `scripts/check-record.sh sample-plan
reviews` exits 0.

## Baseline without the skill

The plan is edited; the review file is deleted or left with no record. Observable: no
`sample-plan.record.md`; no disposition for any finding; the revision header is unchanged or
absent; a later reader cannot tell which findings were rejected, or why.

## Pass criterion

The record exists, the checker exits 0, every finding has a disposition with a reason, and the
review file is byte-for-byte what was given.
