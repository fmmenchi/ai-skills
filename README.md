# ai-skills

My personal, tool-agnostic agent setup: the user-level operating contract, plus the few skills
no vendor could write for me. Installed by symlink, never by copy — edit a file here and every
tool sees it at once.

## Layout

```
AGENTS.md     the user-level operating contract; applies in every repository I open
skills/       skills in the open SKILL.md format
install.sh    symlinks both into each agent tool present on this machine
```

A project's own `AGENTS.md` is more specific than this one and wins where they disagree.

## Admission criterion

A skill belongs here only when all three hold.

1. **No vendor can write it for me.** Nx ships the Nx skills, Cloudflare ships theirs, Argent
   ships theirs. They arrive from their own marketplaces and are never vendored into a
   repository of mine. What is left over is my own workflow and my own conventions.
2. **It would not change in the same pull request as a code change.** If it would, it belongs
   in that repository next to the code it describes, for the same reason tests do.
3. **It names capabilities, not vendor tools.** "Delegate to an isolated subagent" is portable;
   "use the Task tool with `isolation: worktree`" is not, however standard the file format is.

Everything else has a home already: client-scoped skills in their own repository
(`wishew-skills`), project-scoped skills in the project, vendor skills in the vendor's
marketplace.

Say no by default. An empty `skills/` is the correct state until one earns its place, and the
rule of thumb for that is having explained the same thing to an agent three times.

## Install

```bash
./install.sh
```

Idempotent. Skills are linked one by one, so the vendor packs already installed in each tool's
`skills/` directory are left alone. Anything in the way that is not a symlink is reported and
never overwritten.
