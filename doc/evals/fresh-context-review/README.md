# Evals — fresh-context-review

Three scenarios in which an agent **fails without this skill**, written before the skill's
prose as `.agents/doc/authoring.md` requires. They live here, outside the skill directory,
because that directory is symlinked whole into every tool (ADR 0006).

Every scenario runs against the same fixture, `fixtures/sample-plan.md` — a forty-line plan
with three planted defects: step 4 needs figures published four hours after the job runs; the
exit criterion cannot be tested; the failure handling retries a step whose failure is
time-based, and "stops" a job that has already mailed nothing. A stranger can run each eval
with and without the skill and observe the pass criterion without any other context.

| # | Scenario | Fails without the skill because |
| --- | --- | --- |
| [01](./01-same-context-review.md) | "Review this plan" asked of the session that wrote it | the reviewer shares the author's context; nothing is handed off |
| [02](./02-findings-without-scenarios.md) | A review that returns advice instead of findings | nothing is anchored, ranked or checkable |
| [03](./03-outcome-not-recorded.md) | Findings integrated, the review discarded | no record, no verbatim copy, the objection returns |

The baselines below were first observed on 2026-09-07, on a real plan; each is restated as
something a stranger can observe on the fixture.
