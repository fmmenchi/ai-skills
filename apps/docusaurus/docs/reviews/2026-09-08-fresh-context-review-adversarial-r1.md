# Adversarial review of `fresh-context-review` — revision 1

- **Date:** 2026-09-08
- **Artefact reviewed:** the skill at revision 1, then named `reviewing-adversarially`, with its
  three evals inside the skill directory
- **Reviewer:** a fresh-context agent briefed with the skill's own template
- **Outcome:** 12 findings, all CONFIRMED. Dispositions in `fresh-context-review.record.md`.

Verbatim, as delivered (HTML entities in the original output restored).

---

**1. The skill's name collides with the pipeline skill the programme plan already names `reviewing-adversarially`, and the description cannot name that sibling by design.**
Anchor: `name: reviewing-adversarially`; ADR 0005: *"The programme's plan names seven skills its pipeline needs — triage, plan, implement, verify, review adversarially…"* and *"The seven pipeline skills live in `devmate/skills/`"*. Verified: `fmmenchi/devmate` branch `docs/programme-plan`, `doc/plan/devmate-programme.md:139` lists `reviewing-adversarially` as a devmate skill emitting `findings/<reviewer>/NNN.json`.
Scenario: `install.sh` links this skill into `~/.claude/skills`, `~/.codex/skills`, `~/.agents/skills`; devmate ships its own `reviewing-adversarially` project-scoped. Inside devmate, Claude Code shadows the user-level one silently (the craft skill never fires there); Codex/Cursor list two identically named skills and pick by description, which here says nothing about the other. Outside devmate the craft skill fires on the pipeline's own wording ("review adversarially"). authoring.md: *"Two that fire where the other must not are two skills, and each states the other's never when"* — this one cannot, because the repository *"knows nothing of the programme"*.
Verdict: CONFIRMED.
Fix: rename to a name the pipeline will not take (e.g. `fresh-context-review`), and add one never-when clause: *"never when a pipeline expects findings as structured files; that skill is the project's"*.

**2. The "done" criterion is unreachable by construction: the fresh pass reads the artefact that now carries the review record, so it cannot return findings "the author has already dispositioned".**
Anchor: §6 *"The artefact is done when a fresh pass returns findings the author has already dispositioned — that is the signal the reviews have converged, and the only one."* together with §5 *"At its end, a review record"* and §2 *"inconsistencies are findings… No preamble, no praise, no restating the artefact"*.
Scenario: revision 3 carries a record saying "score split in two — rejected, because X". The round-3 reviewer is given revision 3, reads that paragraph, and — briefed to find what is *not* settled and to avoid restating — steers away from it and reports 8–12 *new* findings (the floor in finding 3 guarantees them). No pass ever returns already-dispositioned findings; "done" never fires; the loop is bounded only by the author giving up. It also breaks §3 *"never tell one what another owns"*: the record tells every later reviewer exactly which lens found what.
Verdict: CONFIRMED.
Fix: replace with a testable stop: *"done when a fresh pass returns no CONFIRMED finding of severity above the lowest already accepted, or only findings whose disposition is already in the record"* — and give the round-N reviewer the artefact **without** the record, or state that reading the record is part of the pass.

**3. The count range mandates the padding it claims to prevent; the quotation cited in support argues the opposite.**
Anchor: §2 template *"<N–M> findings"* and *"State the count range. Without one, a reviewer prompted to find gaps will pad to look thorough — 'a reviewer prompted to find gaps will usually report some, even when the work is sound' — and the range plus the verdict split is what keeps padding visible."*
Scenario: a sound six-page note; brief says "8–12 findings". The reviewer must produce eight, so items 5–8 are style notes dressed as defects with PLAUSIBLE verdicts. The author then spends §4 effort dismissing invented findings, and §6 never converges (finding 2). The floor *N* is the padding target; the quoted sentence says a reviewer reports gaps *even when there are none*, which is the case *against* a floor, not for one. This brief is the instance: "8–12 findings" of a 113-line file.
Verdict: CONFIRMED.
Fix: drop the floor — *"at most M findings; zero is a valid answer and must be stated as such"* — and let the verdict split alone carry the padding signal.

