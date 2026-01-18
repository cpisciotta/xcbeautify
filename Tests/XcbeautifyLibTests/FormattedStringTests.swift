//
// FormattedStringTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib

@Suite struct FormattedStringTests {
    // MARK: - Escape Sequence Constants

    // Based on Colorizer library: https://github.com/getGuaka/Colorizer
    // Format: \u{001B}[<code>m where:
    // - 0 = reset, 1 = bold, 3 = italic
    // - 30-37 = foreground colors (31=red, 32=green, 33=yellow, 36=cyan)

    private let redStart = "\u{001B}[31m"
    private let greenStart = "\u{001B}[32m"
    private let yellowStart = "\u{001B}[33m"
    private let cyanStart = "\u{001B}[36m"
    private let boldStart = "\u{001B}[1m"
    private let reset = "\u{001B}[0m"

    private let coloredFormatter = Formatter(colored: true, renderer: .terminal, additionalLines: { nil })
    private let parser = Parser()

    // MARK: - Helper Methods

    private func coloredFormatted(_ string: String) -> String? {
        guard let captureGroup = parser.parse(line: string) else { return nil }
        return coloredFormatter.format(captureGroup: captureGroup)
    }

    // MARK: - Direct Formatting (No Parser)

    @Test func boldAndGreenInMiddleNotAtStart() {
        let formatted = "Prefix: \("Middle".s.Bold.f.Green) :Suffix"
        let expected = "Prefix: \u{001B}[32;1mMiddle\u{001B}[0m :Suffix"
        #expect(formatted == expected)
    }

    @Test func boldAndCyanInMiddleNotAtStart() {
        let formatted = "Note: \("Important".s.Bold.f.Cyan) details"
        let expected = "Note: \u{001B}[36;1mImportant\u{001B}[0m details"
        #expect(formatted == expected)
    }

    @Test func boldAndYellowSegmentWithResetBeforeSuffix() {
        let formatted = "Warning -> \("Segment".s.Bold.f.Yellow) continues"
        let expected = "Warning -> \u{001B}[33;1mSegment\u{001B}[0m continues"
        #expect(formatted == expected)
    }

    // MARK: - Interpolation: Color + Italic, Color mid-string, Style mid-string

    @Test func coloredItalicSegmentInMiddle() {
        let formatted = "Begin \("Core".s.Italic.f.Cyan) End"
        let expected = "Begin \u{001B}[36;3mCore\u{001B}[0m End"
        #expect(formatted == expected)
    }

    @Test func colorsMidStringOnly() {
        let formatted = "Alpha \("Beta".f.Red) Gamma"
        let expected = "Alpha \u{001B}[31mBeta\u{001B}[0m Gamma"
        #expect(formatted == expected)
    }

    @Test func stylesMidStringBoldOnly() {
        let formatted = "Foo \("Bar".s.Bold) Baz"
        let expected = "Foo \u{001B}[1mBar\u{001B}[0m Baz"
        #expect(formatted == expected)
    }

    // MARK: - Color then Style (order reversed)

    @Test func colorThenBoldMidString() {
        let formatted = "Start \("Middle".f.Red.s.Bold) End"
        let expected = "Start \u{001B}[1;31mMiddle\u{001B}[0m End"
        #expect(formatted == expected)
    }

    @Test func colorThenItalicMidString() {
        let formatted = "Begin \("Core".f.Cyan.s.Italic) Finish"
        let expected = "Begin \u{001B}[3;36mCore\u{001B}[0m Finish"
        #expect(formatted == expected)
    }

    // MARK: - Colored Compile Tasks (Target + Bold Command)

    @Test(.disabled(if: .linux))
    func compiledTaskWithColoredTargetAndBoldCommand() {
        let input = "CompileSwift normal x86_64 /Users/admin/dev/project/Sources/setup.swift (in target: xcbeautify)"
        let colored = coloredFormatted(input)

        // Colored: cyan target, bold "Compiling"
        let expected = "[\(cyanStart)xcbeautify\(reset)] \(boldStart)Compiling\(reset) setup.swift"
        #expect(colored == expected)
    }

    @Test func analyzeTaskWithColoredTargetAndBoldCommand() {
        let input = "AnalyzeShallow /Users/admin/project/Classes/DDTTYLogger.m normal x86_64 (in target: CocoaLumberjack-Static)"
        let colored = coloredFormatted(input)

        let expected = "[\(cyanStart)CocoaLumberjack-Static\(reset)] \(boldStart)Analyzing\(reset) DDTTYLogger.m"
        #expect(colored == expected)
    }

