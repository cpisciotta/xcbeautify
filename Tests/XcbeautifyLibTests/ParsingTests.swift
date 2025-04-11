//
// ParsingTests.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import XCTest
@testable import XcbeautifyLib

final class ParsingTests: XCTestCase {
    func testCleanBuildXcode15_1() throws {
        let url = Bundle.module.url(forResource: "clean_build_xcode_15_1", withExtension: "txt")!

        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        let parser = Parser()

        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 45)
        #else
        XCTAssertEqual(uncapturedOutput, 61)
        #endif
    }

    func testLargeXcodebuildLog() throws {
        let url = Bundle.module.url(forResource: "large_xcodebuild_log", withExtension: "txt")!

        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        let parser = Parser()

        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 1508)
        #else
        XCTAssertEqual(uncapturedOutput, 2076)
        #endif
    }

    func testParsingSwiftTestingTestOutput() throws {
        let url = Bundle.module.url(forResource: "swift_test_log", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()
        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                print(line)
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 162)
        #else
        XCTAssertEqual(uncapturedOutput, 271)
        #endif
    }

    func testShortSPISwiftTestingOutput() throws {
        let url = Bundle.module.url(forResource: "spi_swift_testing_short_log", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()
        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 10)
        #else
        XCTAssertEqual(uncapturedOutput, 9)
        #endif
    }

    func testFullSPISwiftTestingOutput() throws {
        let url = Bundle.module.url(forResource: "spi_swift_testing_full_log", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()
        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 2199)
        #else
        XCTAssertEqual(uncapturedOutput, 2198)
        #endif
    }

    func testDemoSwiftTestingOutput() throws {
        let url = Bundle.module.url(forResource: "demo_swift_testing_log", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()
        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        XCTAssertEqual(uncapturedOutput, 2)
    }

    func testSwiftCompile() throws {
        let url = Bundle.module.url(forResource: "swiftcompile-failure-with-stack", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()

        var parsedLines: [any CaptureGroup] = []

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if let parsedLine = parser.parse(line: line) {
                parsedLines.append(parsedLine)
            }
        }

        parseLine(parsedLines.removeFirst(), to: SwiftCompileFailedCaptureGroup.self) {
            XCTAssertEqual(
                $0.wholeError,
                "Command SwiftCompile failed with a nonzero exit code"
            )
        }
        parseLine(parsedLines.removeFirst(), to: SwiftCompileStackDumpHeaderCaptureGroup.self) {
            XCTAssertEqual($0.wholeLine, "Stack dump:")
        }

        while let line = parsedLines.first {
            parseLine(line, to: SwiftCompileStackDumpCaptureGroup.self) {
                print($0.wholeLine)
                XCTAssertTrue(
                    $0.wholeLine.contains {
                        CharacterSet.decimalDigits.contains($0.unicodeScalars.first!)
                    }
                )
            }
            parsedLines.removeFirst()
        }
        XCTAssertTrue(parsedLines.isEmpty)
    }

    private func parseLine<T: CaptureGroup>(
        _ line: any CaptureGroup,
        to type: T.Type,
        check: (T) -> Void
    ) {
        if let parsedLine = line as? T {
            check(parsedLine)
        } else {
            XCTFail("Expected \(type), but got \(Swift.type(of: line))")
        }
    }
}
