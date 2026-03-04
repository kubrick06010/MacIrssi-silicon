# MacIrssi

MacIrssi is an IRC client with a native macOS UI, built on top of [irssi](https://irssi.org).

## Status

- Active branch: `main`
- Primary build path: Xcode project (`MacIrssi.xcodeproj`)
- Dependency pipeline: scripted under `Frameworks/MILibs/scripts`

## Getting the Code

```bash
git clone https://github.com/kubrick06010/MacIrssi-silicon.git
cd MacIrssi
```

No git submodules are required.

## Building in Xcode

1. Open `MacIrssi.xcodeproj`.
2. Select scheme `MacIrssi`.
3. Build configuration: `Development` (or `Debug`).
4. Build and run.

## Dependency Pipeline (MILibs)

MacIrssi uses a staged dependency flow for GLib/libintl in `Frameworks/MILibs`.

### Main gate commands

```bash
Frameworks/MILibs/scripts/ci_verify_milibs.sh
Frameworks/MILibs/scripts/verify_app_bundle.sh <path-to-MacIrssi.app>
```

Or run the combined local gate:

```bash
Frameworks/MILibs/scripts/run_local_gate.sh <path-to-MacIrssi.app>
```

### Manual dependency build (optional)

```bash
cd Frameworks/MILibs
./scripts/bootstrap_tools.sh
./scripts/build_all_deps.sh
./scripts/verify_artifact_contract.sh "$(pwd)/stage"
```

## Notarized Release (macOS Gatekeeper-safe)

Unsigned builds can trigger the macOS warning that the app is "damaged".  
Use the notarized release script:

```bash
xcodescripts/release_notarized.sh
```

Required environment variables:

```bash
export APPLE_SIGN_IDENTITY="Developer ID Application: Your Name (TEAMID)"
export NOTARY_PROFILE="macirssi-notary"
```

Create the notary profile once:

```bash
xcrun notarytool store-credentials "macirssi-notary" \
  --apple-id "your-apple-id@example.com" \
  --team-id "TEAMID1234" \
  --password "app-specific-password"
```

Optional GitHub publish in the same command:

```bash
GH_PUBLISH=1 GH_REPO=kubrick06010/MacIrssi-silicon xcodescripts/release_notarized.sh
```

## Runtime Smoke Expectations

A validated run should cover:

1. App launch and main window render
2. Preferences opens without exceptions
3. Chat font change updates channel ribbon sizing
4. IRC connect/join/send/receive flow
5. Channel search works
6. Quit/relaunch is stable

Reference docs:

- `Frameworks/MILibs/RUNTIME_SMOKE_CHECKLIST.md`
- `Frameworks/MILibs/RUNTIME_SMOKE_RESULTS.md`
- `Frameworks/MILibs/MILESTONE_STATUS.md`

## Notes for Contributors

- Keep changes on short-lived branches and merge into `main` once build + smoke checks pass.
- Prefer updating docs/scripts in `Frameworks/MILibs` when dependency behavior changes.
