---
name: fresh-context-review
description: Conducts a review of a plan, a document or a change through a reader that has not seen the reasoning behind it, and integrates the findings into a numbered revision with a written record. Use when asked for an adversarial review, a red-team read, to "break" a plan, to integrate review findings into a revision, or before a draft leaves the repository. Never for a diff review against a project's checklist — use that project's code-review skill — and never when a pipeline expects findings as structured files, which is that project's own skill.
---

# Fresh-context review

Two roles, and one rule that the whole method rests on: **the author and the reviewer never
share a context.** The author holds every argument that produced the artefact and is therefore
its worst-placed reader; a review run in the author's context returns the author's own hedges.
Everything below is how to keep the two apart and still get the findings back into the artefact.

## 1. Obtain a reviewer that has not seen the reasoning

A delegated agent with an empty context, a separate session, or a person. Give it file paths,
never pasted excerpts — an excerpt is already a selection by the author.

**Write the brief to disk first**, beside where the review will land (§5), before anything is
launched. The file is the hand-off when there is no delegation facility, and it is the record of
what the reviewer was asked to attack — without it, "15 findings, 14 confirmed" three sessions
later says nothing about whether the weak spot was probed or simply out of scope.

Where the environment can isolate the reviewer's working copy, do so: a reviewer allowed to run
the gate, probe and mutate a copy finds more than one allowed only to read, and the main tree
stays untouched.

## 2. The brief

Four parts are mandatory; the wording is not.

```
<Do not edit <artefact path>; run and mutate anything else in this copy.>
   — or, without isolation: <Read this, read-only: <artefact path>>
It must be consistent with (inconsistencies are findings): <supporting paths>

Attack surface — go after all of these, and anything else found:
- <a claim in the artefact that could be false, stated as a target>
- <an internal contradiction to look for>
- <an assumption the artefact rests on>
- <a step or exit criterion that may be untestable>

Format: findings ranked most severe first. For each: (1) one-sentence defect;
(2) the exact passage it anchors to, quoted; (3) a concrete failure scenario —
inputs/state → wrong outcome; (4) verdict CONFIRMED (follows from the text) or
PLAUSIBLE (needs a fact the text does not settle); (5) the smallest change that
would fix it. At most <M> findings; zero is a valid answer and is stated as such.
No preamble, no praise, no restating the artefact.
```

**Name the attack surface concretely.** *"Check the interface"* yields advice; *"the interface is
(input, options) → exit status — can it express a step that waits for a human, or a loop?"*
yields a finding. The author knows where the artefact is weakest; the brief says so, and the
reviewer confirms or refutes it.

**A ceiling, never a floor.** A minimum count is a padding target: a sound artefact then gets its
last findings invented to reach it. The verdict split is what keeps padding visible — a review
that is all PLAUSIBLE has found nothing it could confirm.

**No time cap in the brief.** A reviewer told its deadline returns shallow findings fast,
indistinguishable from diligence. Cap it from outside, if at all.

## 3. Lenses

One adversarial pass finds internal contradictions. It does not find what an expert of the
domain knows, nor what prior art has already settled. Where the artefact warrants it, run
separate fresh contexts with separate lenses — adversarial, a domain expert briefed as such, a
prior-art survey with search access — each with its own brief, none told what another owns.
Agreement across lenses raises confidence; disagreement is itself a finding; a single lens's
CONFIRMED finding stands on its own.

Launch only as many as will be integrated. Three reviews of a plan are a day's work to absorb;
ten are noise.

## 4. Dispositions

Every finding gets one of four, written with its reason in the author's words:

| disposition | meaning |
| --- | --- |
| `accepted` | wrong in the text; the fix is in the next revision |
| `reduced` | partly right; what survives is named |
| `rejected` | one sentence saying why — a rejection without a reason is a finding not understood |
| `settled` | a PLAUSIBLE finding whose fact was fetched: measured, read, run — now confirmed or dismissed |

A PLAUSIBLE finding is never argued with. It names a fact; get the fact.

The reviewer can be wrong, and its errors are part of the record: a miscount or a misquoted
figure is corrected *in the record* with the method that produced the wrong number, because the
correction is evidence about the review and the next reviewer needs it.

## 5. Revise, and record

Produce the next **revision** of the artefact, numbered. For a document, the number is in its
header; for a change, it is the round of the pull request.

Keep every review **verbatim**, and the brief that produced it, in a `reviews/` directory
**next to the artefact's own directory** — never inside anything that is shipped or loaded
whole, such as a skill directory that tools symlink. One file per review, named
`<date>-<artefact>-<lens>-r<N>.md` where `N` is the revision that was reviewed; the brief is
`<date>-<artefact>-<lens>-r<N>.brief.md`.

Beside them, `<artefact>.record.md`: one section per review, headed by the review's file name,
holding a table with one row per finding — number, disposition, note — and a paragraph on what
the review changed. A document read by people also carries that paragraph at its end. Run
`scripts/check-record.sh <artefact> <reviews dir>` before committing: it counts the findings in
each review, checks each has a row in the record, and checks the file names.

The verbatim copy is not courtesy. The same objection returns three sessions later, and the
answer is in the file rather than in a memory of having answered it.

## 6. Done

A round is done when every finding has a disposition and the record is checked. The artefact is
done when a fresh pass returns **no CONFIRMED finding**: PLAUSIBLE ones are settled by fetching
their fact, not by another round. Three rounds without that outcome is not a fourth round; it is
the artefact recorded as **unconverged**, with the open findings listed, which is a legitimate
state and the honest one.

## Two claims, and where they come from

*A reviewer prompted to find gaps will usually report some, even when the work is sound* —
Anthropic's guidance on delegating review to a subagent; it is the reason for the ceiling in §2.
*A reviewer told its deadline returns shallow findings fast* — an observation recorded in the
retrospectives of a public review harness (`maroffo/claude-advanced-review`), not a measurement
made here.

## What this is not

- **A diff review against a checklist.** That has its own shape and its own skill.
- **A vote.** Reviews are not averaged, and a severe finding from one lens is not cancelled by
  silence from another.
- **A defence.** The author does not reply to the reviewer; the author revises the artefact.
- **Optional before publication.** An artefact that leaves the repository goes through at least
  one fresh pass first.
