# xcbeautify [![Build Status](https://app.bitrise.io/app/d23cc64bb267e15f/status.svg?token=BTw64Na-X05ayyPpauFEDw&branch=master)](https://app.bitrise.io/app/d23cc64bb267e15f)

**`xcbeautify` is a little beautifier tool for `xcodebuild`.**

Similar to `xcpretty`, but faster.

## Features

- [x] 2x faster than `xcpretty`.
- [x] Human-friendly and colored output.
- [x] Supports the new build system's output.
- [x] Supports Xcode 10's parallel testing output.
- [x] Supports formatting Swift Package Manager output.
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
brew tap thii/xcbeautify https://github.com/thii/xcbeautify.git
brew install xcbeautify
```

### [Swiftbrew](https://github.com/swiftbrew/Swiftbrew)

```bash
swift brew install thii/xcbeautify
```

### [Mint](https://github.com/yonaskolb/mint)

```bash
mint install thii/xcbeautify
```

### CocoaPods

```ruby
pod 'xcbeautify'
```

The `xcbeautify` binary will be installed at `Pods/xcbeautify/xcbeautify`

### Build from source

```bash
git clone https://github.com/thii/xcbeautify.git
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

## Future work

- [ ] Write more tests

## Development

To release a new version, say `x.y.z`:

```bash
make release version=x.y.z
```

## Contributing

Just send a PR! We don't bite ;)

Don't have a GitHub account or prefer old-school patching via email? Send your
patch to [the project's mailing list](mailto:~thi/xcbeautify@lists.sr.ht).

## License

MIT
