# ADR 0007 — Evals run on promptfoo

- **Status:** accepted (2026-09-08)
- **Date:** 2026-09-08
- **Deciders:** Fabio Menchicchi

## Context and problem statement

The first skill arrived with three eval scenarios written as prose: a fixture, a query, an
observable baseline, a pass criterion. Nothing ran them. A hand-rolled runner was built to do
it — headless sessions spawned with and without the skill, shell checks over the files they
wrote, a hash gate to run only what changed — and it worked, on the first measured run, 14
checks of 14 with the skill against 2 of 14 without.

Two things then became clear, in this order.

**The numbers were weaker than they looked.** The checks verified that a file called
`reviews/*.brief.md` existed and that the first finding contained the word CONFIRMED. Those are
conventions the skill itself invents, so the side without the skill had no reason to produce
them: the comparison was close to a tautology. And both sessions without the skill found the
planted defect anyway. What was measured was compliance with a format, not better work — and it
was reported as if it were more.

**It was a solved problem, solved twice.** `claude plugin eval` ships in the installed CLI and
does the same job with graders, an automatic no-plugin baseline arm, cost ceilings and CI exit
codes. It is also early access, enabled per organisation, and undocumented in the public
documentation. Meanwhile promptfoo, 24,900 stars and MIT, publishes a guide written specifically
for Agent Skills.

And a constraint that decides between them: **the next subscription may be OpenAI's**. A runner
tied to one vendor is a runner to rewrite in a month, in a repository whose entire thesis is
that a skill outlives the tool that reads it.

## Decision

**Evals run on promptfoo.** Where they live is
[ADR 0006](./0006-evals-and-reviews-live-outside-the-skill.md): `evals/<skill-name>/` at the
repository root, outside the skill directory that `install.sh` symlinks whole into every tool.

Each skill gets `evals/<skill-name>/promptfooconfig.yaml`. The prose scenarios stay: they are
the evidence the skill was needed, which the admission criterion requires and no test replaces.
The config is what executes.

Three things settled the choice, each verified rather than assumed:

- **It runs on the subscription, not on API credits.** `apiKeyRequired: false` makes the
  Anthropic provider reuse the local Claude Code session; the Codex provider reuses a ChatGPT
  login when no key is set. This is the constraint that killed the hand-rolled runner's
  isolation and would have made an API-key-only tool unusable here.
- **The same suite runs against more than one runtime** — `anthropic:claude-agent-sdk`,
  `openai:codex-sdk`, `opencode:sdk` — with the tests unchanged and only the provider block
  differing. That is how a skill's portability stops being a claim.
- **`skill-used` and `not-skill-used` are assertion types.** Activation is the failure with no
  other detector: a skill with a vague description never fires and nothing reports why. A shell
  check cannot see it; these can.

**The activation suite is what exists now.** Outcome tests — does the work get better — need
fixtures, a working directory and rubric graders, and they are the next config, not this one.
Saying so is part of the decision: the previous attempt overstated what it had measured, and
this one states what it has not.

`claude plugin eval` stays a possible **second** engine, not the only one. The cases would not
be rewritten, only pointed at another runner. Whether it is even enabled on this account is
untested: `claude plugin eval` in an empty directory answers that.

## Consequences

`scripts/run-evals.sh` is deleted, along with its shell graders and its staleness hash. What is
lost with it: the rule that evals run only when the skill changed. promptfoo has no equivalent,
and the rule was a good one; it can come back as a few lines in the gate once there is a run
worth being stale.

`promptfoo` enters `package.json` as a dev dependency. By ADR 0002 that is allowed — Node serves
the repository, never the skills — and the same reasoning bounds it: no skill may depend on
promptfoo, and none does.

The gate warns when a skill has no `promptfooconfig.yaml`, next to the warning for fewer than
three scenarios. Neither blocks: an eval's verdict is not a semaphore, and running it costs
model time, so it is run by hand when something changed, never in CI.

The first run of the activation suite has **not** happened yet. Until it does, this repository
knows that its one skill is well formed and does not know whether it fires.
