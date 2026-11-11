# Plan — Proper repo docs: README without deploy instructions + itch page description

NumbersMaze.godot#9 · plan for [the spec](../9/spec.md) (validated 2026-11-11,
four rounds, zero-finding PASS). Three items — the three file edits the spec's
scope table names; each item's verification set carries the SCs its edit
delivers.

## Item 1 — README rewrite

**Traces to:** R-1, R-2, R-3 · SC-1, SC-2, SC-3, SC-8.

- **Deliverable:** `README.md` rewritten in one edit: title + Cherokee name
  (ᏣᎳᎩ ᏗᏎᏍᏗ ᏚᎴᎾᎯᎯ), one-paragraph identity (a game for learning the
  Cherokee numbers), engine requirement (Godot 3.x / GDScript 1.x; never
  opened with a Godot 4.x editor), run instructions (Godot 3.x editor open +
  run, or `<godot3-binary> --path .`; scratch harness
  `<godot3-binary> --path . res://misc/TestScene.tscn`), the live game link,
  and a docs index (`docs/itch-app-setup.md` — publishing;
  `docs/itch-page-description.md` — itch page copy; `AGENTS.md` — repo/agent
  notes). The publishing section is deleted; the landing-page URL line is
  preserved. No deploy/publish procedure remains.
- **RED (fails against current state):** I-1 matches 7 lines in the current
  `README.md` (lines 8, 13, 14, 16, 18, 21, 22 — the butler / itch-push /
  itch.conf tokens in the procedure prose); I-2 fails — no identity, engine,
  run, or docs-index content exists in the file.
- **GREEN:** the rewrite above.
- **Verification:** I-1 (zero matches), I-2 (four elements present), I-3
  (README and `itch.conf.example` both state the URL), I-8 (every R-3 fact
  still stated in the tracked docs/scripts — the removal orphans nothing).
- **Depends on:** nothing (first edit).
- No test files authored — instruments are ephemeral read/grep runs.

## Item 2 — itch page description file

**Traces to:** R-4, R-5 · SC-4, SC-5, SC-6.

- **Deliverable:** `docs/itch-page-description.md` created, following the
  BoundPronouns pattern: an HTML-comment usage header (copy everything below
  the cut line into Edit-game → Description), a cut line, then the verbatim
  description body. The body is adapted from the CherokeeLessons
  numbers-maze page and covers the five R-5 elements: pitch; mechanics;
  controls; itch platforms; issue-tracker link. It may link the source
  page's demo video (YouTube `tj6c0UGRMF4`). It carries none of the
  enumerated stale distribution content.
- **Controls verification (before writing the controls element):** read
  `project.godot` `[input]` event definitions and the consuming code
  (`is_action_pressed` sites) to state the current bindings — the 2021
  source page's A=fireball / X=pickup / Y=drop roles are re-verified against
  today's input map, never copied blindly. The description states only
  bindings verified this way.
- **RED (fails against current state):** the file does not exist — I-4's
  read fails, I-5's element read fails, I-6's grep fails.
- **GREEN:** the file authored with the pattern structure and the five
  elements, itch-only distribution content.
- **Verification:** I-4 (pattern structure), I-5 (five elements), I-6
  (tripwire zero matches + prohibition-list read).
- **Depends on:** nothing (independent file; sequenced after Item 1 by the
  dependency-order section below).

## Item 3 — Runbook Step 2 pointer

**Traces to:** R-6 · SC-7.

- **Deliverable:** `docs/itch-app-setup.md` Step 2 item 2 rewritten: the
  description copy is authored in this repo at
  `docs/itch-page-description.md`; the developer pastes the body below the
  cut line verbatim into Edit-game → Description. The superseded sentence
  ("authoring the description copy is out of scope for this repo's
  publication tooling — the sibling repos' pattern is a paste-verbatim
  `docs/itch-page-description.md` file (see BoundPronouns')") is replaced.
  No other part of the runbook changes (it is the preservation target of
  SC-8, not a rewrite subject).
- **RED (fails against current state):** I-7's superseded-wording grep
  matches exactly once today.
- **GREEN:** the item text names this repo's file as the paste source.
- **Verification:** I-7 (zero matches post-change + the paste-source read).
- **Depends on:** Item 2 (the pointed-at file exists).

## Dependencies

1 → 2 → 3. Item 3 requires Item 2's file to exist; Items 1 and 2 are
independent of each other (different files); the order is stated once, here.
One cross-reference to note: Item 1's docs index references the file Item 2
creates — that reference resolves by the end state and carries no build
dependency (the items edit different files and are independently verifiable;
the PR squash makes the ordering invisible in history).

## Traceability

Item 1 ← SC-1, SC-2, SC-3, SC-8 (R-1, R-2, R-3) · Item 2 ← SC-4, SC-5, SC-6
(R-4, R-5) · Item 3 ← SC-7 (R-6). All eight SCs covered; no item lacks an SC
trace; instrument definitions live in the spec's Verification instruments
subsection (single sourcing — the plan does not restate them).

## Documentation sources

- `AGENTS.md` — engine facts (3.x-only, GDScript 1.x, smoke-check and
  harness commands), publication notes. Source for Item 1's run/engine
  content.
- `itch-push.sh` header and `docs/itch-app-setup.md` — the publishing facts
  Item 1's removal must not orphan (verification targets of I-8).
- `../BoundPronouns/docs/itch-page-description.md` — the sibling pattern
  Item 2 follows (read-only, outside the repo).
- `../CherokeeLessons/content/apps/cherokee-numbers-maze---ᏣᎳᎩ-ᏗᏎᏍᏗ-ᏚᎴᎾᎯᎯ/index.md`
  — the copy source Item 2 adapts (read-only, outside the repo).
- `project.godot` `[input]` and the `is_action_pressed` call sites — the
  controls-verification surface for Item 2.

## Enforcement gate

Each item's verification set runs at the item's completion, and the full
I-1…I-8 set runs as the end-state sweep before the PR-readiness claim. No
test framework exists in this repo (no CI, no test framework per
`AGENTS.md`); no test files are authored — every instrument is an ephemeral
read/grep run, and no heavy tier enters any default run (none exists).

## Cost frame

Three files touched, one created. No build, no Godot editor pass — a
docs-only change touches no scene, script, class registration, or export
configuration; `project.godot` is read (input map) but not modified.

## Edge cases

- The Cherokee glyphs in the README title are UTF-8 text in a UTF-8 file —
  no encoding handling needed; the repo already carries Cherokee strings.
- The description body stays markdown/plain text (the BoundPronouns pattern
  is paste-verbatim prose) — itch's Description field renders markdown; no
  HTML beyond the pattern's usage-comment header.
- The runbook's Verification step instructs adding the URL to `README.md` at
  publication — Item 1 preserves the URL, so that instruction stays accurate
  with no runbook edit beyond Item 3's.

## Not included

The spec's Out of scope section governs: dashboard/account actions;
`itch-push.sh`, `itch.conf.example`, `AGENTS.md`, `text/changelog.txt`;
game/code/scene/build-config changes; runbook edits beyond Step 2 item 2.

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
