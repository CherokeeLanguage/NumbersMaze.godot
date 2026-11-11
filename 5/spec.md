# Spec — Publish NumbersMaze to itch.io: butler push tooling for Godot export artifacts

NumbersMaze.godot#5 · local-authoritative · filed 2026-11-10

## Provenance

**Developer statements (2026-11-10, chat):**

- "create a spec to publish the app via itch.io; compare with ../Syllabary, ../Animals, ../BoundPronouns."
- "do not cargo cult stuff. always fresh research."
- "NumbersMaze will need to only use the siblings as a general reference, this repo has its own needs because it is godot and not libgdx which aren't the same for the actual game binaries being published"
- "butler needs to be in .tools; the agents.md must indicate this."
- "only itch.io is the publishing platform going forwards." (2026-11-11)

**Observed repo facts (verified 2026-11-10):**

- Godot 3.x project (`project.godot` `config_version=4`, GDScript 1.x). No itch.io apparatus exists: no `itch-push.sh`, no `itch.conf(.example)`, no `.tools/`, no itch or butler entries in `.gitignore`, no `docs/` directory.
- Machine-local `export_presets.cfg` (gitignored) carries five export presets, all with `export_path` under gitignored `tmp/`: Android → `tmp/NumbersMaze.aab`; Linux/X11 (x64) → `tmp/NumbersMaze.x86_64`; HTML5 → `tmp/html5/index.html`; Mac OSX → `tmp/NumbersMaze-mac.zip`; Windows Desktop (x64) → `tmp/NumbersMaze-x86_64.exe`. The Android preset (verified 2026-11-11, after the developer's editor-session rename) is named "Android (apk)" — previously "Android (aab)" — with `export_path` still `tmp/NumbersMaze.aab`, and is configured APK-format on the prebuilt-template path (`custom_build/use_custom_build=false`, `custom_build/export_format=0`); the tracked `export_presets-tv.cfg` retains the "Android (aab)" name with true gradle-AAB config (`use_custom_build=true`, `export_format=1`).
- `export_presets.cfg` is gitignored and holds the machine's signing config (keystore keys verified present there, values never read); `export_presets-tv.cfg` (tracked) is the Android TV preset and carries no keystore keys (name-only scan).
- A staged HTML5 export from Feb 2021 sits in gitignored `html5/` (`index.html`, `index.js`, `index.wasm`, `index.pck`, `index.png`, `favicon.png`, `index.audio.worklet.js` — ~45 MB total), evidencing the HTML5 export output shape; the current HTML5 preset exports into `tmp/html5/` (verified `export_path`).
- `assets/icons/` carries `itch-io-feature-graphic-630x500.png` (+ `.svg` source — a matching itch cover asset at the recommended 315:250-ratio size) and `android-feature-graphic-1024x500.png` (Play-ratio source material) plus Android-512×512 icons.
- `README.md` is a 2-line stub. `AGENTS.md` is tracked and committed on `feature/agents-md` — commit `9e936e3` (2026-11-11, "docs(#4): add AGENTS.md agent notes; ignore editor caches", which also adds the `.godot/` gitignore entry — #4's hygiene deliverable); the branch carries exactly that one commit and sits ahead of `main` (`main` remains at `016b986` without AGENTS.md); #4 has moved into implementation.
- The itch.io namespace `cherokee-language` lists exactly three games — Cherokee Syllabary, Cherokee Language Animals, Cherokee Bound Pronouns; no NumbersMaze page exists (live fetch of https://cherokee-language.itch.io/, 2026-11-10).

**Sibling comparison (general reference only — developer-directed):** Syllabary and BoundPronouns are libGDX/Java projects; Animals is a Godot project (`project.godot` `config_version=4`) whose Godot port treats the legacy libGDX build as reference material (Animals#11) and whose published artifacts remain the legacy libGDX desktop jar + release APK staged in `dist/` (operator-config push sources). At the artifact level all three push pre-built files via butler; what differs for this repo is the published-binary shape — a single desktop jar (one binary for three desktop OSes) and gradle-produced outputs there, versus per-OS Godot binaries from editor exports into machine-local preset paths here. Their specs: Syllabary#2, BoundPronouns#55, Animals#11 (plus BoundPronouns#56 open, #59 description-doc; Animals#13 re-push).

- Adopted as general convention: repo-local push-only `itch-push.sh` (never builds) + `itch.conf(.example)` + vendored `.tools/butler/` (gitignored); one-time `butler login`; `REPLACE_ME` placeholder guard; `butler status` receipts; no `--userversion` (metadata not trusted — Syllabary#2 R-3); landing-page URL tracked in README + itch config; page-setup runbook in `docs/` with all account steps developer-executed (Syllabary `docs/itch-app-setup.md`).
- **Not carried, with grounds:**
  - gradle-output auto-discovery (newest-by-mtime globs over `desktop/build/libs/`, `android/build/outputs/`) — Godot exports write fixed operator-set paths into machine-local gitignored preset config; artifact locations are operator config (Animals' `itch.conf` path precedent).
  - the single `win-linux-mac` channel — a libGDX jar is one binary for three desktop OSes; Godot desktop exports are three distinct binaries, so itch's per-platform channel tagging applies (separate `windows`/`linux`/`macos` channels).
  - BoundPronouns#55's vendoring URL `broth.itch.ovh/butler/linux-amd64/LATEST/unpack` — dead (DNS non-resolution, live probe 2026-11-10); the current documented automation URL is `broth.itch.zone/butler/linux-amd64/LATEST/archive/default` (live-verified 2026-11-10).
  - tracked `itch.conf` with placeholders (BoundPronouns#55 R-2) — Syllabary/Animals gitignore `itch.conf`; this spec follows the gitignored form (machine-local values never enter history).
  - the CherokeeLessons.com paired-spec route for page creation (Syllabary#2's split) — the developer-named comparison set is the sufficient scoping ground, and the CherokeeLessons.com issue store a paired spec would file into is locally absent (only a stale Forestry-era checkout exists at `../CherokeeLessons.com-broken`, carrying no `.issues/` store — verified 2026-11-11); the developer-executed runbook pattern is adopted instead.

**Research findings (all fetched 2026-11-10; full record with source URLs: `.issues/research-cards/itch-io-publishing.yaml`):**

- butler v15.32.0 current; automation install `https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default` (zip; live-probed HTTP 206); `butler login` = browser OAuth into butler's own credential store; `BUTLER_API_KEY` is the CI alternative.
- `butler push <dir-or-zip> user/game:channel` — lowercase; first push makes the file appear on the page; re-pushes are idempotent patch pushes serving immediately; butler requires an existing project page (it never creates one).
- Channel-name tagging: `win`/`windows` → Windows; `linux` → Linux; `mac`/`osx` → Mac; `android` → Android; no architecture tagging; kebab-case; no name-based tag for web channels — the "HTML5 / Playable in browser" tag and page kind "HTML" are Edit-game-page actions after the first push.
- Versioning: backend assigns increasing integers per channel by default; `--userversion`/`--userversion-file` optional; ordering is upload order.
- 30 GB uncompressed backend cap; `butler status` prints per-channel receipts.
- itch HTML5 hosting: ZIP containing `index.html` at its root (only ZIP accepted); ≤1000 files, ≤240-char paths, ≤500 MB total, ≤200 MB per file — this repo's ~45 MB export fits; itch's CDN auto-gzips `html/js/wasm/pck`; relative paths mandatory.
- SharedArrayBuffer on itch is opt-in per project and NOT needed by a stock Godot 3.2.x export (Threads unimplemented on Godot 3.2 HTML5; the itch SAB checkbox stays off).
- Android: `.apk` accepted and auto-tagged via channel name; `.aab` has no install path on itch (Play-Store bundle; community/platform-mechanics evidence, no official doc — stated gap).
- One page carries both a playable HTML build and downloadable channels (page kind HTML); draft pages serve downloads to no one — publication follows the first pushes.

## Problem

NumbersMaze has no itch.io presence: no page, no push tooling, no documented publication path. The three sibling apps each publish through a repo-local butler workflow, but their published-binary reality (a single desktop jar plus APK) and build-output handling (tracked gradle configs, newest-artifact glob discovery) differ structurally from this Godot repo's (per-OS desktop binaries, editor-driven exports into machine-local preset paths, an Android export path still suffixed `.aab`). The publication needs its own Godot-shaped apparatus.

## Scope

One repository (NumbersMaze.godot): `itch-push.sh`, `itch.conf.example` (+ gitignored `itch.conf`), `.gitignore` entries, `docs/itch-app-setup.md` runbook, a README publishing section, and the AGENTS.md publication note. The itch.io page itself is created by the developer per the runbook (itch-account-gated dashboard actions); the first channel pushes are the developer-assisted verification of SC-1.

## Requirements

- **R-1 — Push tooling.** `itch-push.sh` (repo root) is push-only (never builds or exports); resolves butler `PATH` first, then `.tools/butler/butler` (developer-directed location); reads the itch target from `itch.conf`; pushes each artifact to its channel:
  - HTML5 export directory → `<ITCH_USER>/<ITCH_GAME>:html5`
  - Android APK → `…:android`
  - Windows exe → `…:windows`
  - Linux x86_64 binary → `…:linux`
  - macOS zip → `…:macos`

  Artifact locations come from `itch.conf` (operator config — Godot export paths are machine-local preset settings), with documented defaults `tmp/html5/`, `tmp/NumbersMaze.apk`, `tmp/NumbersMaze-x86_64.exe`, `tmp/NumbersMaze.x86_64`, `tmp/NumbersMaze-mac.zip`. The HTML5 artifact is pushed as its directory (`index.html` at the build root, the form itch's HTML5 hosting expects).
- **R-2 — Guided failure before any upload.** The script exits non-zero naming the missing piece — butler absent from both `PATH` and `.tools/butler/butler` (message names the current vendoring command — the `broth.itch.zone` archive URL — and the one-time `butler login`), `itch.conf` missing, carrying `REPLACE_ME` placeholders, or lacking a required key, or an artifact path absent (message names the export preset to run and the runbook) — in every case before any butler invocation.
- **R-3 — Target config, no secrets.** `itch.conf.example` (tracked) carries `ITCH_USER=cherokee-language`, `ITCH_GAME=cherokee-numbers-maze` (proposed target), and commented artifact-path overrides; `itch.conf` is gitignored, filled by the developer locally. No API key, token, or secret enters any tracked file — butler credentials live exclusively in butler's own credential store (one-time `butler login`).
- **R-4 — No version claims.** Pushes carry no `--userversion`; butler's per-channel auto-numbering stands (the family's live default; the version-wiring question stays open as it is for the family — BoundPronouns#56 remains open).
- **R-5 — Page-setup runbook.** `docs/itch-app-setup.md` documents every developer-executed step: create the game slot (title "Cherokee Numbers Maze", slug `cherokee-numbers-maze` under the `cherokee-language` namespace), kind of project **HTML**, cover image (itch ratio 315:250, 630×500 recommended — `assets/icons/itch-io-feature-graphic-630x500.png` (+ `.svg`) provides a matching cover; the 1024×500 Play-ratio graphics are separate source material), description field (paste-verbatim pattern of the siblings' `docs/itch-page-description.md`; description authoring itself out of scope), Draft-until-first-pushes guidance, first pushes via `itch-push.sh`, Edit-game tagging of the `html5` channel as "HTML5 / Playable in browser", publish, verification (`butler status` per channel; the page serves the playable build + download buttons), and rollback notes (butler stores every push as a patch; dashboard re-edits; draft/revoke states). The runbook states the android channel's APK requirement — a `.aab` is not device-installable from itch — and documents the Android export preset as APK-format on the prebuilt-template path with its export artifact at `tmp/NumbersMaze.apk`; the prebuilt path needs no gradle build and none of its JDK/Android-SDK prerequisites, and Google Play is not a publication target (developer-directed 2026-11-11: itch.io only). Runbook facts carry their verification date; the itch SharedArrayBuffer checkbox stays off (Godot 3.2.x needs no SharedArrayBuffer).
- **R-6 — README publishing section.** README.md gains "Publishing to itch.io (manual)": the flow (export via the editor presets → `cp itch.conf.example itch.conf` → `butler login` once → `./itch-push.sh`), the butler-in-`.tools` note, and a pointer to the runbook; the live page URL is added to README and `itch.conf.example` (`ITCH_URL`) at publication per the runbook's verification step.
- **R-7 — AGENTS.md indication.** AGENTS.md documents the itch publication: butler vendored at `.tools/butler/` (gitignored) with the vendoring command, `itch.conf` local-only, the push flow and the five channels, and the runbook pointer — every command and path matching the repo as it then stands. AGENTS.md is committed on `feature/agents-md` via NumbersMaze.godot#4's work (commit `9e936e3`), not yet on `main`; whether this work stacks on that branch or the file has landed on `main` by implementation time is a plan-stage sequencing decision — the requirement binds the AGENTS.md content the delivering branch carries, not a particular branch location.
- **R-8 — Gitignore.** `.gitignore` gains `itch.conf` and `.tools/butler/` entries.

## Success criteria

| ID | Criterion | Class | Instrument | Traces to |
|---|---|---|---|---|
| SC-1 | With the itch page existing, butler authenticated, `itch.conf` filled, and the five artifacts present at their configured paths, executing `./itch-push.sh` transfers each artifact to its channel (html5, android, windows, linux, macos) and the receipt lists each channel's new build | behavioral | executed push log + `butler status` output for the five channels (developer-assisted run: page creation and `butler login` are developer-side, sequenced by the runbook) | R-1 |
| SC-2 | Each fault condition R-2 names — butler absent from `PATH` and `.tools/butler/`; `itch.conf` missing; `itch.conf` carrying `REPLACE_ME`; `itch.conf` lacking a required key; an artifact path absent — exits non-zero naming the missing piece (for butler: the vendoring URL + login pointer; for artifacts: the export preset + runbook pointer), before any butler invocation | behavioral | five executed runs, one per fault condition, each showing the exit code and guidance message with the other prerequisites in place (disclosed per run) | R-2 |
| SC-3 | No itch credentials, API keys, or tokens in any tracked file; `itch.conf` and the vendored `.tools/butler/` are gitignored; `itch.conf.example` carries only non-secret target fields | structural | grep over tracked files for itch/butler token patterns; `.gitignore` read (both entries present) | R-3, R-8 |
| SC-4 | The script resolves butler `PATH`-first then `.tools/butler/butler`, and its no-butler guidance names the verified automation install URL (`broth.itch.zone/butler/linux-amd64/LATEST/archive/default`) and `butler login` | structural | script read | R-1, R-2 |
| SC-5 | The script's push section maps each configured artifact to its channel — html5 (HTML5 export dir), android (APK), windows (exe), linux (x86_64 binary), macos (mac zip) — with no channel name carrying a wrong-platform substring | structural | script read; channel names checked against the butler tagging substrings (win/linux/mac/android) | R-1 |
| SC-6 | Pushes carry no version claims | structural | script read (`--userversion` absent) | R-4 |
| SC-7 | `docs/itch-app-setup.md` states every runbook step (page creation with the slug, kind HTML, cover requirement incl. ratio, Draft-until-first-pushes, html5 channel tagging, publish, verification, rollback), the APK-not-aab android requirement with the APK preset instructions, the SAB-off note, and dates its itch-facts verification | content | runbook read; element checklist; itch-fact claims cross-checked against the research record's sources | R-5 |
| SC-8 | README carries the publishing section (export → configure → login → push flow, butler-in-`.tools` note, runbook pointer) | content | README read | R-6 |
| SC-9 | AGENTS.md documents the itch publication (butler in `.tools/butler` with the vendoring command, `itch.conf` local-only, push flow + channels, runbook pointer), and every command/path it states matches the repo as it then stands | content | AGENTS.md read; cross-check each stated command/path against the repo's actual files | R-7 |

## Approach

Mirror the family's script shape (`set -euo pipefail`, cd to script dir, guarded sequence: conf → butler → artifacts → pushes → receipts), with three Godot-grounded deviations from the sibling pattern:

1. **Exact-path artifact checks from `itch.conf`** instead of gradle-glob newest-by-mtime discovery — Godot exports write fixed operator-set paths, and the preset config is machine-local (gitignored); the artifact location is operator config (Animals' `itch.conf` precedent), defaulted to the repo's documented export paths.
2. **Five channels instead of the siblings' two** — a single desktop jar is one binary for three desktop OSes (the shape behind the siblings' single `win-linux-mac` channel), while Godot desktop exports are three distinct binaries, so itch's per-platform channel tagging applies; plus an `html5` channel for the browser-playable export the repo already produces. The channel set maps the repo's full export-preset surface; the developer prunes or renames at spec approval if fewer channels are wanted.
3. **Directory push for the HTML5 artifact** — butler accepts a directory or zip; the directory form puts `index.html` at the build root exactly as itch's HTML5 hosting expects, with no zip step to drift.

No production risk: the itch page does not exist yet, so first pushes CREATE the channels rather than replace published artifacts (unlike Syllabary's conversion case, where the first push was deferred to avoid overwriting a live channel). Page creation per the runbook precedes the verification push (butler cannot create pages — verified 2026-11-10). Research findings live in `.issues/research-cards/itch-io-publishing.yaml`.

## Out of scope

- Itch page description copy (family precedent: BoundPronouns#59 filed it separately after the publish spec).
- Further cover/promo art creation — a matching 630×500 cover asset already exists (`assets/icons/itch-io-feature-graphic-630x500.png`); its upload is a developer-side runbook step, and additional art authoring is out of scope.
- Version wiring (`--userversion`) — open family question (BoundPronouns#56); not requested here.
- Android TV channel (the tracked `export_presets-tv.cfg` exists; no TV publication was requested).
- CI automation (the family chose manual publishing; unchanged here).
- iOS/IPA distribution — itch cannot deliver iOS app installs.
- Google Play / `.aab` publication, and the gradle-build toolchain it would require — the developer directed itch.io as the only publishing platform going forwards (2026-11-11).
- The NumbersMaze.godot#4 deliverables (AGENTS.md / `.gitignore` hygiene work) — this spec's R-7/R-8 coordinate with that in-flight work; they do not own it.

## Impact

New files: `itch-push.sh`, `itch.conf.example`, `docs/itch-app-setup.md` (+ gitignored `itch.conf` at use time, vendored `.tools/butler/`). Edited: `.gitignore` (two entries), `README.md` (publishing section), `AGENTS.md` (publication docs, coordinating with #4's in-flight file). No runtime/game behavior change; no tracked build-system change (the Android preset's conversion to the itch APK preset is a machine-local editor step the runbook documents). Risk: low — pushes are idempotent butler patching; the page is new, so first pushes create channels; no secrets enter the repo (butler's own credential store). Blast radius: the new itch page, and this repo's future release flow.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)
