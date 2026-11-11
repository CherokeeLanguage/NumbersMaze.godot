# Spec — itch description copy as raw HTML (markdown renders literally on the page)

NumbersMaze.godot#11 · filed 2026-11-11 · labels: spec, bug, documentation

## Problem

The itch.io Description field does not render markdown. The description copy
delivered under #9 (`docs/itch-page-description.md`, merged to `main` in PR
#10 at commit `d0eb5f7`) was pasted to the live page, and the page shows the
markdown markup literally: `**Gamepad:**`, `**[A]**`, `**[X]**`, and the
`<https://…>` autolink brackets appear as raw characters (verified by
fetching https://cherokee-language.itch.io/cherokee-numbers-maze on
2026-11-11; the page's "Updated 1 minute ago" timestamp at fetch time shows
the paste had just happened).

Developer statements (2026-11-11): markdown is not supported for game
descriptions or game installation instructions; the supported format is
**raw HTML**. Routing: always a new spec after a merge — this correction is
a new ticket, not a revision of the closed #9.

### Observed failure

- Live page (fetched 2026-11-11) renders `**Gamepad:** left stick or D-pad
  to move · **[A]** fireball · …` and `Demo video:
  <https://www.youtube.com/watch?v=tj6c0UGRMF4>` as literal text — the bold
  markers and angle-bracket autolinks are visible to players.

### Root cause

#9's spec never stated the itch Description field's format constraint — its
R-4 adopted the BoundPronouns pattern file's *structure* (usage header, cut
line, verbatim body) and its R-5 the content elements, but neither stated
the body's markup language. The BoundPronouns sibling file is itself
markdown-bodied, so following the pattern faithfully reproduced a copy the
target surface cannot render. The constraint surfaces only against the live
page, which no instrument in #9's criteria set observed.

## Scope

One repository — NumbersMaze.godot:

| File | Change |
|---|---|
| `docs/itch-page-description.md` | body below the cut line re-authored as raw HTML; content details preserved |
| `docs/itch-app-setup.md` | Step 2 paste instruction states the copy is raw HTML; no other edits |

No code, build-config, or runtime change. `README.md` (a GitHub surface —
markdown is correct there), `itch-push.sh`, `itch.conf.example`,
`AGENTS.md`, and `text/changelog.txt` are untouched.

## Requirements

- **R-1 — Raw-HTML body.** The description body below the cut line SHALL be
  raw HTML: block structure and emphasis via HTML tags (`<p>`,
  `<strong>`/`<b>`, `<a href>`), and no markdown syntax anywhere below the
  cut line — no `**` emphasis, no markdown headings or bullets, no
  `<url>` autolink brackets. The usage-header comment, the title line, and
  the cut-line structure above the body are unchanged (they are repo-side
  guidance, never pasted).
- **R-2 — Content details preserved.** The body SHALL carry the same five
  elements as the delivered copy (#9's R-5, verified at its merge): the
  pitch (learn the Cherokee numbers — ᏣᎳᎩ ᏗᏎᏍᏗ — by playing a maze game);
  the challenge-and-level mechanics (wander the maze, collect dice matching
  the challenge, explode them, advance to larger levels with more numbers);
  the controls with the bindings verified this session against
  `project.godot`'s input map and `player/Player.gd` (gamepad: stick/D-pad
  move, A fireball, X pick up, Y drop; keyboard: arrows move, F/Space/Enter
  fireball, D pick up, S drop); the itch platforms (browser-playable plus
  Windows/macOS/Linux/Android downloads served by the page); the demo-video
  link (YouTube `tj6c0UGRMF4`); and the issue-tracker link
  (`https://github.com/CherokeeLanguage/NumbersMaze.godot/issues`). Wording
  is unchanged except where the format requires it.
