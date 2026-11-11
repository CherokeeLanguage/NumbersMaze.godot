# itch.io app page setup — Cherokee Numbers Maze

<!-- SPDX-FileCopyrightText: 2026 Michael Conrad -->

Operational runbook for setting up the itch.io app page and its channels for
this repo. Every step is executed by the developer; no script here performs
account actions. Itch-facts below carry their verification date — re-verify
dashboard wording before relying on it, per `AGENTS.md`'s maintenance bar
(itch facts verified 2026-11-10/11 against live pages and the butler
research record `.issues/research-cards/itch-io-publishing.yaml`).

## Prerequisites

- itch.io account holding the `cherokee-language` namespace, with the game
  slug `cherokee-numbers-maze` available (the namespace listed exactly the
  three sibling games as of 2026-11-10 — no NumbersMaze page exists yet).
- butler installed (on PATH, or vendored at `.tools/butler/butler` — vendoring
  command in `itch-push.sh`'s header) and authenticated once: `butler login`
  (opens a browser; credentials live in butler's own store, never in the
  repo).
- The Godot 3.x editor with the machine-local export presets
  (`export_presets.cfg`, gitignored). Five presets feed the five channels:
  HTML5 → `tmp/html5/`; Android (apk) → `tmp/NumbersMaze.apk`;
  Windows Desktop (x64) → `tmp/NumbersMaze-x86_64.exe`; Linux/X11 (x64) →
  `tmp/NumbersMaze.x86_64`; Mac OSX → `tmp/NumbersMaze-mac.zip`.

## Step 1 — Create the game slot

1. In the itch.io dashboard, create the game and set its URL slug to
   `cherokee-numbers-maze` under the `cherokee-language` namespace so the
   page lands exactly at
   https://cherokee-language.itch.io/cherokee-numbers-maze — matching the
   target `itch.conf.example` already tracks.
2. Title: `Cherokee Numbers Maze`.
3. Kind of project: **HTML** (the page carries the browser-playable build
   plus the download channels; verified 2026-11-10 — one page serves both).
4. Publishing state: leave **Draft** until the channels have their first
   pushes (Step 3) — a draft page serves downloads to no one; publication
   follows the first pushes (verified 2026-11-10).

## Step 2 — Page visuals and text

1. **Cover image** (Dashboard → Edit-game → Cover): upload
   `assets/icons/itch-io-feature-graphic-630x500.png` (630 × 500 PNG — itch's
   recommended cover size at the 315:250 ratio). The `.svg` alongside it is
   the vector source; itch accepts PNG/JPG only, so the SVG stays in the
   repo. (`android-feature-graphic-1024x500.png` is Play-ratio source
   material — not an itch cover.)
2. **Description** (Edit-game → Description): the description copy is
   authored in this repo at
   [docs/itch-page-description.md](itch-page-description.md) — everything
   below that file's cut line is raw HTML, and the Description form accepts
   raw HTML: copy the body and paste it directly (the tags render).
   Markdown is not supported — it shows literally. If the copy changes,
   edit the file in the repo first, then re-paste.

## Step 3 — Export the artifacts and feed the channels

1. **Android export path (one-time editor edit):** the Android export preset
   is APK-format on the prebuilt-template path (`custom_build/use_custom_build=false`,
   `custom_build/export_format=0` — verified 2026-11-11), so it needs no
   gradle build and none of the JDK/Android-SDK toolchain — but its
   `export_path` still reads `tmp/NumbersMaze.aab`. In Editor → Export →
   Android (apk), change Export Path to `tmp/NumbersMaze.apk`: itch can only
   deliver `.apk` installs — a `.aab` is a Play-Store bundle with no install
   path on itch. Google Play is not a publication target (itch.io only,
   developer direction 2026-11-11).
2. In the Godot editor, run the five export presets to produce the artifacts
   at the paths above (`tmp/html5/` from the 2026-11-11 editor session is
   already staged).
3. Copy `itch.conf.example` to `itch.conf` (already carries the real target
   `cherokee-language/cherokee-numbers-maze`; it is gitignored):

       cp itch.conf.example itch.conf

4. Push once to create the channels — `./itch-push.sh` pushes the HTML5
   directory to `html5`, the APK to `android`, the Windows exe to `windows`,
   the Linux binary to `linux`, and the mac zip to `macos`, then prints
   butler receipts for all five. Verify:

       butler status cherokee-language/cherokee-numbers-maze:html5
       butler status cherokee-language/cherokee-numbers-maze:android
       butler status cherokee-language/cherokee-numbers-maze:windows
       butler status cherokee-language/cherokee-numbers-maze:linux
       butler status cherokee-language/cherokee-numbers-maze:macos

   All five must list the pushed build. butler's per-channel auto-numbering
   stands (no `--userversion`, per repo convention — metadata is not
   trusted, no version label asserted).

## Step 4 — Tag the html5 channel, then publish

1. **Check the browser build is playable:** channel names tag desktop
   platforms automatically (`windows`→Windows, `linux`→Linux, `macos`→Mac
   via the `mac` substring, `android`→Android), and there is no name-based
   tag for web channels (verified 2026-11-10) — but with the page kind set
   to **HTML** at creation (Step 1), the first `html5` push serves the
   playable build with no dashboard action: the page shows "Run game"
   immediately (observed 2026-11-11). If it does not, set the `html5`
   channel's kind to "HTML5 / Playable in browser" in the Edit-game form.
2. Dashboard → Edit-game → Publish. Confirm the page serves the playable
   browser build and five download buttons.

## Verification

- `butler status <channel>` (all five channels) lists the pushed builds.
- The page shows the playable HTML5 build, the five downloads, and the
  uploaded cover.
- **Record the live page URL** (R-6): fill `ITCH_URL` in `itch.conf.example`
  (uncomment it) and add the URL to `README.md` — the tracked landing-page
  URL is added at publication, per this step.

## Rollback (undo at each stage)

- Wrong cover/description: re-edit on the dashboard — dashboard edits apply
  instantly; re-upload replaces.
- Bad build pushed to a channel: butler stores every push as a patch; serve
  an earlier push from the channel's dashboard view, or push the corrected
  build — a later push overwrites what the page serves.
- Page not yet right: keep it in Draft (Step 1 item 4) — rescind publishing
  via Edit-game → Publish tab → "Revoke" at any time.

## Notes

- **SharedArrayBuffer stays off:** itch's SAB checkbox is opt-in per project
  and a stock Godot 3.2.x HTML5 export does not need it (Threads is
  unimplemented on Godot 3.2 HTML5 — verified 2026-11-10). Do not enable it.
- The android channel serves the APK built from the prebuilt-template path;
  no gradle/JDK/SDK toolchain is involved anywhere in this flow.
