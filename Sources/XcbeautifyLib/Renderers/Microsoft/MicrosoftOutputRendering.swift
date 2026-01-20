//
// MicrosoftOutputRendering.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import XcLogParserLib

struct Annotation {
    struct Platforms: OptionSet {
        let rawValue: Int

        static let githubAction = Platforms(rawValue: 1 << 0)
        static let azureDevOps = Platforms(rawValue: 1 << 1)

        static let all: Platforms = [.githubAction, .azureDevOps]
    }

    let value: String
    let platforms: Platforms

    static let warning = Annotation(value: "warning", platforms: [.githubAction, .azureDevOps])

    static let error = Annotation(value: "error", platforms: [.githubAction, .azureDevOps])

    static let notice = Annotation(value: "notice", platforms: .githubAction)
}

protocol MicrosoftOutputRendering: OutputRendering {
    func makeOutputLog(annotation: Annotation, fileComponents: FileComponents?, message: String) -> String
}

extension MicrosoftOutputRendering {
    func makeOutputLog(annotation: Annotation, message: String) -> String {
        makeOutputLog(annotation: annotation, fileComponents: nil, message: message)
    }

    func formatCompileError(group: CompileErrorCaptureGroup) -> String {
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = """
        \(reason)
        \(line)
        \(cursor)
        """

        return makeOutputLog(
            annotation: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup) -> String {
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = """
        \(reason)
        \(line)
        \(cursor)
        """

        return makeOutputLog(
            annotation: .warning,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String {
        makeOutputLog(annotation: .error, message: group.wholeError)
    }

    func formatUndefinedSymbolLocation(group: UndefinedSymbolLocationCaptureGroup) -> String {
        makeOutputLog(annotation: .warning, message: group.wholeWarning)
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return makeOutputLog(
            annotation: .warning,
            message: message
        )
    }

    func formatError(group: any ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        return makeOutputLog(
            annotation: .error,
            message: errorMessage
        )
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let file = group.file
        let fileComponents = file.asFileComponents()
        let testCase = group.testCase
        let failingReason = group.reason
        let message = Format.indent + testCase + ", " + failingReason
        return makeOutputLog(
            annotation: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        return makeOutputLog(
            annotation: .error,
            fileComponents: fileComponents,
            message: reason
        )
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let warningMessage = group.warningMessage
        return makeOutputLog(
            annotation: .warning,
            fileComponents: nil,
            message: "\(prefix)\(warningMessage)"
        )
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return makeOutputLog(annotation: .error, message: reason)
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return makeOutputLog(annotation: .error, message: reason)
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        let message = "    \(testCase) on '\(device)' (\(time) seconds)"
        return makeOutputLog(
            annotation: .error,
            message: message
        )
    }

    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String {
        makeOutputLog(
            annotation: .error,
            message: group.wholeError
        )
    }

    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String {
        let message = Format.indent + group.wholeMessage
        return makeOutputLog(
            annotation: .error,
            message: message
        )
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let file = group.file
        let fileComponents = file.asFileComponents()
        let failingReason = group.reason
        let message = Format.indent + failingReason
        return makeOutputLog(
            annotation: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return makeOutputLog(
            annotation: .warning,
            message: warningMessage
        )
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return makeOutputLog(
            annotation: .warning,
            message: warningMessage
        )
    }

    func formatSwiftTestingRunFailed(group: SwiftTestingRunFailedCaptureGroup) -> String {
        let errorMessage = "Test run with \(group.numberOfTests) tests failed after \(group.totalTime) seconds with \(group.numberOfIssues) issue(s)"
        return makeOutputLog(
            annotation: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingSuiteFailed(group: SwiftTestingSuiteFailedCaptureGroup) -> String {
        let errorMessage = "Suite \(group.suiteName) failed after \(group.timeTaken) seconds with \(group.numberOfIssues) issue(s)"
        return makeOutputLog(
            annotation: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingTestFailed(group: SwiftTestingTestFailedCaptureGroup) -> String {
        let errorMessage = "\(group.testName) (\(group.timeTaken) seconds) \(group.numberOfIssues) issue(s)"
        return makeOutputLog(
            annotation: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingIssue(group: SwiftTestingIssueCaptureGroup) -> String {
        var fileComponents: FileComponents?
        var detailMessage = group.issueDetails?.trimmingCharacters(in: .whitespacesAndNewlines)

        if let issueDetails = detailMessage, !issueDetails.isEmpty {
            let locationAndMessage = issueDetails.split(separator: ": ", maxSplits: 1, omittingEmptySubsequences: false)
            if let locationPart = locationAndMessage.first {
                let locationSegments = locationPart.split(separator: ":").map(String.init)
                if let path = locationSegments.first, !path.isEmpty {
                    let line = locationSegments.count > 1 ? Int(locationSegments[1]) : nil
                    let column = locationSegments.count > 2 ? Int(locationSegments[2]) : nil
                    fileComponents = FileComponents(path: path, line: line, column: column)
                    if locationAndMessage.count > 1 {
                        detailMessage = String(locationAndMessage[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                    } else {
                        detailMessage = nil
                    }
                }
            }
        }

        let message =
            if let detailMessage, !detailMessage.isEmpty {
                "Recorded an issue (\(detailMessage))"
            } else {
                "Recorded an issue"
            }
        return makeOutputLog(
            annotation: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatSwiftTestingIssueArguments(group: SwiftTestingIssueArgumentCaptureGroup) -> String {
        let message = "Recorded an issue" + (group.numberOfArguments.map { " (\($0)) argument(s)" } ?? "")
        return makeOutputLog(
            annotation: .error,
            message: message
        )
    }
}
