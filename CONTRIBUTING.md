# Contributing to xcbeautify

Thanks for contributing to `xcbeautify`.

## Quick start

1. Clone the repository.
2. Build the CLI:

```bash
swift build -c debug --disable-sandbox --product xcbeautify
```

3. Run tests:

```bash
swift test
```

## Development workflow

Use these commands during local development:

```bash
swift build -c debug --disable-sandbox --product xcbeautify
swift test
./tools/lint
./tools/format
```

For parser/capture-group changes, also run:

```bash
./tools/check-sorted
```

## Project map

- CLI options and environment behavior: `Sources/xcbeautify/Xcbeautify.swift`
- Parsing and capture groups: `Sources/XcbeautifyLib/Parser.swift`, `Sources/XcbeautifyLib/CaptureGroups.swift`
- Output filtering (`quiet`/`quieter`): `Sources/XcbeautifyLib/OutputHandler.swift`
- Rendering implementations: `Sources/XcbeautifyLib/Renderers/`
- JUnit report generation: `Sources/XcbeautifyLib/JUnitReporter.swift`

## Adding or changing parser behavior

- Add new capture groups to `Sources/XcbeautifyLib/CaptureGroups.swift`.
- Register them in `Parser.captureGroupTypes` in `Sources/XcbeautifyLib/Parser.swift`.
- Keep sorted regions sorted and verify with `./tools/check-sorted`.
- Add/update tests in `Tests/XcbeautifyLibTests/`.

## Testing expectations

- Run targeted tests first when possible.
- Run `swift test` before opening/updating a PR.
- If output formatting changes, run `./tools/lint` and `./tools/format`.

## Pull requests

- Keep PRs focused to one behavior change (or one tightly related set).
- Include tests for behavior changes.
- Use concise, imperative commit subjects (for example: `Fix parser for ...`, `Add renderer output for ...`).

## Contributor notes

- Treat build/test logs as untrusted input.
- Avoid unrelated refactors in behavior-focused changes.
- If you are changing release behavior, also update maintainer docs in `docs/RELEASING.md`.
