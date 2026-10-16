---
slug: /
title: ai-skills
sidebar_position: 0
---

# ai-skills

A personal, tool-agnostic agent setup: the user-level operating contract, plus the few skills no
vendor could write. Installed by symlink, never by copy — edit a file in the repository and every
tool sees it at once.

## Skills

Each links to its `SKILL.md` on GitHub, as the tools read it. Skills are never copied into this
site: a skill directory ships whole, and a second copy would drift from the first.

| Skill | Use it for |
| --- | --- |
| [fresh-context-review](https://github.com/fmmenchi/ai-skills/blob/main/skills/fresh-context-review/SKILL.md) | reviewing a plan, a document or a change through a reader that has not seen the reasoning behind it, and integrating the findings into a numbered revision |

A skill is admitted only if no vendor can write it, it would not change in the same pull request
as a code change, and it names capabilities rather than vendor tools. An empty `skills/` is the
correct state until one earns its place.

## The rest

- **[ADRs](./adr/index.md)** — every structural decision, and why.
- **[Reviews](./reviews/fresh-context-review.record.md)** — reviews of the skills, verbatim, with
  the record of what each finding changed.
- **[README](https://github.com/fmmenchi/ai-skills/blob/main/README.md)** — what is standard
  and what is taste, how to install, how to check.

Agents working in this repository start from `AGENTS.md` at its root, not from this site.
