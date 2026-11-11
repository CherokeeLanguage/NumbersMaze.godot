# Spec — Convert the NumbersMaze.godot repo's deploy target to itch.io (standard itch.io deployment)

Paired spec: **CherokeeLessons.com#25** — the itch.io page for Cherokee Numbers Maze and the initial deployment of the currently-published artifacts. This spec owns the NumbersMaze.godot repo's own release-pipeline conversion; the pair splits the app's migration across the two repos that own its halves.

## Problem

The NumbersMaze.godot repo's releases have deployed through app stores and site-hosted binaries. The migration makes itch.io the deploy target for the repo's future releases: the paired cherokeelessons.com spec establishes the itch page and deploys the currently-published artifacts from that repo's copies; this repo's own release pipeline must follow suit, using the standard itch.io deployment the BoundPronouns repo established.

## Scope

The NumbersMaze.godot repo (`CherokeeLanguage/NumbersMaze.godot`): repo-local itch deployment tooling per the BoundPronouns pattern, the push-target binding, and itch landing-page URL tracking. Out of scope: the first production push (happens at the repo's next release).

## Requirements

- **R-1 — Deployment tooling.** Repo-local `itch-push.sh` plus `itch.conf.example` mirroring the BoundPronouns pattern (`butler` resolution PATH→vendored `.tools/butler/`, `REPLACE_ME` config guard, per-channel pushes; no secrets in the repo — butler credentials live in butler's own store), with `itch.conf` gitignored. The script's artifact/channel section maps the repo's Godot export outputs (`export_presets.cfg` export paths, verified 2026-11-09): `tmp/NumbersMaze.x86_64` → `linux`; `tmp/NumbersMaze-x86_64.exe` → `windows`; `tmp/NumbersMaze-mac.zip` → `mac`; `tmp/html5/` zipped → `html` — matching the paired itch page's channel set. The Android preset's output (`tmp/NumbersMaze.aab`) is a Play-format bundle, not an itch-deployable APK, and stays out of the itch mapping.
- **R-2 — Target and landing-page URL tracking.** The push target binds to the paired itch project `cherokee-language/cherokee-numbers-maze`; the repo tracks its itch.io published landing page URL — `https://cherokee-language.itch.io/cherokee-numbers-maze` — in the itch config (`ITCH_URL` in `itch.conf.example`) and in the README.
- **R-3 — No version claims.** Pushes carry no `--userversion`; butler's auto-numbering stands (metadata is not trusted — no version label is verified or asserted).

## Success criteria

| ID | Criterion | Class | Instrument | Traces to |
|---|---|---|---|---|
| SC-1 | `itch-push.sh` + `itch.conf.example` exist carrying the BoundPronouns-pattern guards (REPLACE_ME guard, butler resolution PATH→vendored, per-channel pushes); `itch.conf` is gitignored | structural | Read the script and config; check `.gitignore` | R-1 |
| SC-2 | The repo tracks its itch.io published landing page URL: `ITCH_URL` in `itch.conf.example` and the URL stated in the README, both matching `https://cherokee-language.itch.io/cherokee-numbers-maze` | content | Read both files; string match against the paired page URL | R-2 |
| SC-3 | The script's push target binds `cherokee-language/cherokee-numbers-maze` and its channel section encodes `linux`, `windows`, `mac`, and `html` (zipped) per the export-preset output paths | structural | Read the script | R-1 |
| SC-4 | Pushes carry no version claims | structural | Script read (`--userversion` absent) | R-3 |

## Approach

Mirror the BoundPronouns repo's `itch-push.sh`/`itch.conf(.example)` pattern, adapted to this repo's Godot export outputs. No production push is performed in this work: the paired cherokeelessons.com spec owns the initial deployment of the published artifacts, and a conversion-verification push to a live channel would replace the published channel artifact — the first real push happens at the repo's next release.

## Out of scope

- The paired cherokeelessons.com work (itch page creation, initial artifact deployment) — CherokeeLessons.com#25.
- The first production push — happens at the repo's next release.
- The Android/TV output — its `.aab` export is a Play-format bundle, not an itch-deployable APK; any itch Android channel awaits a developer decision and is not part of this conversion.

## Impact

Repo-local tooling files only; no runtime behavior change; the paired itch page gains no new state from this work (channels grow only at future release pushes). The repo's future releases gain a repeatable path to itch.io.

🤖 Co-authored with AI: OpenCode (huggingface/zai-org/GLM-5.3-Flash)

