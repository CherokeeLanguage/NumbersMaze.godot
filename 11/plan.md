# Plan — itch description copy as raw HTML

NumbersMaze.godot#11 · plan for [the spec](../11/spec.md) (validated 2
rounds, zero-finding PASS). Two items — the two file edits the spec's scope
table names.

## Item 1 — Raw-HTML description body

**Traces to:** R-1, R-2, R-3, R-5 · SC-1, SC-2, SC-5, SC-6.

- **Deliverable:** `docs/itch-page-description.md`'s body below the cut
  line re-authored as raw HTML — same wording, same facts, markup swapped:
  `**…**` → `<strong>…</strong>`, `<url>` → `<a href="url">url</a>`,
  paragraphs → `<p>` blocks. The usage-header comment, title line, and
  cut-line structure above the body are untouched. No installation
  instructions are added.
- **RED (fails against current state):** I-1 matches 7 body lines (the
  markdown shapes); I-2's tag read fails (no `<p>`/`<strong>`/`<a href>` in
  the body).
- **GREEN:** the HTML body as described.
- **Verification:** I-1 (zero matches), I-2 (tags + six elements + fact
  greps), I-5 (stale-distribution tripwire zero + prohibition read), I-6
  (install-token zero + download-only read).
- **Depends on:** nothing (first edit).
- No test files authored — instruments are ephemeral read/grep runs.

## Item 2 — Runbook wording touch

**Traces to:** R-4 · SC-3, SC-4.

- **Deliverable:** `docs/itch-app-setup.md` Step 2 item 2's paste
  instruction states that the copy below the cut line is raw HTML. No other
  part of the runbook changes.
- **RED (fails against current state):** I-3 — "raw HTML" has zero matches
  in the runbook today.
- **GREEN:** the wording touch.
- **Verification:** I-3 (matches in the Step 2 item), I-4 (structure and
  paste-source pointer preserved).
- **Depends on:** nothing (independent file; sequenced after Item 1 by the
  dependency-order section below).

## Dependencies

1 → 2. The items edit different files and are independent; the order is
stated once, here.

## Traceability

Item 1 ← SC-1, SC-2, SC-5, SC-6 (R-1, R-2, R-3, R-5) · Item 2 ← SC-3, SC-4
(R-4, plus R-1's structure preservation and R-4's pointer). All six SCs
covered; no item lacks an SC trace; instrument definitions live in the
spec's Verification instruments subsection (single sourcing).

## Documentation sources

- The delivered copy (`docs/itch-page-description.md` on `main`, commit
  `d0eb5f7`) — the fact source whose details Item 1 preserves.
- `docs/itch-app-setup.md` Step 2 — the wording Item 2 touches.
- The controls bindings verified this session against `project.godot`
  `[input]` and `player/Player.gd` (evidence carried from #9's
  implementation; unchanged since).
- `../BoundPronouns/docs/itch-page-description.md` — the pattern source for
  the file's structure (read-only, outside the repo; its markdown body is
  the anti-pattern this change corrects for itch's Description field).

## Enforcement gate

Each item's verification set runs at the item's completion; the full
I-1…I-6 set runs as the end-state sweep before any completion claim. No
test framework exists in this repo; no test files are authored — every
instrument is an ephemeral read/grep run.

## Cost frame

Two files touched, none created. No build, no Godot editor pass — a
docs-only change; no scene, script, class, or export surface is involved.

## Edge cases

- HTML `<a href>` targets must URL-encode nothing special here (the two
  URLs are plain https links).
- The `·` separators and Cherokee glyphs are plain text inside HTML
  paragraphs — no encoding handling beyond the file's UTF-8.
- itch's Description field renders raw HTML; only basic inline/block tags
  are used (`<p>`, `<strong>`, `<a>`), nothing the field would strip or
  mis-render.

## Not included

The spec's Out of scope section governs: installation instructions (R-5's
stated exclusion), dashboard paste, `README.md` and the other untouched
files, any code/build change, runbook edits beyond the Step 2 wording.

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