    @Test func codesignWithBoldCommand() {
        let input = "CodeSign build/Release/MyApp.app"
        let colored = coloredFormatted(input)

        let expected = "\(boldStart)Signing\(reset) MyApp.app"
        #expect(colored == expected)
    }

    @Test func cleaningWithBoldCommand() {
        let input = "Clean.Remove clean /Users/admin/Library/Developer/Xcode/DerivedData/MyLibrary-abcd/Build/Intermediates/MyLibrary.build/Debug-iphonesimulator/MyLibraryTests.build"
        let colored = coloredFormatted(input)

        let expected = "\(boldStart)Cleaning\(reset) MyLibraryTests.build"
        #expect(colored == expected)
    }

    @Test(.disabled(if: .linux))
    func linkingWithTargetAndBoldCommand() {
        let input = "Ld build/Release/MyApp.app/MyApp normal arm64 (in target: MyApp)"
        let colored = coloredFormatted(input)

        let expected = "[\(cyanStart)MyApp\(reset)] \(boldStart)Linking\(reset) MyApp"
        #expect(colored == expected)
    }

    // MARK: - Colored Errors (Red Text + Emoji)

    @Test func clangErrorWithRedTextAndEmoji() {
        let input = "clang: error: linker command failed with exit code 1 (use -v to see invocation)"
        let colored = coloredFormatted(input)

        let expected = "❌ \(redStart)clang: error: linker command failed with exit code 1 (use -v to see invocation)\(reset)"
        #expect(colored == expected)
    }

    @Test func linkerUndefinedSymbolsErrorWithRedText() {
        let input = "Undefined symbols for architecture x86_64:"
        let colored = coloredFormatted(input)

        let expected = "❌ \(redStart)Undefined symbols for architecture x86_64\(reset)"
        #expect(colored == expected)
    }

    // MARK: - Colored Warnings (Yellow Text + Emoji)

    @Test func genericWarningWithYellowTextAndEmoji() {
        let input = "warning: some warning message here"
        let colored = coloredFormatted(input)

        let expected = "⚠️ \(yellowStart)some warning message here\(reset)"
        #expect(colored == expected)
    }

    @Test func ldWarningWithYellowTextAndEmoji() {
        let input = "ld: warning: object file (/path/file.o) was built for newer macOS version"
        let colored = coloredFormatted(input)

        let expected = "⚠️ \(yellowStart)ld: \(reset)\(yellowStart)object file (/path/file.o) was built for newer macOS version\(reset)"
        #expect(colored == expected)
    }

    @Test func duplicateLocalizedStringKeyWarning() {
        let input = "warning: duplicate key 'MyKey' found in strings file at '/path/file.strings'"
        let colored = coloredFormatted(input)

        let expected = "⚠️ \(yellowStart)duplicate key 'MyKey' found in strings file at '/path/file.strings'\(reset)"
        #expect(colored == expected)
    }

    // MARK: - Colored Success Messages (Green + Bold)

    @Test func phaseSuccessWithGreenAndBold() {
        let input = "** BUILD SUCCEEDED **"
        let colored = coloredFormatted(input)

        let expected = "\u{001B}[32;1mBuild Succeeded\(reset)"
        #expect(colored == expected)
    }

    @Test func testSuccessWithGreenAndBold() {
        let input = "** TEST SUCCEEDED **"
        let colored = coloredFormatted(input)

        let expected = "\u{001B}[32;1mTest Succeeded\(reset)"
        #expect(colored == expected)
    }

    // MARK: - More Colored Build Tasks

    @Test func generatingDsymWithTargetAndBoldCommand() {
        let input = "GenerateDSYMFile /path/MyApp.app.dSYM /path/MyApp (in target: MyApp)"
        let colored = coloredFormatted(input)

        let expected = "[\(cyanStart)MyApp\(reset)] \(boldStart)Generating\(reset) MyApp.app.dSYM"
        #expect(colored == expected)
    }

    @Test func processingInfoPlistWithTargetAndBold() {
        let input = "ProcessInfoPlistFile /path/Info.plist /path/Source/Info.plist (in target: MyApp)"
        let colored = coloredFormatted(input)

        let expected = "[\(cyanStart)MyApp\(reset)] \(boldStart)Processing\(reset) Info.plist"
        #expect(colored == expected)
    }

