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
    @Test func cleanBuildXcode15_1() throws {
        let url = try #require(Bundle.module.url(forResource: "clean_build_xcode_15_1", withExtension: "txt"))

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

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 45)
        #else
        #expect(uncapturedOutput == 61)
        #endif
    }

    @Test func largeXcodebuildLog() throws {
        let url = try #require(Bundle.module.url(forResource: "large_xcodebuild_log", withExtension: "txt"))

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

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        #expect(uncapturedOutput == 1508)
        #else
        #expect(uncapturedOutput == 2076)
        #endif
    }

    @Test func parsingSwiftTestingTestOutput() throws {
        let url = try #require(Bundle.module.url(forResource: "swift_test_log_macOS", withExtension: "txt"))
        let logContent = try String(contentsOf: url, encoding: .utf8)
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
        #expect(uncapturedOutput == 162)
        #else
        #expect(uncapturedOutput == 271)
        #endif
    }

    @Test func shortSPISwiftTestingOutput() throws {
        let url = try #require(Bundle.module.url(forResource: "spi_swift_testing_short_log", withExtension: "txt"))
        let logContent = try String(contentsOf: url, encoding: .utf8)
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
        #expect(uncapturedOutput == 10)
        #else
        #expect(uncapturedOutput == 9)
        #endif
    }

    @Test func fullSPISwiftTestingOutput() throws {
        let url = try #require(Bundle.module.url(forResource: "spi_swift_testing_full_log", withExtension: "txt"))
        let logContent = try String(contentsOf: url, encoding: .utf8)
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
        #expect(uncapturedOutput == 2199)
        #else
        #expect(uncapturedOutput == 2198)
        #endif
    }

    @Test func demoSwiftTestingOutput() throws {
        let url = try #require(Bundle.module.url(forResource: "demo_swift_testing_log", withExtension: "txt"))
        let logContent = try String(contentsOf: url, encoding: .utf8)
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
        #expect(uncapturedOutput == 2)
    }
}
