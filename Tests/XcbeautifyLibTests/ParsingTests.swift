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

@Suite struct ParsingTests {

    private func uncapturedOutput(
        for resource: String,
        withExtension `extension`: String = "txt"
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
        let uncapturedOutput = try self.uncapturedOutput(for: "clean_build_xcode_15_1_log")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 45)
        #else
        #expect(uncapturedOutput == 61)
        #endif
    }

    @Test func demoSwiftTestingOutput() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "demo_swift_testing_log")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #expect(uncapturedOutput == 2)
    }

    @Test func largeXcodebuildLog() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "large_xcodebuild_log")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 1508)
        #else
        #expect(uncapturedOutput == 2076)
        #endif
    }

    @Test func mixedTestLog60Linux() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "MixedTestLog_6_0_Linux")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 10)
        #else
        #expect(uncapturedOutput == 2)
        #endif
    }

    @Test func mixedTestLog60MacOS() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "MixedTestLog_6_0_macOS")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 3)
        #else
        #expect(uncapturedOutput == 6)
        #endif
    }

    @Test func parallelTestLog() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "ParallelTestLog")
        #expect(uncapturedOutput == 0)
    }

    @Test func fullSPISwiftTestingOutput() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "spi_swift_testing_full_log")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 2199)
        #else
        #expect(uncapturedOutput == 2198)
        #endif
    }

    @Test func shortSPISwiftTestingOutput() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "spi_swift_testing_short_log")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 10)
        #else
        #expect(uncapturedOutput == 9)
        #endif
    }

    @Test func parsingSwiftTestingTestOutput() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "swift_test_log_macOS")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 162)
        #else
        #expect(uncapturedOutput == 271)
        #endif
    }

    @Test func testLog() throws {
        let uncapturedOutput = try self.uncapturedOutput(for: "TestLog")

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `==` instead of `<=` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 3)
        #else
        #expect(uncapturedOutput == 84)
        #endif
    }
}