    @Test func touchingWithTargetAndBoldCommand() {
        let input = "Touch /path/MyApp.app (in target: MyApp from project: MyProject)"
        let colored = coloredFormatted(input)

        let expected = "[\(cyanStart)MyApp from project: MyProject\(reset)] \(boldStart)Touching\(reset) MyApp.app"
        #expect(colored == expected)
    }

    // MARK: - Package Operations (Cyan + Bold + Green)

    @Test func targetCommandWithBoldAndCyan() {
        let input = "=== BUILD TARGET MyTarget OF PROJECT MyProject WITH CONFIGURATION Debug ==="
        let colored = coloredFormatted(input)

        let expected = "\u{001B}[36;1mBuild target MyTarget of project MyProject with configuration Debug\(reset)"
        #expect(colored == expected)
    }

    // MARK: - coloredTime() Method Tests

    @Test func coloredTimeNoColorBelow025Seconds() {
        let timeString = "0.020"
        let result = timeString.coloredTime()

        // Below 0.025 should have no color codes
        #expect(result == "0.020")
    }

    @Test func coloredTimeYellowBetween025And100Seconds() {
        let timeString = "0.050"
        let result = timeString.coloredTime()

        let expected = "\(yellowStart)0.050\(reset)"
        #expect(result == expected)
    }

    @Test func coloredTimeRedAbove100Seconds() {
        let timeString = "0.150"
        let result = timeString.coloredTime()

        let expected = "\(redStart)0.150\(reset)"
        #expect(result == expected)
    }

    @Test func coloredTimeExactBoundary025Seconds() {
        let timeString = "0.025"
        let result = timeString.coloredTime()

        // At exactly 0.025, should be yellow (< 0.025 = no color, else < 0.100 = yellow)
        let expected = "\(yellowStart)0.025\(reset)"
        #expect(result == expected)
    }

    @Test func coloredTimeExactBoundary100Seconds() {
        let timeString = "0.100"
        let result = timeString.coloredTime()

        // At exactly 0.100, should be red (>= 0.100 = red)
        let expected = "\(redStart)0.100\(reset)"
        #expect(result == expected)
    }

    @Test func coloredTimeInvalidStringReturnsUnchanged() {
        let timeString = "invalid"
        let result = timeString.coloredTime()

        #expect(result == "invalid")
    }

    // MARK: - coloredDeviation() Method Tests

    @Test func coloredDeviationNoColorBelow1() {
        let deviationString = "0.5"
        let result = deviationString.coloredDeviation()

        // Below 1 should have no color codes
        #expect(result == "0.5")
    }

    @Test func coloredDeviationYellowBetween1And10() {
        let deviationString = "5.0"
        let result = deviationString.coloredDeviation()

        let expected = "\(yellowStart)5.0\(reset)"
        #expect(result == expected)
    }

    @Test func coloredDeviationRedAbove10() {
        let deviationString = "15.0"
        let result = deviationString.coloredDeviation()

        let expected = "\(redStart)15.0\(reset)"
        #expect(result == expected)
    }

    @Test func coloredDeviationExactBoundary1() {
        let deviationString = "1.0"
        let result = deviationString.coloredDeviation()

        // At exactly 1, should be yellow (< 1 = no color, else < 10 = yellow)
        let expected = "\(yellowStart)1.0\(reset)"
        #expect(result == expected)
    }

    @Test func coloredDeviationExactBoundary10() {
        let deviationString = "10.0"
        let result = deviationString.coloredDeviation()

        // At exactly 10, should be red (>= 10 = red)
        let expected = "\(redStart)10.0\(reset)"
        #expect(result == expected)
    }

    @Test func coloredDeviationInvalidStringReturnsUnchanged() {
        let deviationString = "invalid"
        let result = deviationString.coloredDeviation()

        #expect(result == "invalid")
    }

    // MARK: - Test Case Formatting with coloredTime()

    @Test(.disabled(if: .linux))
    func testCasePassedWithColoredTime() {
        let input = "Test Case '-[MyTests myTest]' passed (0.050 seconds)."
        let colored = coloredFormatted(input)

        // Should have green status with yellow time (between 0.025-0.100)
        let expectedPattern = "\(Format.indent)\(greenStart)✔\(reset) myTest (\(yellowStart)0.050\(reset) seconds)"
        #expect(colored == expectedPattern)
    }

    @Test(.disabled(if: .linux))
    func testCaseSkippedWithColoredTime() {
        let input = "Test Case '-[MyTests myTest]' skipped (0.002 seconds)."
        let colored = coloredFormatted(input)

        // Should have yellow status with no color for time (< 0.025)
        let expectedPattern = "\(Format.indent)\(yellowStart)⊘\(reset) myTest (0.002 seconds)"
        #expect(colored == expectedPattern)
    }