- **R-3 — Stale-content prohibition carries over.** itch.io SHALL remain
  the only named distribution channel: no Google Play / Google App Store /
  Amazon / Apple / Microsoft Store / Linux Store items, no external
  play-online link (the source page's `/HTML-Games/NumbersMaze` path), no
  non-itch direct-download file links (developer direction 2026-11-11:
  itch.io only).
- **R-4 — Runbook wording.** `docs/itch-app-setup.md` Step 2's paste
  instruction SHALL state that the copy below the cut line is raw HTML, so
  the developer knows what the field expects before pasting.
- **R-5 — Install instructions excluded.** No installation instructions are
  added to the copy (developer direction 2026-11-11: "ignore install
  instructions for now").

## Approach

1. Rewrite the body below the cut line in `docs/itch-page-description.md`
   as raw HTML — same wording, same facts, markup swapped: `**…**` →
   `<strong>…</strong>`, `<url>` → `<a href="url">url</a>`, paragraphs →
   `<p>` blocks.
2. Touch the runbook's Step 2 item to state the raw-HTML format.
3. Verify with the instruments below.

## Success criteria

| ID | Criterion | Class | Instrument | Traces to |
|---|---|---|---|---|
| SC-1 | no markdown syntax below the cut line | structural | I-1 | R-1 |
| SC-2 | the body is raw HTML carrying the five elements with the delivered details | structural | I-2 | R-2 |
| SC-3 | the runbook states the raw-HTML format | structural | I-3 | R-4 |
| SC-4 | pattern structure and single paste source preserved | structural | I-4 | R-1, R-4 |

Every criterion is atomic, binary-verifiable by its instrument, and
deliverable-owned. No behavioral criteria: the change touches no runtime
surface.

### Verification instruments

```
I-1  grep -nE '\*\*|<http' below-the-cut-line content of docs/itch-page-description.md
     → zero matches  (the '**' bold markers and '<https' autolink brackets
     are the markdown shapes the body used; no headings/bullets exist in
     the delivered body, so these two tokens cover its markdown inventory)
I-2  body read: <p>/<strong>/<a href> tags present; five-element read
     against R-2's list; fact greps — 'youtube.com/watch?v=tj6c0UGRMF4',
     'github.com/CherokeeLanguage/NumbersMaze.godot/issues', the control
     bindings (A/F/Space/Enter, X/D, Y/S, D-pad/stick) — all match the
     delivered copy
I-3  grep -n "raw HTML" docs/itch-app-setup.md → matches in the Step 2 item
I-4  head-of-file read (usage-header comment, title, cut-line comment,
     '---' cut line) + grep itch-page-description docs/itch-app-setup.md
     → Step 2 still names the file as the paste source
```

I-1 was exercised against the current state on 2026-11-11: the delivered
body matches both tokens (multiple `**` spans; two `<http` autolinks), so
the post-change zero-matches is informative.

## Out of scope

- Installation instructions in the copy (developer direction: ignore for
  now — R-5 states the exclusion so its later addition is a deliberate
  change, not drift).
- Dashboard/account actions — the developer re-pastes the corrected copy;
  page setup, tagging, publish, rollback stay per the runbook.
- `README.md`, `itch-push.sh`, `itch.conf.example`, `AGENTS.md`,
  `text/changelog.txt`.
- Any game/code, scene, or build-config change.
- Rewriting the runbook beyond the Step 2 wording touch.

## Impact / blast radius

- **Consumers:** the itch page (the paste source is currently wrong on the
  live page — this fix is what the next paste picks up), repo readers,
  agent sessions (AGENTS.md unchanged).
- **Relationship to #9:** #9 is closed (reason: completed) and merged
  (PR #10, commit `2d79ee3`); its criteria set could not observe the
  format constraint. Per the developer's routing rule — always a new spec
  after a merge — this correction files as a new ticket rather than
  reopening #9; #9's record stands as history.
- **Risk:** low. Rollback: `git revert`; the page-side paste is
  dashboard-reversible per the runbook's rollback notes. No data-loss path.

## Provenance

- Developer statements (2026-11-11): "markdown is not supported for game
  descriptions or game installation instructions"; "raw html"; "always a
  new spec after a merge; ignore install instructions for now; implement
  corrected game description details for copy/paste."
- Live-page evidence fetched 2026-11-11 (the literal-markdown rendering
  quoted above).
- Current-state evidence: `docs/itch-page-description.md` on `main`
  (delivered markdown body, commit `d0eb5f7`); `docs/itch-app-setup.md`
  Step 2 paste instruction; #9's spec/plan and validation record
  (`.issues/9/`); the controls bindings verified this session against
  `project.godot` `[input]` and `player/Player.gd` (unchanged since — the
  same session's evidence).
- Alternatives weighed: BBCode (not stated as supported by the developer —
  raw HTML is the named format); plain text with no markup (loses the
  emphasis/links the copy uses); reopening #9 (rejected — routing rule
  names a new spec).

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
