# 03 — Findings integrated, the review discarded

## Query

> integra le review e aggiorna il piano

## Setup

Two or three reviews have come back on the same artefact. The author revises it.

## Expected behaviour with the skill

The revised artefact carries a **review record**: for each review, what it changed, in a few
lines. The reviews themselves are kept **verbatim** beside the artefact, dated and numbered by
the revision they reviewed. A reviewer's own errors — a miscount, a misquoted figure — are
corrected *in the record*, not silently dropped, because the correction is evidence about the
method. The artefact's revision number increments.

## Observed without the skill (baseline)

The findings are absorbed into the text and the review is thrown away. Three sessions later the
same objection is raised again — *"why is the score split in two?"* — and the reason has to be
reconstructed from memory. When the first survey behind one decision turned out to be wrong
(a regex had counted a pronoun as a verb, inflating one category and collapsing another), the
correction survived only because the record demanded it; the corrected numbers, 60 of 77 rather
than 58 of 108, are in the artefact's review record with the method that produced the wrong
ones.

## Pass criterion

The artefact names each review and what it changed; the reviews exist as files beside it; a
correction to a reviewer's error is visible in the record.
