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

    // MARK: - Skip Formatting

    @Test func skippedCaptureGroupReturnsRawLineWithOriginalOutputType() throws {
        let beautifier = XCBeautifier(
            colored: false,
            renderer: .azureDevOpsPipelines,
            preserveUnbeautifiedLines: false,
            skippedCaptureGroups: ["fatal-error"],
            additionalLines: { nil }
        )

        let input = "fatal error: something went wrong"
        let result = try #require(beautifier.process(line: input))

        #expect(result.captureGroup is FatalErrorCaptureGroup)
        #expect(result.outputType == .error)
        #expect(result.formatted == input)
    }

    @Test func skippedCaptureGroupDoesNotEmitAnnotation() throws {
        let beautifier = XCBeautifier(
            colored: false,
            renderer: .azureDevOpsPipelines,
            preserveUnbeautifiedLines: false,
            skippedCaptureGroups: ["fatal-error"],
            additionalLines: { nil }
        )

        let input = "fatal error: something went wrong"
        let result = try #require(beautifier.process(line: input))

        #expect(result.formatted?.hasPrefix("##vso[") != true)
    }

    @Test func nonSkippedCaptureGroupFormatsNormally() throws {
        let beautifier = XCBeautifier(
            colored: false,
            renderer: .azureDevOpsPipelines,
            preserveUnbeautifiedLines: false,
            skippedCaptureGroups: ["fatal-error"],
            additionalLines: { nil }
        )

        let input = "fatal error: something went wrong"
        let skippedResult = try #require(beautifier.process(line: input))
        #expect(skippedResult.outputType == .error)
        #expect(skippedResult.formatted == input)

        let otherInput = "xcodebuild: error: something else failed"
        let normalResult = try #require(beautifier.process(line: otherInput))
        #expect(normalResult.outputType == .error)
        #expect(normalResult.formatted?.hasPrefix("##vso[task.logissue type=error]") == true)
    }

    @Test func skippedFatalErrorWithFilePathReturnsRawLine() throws {
        let beautifier = XCBeautifier(
            colored: false,
            renderer: .gitHubActions,
            preserveUnbeautifiedLines: false,
            skippedCaptureGroups: ["fatal-error-with-file-path"],
            additionalLines: { nil }
        )

        let input = "Target/File.swift:193: Fatal error: Assertion failed"
        let result = try #require(beautifier.process(line: input))

        #expect(result.captureGroup is FatalErrorWithFilePathCaptureGroup)
        #expect(result.outputType == .error)
        #expect(result.formatted == input)
        #expect(result.formatted?.hasPrefix("::error") != true)
    }

    @Test func emptySkippedSetFormatsNormally() throws {
        let beautifier = XCBeautifier(
            colored: false,
            renderer: .azureDevOpsPipelines,
            preserveUnbeautifiedLines: false,
            skippedCaptureGroups: [],
            additionalLines: { nil }
        )

        let input = "fatal error: something went wrong"
        let result = try #require(beautifier.process(line: input))

        #expect(result.outputType == .error)
        #expect(result.formatted?.hasPrefix("##vso[task.logissue type=error]") == true)
    }
}
