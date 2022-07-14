# xcbeautify

[![Build Status](https://github.com/tuist/xcbeautify/workflows/build/badge.svg?branch=main)](https://github.com/tuist/xcbeautify/actions)
[![Latest Release](https://img.shields.io/github/release/tuist/xcbeautify.svg)](https://github.com/tuist/xcbeautify/releases/latest)
[![License](https://img.shields.io/github/license/tuist/xcbeautify.svg)](LICENSE.md)

**`xcbeautify` is a little beautifier tool for `xcodebuild`.**

Similar to `xcpretty`, but faster.

## Features

- [x] 2x faster than `xcpretty`.
- [x] Human-friendly and colored output.
- [x] Supports the new build system's output.
- [x] Supports Xcode's parallel testing output.
- [x] Supports formatting Swift Package Manager output.
- [x] Supports formatting Bazel output.
- [x] Supports macOS & Linux.
- [x] Written in Swift: `xcbeautify` compiles to a static binary which you can
  bring anywhere. This also means less Ruby-dependant in your development
  environment and CI.

**Note:** `xcbeautify` does not support generating JUnit or HTML test reports.
In fact, you shouldn't rely on `xcodebuild`'s output to generate test reports.
We suggest using [trainer](https://github.com/KrauseFx/trainer) or
[XCTestHTMLReport](https://github.com/TitouanVanBelle/XCTestHTMLReport) to
generate test reports from `xcodebuild`'s generated `TestSummaries.plist`
files.

## Fun fact

`xcbeautify` uses itself to format its CI build logs.

## Installation

If you use macOS 10.14.3 or earlier, install Swift 5 Runtime Support for
Command Line Tools first:

```bash
brew cask install thii/swift-runtime/swift-runtime
```

### Homebrew

```bash
brew install xcbeautify
```

### [Mint](https://github.com/yonaskolb/mint)

```bash
mint install tuist/xcbeautify
```

### CocoaPods

```ruby
pod 'xcbeautify'
```

The `xcbeautify` binary will be installed at `Pods/xcbeautify/xcbeautify`


### Swift Package Manager

Create a directory in the same location as the `xcodeproj` file, for example `Example`.  
In that directory, create a `Package.swift` file with the following contents.  
In addition, add an empty file named `Empty.swift` to the same location.

```swift
// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "Example",
    platforms: [.macOS(.v10_11)],
    dependencies: [
      .package(url: "https://github.com/tuist/xcbeautify", from: "0.13.0"),
    ],
    targets: [
      .target(name: "Example", path: "")
    ]
)
```

Enter this command to execute.  
```
$ cd Example
$ swift run -c release --package-path {package-path} xcbeautify
```

### Build from source

```bash
git clone https://github.com/tuist/xcbeautify.git
cd xcbeautify
make install
```

## Usage

```bash
xcodebuild [flags] | xcbeautify
```

If you want `xcbeautify` to exit with the same status code as `xcodebuild`
(e.g. on a CI):

```bash
set -o pipefail && xcodebuild [flags] | xcbeautify
```

For parallel and concurrent destination testing, it helps to use unbuffered I/O for _stdout_ and to redirect _stderr_ to _stdout_.

```bash
NSUnbufferedIO=YES xcodebuild [flags] 2>&1 | xcbeautify
```

```bash
swift test [flags] 2>&1 | xcbeautify
```

Parse Bazel's building and testing output:

```sh
set -o pipefail && bazel build //path/to/package:target 2>&1 | xcbeautify
```

```sh
set -o pipefail && bazel test //path/to/package:target 2>&1 | xcbeautify
```

## Future work

- [ ] Write more tests

## Development

Generate Xcode project:

```sh
make xcode
```

Build with Bazel:

```sh
bazel build //Sources/xcbeautify
```

Release a new version, say `x.y.z`:

```bash
make release version=x.y.z
```

## Contributing

Please send a PR!

## License

MIT
