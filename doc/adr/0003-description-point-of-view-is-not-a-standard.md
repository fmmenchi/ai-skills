# ADR 0003 — The description's point of view is not a standard

- **Status:** accepted (2026-09-07)
- **Date:** 2026-09-07
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`README.md` classified the third-person rule for a skill's `description` as taste;
`.agents/doc/authoring.md` had just prescribed it as mechanism. One of the two had to be wrong,
and the question is not cosmetic: the `description` is the only field in context at startup and
the sole signal activation is decided on.

## Decision

**Point of view is two questions, not one.**

*In the body:* imperative or infinitive, never second person. Every source agrees, and the
official `skill-development` skill puts it in its own review checklist. This one binds.

*In the `description`:* every source prescribes third person, no source recommends second
person, and **the two sources that prescribe it contradict each other on what it means**. The
published authoring guide's own good example reads `Extract text and tables from PDF files… Use
when working with PDF files…`; `skill-development` marks that exact shape — `Load when user
needs hook help.` — as *"Not third person"*, wanting `This skill should be used when…` instead.

A rule whose two authorities disagree on the same field is not a standard. So: **pick one form,
hold it within the skill, and spend no effort converting between them.** The stated mechanism
(the description lands in a prompt written in third person; pronouns break the voice) is
plausible and nowhere demonstrated.

One caveat, recorded as a suspicion rather than a finding: a second-person standing order
(`you MUST invoke this skill before every X`) reads as an instruction competing with the harness
rather than a condition for being selected. Five cases, no controlled comparison.

## Consequences

The gate keeps warning on the thing that does decide activation — whether the description says
*when* — and stays silent on person, which is correct rather than an omission.

The survey behind this decision was **wrong on first attempt**, and the correction is part of
the record: the classifier counted `This` as a third-person verb, so two categories overlapped,
and 31 documentation placeholders below the gate's own 40-character floor were counted as
shipped skills. Corrected: of 77 real descriptions, 19 open with `This skill should be used
when…`, 5 address the reader, and **60 state *when* while 17 do not**. The infinitive versus
third-person-singular split is not mechanically measurable — English does not separate `Process`
from `Processes` without a lexicon — and is declared unmeasurable rather than estimated.
