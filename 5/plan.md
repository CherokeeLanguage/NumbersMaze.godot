# Plan — NumbersMaze.godot#5: itch.io publish tooling (butler push for Godot export artifacts)

Source spec: `.issues/5/spec.md` (validated round 5, PASS, zero findings).
Authorization: `#5 approved for PR` (2026-11-11) — carries plan → implement →
verify → PR; merge stays human-only.

## SC consumption judgment

Each SC judged against the spec validation-standards defect classes in this
context: all nine carry capable instruments; SC-1's developer-assisted
instrument is the spec's own design (its Scope assigns page creation and
`butler login` to the developer), not a defect. No BLOCKED criteria.

## Sequencing decision (spec R-7's deferred decision)

Branch from `main` @ `f36a902` — AGENTS.md landed on the trunk via PR #6
(`feature/agents-md` merged 2026-11-11, API-verified). No stacking on a #4
branch: that branch is merged and deleted. Branch name:
`feature/itch-publish`.

## Working-tree guard

The working tree carries untracked/modified developer content that is NOT
part of this work: `project.godot` (modified), `assets/icons/…feature-graphic…`
(.png/.svg), `assets/screenshots/*.xcf`, `.issues/`, `.opencode/`. Commits
stage only the files this plan's items deliver — never that content.

## Items

### Item 1 — Gitignore entries (R-8; SC-3's gitignore prong)

- **Deliverable:** `.gitignore` gains `itch.conf` and `.tools/butler/`.
- **RED:** `git check-ignore itch.conf .tools/butler/butler` reports neither
  path ignored (fails: both untracked-visible today).
- **GREEN:** append the two entries to the existing `.gitignore` block.
- **Instrument:** `git check-ignore itch.conf .tools/butler/butler` exits 0
  listing both; `.gitignore` read shows both entries.

### Item 2 — `itch.conf.example` (R-3; SC-3's example prong)

- **Deliverable:** tracked `itch.conf.example` (family form, Syllabary's as
  general reference): `ITCH_USER=cherokee-language`,
  `ITCH_GAME=cherokee-numbers-maze`; commented artifact-path overrides for the
  five artifacts with their documented defaults (`tmp/html5/`,
  `tmp/NumbersMaze.apk`, `tmp/NumbersMaze-x86_64.exe`, `tmp/NumbersMaze.x86_64`,
  `tmp/NumbersMaze-mac.zip`) using the variable names the script reads
  (`ITCH_HTML5_DIR`, `ITCH_ANDROID_APK`, `ITCH_WINDOWS_EXE`, `ITCH_LINUX_BIN`,
  `ITCH_MACOS_ZIP`); header text stating credentials never live here (butler's
  own store, one-time `butler login`). `ITCH_URL` appears as a commented-out
  field with its fill-at-publication note (R-6: the live URL is added at
  publication per the runbook — the page does not exist yet; no URL is
  invented).
- **RED:** file absent — the conf-example read check fails.
- **GREEN:** author the file exactly as above.
- **Instrument:** file read against the field list; grep of the file shows no
  token/key/secret pattern (only the two real, non-secret target values).

### Item 3 — `itch-push.sh` conf guard + butler resolution (R-2, R-1 resolution half; SC-2 runs 1–4, SC-4)

- **Deliverable:** repo-root `itch-push.sh`, family script shape
  (`#!/bin/bash`, `set -euo pipefail`, `cd "$(dirname "$0")"`): conf section
  (missing `itch.conf` → error naming `cp itch.conf.example itch.conf`;
  `source` it; missing `ITCH_USER`/`ITCH_GAME` → required-key error;
  `REPLACE_ME` in either → placeholder error) and butler resolution (PATH
  first, then `.tools/butler/butler`; absent from both → error naming the
  vendoring command with the live `broth.itch.zone/butler/linux-amd64/LATEST/archive/default`
  URL and the one-time `butler login`). All exits non-zero, before any butler
  invocation.
