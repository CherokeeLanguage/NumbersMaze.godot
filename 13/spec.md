# Spec — itch page installation instructions in the description copy (deferred from #11)

NumbersMaze.godot#13 · filed 2026-11-11 · labels: spec, documentation,
needs-approval · sub-issue of NumbersMaze.godot#11

## Problem

The itch page serves four downloads — `NumbersMaze.apk`,
`NumbersMaze-x86_64.exe`, `NumbersMaze.x86_64`,
`cherokee-numbers-maze-macos.zip` (observed on the live page 2026-11-11) —
and the description copy carries no installation guidance. A player who
downloads the APK has no in-page note about installing it (Android blocks
sideloaded installs by default); the desktop builds likewise carry no
download-and-run note.

The developer's format correction (2026-11-11) named "game installation
instructions" among the surfaces where markdown is not supported (raw
HTML) — the guidance is an expected part of the copy. It was explicitly
deferred (#11's R-5: "ignore install instructions for now") and is captured
here so the deferral is a recorded open item rather than drift. No
implementation is authorized by this filing; the content awaits the
developer's approval (`needs-approval`).

### Root cause

The copy was authored from #9's five-element list, which had no
installation element; the sibling pattern's platform notes (BoundPronouns'
desktop-Java and Android-APK install notes) were never adapted to this
game's builds.

## Scope

One repository — NumbersMaze.godot:

| File | Change |
|---|---|
| `docs/itch-page-description.md` | the raw-HTML copy gains an installation-guidance element |

The runbook needs no change (its Step 2 already states the raw-HTML paste
behavior). No code, build-config, or runtime change; `README.md`,
`itch-push.sh`, `itch.conf.example`, `AGENTS.md`, `text/changelog.txt`
untouched.

## Requirements

- **R-1 — Installation-guidance element.** The description copy SHALL carry
  installation guidance covering the builds the page serves: the Android
  APK — install it directly on the device; Android may ask once to allow
  installs from this source — and the desktop builds (Windows/macOS/Linux)
  — download and run. Shaped after the BoundPronouns sibling's platform
  notes; exact copy is authored at implementation from this pattern and
  the live page's served file list.
- **R-2 — Format.** The added element SHALL be raw HTML, consistent with
  #11's R-1: no markdown below the cut line; the form accepts raw HTML.
- **R-3 — Prohibitions carry over.** itch.io SHALL remain the only named
  distribution channel: no Google Play / Google App Store / Amazon / Apple
  / Microsoft Store / Linux Store items, no external play-online link, no
  non-itch direct-download links (developer direction 2026-11-11).
- **R-4 — Seam with #11's instrument.** When this lands, #11's I-6
  instrument (`grep -i install` on the description file → zero matches) is
  superseded: the token `install` SHALL appear only within the
  installation-guidance element's lines. The guidance is what #11's R-5
  excluded; this spec supersedes that exclusion for the guidance it adds
  and for nothing else — every other #11 criterion (SC-1's markdown ban,
  SC-2's content details, SC-3's runbook wording, SC-4's structure,
  SC-5's prohibition tripwire) remains in force and holding.

## Approach

1. Author the guidance element as a `<p>` block (or two, Android and
   desktop) after the Platforms element in the description copy, raw HTML,
   wording from the BoundPronouns pattern adapted to this game's files.
2. Verify with the instruments below; the guidance element's line span is
   recorded so SC-4's containment check is decidable.

## Success criteria

| ID | Criterion | Class | Instrument | Traces to |
|---|---|---|---|---|
| SC-1 | the copy carries installation guidance covering the APK and the desktop builds | structural | I-1 | R-1 |
| SC-2 | no markdown below the cut line | structural | I-2 | R-2 |
| SC-3 | itch-only prohibitions hold | structural | I-3 | R-3 |
| SC-4 | the `install` token appears only within the guidance element | structural | I-4 | R-4 |

Every criterion is atomic, binary-verifiable by its instrument, and
deliverable-owned. No behavioral criteria: the change touches no runtime
surface.

### Verification instruments

```
I-1  element read: an installation-guidance element exists in the copy
     below the cut line; its text covers the Android APK (direct install;
     the allow-installs-from-this-source note) and the desktop builds
     (download and run)
I-2  grep -nE '\*\*|<http|^#{1,6} |^- |^\* |^[0-9]+\. ' over the
     below-the-cut-line content of docs/itch-page-description.md
     → zero matches (the #11 I-1 instrument, unchanged in force)
I-3  grep -inE 'Google Play|Google App Store|App Store|Amazon|Apple|Microsoft Store|Linux Store|HTML-Games|play\.google\.com|apps\.apple\.com|amazon\.com' docs/itch-page-description.md
     → zero matches (the #11 I-5 instrument, unchanged in force)
I-4  grep -in install docs/itch-page-description.md → every match's line
     number falls within the guidance element's line span (read-verified
     against the file; the span is stated in the implementation evidence)
```

Capability note: I-2 and I-3 are #11's instruments, carried forward — their
post-change zero-matches stay informative for their token sets. I-4 is new:
its failure shape (an `install` mention outside the guidance element, e.g.
in the mechanics or platforms text) is observable by comparing the grep's
line numbers to the element's span.

## Out of scope

- Any download-page or dashboard change — the guidance is description copy;
  the paste remains developer-executed per the runbook.
- `README.md`, `itch-push.sh`, `itch.conf.example`, `AGENTS.md`,
  `text/changelog.txt`.
- Any game/code, scene, or build-config change.

## Impact / blast radius

- **Consumers:** the itch page (paste source — the guidance reaches players
  at the download decision point), repo readers.
- **Relationship:** sub-issue of #11; when its PR lands it supersedes
  #11's R-5 exclusion and I-6 instrument (R-4) — #11's other criteria are
  untouched and remain verified. This filing authorizes no implementation;
  the content awaits the developer's approval.
- **Risk:** low. Rollback: `git revert`; the page-side paste is
  dashboard-reversible. No data-loss path.

## Provenance

- Developer statements (2026-11-11): "markdown is not supported for game
  descriptions or game installation instructions" (the format constraint
  covering install guidance); "ignore install instructions for now"
  (the deferral #11's R-5 records); "capture all pending changes.
  add/revise specs as appropriate" (this capture).
- Current-state evidence: the live page's file list (four builds, fetched
  2026-11-11); `docs/itch-page-description.md` at `main` (`49ff20c`'s
  raw-HTML copy, no guidance element); #11's validated criteria set
  (`.issues/11/spec.md`, the superseded instrument named in R-4);
  `../BoundPronouns/docs/itch-page-description.md` (the pattern's install
  notes, read-only).
- Alternatives weighed: adding the guidance into #11's open PR (rejected —
  the developer's deferral directive governs that scope, and the PR is
  filed); leaving the item unrecorded (rejected — this capture exists so
  the deferral surfaces); separate desktop-vs-Android documents
  (rejected — single paste source, per #11's design).

---

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
