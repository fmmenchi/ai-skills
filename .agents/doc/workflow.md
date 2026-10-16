# Workflow — agent rules

ADRs, commits, branches, hooks, the gates and CI. The hub carries the short version of the rules
whose breach is silent; this file is the full rule. Decided in
[ADR 0002](../../apps/docusaurus/docs/adr/0002-node-serves-the-repository-never-the-skills.md)
(the commit tooling) and
[ADR 0008](../../apps/docusaurus/docs/adr/0008-agentic-workspace-on-the-shared-platform-model.md)
(CI).

## Decisions

**A structural decision gets an ADR first, and is not made until it is written.** Before
changing the shape of the repository, what it ships, what a skill may depend on, or any rule that
binds every future skill: write `apps/docusaurus/docs/adr/NNNN-<kebab-title>.md` and add its row
to `adr/index.md`, where the conventions are. The `.agents/doc/*.md` spokes **state** what was
decided; they are never where it is decided, and a decision that lives only in a conversation
will be re-litigated. The test is whether reversing it later would cost more than the decision
itself.

An ADR may stay `proposed` indefinitely — a framed open question is worth more than a decision
taken early to close it. Never rewrite an accepted ADR: supersede it. A number is never reused,
and a gap in the sequence is information.

## Commits and branches

- **Conventional commits, always.** `pnpm run commit` builds the message; the `commit-msg` hook
  runs commitlint and refuses anything else. The type vocabulary lives in
  `tools/commit/types.mjs` — one list, read by both the hook and the branch gate, so the two can
  never disagree. A body line that opens with `word:` is read as a footer, and commitlint warns.
- **Semantic branches** — `<type>/<kebab-description>`, the type from that same list, ending
  with the issue number when there is one. Never work on `main`. The `pre-push` hook rejects
  anything else.
- **Rebase and merge — the history stays linear.** No merge commits; branch protection on `main`
  requires a linear history. A rebase merge gives every commit a new SHA on `main`, so anything
  that pins a commit of this repository pins the one on `main`, never the branch's.

## The gates

**Done means both are green:** `pnpm run check` (the skills — structure fails, style warns) and
`pnpm nx run @fmmenchi/ai-skills-docs:build` (the docs site — fails on any broken link).

## Hooks

- **`commit-msg`** runs commitlint.
- **`pre-push`** checks the names of **the refs being pushed**, read from stdin — not the branch
  checked out, which `git push origin HEAD:refs/heads/anything` would slip past — then runs
  `check-skills.sh`. It does not build the docs: it stays bash and fast, and needs no token.
- **The hooks fail open, silently.** `pnpm install` installs them per working tree, so a
  checkout or worktree that has not run it has no hook at all and says nothing. Run
  `pnpm install` once in every new worktree, and treat a green commit as evidence of nothing
  until you have. See `known-issues.md`.
- **Never bypass a hook.** `--no-verify` and its friends are forbidden; a failing gate gets
  fixed, and time pressure is not a justification. Nothing local can enforce this, which is why
  CI exists.

## CI

`.github/workflows/ci.yml` runs both gates and, on pull requests, the branch-name and
commit-message gates. It installs through `shared-platform`'s `setup` brick, **pinned by commit
SHA**, with the tag it corresponds to in a comment: bump it by moving both, never by switching
to a tag, which can be moved. The install passes the job's token with `packages: read`, because
the docs plugin comes from GitHub Packages.

The job is named `check`, and the name is load-bearing: branch protection on `main` requires a
check of exactly that name, and a renamed job leaves every pull request waiting on one that
never reports.

**Always wait for CI.** A green run on this machine is evidence about this machine — and the
hooks behind it fail open, so it may be evidence about nothing. CI is the only enforcement that
cannot be skipped from a laptop. It is worth the wait.

## Pushing

**Never push.** Fabio pushes, and merges.