- **RED:** the four fault scenarios executed today exit 127 (no script) with
  none of the specified guidance.
- **GREEN:** author the script through the butler-resolution section (push
  section deferred to Item 4).
- **Instrument (executed runs, one per fault, other prerequisites in place,
  disclosed per run):** (1) butler absent from PATH (PATH scrubbed) and
  `.tools/` — exit ≠ 0, message carries the vendoring URL + `butler login`;
  (2) no `itch.conf` — exit ≠ 0, message names the cp command; (3) `itch.conf`
  carrying `REPLACE_ME` — exit ≠ 0, placeholder message; (4) `itch.conf`
  lacking `ITCH_GAME` — exit ≠ 0, required-key message. Plus script read:
  PATH-first-then-`.tools` resolution order visible (SC-4).

### Item 4 — `itch-push.sh` artifact guard + channel pushes + receipts (R-1, R-4; SC-2 run 5, SC-5, SC-6)

- **Deliverable:** the script's artifact section: every configured artifact
  path checked before ANY butler invocation (R-2's before-any-push rule —
  no partial publish sequence); html5 check requires the directory AND
  `index.html` at its root (the form itch's HTML5 hosting expects); absent
  artifact → error naming the export preset to run + the runbook pointer.
  Push section: five pushes in spec order — html5 (directory push), android,
  windows, linux, macos — each `"$BUTLER" push <artifact> "$ITCH_USER/$ITCH_GAME:<channel>"`;
  receipts: `"$BUTLER" status` per channel. No `--userversion` anywhere.
- **RED:** artifact-absent fault scenario still exits 127 (script stops at
  Item 3's sections; no artifact guard, no pushes).
- **GREEN:** extend the script with the artifact/push/receipt sections.
- **Instrument:** (5) executed artifact-absent fault run — butler present
  (vendored into gitignored `.tools/butler/` using the documented vendoring
  command, which also live-validates the URL the guidance names), `itch.conf`
  filled, at least one configured artifact path absent — exit ≠ 0 naming the
  preset + runbook, no push executed; script read: channel map
  html5/android/windows/linux/macos against butler tagging substrings
  (`win`, `linux`, `mac`, `android` — each name tags only its own platform;
  `html5` carries none, per research), `--userversion` absent (SC-5, SC-6).

### Item 5 — `docs/itch-app-setup.md` runbook (R-5; SC-7)

- **Deliverable:** new `docs/itch-app-setup.md` — every developer-executed
  step: create the game slot (title "Cherokee Numbers Maze", slug
  `cherokee-numbers-maze`, kind **HTML**, Draft); cover image (315:250 ratio,
  630×500 recommended — `assets/icons/itch-io-feature-graphic-630x500.png`);
  description pointer (authoring out of scope — sibling
  `docs/itch-page-description.md` paste pattern); first pushes via
  `./itch-push.sh` after `cp itch.conf.example itch.conf`, butler vendoring
  (the live URL), and one-time `butler login`; Edit-game tagging of the
  `html5` channel as "HTML5 / Playable in browser" (no name-based web tag);
  publish; verification (`butler status` per channel; page serves the playable
  build + download buttons); rollback notes (butler patch history, dashboard
  re-edits, draft/revoke); android channel needs the APK — a `.aab` is not
  device-installable from itch; the export preset is APK-format on the
  prebuilt-template path with `export_path` `tmp/NumbersMaze.apk` (a
  one-time editor edit of the machine-local preset's path field — the
  prebuilt path needs no gradle/JDK; Google Play is not a target);
  SharedArrayBuffer checkbox stays off; every itch-fact statement dated.
- **RED:** no `docs/` directory exists — the runbook-element checklist fails.
- **GREEN:** author the runbook from the research card's sourced findings and
  the page-setup guidance already delivered in chat (siblings' runbook as
  general reference only).
- **Instrument:** runbook read against the element checklist; itch-fact
  claims cross-checked against `.issues/research-cards/itch-io-publishing.yaml`
  sources.

### Item 6 — README publishing section (R-6; SC-8)

- **Deliverable:** README.md gains "Publishing to itch.io (manual)": the flow
  (export via the editor presets → `cp itch.conf.example itch.conf` →
  `butler login` once → `./itch-push.sh`), the butler-in-`.tools` note, and
  the runbook pointer.
- **RED:** README read shows a 2-line stub with no publishing section.
- **GREEN:** append the section.
- **Instrument:** README read against the three required elements.

### Item 7 — AGENTS.md publication note (R-7; SC-9)

- **Deliverable:** AGENTS.md (now on `main`) documents the itch publication:
  butler vendored at `.tools/butler/` (gitignored) with the vendoring command,
  `itch.conf` local-only, the push flow and the five channels, the runbook
  pointer — every command and path matching the repo as it then stands.
- **RED:** AGENTS.md read shows no itch publication documentation.
- **GREEN:** add the publication section (sits with the existing
  Engine/Architecture/Gotchas structure).
- **Instrument:** AGENTS.md read; each stated command/path cross-checked
  against the repo's actual files.

### Item 8 — SC-1 developer-assisted push verification (SC-1; R-1 end-to-end)

- **Deliverable:** the executed five-channel push evidence — the push log of
  `./itch-push.sh` transferring each artifact to its channel and the
  `butler status` output listing each channel's new build — recorded in the
  issue store (`.issues/5/audit/`).
- **Execution gate (spec-designed, not evadable):** SC-1's instrument is
  developer-assisted by the spec's own Scope — it executes only when the
  developer-side prerequisites are in place: the itch page created per the
  runbook (dashboard, account-gated), one-time `butler login`, `itch.conf`
  filled, and the five artifacts present at their configured paths
  (`tmp/html5/` already staged). If the prerequisites are not in place at PR
  time, the PR discloses SC-1 as pending its developer-assisted run per the
  spec's design — the spec defines no agent-unilateral path to this
  criterion's evidence (butler cannot create pages; first pushes need the
  page).
- **RED:** no executed push evidence exists for the five channels (true
  today — the page itself does not exist yet, live-verified 2026-11-10).
- **GREEN:** with the prerequisites in place, run `./itch-push.sh` and record
  the push log + `butler status` receipts for all five channels.
- **Instrument:** executed push log + `butler status` output per the spec's
  SC-1 instrument; evidence file in `.issues/5/audit/`.

## Order

1 → 2 → 3 → 4 → 5 → 6 → 7 → 8. Rationale: gitignore precedes butler vendoring
(Item 4's verification vendores into `.tools/butler/`) so the vendored binary
never appears in git status; the conf example precedes the script's fault
runs (they source real conf states); the script is complete before the three
documentation items so every command/path they state matches a file that
exists; items 5–7 are mutually independent (any order after 4); item 8
consumes everything (its run needs conf, butler, artifacts, page).

## Test tiers and routing (test-discipline)

- No test files are authored — the repo has no test framework (AGENTS.md);
  every instrument is an executed shell run or file read, recorded as
  evidence in the issue store (`.issues/5/audit/`), never committed as test
  files (ephemeral class).
- SC-2's five fault runs: executed during Items 3–4 (they exit before any
  butler invocation — no network, no page needed).
- SC-1: heavyweight tier, developer-assisted, on-demand (never a default
  run) — owned by Item 8, whose execution gate states the developer-side
  prerequisites and the PR disclosure rule.
- SC-3's grep-over-tracked-files prong runs across the full changed-file set
  as part of verify-stage evidence assembly (its per-file prongs ride Items
  1–3's instruments).

## Out of plan

Everything in the spec's Out-of-scope list; no script features beyond R-1/R-2
(no dry-run flag, no channel selection — not specced); no change to
`export_presets.cfg` (machine-local, gitignored — the preset path edit is a
developer editor step the runbook documents); the untracked developer content
listed under Working-tree guard.
