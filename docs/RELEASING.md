# Releasing xcbeautify

This guide is for maintainers.

## Prerequisites

- Ensure you have push access to `main` and tag permissions.
- Ensure local branch is clean and up to date.
- Run validation before release:

```bash
swift test
./tools/lint
./tools/check-sorted
```

## Version bump and tag

Use the existing release target:

```bash
make release version=x.y.z
```

This target updates `Sources/xcbeautify/Version.swift`, commits, pushes `main`, creates the tag, and pushes the tag.

## Artifacts and workflows

- Release artifacts are built by repository workflows.
- If changing packaging behavior, keep `Makefile` and workflow definitions aligned.

## Post-release checks

- Verify the new tag and GitHub Release are visible.
- Verify Homebrew and Mint installation paths still work as expected.
- If CLI flags or defaults changed, update `README.md` and `CONTRIBUTING.md`.