**4. The fixed brief forbids the reviewer from doing what §1 says makes a reviewer valuable.**
Anchor: §1 *"a reviewer that may probe, run, or mutate a copy finds more than one that may only read"* versus the template's first line *"Read this, read-only — do not edit any file"* and *"Its shape is fixed"*.
Scenario: the author follows §1, gives the reviewer an isolated working copy, then pastes the fixed brief. The reviewer obeys the brief, never runs the gate or a mutation probe, and the isolation bought nothing. Or it obeys §1 and violates the brief, and the transcript shows an instruction ignored.
Verdict: CONFIRMED.
Fix: make the first line conditional — *"Do not edit `<artefact path>`; you may run and mutate anything else in this copy"* when isolation exists — and stop calling the shape fixed (authoring.md reserves *fixed* for output *something downstream parses*; nothing parses this brief).

**5. The repository's product-agnosticism is breached: the product's plan path and its runner contract are inside the skill directory.**
Anchor: `evals/01-same-context-review.md:9` *"The session has just written `doc/plan/devmate-programme.md`"*; `SKILL.md:44–46` *"the runner contract is (repo, issue, skills, effort) → exit status — can it express a human gate mid-run, a fix loop, N parallel reviewers?"* (the devmate contract, verbatim in its plan). ADR 0005: *"`.agents/doc/architecture.md` says so in one paragraph, and that paragraph is the only place the product is named."*
Scenario: the skill is symlinked into every tool on the machine; a session in an unrelated repository activates it and is handed devmate's runner contract as the worked example of an attack surface, and `evals/01` refers a stranger to a file that exists only on an unmerged branch of another repository. ADR 0005 is false the day it is accepted.
Verdict: CONFIRMED.
Fix: replace the runner-contract example with a neutral one (any interface signature) and make eval 01's setup *"the session has just written a multi-hundred-line plan"* with no path.

