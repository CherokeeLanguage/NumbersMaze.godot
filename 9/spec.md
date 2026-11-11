# Spec — Proper repo docs: README without deploy instructions + itch page description

NumbersMaze.godot#9 · filed 2026-11-11 · labels: spec, documentation

## Problem

The repo's front door is a deploy runbook. `README.md` (25 lines) is, in its
entirety, the itch.io publish procedure — export presets, `itch.conf` setup,
`butler login`, `./itch-push.sh`, the vendored-butler note — and carries
nothing a readme exists to carry: no project description, no engine/run facts,
no index of the repo's docs. Deploy instructions do not belong in a repo's
readme (developer statement, 2026-11-11).

Separately, the game's itch.io page (live since 2026-11-11) needs a proper
description (developer statement, 2026-11-11). The repo-family convention
already records where that copy lives: `docs/itch-app-setup.md` Step 2 states
authoring is deferred to "the sibling repos' pattern [of] a paste-verbatim
`docs/itch-page-description.md` file" — this repo ships no such file.

### Observed failures (verified 2026-11-11)

- `README.md` lines 4–25 are the publish procedure; lines 1–2 are a bare
  title. No identity, engine, run, or doc-index content exists anywhere in
  the file.
- The procedure section duplicates documented surfaces: the export/conf/push/
  receipts flow is `docs/itch-app-setup.md` Step 3; the push-only contract,
  vendored-butler fallback, and login step are `itch-push.sh`'s header
  (lines 3–17) and the runbook's Prerequisites.
- The README's one unique fact is the live landing-page URL (line 6), which
  is also tracked in `itch.conf.example` (`ITCH_URL`,
  live-since 2026-11-11 comment).
- No `docs/itch-page-description.md` exists in this repo; the sibling
  pattern file is `../BoundPronouns/docs/itch-page-description.md`
  (usage-header comment → cut line → verbatim body: pitch, feature bullets,
  platform/download notes, issue-report link).
- The developer's existing description copy for this game lives on the
  CherokeeLessons site:
  `../CherokeeLessons/content/apps/cherokee-numbers-maze---ᏣᎳᎩ-ᏗᏎᏍᏗ-ᏚᎴᎾᎯᎯ/index.md`
  ("About": simple game to learn Cherokee numbers; wander a maze, collect
  dice matching the challenge, explode them; complete a level's challenges
  to advance to a larger level with more numbers; gamepad + keyboard
  controls; demo video). Its distribution section predates the itch-only
  decision (Google Play/Amazon/Apple store items, "No guarantees" HTML-Games
  link) and is stale for the new page — developer direction 2026-11-11:
  itch.io only, no Google Play path.

### Root cause

The README was authored as publication scaffolding during #5's itch
migration and never carried readme-level content; the itch page went live
without a repo-authored description file, so the runbook points at a sibling
instead.

## Scope

One repository — NumbersMaze.godot (every path below resolves under this
repo's session-init `path` prefix; no sibling repo's files are modified — the
two reference sources outside the repo are read-only inspiration inputs):

| File | Change |
|---|---|
| `README.md` | rewritten: identity, engine/run facts, game link, doc index; publishing section removed |
| `docs/itch-page-description.md` | new: paste-verbatim itch description, sibling pattern |
| `docs/itch-app-setup.md` | Step 2 description item re-pointed at the new file; no other edits |

No code, build-config, or runtime change. `itch-push.sh`,
`itch.conf.example`, `AGENTS.md`, and `text/changelog.txt` (generated) are
untouched.

## Requirements

- **R-1 — README without deploy instructions.** `README.md` SHALL carry no
  deploy/publish procedure: no export steps, no `itch.conf` setup, no butler
  login/push steps. It SHALL state: the project identity (Cherokee Numbers
  Maze — ᏣᎳᎩ ᏗᏎᏍᏗ ᏚᎴᎾᎯᎯ — a game for learning Cherokee numbers), the Godot
  3.x engine requirement (GDScript 1.x project; never opened with a Godot
  4.x editor), how to run it locally (Godot 3.x editor open + run, or
  `<godot3-binary> --path .`; scratch harness
  `<godot3-binary> --path . res://misc/TestScene.tscn`), and an index of the
  repo's docs (`docs/itch-app-setup.md` for publishing, `AGENTS.md` for
  repo/agent notes).
- **R-2 — Landing-page URL stays tracked in the README.** The README SHALL
  retain the published page URL as the game's home link, matching `ITCH_URL`
  in `itch.conf.example` — `https://cherokee-language.itch.io/cherokee-numbers-maze`.
  This preserves the URL-tracking requirement #5's R-6 carries (the runbook's
  Verification step operationalizes it) against the rewrite.
