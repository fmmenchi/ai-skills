---
name: reviewing-adversarially
description: Conducts an adversarial review of a plan, a document or a change through a reviewer that has not seen the reasoning behind it, and turns the findings into a recorded revision. Use when asked for an adversarial review, a red-team read, to "break" a plan, or before a draft leaves the repository — and whenever the artefact's author is the current session. Never for a routine code review against a checklist, and never by reviewing inside the context that produced the artefact; that is the failure this skill exists to prevent.
---

# Reviewing adversarially

Two roles, never in the same context: the **author**, who holds every argument that produced
the artefact and is therefore the worst-placed reader of it; and the **reviewer**, who has the
artefact, its supporting files and a brief — and nothing else. The value comes from that
separation. A review conducted by the author's own context returns the author's own hedges.

## 1. Obtain a fresh context

Hand the review to a reader that has **not** seen the conversation: a delegated agent with an
empty context, a separate session, or a person. Give it file paths, never pasted excerpts — an
excerpt is already a selection by the author. If the environment offers isolation for the
reviewer's working copy, use it: a reviewer that may probe, run, or mutate a copy finds more than
one that may only read, and the main tree stays untouched.

Do not run the review in the current context "to save time". The time saved is the review.

## 2. Write the brief

The brief is short and has four parts. Its shape is fixed; its content is judgement.

```
Read this, read-only — do not edit any file: <artefact path>
It must be consistent with (inconsistencies are findings): <supporting file paths>

Attack surface — go after all of these, and anything else you find:
- <claim in the artefact that could be false, stated as a target>
- <internal contradiction to look for>
- <assumption the artefact rests on>
- <step or exit criterion that may be untestable>

Format: findings ranked most severe first. For each: (1) one-sentence defect;
(2) the exact passage it anchors to, quoted; (3) a concrete failure scenario —
inputs/state → wrong outcome; (4) verdict CONFIRMED (follows from the text) or
PLAUSIBLE (needs a fact the text does not settle); (5) the smallest change that
would fix it. <N–M> findings. No preamble, no praise, no restating the artefact.
```

Name the attack surface concretely. *"Check the runner contract"* yields advice; *"the runner
contract is (repo, issue, skills, effort) → exit status — can it express a human gate mid-run, a
fix loop, N parallel reviewers?"* yields a finding. The author knows where the artefact is
weakest; say so in the brief and let the reviewer confirm or refute it.

State the count range. Without one, a reviewer prompted to find gaps will pad to look thorough
— *"a reviewer prompted to find gaps will usually report some, even when the work is sound"* —
and the range plus the verdict split is what keeps padding visible.

Never state a time cap in the brief. A reviewer told its deadline returns shallow findings fast,
indistinguishable from diligence.

## 3. Choose the lenses

One adversarial pass finds internal contradictions. It does not find what an expert of the
artefact's domain knows, nor what prior art has already settled. When the artefact warrants it,
run **separate fresh contexts with separate lenses** — adversarial, a domain expert briefed as
such, a prior-art survey with search access — and never tell one what another owns. Agreement
across lenses is signal; a finding from one lens alone is still a finding.

Launch only as many as you will integrate. Three reviews of a plan are a day's work to absorb
properly; ten are noise.

## 4. Read the findings as findings

Each one is accepted, rejected or reduced — with the reason written next to it, in the author's
own words, because the reasoning is what the record is for.

- **CONFIRMED** findings are wrong in the text. The fix is in the artefact, not in a reply.
- **PLAUSIBLE** findings name a fact. Get the fact — measure, read the source, run the command —
  and the finding becomes confirmed or dismissed. Do not argue with a plausible finding; settle
  it.
- A finding the author rejects gets one sentence saying why. A rejection with no reason is a
  finding the author did not understand.

The reviewer can be wrong, and its errors are part of the record. When a reviewer misquotes a
figure or miscounts, correct it *in the review record* with the method that produced the wrong
number; that correction is evidence about the review, and the next reviewer needs it.

## 5. Revise, and record

Produce the next **revision** of the artefact, numbered. At its end, a **review record**: one
paragraph per review — which lens, how many findings, how many confirmed — and what it changed,
in the order it matters. Keep every review **verbatim** beside the artefact, in a `reviews/`
directory, named by date, lens and the revision it reviewed:

```
doc/<artefact>.md                       revision N
doc/reviews/<date>-adversarial-r<N-1>.md
doc/reviews/<date>-<lens>-r<N-1>.md
```

The verbatim copy is not courtesy. Three sessions later the same objection returns, and the
answer is in the file — not in a memory of having answered it.

## 6. Know when it is done

A review round is done when every finding has a written disposition and the artefact carries the
record. The artefact is done when a fresh pass returns findings the author has already dispositioned
— that is the signal the reviews have converged, and the only one.

## What this is not

- **A checklist code review.** That has its own shape; this is for artefacts whose defects are
  contradictions, unstated assumptions and untestable claims.
- **A vote.** Reviews are not averaged, and a severe finding from one lens is not cancelled by
  silence from another.
- **A defence.** The author does not reply to the reviewer; the author revises the artefact.
- **Optional before publication.** An artefact that leaves the repository — a page, a plan sent
  to someone — goes through at least one fresh pass first.
