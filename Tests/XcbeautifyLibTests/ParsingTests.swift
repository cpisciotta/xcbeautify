//
// ParsingTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import Testing
@testable import XcbeautifyLib
import XcLogParserLib

@Suite struct ParsingTests {
    // These test cases use magic numbers to represent the number of lines that aren't captured by the Parser.
    // Slowly, the values should decrease until they reach 0.
    // Test cases uses `==` instead of `<=` as a reminder.
    // Update the magic numbers whenever `uncapturedOutput` is less than the current magic number.
    // There's a regression whenever `uncapturedOutput` is greater than the current magic number.

    private func uncapturedOutput(
        for resource: String,
        withExtension extension: String = "txt"
    ) throws -> Int {
        let url = try #require(Bundle.module.url(forResource: resource, withExtension: `extension`))

        var buildLog: [String] = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)

        let parser = Parser()

        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        return uncapturedOutput
    }

    @Test func cleanBuildXcode15_1() throws {
        let uncapturedOutput = try uncapturedOutput(for: "clean_build_xcode_15_1")

        #if os(macOS)
        #expect(uncapturedOutput == 45)
        #else
        #expect(uncapturedOutput == 61)
        #endif
    }

    @Test func demoSwiftTestingOutput() throws {
        let uncapturedOutput = try uncapturedOutput(for: "demo_swift_testing_log")
        #expect(uncapturedOutput == 2)
    }

    @Test func largeXcodebuildLog() throws {
        let uncapturedOutput = try uncapturedOutput(for: "large_xcodebuild_log")

        #if os(macOS)
        #expect(uncapturedOutput == 1508)
        #else
        #expect(uncapturedOutput == 2076)
        #endif
    }

    @Test func mixedTestLog60Linux() throws {
        let uncapturedOutput = try uncapturedOutput(for: "MixedTestLog_6_0_Linux")

        #if os(macOS)
        #expect(uncapturedOutput == 10)
        #else
        #expect(uncapturedOutput == 2)
        #endif
    }

    @Test func mixedTestLog60MacOS() throws {
        let uncapturedOutput = try uncapturedOutput(for: "MixedTestLog_6_0_macOS")

        #if os(macOS)
        #expect(uncapturedOutput == 3)
        #else
        #expect(uncapturedOutput == 6)
        #endif
    }

    @Test func parallelTestLog() throws {
        let uncapturedOutput = try uncapturedOutput(for: "ParallelTestLog")
        #expect(uncapturedOutput == 0)
    }

    @Test func fullSPISwiftTestingOutput() throws {
        let uncapturedOutput = try uncapturedOutput(for: "spi_swift_testing_full_log")

        #if os(macOS)
        #expect(uncapturedOutput == 2199)
        #else
        #expect(uncapturedOutput == 2198)
        #endif
    }

    @Test func shortSPISwiftTestingOutput() throws {
        let uncapturedOutput = try uncapturedOutput(for: "spi_swift_testing_short_log")

        #if os(macOS)
        #expect(uncapturedOutput == 10)
        #else
        #expect(uncapturedOutput == 9)
        #endif
    }

    @Test func parsingSwiftTestingTestOutput() throws {
        let uncapturedOutput = try uncapturedOutput(for: "swift_test_log_macOS")

        #if os(macOS)
        #expect(uncapturedOutput == 162)
        #else
        #expect(uncapturedOutput == 271)
        #endif
    }

    @Test func testLog() throws {
        let uncapturedOutput = try uncapturedOutput(for: "TestLog")

        #if os(macOS)
        #expect(uncapturedOutput == 3)
        #else
        #expect(uncapturedOutput == 84)
        #endif
    }
}
