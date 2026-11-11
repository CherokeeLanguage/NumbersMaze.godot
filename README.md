# NumbersMaze.godot
Cherokee Language Numbers Maze

## Publishing to itch.io (manual)

The published page: **https://cherokee-language.itch.io/cherokee-numbers-maze**

The game publishes to itch.io via butler — the repo's push script never
builds anything; it pushes editor-exported artifacts to five channels
(`html5`, `android`, `windows`, `linux`, `macos`).

1. Export the artifacts with the Godot editor's export presets (paths in
   `itch.conf.example`).
2. `cp itch.conf.example itch.conf` and fill in the target (gitignored;
   defaults carry the real target already).
3. `butler login` — once; credentials live in butler's own store, never in
   the repo.
4. `./itch-push.sh` — pushes all five artifacts and prints per-channel
   receipts.

butler is not required on `PATH`: the script falls back to the vendored copy
at `.tools/butler/butler` (gitignored; the vendoring command is in the
script's header). Full page setup — creating the game slot, the cover, the
html5 channel tagging, publish and rollback — is documented step by step in
[docs/itch-app-setup.md](docs/itch-app-setup.md).
