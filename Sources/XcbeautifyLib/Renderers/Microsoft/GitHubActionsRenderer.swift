//
// GitHubActionsRenderer.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import XcLogParserLib

struct GitHubActionsRenderer: MicrosoftOutputRendering {
    let colored: Bool
    let additionalLines: () -> String?

    init(colored: Bool, additionalLines: @escaping () -> String?) {
        self.colored = colored
        self.additionalLines = additionalLines
    }

    func makeOutputLog(
        annotation: Annotation,
        fileComponents: FileComponents? = nil,
        message: String
    ) -> String {
        assert(annotation.platforms.contains(.githubAction))
        let formattedFileComponents = fileComponents?.formatted ?? ""
        return "::\(annotation.value) \(formattedFileComponents)::\(message)"
    }

    func formatParallelTestCaseSkipped(group: ParallelTestCaseSkippedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        let message = Format.indent + testCase + " on '\(device)' (\(time) seconds)"
        return makeOutputLog(
            annotation: .notice,
            message: message
        )
    }

    func formatTestCaseSkipped(group: TestCaseSkippedCaptureGroup) -> String {
        let testSuite = group.suite
        let testCase = group.testCase
        let message = "Skipped \(testSuite).\(testCase)"
        return makeOutputLog(
            annotation: .notice,
            message: message
        )
    }

    func formatSwiftTestingRunCompletion(group: SwiftTestingRunCompletionCaptureGroup) -> String {
        let outputString = "Test run with \(group.numberOfTests) tests passed after \(group.totalTime) seconds"
        return makeOutputLog(annotation: .notice, message: outputString)
    }

    func formatSwiftTestingTestSkipped(group: SwiftTestingTestSkippedCaptureGroup) -> String {
        let message = "Skipped \(group.testName)"
        return makeOutputLog(
            annotation: .notice,
            message: message
        )
    }

    func formatSwiftTestingTestSkippedReason(group: SwiftTestingTestSkippedReasonCaptureGroup) -> String {
        let message = "Skipped \(group.testName)" + (group.reason.map { ".(\($0))" } ?? "")
        return makeOutputLog(
            annotation: .notice,
            message: message
        )
    }
}

private extension FileComponents {
    var formatted: String {
        guard let line else {
            return "file=\(path)"
        }

        guard let column else {
            return "file=\(path),line=\(line)"
        }

        return "file=\(path),line=\(line),col=\(column)"
    }
}
