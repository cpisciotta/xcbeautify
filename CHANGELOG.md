## 0.7.6
- Added support for parsing warnings and errors from Bazel build output (#34) @thii

## 0.7.5
- Fixed ProcessPCH++ not parsed and incorrect captured content for processPchCommand (#32) @greensky01

## 0.7.4
- Added support for undefined symbold location warnings (#31) @kingslay

## 0.7.3
- Failing tests are no longer being masked by the "--quiet" flag. (#29) @cobbal

## 0.7.2
- Fixed Xcode 11.3 output (#28) @greensky01

## 0.7.1
- Fixed shell command matcher hiding UI test failures (#26) @cobbal

## 0.7.0
- Fixed parsing of Xcode 11.1 and above's outputs (#24) @thii
- Fixed log parsing for certain outputs for SwiftPM CLI on Linux (#21) @cyberbeni
- Bumped Swift tools version to 5.0 (#21) @cyberbeni

## 0.6.0
- Parallel & Concurrent Destination Testing (#16) @chriszielinski

## 0.5.0
- Display a banner and warning or error in the quiet mode (#15) @greensky01
- Support filtering out ouput that aren't warnings and errors (#14) @thii

## 0.4.4
- Remove backslashes before whitespaces in script build phases (#12)
  @guillaumealgis

## 0.4.3
- Fix bottling error on macOS High Sierra.

## 0.4.2
- Support building with Swift 4

## 0.4.1
- Support custom prefix installation

## 0.4.0
- Reduces binary size.
- This version requires macOS Mojave 10.14.4 or above.

## 0.3.8
- Improves performance significantly.
- This is the last version that supports macOS 10.14.3 and below.

## 0.3.7
- Supports AppKit projects.

## 0.3.6
- Fixes `Executable product not found` error when installs using Mint.

## 0.3.5
- Fixes crash when parsing `PBXCp` commands (#1).
- Improves format of other `AnalyzeShallow` and `ProcessPCH`.

## 0.3.3
- Fixes crash when parsing `compileXib` line.

## 0.3.2
- Fixes crash when parsing `compileStoryboard` line.

## 0.3.1
- Fixes format of `Ld`.

## 0.3.0

- Improves format of `GenerateDSYMFile` and `Libtool`.

## 0.2.1

- Minor bug fixes.

## 0.2.0

- Drops support for Xcode 9. If you're using Xcode 9, `xcpretty` still works
  great.
- Improves parsing output.

## 0.1.0

- This is the initial public relase.
