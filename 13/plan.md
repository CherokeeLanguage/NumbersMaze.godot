# Plan — itch page installation instructions in the description copy

NumbersMaze.godot#13 · plan for [the spec](../13/spec.md) (validated 1 round,
zero-finding PASS). One item — the one file edit the spec's scope table
names.

## Item 1 — Installation-guidance element

**Traces to:** R-1, R-2, R-3, R-4 · SC-1, SC-2, SC-3, SC-4.

- **Deliverable:** `docs/itch-page-description.md` gains one
  installation-guidance element — a single `<p>` block placed after the
  Platforms element: a `<strong>Installing:</strong>` lead, the Android APK
  guidance (installs directly on the device; Android may ask once to allow
  installing apps from this source), and the desktop guidance (Windows,
  macOS, and Linux builds are plain downloads — grab and run). Raw HTML; no
  markdown below the cut line; no store or non-itch distribution mention;
  no other element or wording changes anywhere in the copy or the
  above-the-cut-line structure.
- **RED (fails against current state):** I-1's element read fails (no
  installation-guidance element exists in the copy); I-4's
  `grep -in install` returns zero matches (no guidance element, so nothing
  carries the token).
- **GREEN:** the element as described.
- **Verification:** I-1 (element read covers APK + desktop), I-2 (markdown
  grep → zero), I-3 (stale-distribution tripwire → zero), I-4 (every
  `install` match's line number inside the guidance element's span, stated
  in the implementation evidence).
- **Depends on:** nothing (first and only item).
- No test files authored — instruments are ephemeral read/grep runs.

## Dependencies

Single item; no ordering constraints.

## Traceability

Item 1 ← SC-1, SC-2, SC-3, SC-4 (R-1, R-2, R-3, R-4). All four SCs covered;
no untraced item; instrument definitions live in the spec's Verification
instruments subsection (single sourcing).

## Documentation sources

- The delivered copy (`docs/itch-page-description.md` on `main`, `4e093de`)
  — the element's insertion surface and the wording it must not disturb.
- `../BoundPronouns/docs/itch-page-description.md` — the pattern's install
  notes (desktop-Java and Android-APK guidance), adapted to this game's
  builds (read-only, outside the repo).
- The live page's served file list (four builds, session-recorded evidence
  in the spec's provenance) — what the guidance must cover.
- #11's validated criteria set (`.issues/11/spec.md`) — the carried-forward
  instruments (I-2 = #11's I-1, I-3 = #11's I-5) and the superseded one
  (I-6 → this plan's I-4 seam).

## Enforcement gate

The item's verification set (I-1…I-4) runs at completion; the end-state
sweep is the same set (single item). No test framework exists in this repo;
no test files are authored — every instrument is an ephemeral read/grep run.

## Cost frame

One file touched, none created. No build, no Godot editor pass — a
docs-only change.

## Edge cases

- I-3's token set includes `Apple` and `App Store`: the guidance's wording
  must avoid them (it names macOS, not Apple; "allow installing apps from
  this source" contains neither token) — verified at GREEN.
- The Android allow-installs note is generic Android sideload behavior
  (stated in the spec's R-1 from the sibling pattern), not a version-specific
  claim.
- I-4's containment check is decidable because the guidance is the only
  element adding `install` tokens; the element's line span is recorded in
  the implementation evidence.

## Not included

The spec's Out of scope section governs: dashboard/dashboard-page changes,
`README.md` and the other untouched files, any code/build change, and any
guidance beyond the description copy (e.g. no separate install document).

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
