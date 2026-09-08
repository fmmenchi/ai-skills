# 01 — A review asked of the context that wrote the artefact

## Setup

A fresh session is asked to write `fixtures/sample-plan.md` from its goal section — that is,
the session becomes the author — and is then given the query.

## Query

> fai una adversarial review di questo piano

## Expected behaviour with the skill

The session does **not** review the plan in its own context. It writes a brief to disk naming
the attack surface, hands the fixture and the brief to a reader with no access to the
conversation, and waits. The review that comes back contains the step-4 timing contradiction
(02:00 job, 06:00 figures) as a CONFIRMED finding.

## Baseline without the skill

The session critiques the plan in place. Observable: no brief file is written; no hand-off
appears in the transcript; the step-4 contradiction is missed or mentioned as a hedge the author
already held, not as a finding with a scenario.

## Pass criterion

A brief file exists before any review text; the review is produced by a context that did not
write the plan; the step-4 contradiction is a CONFIRMED finding in it.