    @Test(.disabled(if: .linux))
    func testCaseFailedWithRedStatus() {
        let input = "\(Format.indent)MyTests.swift:10: error: -[MyTests testFailure] : failed - Expected true"
        let colored = coloredFormatted(input)

        let expected = "\(Format.indent)\(redStart)✖\(reset) testFailure, failed - Expected true"
        #expect(colored == expected)
    }

    // MARK: - Parallel Test Cases with Colored Status

    @Test func parallelTestCasePassedWithGreenStatus() {
        let input = "Test case 'MyTests.testSomething()' passed on 'iPhone 15 Simulator' (0.050 seconds)"
        let colored = coloredFormatted(input)

        let expected = "\(Format.indent)\(greenStart)✔\(reset) [\(cyanStart)MyTests\(reset)] testSomething on 'iPhone 15 Simulator' (\(yellowStart)0.050\(reset) seconds)"
        #expect(colored == expected)
    }

    @Test func parallelTestCaseFailedWithRedStatus() {
        let input = "Test case 'MyTests.testFailure()' failed on 'iPhone 15 Simulator' (0.010 seconds)"
        let colored = coloredFormatted(input)

        let expected = "\(Format.indent)\(redStart)✖\(reset) [\(cyanStart)MyTests\(reset)] testFailure on 'iPhone 15 Simulator' (0.010 seconds)"
        #expect(colored == expected)
    }

    @Test func parallelTestCaseSkippedWithYellowStatus() {
        let input = "Test case 'MyTests.testSkipped()' skipped on 'iPhone 15 Simulator' (0.001 seconds)"
        let colored = coloredFormatted(input)

        let expected = "\(Format.indent)\(yellowStart)⊘\(reset) [\(cyanStart)MyTests\(reset)] testSkipped on 'iPhone 15 Simulator' (0.001 seconds)"
        #expect(colored == expected)
    }

    // MARK: - Check Dependencies with Bold

    @Test func checkDependenciesWithBold() {
        let input = "Check dependencies"
        let colored = coloredFormatted(input)

        let expected = "\(boldStart)Check dependencies\(reset)"
        #expect(colored == expected)
    }

    // MARK: - Integration Tests: Verify Emoji vs ASCII Symbol Switching

    @Test func errorSymbolSwitchesBetweenEmojiAndAscii() {
        let input = "clang: error: linker command failed"
        let colored = coloredFormatted(input)

        let expectedWithEmoji = "❌ \(redStart)clang: error: linker command failed\(reset)"
        #expect(colored == expectedWithEmoji)
    }

    @Test func warningSymbolSwitchesBetweenEmojiAndAscii() {
        let input = "ld: warning: object file was built for newer macOS"
        let colored = coloredFormatted(input)

        let expectedWithEmoji = "⚠️ \(yellowStart)ld: \(reset)\(yellowStart)object file was built for newer macOS\(reset)"
        #expect(colored == expectedWithEmoji)
    }

    // MARK: - Edge Cases

    @Test func resetCodeAppearsAfterEachStyledSegment() {
        let timeString = "0.050"
        let result = timeString.coloredTime()

        // Structure should be: start color + text + reset
        let expected = "\(yellowStart)0.050\(reset)"
        #expect(result == expected)
    }

    @Test(.disabled(if: .linux))
    func multipleStylesInTargetCommand() {
        // Compile task has both cyan target and bold command
        let input = "CompileSwift normal x86_64 /path/file.swift (in target: MyTarget)"
        let colored = coloredFormatted(input)

        // Verify both cyan and bold are present with resets
        let expected = "[\(cyanStart)MyTarget\(reset)] \(boldStart)Compiling\(reset) file.swift"
        #expect(colored == expected)
    }

    @Test func errorMessagePreservesEmojiAndColor() {
        let input = "clang: error: unknown argument: '-invalid-flag'"
        let colored = coloredFormatted(input)

        // Emoji + red colored error message + reset
        let expected = "❌ \(redStart)clang: error: unknown argument: '-invalid-flag'\(reset)"
        #expect(colored == expected)
    }

    @Test func warningMessagePreservesEmojiAndColor() {
        let input = "warning: unused variable 'x'"
        let colored = coloredFormatted(input)

        // Emoji + yellow colored warning message + reset
        let expected = "⚠️ \(yellowStart)unused variable 'x'\(reset)"
        #expect(colored == expected)
    }
}