**6. Both italicised quotations are unsourced and are other people's sentences.**
Anchor: §2 *"'a reviewer prompted to find gaps will usually report some, even when the work is sound'"* and *"A reviewer told its deadline returns shallow findings fast, indistinguishable from diligence."* Provenance (from devmate's `2026-09-07-prior-art-r2.md`): the first is Anthropic's agent best-practices text; the second is a `LEARNING` note in `maroffo/claude-advanced-review`.
Scenario: a reader treats the quoted sentence as the skill's own measured claim (contract/AGENTS.md: *"Keep what you verified separate from what you assumed"*); a later maintainer cannot check it, cannot update it when the source changes, and the skill presents a third party's calibration note as a law. The quotation marks with no attribution are worse than paraphrase: they assert a source and hide it.
Verdict: CONFIRMED.
Fix: attribute inline (*"Anthropic's agent guidance: …"*, *"observed in one review harness's notes: …"*) or drop the quotation marks and own the claim.

**7. The evals are not runnable: their setup is a transcript state, their baseline is a claim, and eval 03's query contains no trigger the description routes on.**
Anchor: `evals/README.md` *"An eval is run by giving a fresh agent the query and the setup, with and without the skill installed… The baseline column is what actually happened without it"* (the table has no baseline column); `01` setup *"its context holds every argument that produced it"*; `01` baseline *"The same session reviewed its own plan in place and produced a list of concerns it already held"* (no artefact exists for this); `03` query *"integra le review e aggiorna il piano"*.
Scenario: a stranger tries eval 01 without the skill: they cannot recreate "a session that has just written the plan" — the plan is on another repository's unmerged branch — and the pass criterion *"the transcript shows the brief and the hand-off"* has no file to inspect. Eval 03: the description fires on *adversarial review / red-team / "break" / before a draft leaves*; "integrate the reviews and update the plan" has none of those words, so with the skill installed it does not activate and the eval fails *with* the skill.
Verdict: CONFIRMED.
Fix: give each eval a self-contained fixture (a 40-line sample plan under `evals/fixtures/`), state the baseline as an observable ("no `reviews/` directory is created"), and either add "integrate the reviews" to the description's triggers or drop eval 03.

**8. `evals/` is a directory the conventions do not recognise, the gate never inspects, and `install.sh` ships into every tool — and it is a layout rule for every future skill introduced without an ADR.**
Anchor: `evals/README.md` *"as `.agents/doc/authoring.md` requires"* — authoring.md requires *writing* three scenarios and says nothing about a directory; architecture.md *"Convention… the `references/` `scripts/` `assets/` split"*; `check-skills.sh` only resolves `(references|scripts|assets)/` paths; `install.sh:79` symlinks the skill directory whole; AGENTS.md *"any rule that binds every future skill: write `doc/adr/…`"*.
Scenario: the next skill puts evals in `tests/`, a third in `SKILL.md` itself; nothing warns. Meanwhile every tool receives `evals/` (with the product path from finding 5 and Italian queries) under `~/.codex/skills/reviewing-adversarially/`, and a tool that indexes the directory reads them as skill content. ADR README: *"the contents of one skill"* is not structural — but a directory convention is.
Fix: one line in authoring.md naming `evals/` (or `SKILL.md § Evals`) as the home, a `warn` in `check-skills.sh` when a skill has fewer than three, and an ADR if it is to bind.
Verdict: CONFIRMED.

**9. §5's layout only exists for a Markdown document under `doc/`; the description promises "a change", which has no revision number and no `reviews/` beside it.**
Anchor: description *"of a plan, a document or a change"*; §5 *"doc/<artefact>.md revision N / doc/reviews/<date>-<lens>-r<N-1>.md"* and *"Produce the next revision of the artefact, numbered"*.
Scenario: the artefact is a pull request. There is no `doc/<artefact>.md`, a diff carries no revision number to put in `r<N-1>`, and "keep every review verbatim beside the artefact" has no beside. The artefact is this skill: the reviews land in `skills/reviewing-adversarially/reviews/` and are symlinked into three tool directories (finding 8). The one real instance (devmate) is `doc/plan/reviews/`, not `doc/reviews/` — the example is already not followed by its own origin.
Verdict: CONFIRMED.
Fix: state the rule, not the path — *"a `reviews/` directory next to the artefact's own directory; for a change, next to the plan or note the change implements, never inside a shipped skill"* — and say what "revision" means for a diff (the PR round).

**10. The brief — the one input that encodes the author's knowledge of where the artefact is weakest — is never recorded, and the hand-off to "a separate session, or a person" is never written to disk.**
Anchor: §2 *"The author knows where the artefact is weakest; say so in the brief"*; §5 *"Keep every review verbatim beside the artefact"* (reviews only); §4 *"that correction is evidence about the review, and the next reviewer needs it"*; eval 01 pass criterion *"the transcript shows the brief"*.
Scenario: three sessions later the record says "adversarial review, 15 findings, 14 confirmed" and nothing about what it was asked to attack, so nobody can tell whether the runner contract was probed or simply not in scope. On a tool with no delegation the skill's only permitted paths are "a separate session, or a person" — both need the brief as a file, and the skill never says to write one, so the agent stops with a brief in its own output and no hand-off.
Verdict: CONFIRMED.
Fix: *"Write the brief to `reviews/<date>-<lens>-r<N-1>.brief.md` before launching; that file is the hand-off when no delegation exists."*

**11. The description's last trigger fires on everything, and its never-when names no sibling and no checkable criterion.**
Anchor: *"…or before a draft leaves the repository — and whenever the artefact's author is the current session. Never for a routine code review against a checklist…"*; authoring.md *"name the sibling to read instead — with a criterion that can be checked, not interpreted"*.
Scenario: a session writes a README paragraph; it authored the artefact, so the clause says fire, and a 100-line review protocol activates for a one-line edit. Conversely "routine" and "checklist" are the reader's judgement — a PR review asked as "is this PR ok?" matches neither trigger nor exclusion, and the collision in finding 1 is exactly where a checkable criterion was needed.
Verdict: CONFIRMED.
Fix: drop *"whenever the artefact's author is the current session"* (it is a condition of *how*, already in the body, not of *when*) and make the exclusion checkable: *"never for a diff review: use the project's code-review skill"*.

**12. Body rules broken: second person, the same prohibition stated four times, and deterministic steps left as prose with no `scripts/`.**
Anchor: §3 *"Launch only as many as you will integrate."* (ADR 0003: body *"never second person… This one binds"*); the same-context rule in the description (twice), §1 (twice: *"Hand the review to a reader that has not seen the conversation"*, *"Do not run the review in the current context"*) and *"What this is not — A defence"*; §5's counts *"how many findings, how many confirmed"*, the filename pattern, and §6 *"every finding has a written disposition"* — all mechanically checkable, yet authoring.md says *"prose for judgement, scripts/ for procedure"* and *"Close the loop wherever a script can judge the result"*.
Scenario: a review record says "12 findings, 11 confirmed" for a file holding 13; a disposition is missing for finding 9; the file is named `r2` for a review of revision 2. Nothing catches any of it, and the skill's own §4 says a reviewer's miscount is evidence — while offering no way to count.
Verdict: CONFIRMED.
Fix: *"Launch only as many as will be integrated"*; keep the rule once in the body; add `scripts/check-record.sh <artefact> <reviews-dir>` that counts findings and verdicts per review file, checks each has a disposition in the record, and validates the `<date>-<lens>-r<N-1>` name against the artefact's revision line.
