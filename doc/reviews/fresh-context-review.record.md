# Review record — `fresh-context-review`

One section per review, headed by the review's file name. One row per finding. Checked by
`skills/fresh-context-review/scripts/check-record.sh fresh-context-review doc/reviews`.

## 2026-09-08-fresh-context-review-adversarial-r1.md

Adversarial, fresh context, on revision 1 (then named `reviewing-adversarially`). 12 findings,
12 CONFIRMED. The reviewer verified the name collision by reading the devmate plan on its
branch, which the skill's author could not have done from inside this repository.

| # | disposition | note |
| --- | --- | --- |
| 1 | `accepted` | renamed to `fresh-context-review`; never-when clause added for pipelines expecting structured findings |
| 2 | `accepted` | done = a fresh pass returns no CONFIRMED finding; three rounds without it → recorded as unconverged. The "without the record" variant was not taken: the record is part of the artefact, and hiding it would make the reviewer re-find dispositioned items |
| 3 | `accepted` | ceiling only, zero valid and stated; the misused quotation now supports the ceiling, which is what it says |
| 4 | `accepted` | first line of the brief conditional on isolation; "fixed" dropped — four mandatory parts, wording free |
| 5 | `accepted` | product path removed from eval 01; runner-contract example replaced with a neutral interface |
| 6 | `accepted` | both claims attributed in a section of their own; the second labelled an observation, not a measurement |
| 7 | `accepted` | a 40-line fixture with three planted defects; baselines restated as observables; "integrate review findings into a revision" added to the description's triggers |
| 8 | `accepted` | evals moved to `doc/evals/<skill>/`; gate warns under three; ADR 0006 records the rule |
| 9 | `accepted` | the rule stated instead of the path; revision for a change = the PR round; reviews of a shipped artefact live outside it — which is why this record is in `doc/reviews/` |
| 10 | `accepted` | the brief is written to disk first, named `.brief.md` beside the review; it is the hand-off when there is no delegation |
| 11 | `accepted` | the author-is-the-session trigger dropped; exclusion made checkable — a diff review goes to the project's code-review skill |
| 12 | `reduced` | second person fixed; the same-context rule now stated once in the body (the description still needs its own never-when, which is routing, not repetition); `scripts/check-record.sh` added and run on this record. Not taken: validating the `r<N>` against the artefact's revision line — a skill has no revision line in its header, and the number is checked by name pattern only |

What the review changed: the name, the stop criterion, the brief (ceiling, conditional first
line, written to disk), the description (triggers and a checkable exclusion), the evals (moved
out, made runnable on a fixture), the layout rule for reviews, the sources of two claims, and the
addition of a script that checks this very file.
