# Evals — reviewing-adversarially

Three scenarios in which an agent **fails without this skill**, written before the skill's
prose, as `.agents/doc/authoring.md` requires. Each was observed on 2026-09-07 while a programme
plan went through three reviews; none is invented.

An eval is run by giving a fresh agent the *query* and the *setup*, with and without the skill
installed, and checking the *expected behaviour*. The baseline column is what actually happened
without it.

| # | Scenario | Fails without the skill because |
| --- | --- | --- |
| [01](./01-same-context-review.md) | "Review this plan" asked of the session that wrote it | the reviewer shares the author's assumptions and confirms them |
| [02](./02-findings-without-scenarios.md) | A review that returns advice instead of findings | nothing can be verified, ranked or acted on |
| [03](./03-outcome-not-recorded.md) | Findings integrated, the review discarded | objections resurface; the reviewer's own errors vanish |