- **R-3 — No deploy fact orphaned.** Every operational fact the removed
  README section carried SHALL remain stated in the repo's tracked
  docs/scripts: the push-only contract (`itch-push.sh` header), the
  vendored-butler fallback and vendoring command (`itch-push.sh` header,
  runbook Prerequisites), the `itch.conf` copy step and `butler login`
  (runbook Prerequisites + Step 3), the push + per-channel receipts
  (runbook Step 3), and the live URL (README per R-2 + `itch.conf.example`).
  All were verified present on 2026-11-11; the rewrite must not orphan any.
- **R-4 — Description file follows the sibling pattern.**
  `docs/itch-page-description.md` SHALL follow the BoundPronouns pattern: an
  HTML-comment usage header instructing to copy everything below the cut
  line into the itch page's Description field (Edit-game → Description), a
  cut line separating the header from the body, and the description body as
  the verbatim paste content.
- **R-5 — Description content.** The body SHALL be adapted from the
  CherokeeLessons numbers-maze page (developer-named inspiration source) and
  SHALL cover five elements: (1) the game pitch — learn the Cherokee
  numbers; (2) the challenge-and-level mechanics — wander the maze, collect
  dice matching the challenge, explode them, advance to larger levels with
  more numbers; (3) controls for gamepad and keyboard, verified against the
  project's current input map (`project.godot` `[input]`: `left/right/up/down`,
  `btn_a/btn_x/btn_y/btn_b`, `btn_select`, `btn_start`, `move_to` — the 2021
  page's A/X/Y roles are re-verified at write time, not copied blindly);
  (4) the itch platforms — browser-playable build plus Windows, macOS,
  Linux, and Android downloads served by the itch page; (5) the project's
  issue-tracker link (`https://github.com/CherokeeLanguage/NumbersMaze.godot/issues`).
  Distribution claims SHALL reflect the itch-only reality (developer
  direction 2026-11-11): the description SHALL name itch.io as the sole
  distribution channel and SHALL carry none of the source page's stale
  distribution content — no Google Play / Google App Store / Amazon /
  Apple / Microsoft Store / Linux Store items, no external play-online
  link (the source's `/HTML-Games/NumbersMaze` path), and no non-itch
  direct-download file links (the source's `NumbersMaze.x86_64`,
  `NumbersMaze-x86_64.exe`, `NumbersMaze-mac.zip` links).
- **R-6 — Runbook pointer.** `docs/itch-app-setup.md` Step 2's description
  item SHALL name `docs/itch-page-description.md` as the paste source,
  replacing the current "out of scope … see BoundPronouns'" wording. The
  runbook's Verification step ("add the URL to `README.md`") SHALL remain
  consistent with the rewritten README (the README keeps the URL per R-2, so
  the instruction stands unmodified).

## Approach

1. Rewrite `README.md`: title + Cherokee name, one-paragraph identity,
   engine requirement, run instructions (editor + command line + scratch
   harness), the live game link, and a docs index pointing at the runbook,
   `AGENTS.md`, and the description file. No publish steps.
2. Author `docs/itch-page-description.md` on the sibling pattern: usage
   header comment, cut line, then the description body adapted from the
   CherokeeLessons page with the itch-only distribution facts. The demo
   video from the source page (YouTube `tj6c0UGRMF4`) may be linked.
3. Edit `docs/itch-app-setup.md` Step 2 item 2: the description copy is
   authored in-repo at `docs/itch-page-description.md`; the developer pastes
   it verbatim.
4. Verify with the instruments below (grep preservation + element reads).

## Success criteria

| ID | Criterion | Class | Instrument | Traces to |
|---|---|---|---|---|
| SC-1 | `README.md` contains no deploy/publish procedure | structural | I-1 | R-1 |
| SC-2 | README states the four R-1 elements: identity (game + Cherokee name), Godot 3.x requirement, local run path, docs index | structural | I-2 | R-1 |
| SC-3 | README's URL = `ITCH_URL` in `itch.conf.example` = `https://cherokee-language.itch.io/cherokee-numbers-maze` | structural | I-3 | R-2 |
| SC-4 | `docs/itch-page-description.md` exists with the sibling pattern structure: usage-header comment, cut line, verbatim body below | structural | I-4 | R-4 |
| SC-5 | the description body covers the five R-5 elements | structural | I-5 | R-5 |
| SC-6 | the description carries no stale distribution content: itch.io is the only named distribution channel, and none of the source page's stale distribution content appears (Google Play / Google App Store / Amazon / Apple / Microsoft Store / Linux Store items, the `/HTML-Games/NumbersMaze` play-online link, the non-itch direct-download file links) | structural | I-6 | R-5 |
| SC-7 | the runbook's Step 2 description item names this repo's `docs/itch-page-description.md` as the paste source, replacing the out-of-scope wording | structural | I-7 | R-6 |
| SC-8 | every R-3 fact remains stated in the tracked docs/scripts | structural | I-8 | R-3 |

Every criterion is atomic, binary-verifiable by its instrument, and
deliverable-owned (the docs' content — not the toolchain's). No behavioral
criteria: the change touches no runtime surface.

### Verification instruments

```
I-1  grep -inE 'butler|itch-push|itch\.conf' README.md
     → zero matches, and no step-numbered deploy section in the README
I-2  README read against the four R-1 elements
I-3  string match across README.md and itch.conf.example — both state
     https://cherokee-language.itch.io/cherokee-numbers-maze
I-4  head-of-file read of docs/itch-page-description.md — usage-header
     comment, cut line, verbatim body below
I-5  description body read against the five R-5 elements
I-6  grep -inE 'Google Play|Google App Store|App Store|Amazon|Apple|Microsoft Store|Linux Store|HTML-Games|play\.google\.com|apps\.apple\.com|amazon\.com' docs/itch-page-description.md
     → zero matches, plus the distribution content read against R-5's
     enumerated prohibition list
I-7  grep -n "out of scope for this repo's publication tooling" docs/itch-app-setup.md
     → zero matches, plus the Step 2 item read shows this repo's
     docs/itch-page-description.md as the paste source
I-8  per-fact greps: itch-push.sh header states the push-only contract and
     the vendored-butler fallback with its vendoring command;
     docs/itch-app-setup.md states the itch.conf copy step, butler login,
     and the push + per-channel receipts; itch.conf.example states ITCH_URL
     with the live URL
```

Instruments I-1, I-6, and I-7 were exercised against the pre-change state on
2026-11-11: I-1 and I-6 match the tokens they guard (proving post-change
zero-matches is informative), and I-7 matches exactly once pre-change (the
superseded wording), so the post-change zero observes the edit.

## Out of scope

- itch.io dashboard/account actions — the developer pastes the description;
  page setup, tagging, publish, and rollback stay per the runbook.
- `itch-push.sh`, `itch.conf.example`, `AGENTS.md`, `text/changelog.txt`.
- Any game/code, scene, or build-config change; no export-preset edits.
- Rewriting `docs/itch-app-setup.md` beyond the Step 2 pointer (its
  procedure content is the preservation target, not a rewrite subject).

## Impact / blast radius

- **Consumers:** the itch page (description paste source), repo readers
  (README is the front door), agent sessions (`AGENTS.md` unchanged; the
  README's doc index now routes humans and agents to the same docs).
- **Cross-references:** the runbook's Verification step references
  `README.md` for the URL — stays satisfied by R-2. #5's artifacts are
  historical record (issue closed); this spec supersedes the placement of
  #5's README publishing section (R-6/SC-8), not #5's history — no revision
  to the closed record.
- **Risk:** low. Rollback: `git revert`; the page-side description is
  dashboard-reversible per the runbook's rollback notes. No data-loss or
  destructive path exists in a docs change.

## Provenance

- Developer statements (2026-11-11): "the readme is bogus. deploy
  instructions do not belong in a repo's readme"; "file a spec to produce a
  proper set of repo docs then approved for PR"; "the game needs a proper
  description on itch-io also; refer to ../CherokeeLessons numbers maze page
  for inspiration".
- Current-state evidence verified this session: README.md (25 lines, read);
  `docs/itch-app-setup.md` (read; Step 2 item 2, Step 3, Prerequisites,
  Verification/rollback); `itch-push.sh` header (read); `itch.conf.example`
  (read; `ITCH_URL` live-since comment); `project.godot` (`run/main_scene`
  = `res://main/Main.tscn`; `[input]` action names); `../BoundPronouns/docs/itch-page-description.md`
  (read; pattern source); `../CherokeeLessons/content/apps/cherokee-numbers-maze---ᏣᎳᎩ-ᏗᏎᏍᏗ-ᏚᎴᎾᎯᎯ/index.md`
  (read; inspiration source); `AGENTS.md` (engine, harness, publication
  facts); issue store (`#3`, `#4`, `#5` closed; #5's R-6/SC-8 authored the
  section now removed).
- Alternatives weighed: folding the description into
  `docs/itch-app-setup.md` (rejected — the runbook is dashboard-scoped and
  the paste-verbatim sibling pattern is the family convention); leaving the
  README's publish section in place (rejected — it is the stated defect);
  creating a separate `docs/itch-publishing.md` (rejected — the procedure
  already lives in the runbook Step 3; a third doc would duplicate it).

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
