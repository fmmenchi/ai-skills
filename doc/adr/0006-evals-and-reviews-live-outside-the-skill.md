# ADR 0006 — A skill's evals and reviews live outside the skill

- **Status:** accepted (2026-09-08)
- **Date:** 2026-09-08
- **Deciders:** Fabio Menchicchi

## Context and problem statement

`authoring.md` requires three evals before a skill's prose, and the fresh-context review method
requires reviews kept verbatim beside the artefact. The first skill put both inside its own
directory. Its adversarial review pointed out what that means: `install.sh` symlinks a skill
directory **whole** into every tool on the machine, so evals — fixtures, Italian queries,
baselines — and reviews travel to `~/.codex/skills/…` and `~/.agents/skills/…` as skill content,
where a tool that indexes the directory may read them. The conventions recognise `references/`,
`scripts/` and `assets/`; nothing said where evals go, so the next skill would have chosen
differently, and nothing would have warned.

A directory convention binds every future skill. That makes it structural.

## Decision

- **Evals live in `evals/<skill-name>/`** at the repository root, beside `skills/<skill-name>/`:
  one file per scenario, numbered, plus any fixture under `fixtures/`. They are tests, and a
  repository keeps its tests in a directory of their own. Three is the bar; `check-skills.sh`
  warns when a skill has fewer. What runs them is [ADR 0007](./0007-evals-run-on-promptfoo.md).
- **Reviews and their records live in `doc/reviews/`**, named
  `<date>-<artefact>-<lens>-r<N>.md`, with `<artefact>.record.md` beside them — never inside a
  skill directory.
- Neither `evals/` nor `doc/` is shipped. What ships is `contract/` and `skills/`, and only
  those.

## Consequences

A skill directory holds only what the tool needs: `SKILL.md`, and `references/`, `scripts/`,
`assets/` when earned. Everything about *making* the skill — evidence that it was needed,
evidence that it was reviewed — stays in the repository and never enters a tool's context.

The gate's warning is a floor, not a judge of quality: three files named `01-…` do not prove
three scenarios. The scenarios prove themselves when a stranger can run them, which is what the
review of the first skill demanded and what its evals now do.
