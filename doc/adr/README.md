# Architecture Decision Records

Structural decisions for `ai-skills` are recorded here, one file per decision, numbered
sequentially: `NNNN-<kebab-title>.md`.

**No structural or architectural decision is made until it is written here.** Not the commit
that implements it, not the paragraph in a spoke that describes it afterwards — the ADR comes
first. A decision that lives only in a chat is a decision that will be re-litigated, and the
`.agents/doc/*.md` spokes are meant to *state* what was decided, never to be the place it was
decided.

- **Statuses:** `proposed` → `accepted` | `rejected` | `superseded by NNNN`. An ADR may sit at
  `proposed` indefinitely: an open question that has been framed is worth more than a decision
  taken to close it.
- **Never rewrite an accepted ADR: supersede it with a new one.** A number is an identifier,
  referenced from commit messages and pull requests, so it is never reused and never renumbered.
  A gap in the sequence is information, not a mistake.

## What counts as structural

The test is whether reversing it later would cost more than the decision itself: the shape of
the repository, what is shipped and what is not, a dependency or toolchain entering, the
boundary of what a skill may rely on, or a rule that constrains every future skill.

What does not: the wording of a description, the contents of one skill, anything the gate can
already check.

## In force

| ADR | Title |
| --- | --- |
| [0001](./0001-two-contracts-one-repository.md) | Two contracts, one repository |
| [0002](./0002-node-serves-the-repository-never-the-skills.md) | Node serves the repository, never the skills |
| [0003](./0003-description-point-of-view-is-not-a-standard.md) | The description's point of view is not a standard |
| [0005](./0005-pipeline-skills-live-with-the-product.md) | Pipeline skills live with the product; this repository stays craft-only |
| [0006](./0006-evals-and-reviews-live-outside-the-skill.md) | A skill's evals and reviews live outside the skill |
| [0007](./0007-evals-run-on-promptfoo.md) | Evals run on promptfoo, by hand when something changed, never in CI |

## Open

| ADR | Title |
| --- | --- |
| [0004](./0004-a-docs-site-for-this-repository.md) | A docs site for this repository |
