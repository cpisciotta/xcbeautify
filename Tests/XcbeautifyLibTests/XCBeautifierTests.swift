//
// XCBeautifierTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib

struct XCBeautifierTests {
    @Test func processReturnsNilForUnrecognizedLineWhenPreserveDisabled() {
        let beautifier = XCBeautifier(
            colored: true,
            renderer: .terminal,
            preserveUnbeautifiedLines: false,
            additionalLines: { nil }
        )

        let result = beautifier.process(line: "this line is not recognized")

        #expect(result == nil)
        #expect(beautifier.format(line: "this line is not recognized") == nil)
    }

    @Test func processPreservesUnrecognizedLineWhenPreserveEnabled() throws {
        let beautifier = XCBeautifier(
            colored: true,
            renderer: .terminal,
            preserveUnbeautifiedLines: true,
            additionalLines: { nil }
        )

        let input = "this line is not recognized"
        let result = try #require(beautifier.process(line: input))

        #expect(result.captureGroup == nil)
        #expect(result.outputType == .undefined)
        #expect(result.formatted == input)
        #expect(beautifier.format(line: input) == input)
    }

    @Test func processReturnsCaptureGroupForRecognizedLine() throws {
        let beautifier = XCBeautifier(
            colored: true,
            renderer: .terminal,
            preserveUnbeautifiedLines: false,
            additionalLines: { nil }
        )

        let input = "** BUILD SUCCEEDED **"
        let result = try #require(beautifier.process(line: input))

        #expect(result.captureGroup is PhaseSuccessCaptureGroup)
        #expect(result.outputType == .result)
        #expect(result.formatted == "\u{001B}[32;1mBuild Succeeded\u{001B}[0m")
        #expect(beautifier.format(line: input) == result.formatted)
    }

    @Test func processKeepsCaptureGroupWhenFormattedOutputIsNil() throws {
        let beautifier = XCBeautifier(
            colored: true,
            renderer: .terminal,
            preserveUnbeautifiedLines: false,
            additionalLines: { nil }
        )

        let input = "CreateBuildDirectory /Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug"
        let result = try #require(beautifier.process(line: input))

        #expect(result.captureGroup is CreateBuildDirectoryCaptureGroup)
        #expect(result.outputType == .task)
        #expect(result.formatted == nil)
        #expect(beautifier.format(line: input) == nil)
    }
}
