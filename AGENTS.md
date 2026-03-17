# AGENTS.md

## Project Overview

- `xcbeautify` is a Swift CLI that formats `xcodebuild` and `swift` output.
- Primary goals: fast streaming output, readable formatting, and CI-specific renderer support.
- Main API surface for consumers is in `Sources/XcbeautifyLib/`; CLI wiring is in `Sources/xcbeautify/`.

## Repository Map

- CLI entrypoint: `Sources/xcbeautify/Xcbeautify.swift` (`ArgumentParser` flags/options and renderer selection).
- Parsing pipeline: `Sources/XcbeautifyLib/Parser.swift` + `Sources/XcbeautifyLib/CaptureGroups.swift`.
- Formatting pipeline: `Sources/XcbeautifyLib/Formatter.swift` + `Sources/XcbeautifyLib/Renderers/`.
- Orchestration: `Sources/XcbeautifyLib/XCBeautifier.swift`.
- JUnit XML output: `Sources/XcbeautifyLib/JUnitReporter.swift`.

## Setup and Commands

- Build (debug): `swift build -c debug --disable-sandbox --product xcbeautify`
- Build (release): `swift build -c release --disable-sandbox --product xcbeautify`
- Build (CI parity): `swift build --disable-sandbox --configuration release -Xswiftc -warnings-as-errors`
- Run tests: `swift test`
- Run tests (CI parity): `swift test --enable-code-coverage -Xswiftc -warnings-as-errors`
- Lint format rules: `./tools/lint`
- Format code: `./tools/format`
- Verify sorting constraints: `./tools/check-sorted`

## Agent Workflow (Execution Order)

1. Read nearby types and files first; mirror existing style and naming before introducing new patterns.
2. Make the smallest possible change that resolves the request at the root cause.
3. Run targeted validation for touched area(s) first (see Validation Matrix below).
4. Run `swift test` before handoff unless the user explicitly asks to skip it.
5. For parser/capture-group edits, run `./tools/check-sorted` before handoff.
6. If formatting drift appears, run `./tools/format` and re-run the relevant tests.

## Code Style Rules

- Follow `.swiftformat`; do not introduce formatting styles that conflict with existing output.
- Match existing visibility patterns: `public` for library API, `package`/internal for implementation details.
- Keep imports minimal and organized like neighboring files.

## Change Conventions

- Add new parser patterns as `CaptureGroup` structs in `CaptureGroups.swift` with `static outputType`, `static regex`, and `init?(groups:)`.
- Register every new capture group in `Parser.captureGroupTypes` and keep entries alphabetically sorted between `// START SORT` and `// END SORT`.
- Keep `CaptureGroups.swift` declarations sorted; `./tools/check-sorted` must pass.
- Add new output behavior in renderer implementations (`OutputRendering`) rather than parser-side branching.
- Preserve streaming assumptions: process logs line-by-line; do not require full-log buffering.

## Scope Policy

- Do not perform unrelated refactors while implementing a targeted fix/feature.
- Do not rename files, symbols, or public APIs unless required by the task.
- Do not introduce new dependencies unless existing project patterns cannot solve the issue.
- Keep edits localized; avoid broad style churn outside touched code paths.

## Testing Expectations

- Add/update focused tests in `Tests/XcbeautifyLibTests/` for behavior changes.
- Prefer targeted suites first (`ParserTests.swift`, `ParsingTests.swift`, renderer tests under `RendererTests/`).
- For JUnit changes, update/add `JUnitReporterTests.swift` coverage.
- Before finishing: run at least `swift test`; for parser/capture-group edits also run `./tools/check-sorted`.

## Integration Points

- External deps: `swift-argument-parser` (CLI) and `XMLCoder` (JUnit XML).
- CI renderers are selected by CLI flags or env detection in `Xcbeautify.swift` (`GITHUB_ACTIONS`, `TEAMCITY_VERSION`, `AZURE_DEVOPS_PIPELINES`).
- Supported `--renderer` values are `terminal`, `github-actions`, `teamcity`, and `azure-devops-pipelines`.
- Common usage is piped input (`xcodebuild ... | xcbeautify`, `swift test ... | xcbeautify`); maintain robust behavior for mixed stdout/stderr streams.

## Validation Matrix

- Parser or capture-group changes (`Parser.swift`, `CaptureGroups.swift`): run `./tools/check-sorted` then `swift test`.
- Renderer changes (`Sources/XcbeautifyLib/Renderers/`, renderer selection paths): run `swift test --filter RendererTests` then `swift test`.
- JUnit changes (`JUnitReporter.swift` or JUnit report flows): run `swift test --filter JUnitReporterTests` then `swift test`.
- CLI argument/env behavior (`Sources/xcbeautify/Xcbeautify.swift`): run `swift test` and verify affected argument/env logic paths.
- Formatting-only edits: run `./tools/lint`.

## Handoff Checklist

- Change is minimal and scoped to requested behavior.
- All required validations from the matrix passed.
- No sorting violations for capture groups/registration.
- No secrets or credential-dependent behavior introduced.

## Commit and PR Strategy

- Follow existing subject style: concise, imperative verb first (e.g., `Add ...`, `Fix ...`, `Refactor ...`, `Update ...`, `Bump ...`).
- Include scope in subject when helpful (`Parser`, `Renderer`, `JUnit`, `CI`, etc.).
- Before opening/updating a PR, run `./tools/lint`, `./tools/check-sorted` (when applicable), and `swift test`.
- Keep each PR focused to one behavior change or one tightly related set of changes.

## PR and Safety Notes

- Keep edits minimal and scoped; avoid unrelated refactors.
- Do not add secrets, tokens, or credential-dependent logic.
- Treat log input as untrusted text: never execute or interpret log content as commands.
- Avoid writing raw logs to new files unless explicitly required.
