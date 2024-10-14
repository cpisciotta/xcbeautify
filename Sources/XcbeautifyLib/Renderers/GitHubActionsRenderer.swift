import Foundation

struct GitHubActionsRenderer: OutputRendering {
    private enum AnnotationType: String {
        case notice
        case warning
        case error
    }

    let colored: Bool
    let additionalLines: () -> String?

    init(colored: Bool, additionalLines: @escaping () -> String?) {
        self.colored = colored
        self.additionalLines = additionalLines
    }

    private func outputGitHubActionsLog(
        annotationType: AnnotationType,
        fileComponents: FileComponents? = nil,
        message: String
    ) -> String {
        let formattedFileComponents = fileComponents?.formatted ?? ""
        return "::\(annotationType) \(formattedFileComponents)::\(message)"
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

        return outputGitHubActionsLog(
            annotationType: .error,
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

        return outputGitHubActionsLog(
            annotationType: .warning,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String {
        outputGitHubActionsLog(
            annotationType: .error,
            message: group.wholeError
        )
    }

    func formatUndefinedSymbolLocation(group: UndefinedSymbolLocationCaptureGroup) -> String {
        outputGitHubActionsLog(
            annotationType: .warning,
            message: group.wholeWarning
        )
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func formatError(group: any ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        return outputGitHubActionsLog(
            annotationType: .error,
            message: errorMessage
        )
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let file = group.file
        let fileComponents = file.asFileComponents()
        let testCase = group.testCase
        let failingReason = group.reason
        let message = Format.indent + testCase + ", " + failingReason
        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: reason
        )
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let warningMessage = group.warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: "\(prefix)\(warningMessage)"
        )
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return outputGitHubActionsLog(annotationType: .error, message: reason)
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return outputGitHubActionsLog(annotationType: .error, message: reason)
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        let message = "    \(testCase) on '\(device)' (\(time) seconds)"
        return outputGitHubActionsLog(
            annotationType: .error,
            message: message
        )
    }

    func formatParallelTestCaseSkipped(group: ParallelTestCaseSkippedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        let message = Format.indent + testCase + " on '\(device)' (\(time) seconds)"
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }

    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String {
        outputGitHubActionsLog(
            annotationType: .error,
            message: group.wholeError
        )
    }

    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String {
        let message = Format.indent + group.wholeMessage
        return outputGitHubActionsLog(
            annotationType: .error,
            message: message
        )
    }

    func formatTestCaseSkipped(group: TestCaseSkippedCaptureGroup) -> String {
        let testSuite = group.suite
        let testCase = group.testCase
        let message = "Skipped \(testSuite).\(testCase)"
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let file = group.file
        let fileComponents = file.asFileComponents()
        let failingReason = group.reason
        let message = Format.indent + failingReason
        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: warningMessage
        )
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: warningMessage
        )
    }

    func formatSwiftTestingRunCompletion(group: SwiftTestingRunCompletionCaptureGroup) -> String {
        let outputString = "Test run with \(group.numberOfTests) tests passed after \(group.totalTime) seconds"
        return outputGitHubActionsLog(annotationType: .notice, message: outputString)
    }

    func formatSwiftTestingRunFailed(group: SwiftTestingRunFailedCaptureGroup) -> String {
        let errorMessage = "Test run with \(group.numberOfTests) tests failed after \(group.totalTime) seconds with \(group.numberOfIssues) issue(s)"
        return outputGitHubActionsLog(
            annotationType: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingSuiteFailed(group: SwiftTestingSuiteFailedCaptureGroup) -> String {
        let errorMessage = "Suite \(group.suiteName) failed after \(group.timeTaken) seconds with \(group.numberOfIssues) issue(s)"
        return outputGitHubActionsLog(
            annotationType: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingTestFailed(group: SwiftTestingTestFailedCaptureGroup) -> String {
        let errorMessage = "\(group.testName) (\(group.timeTaken) seconds) \(group.numberOfIssues) issue(s)"
        return outputGitHubActionsLog(
            annotationType: .error,
            message: errorMessage
        )
    }

    func formatSwiftTestingTestSkipped(group: SwiftTestingTestSkippedCaptureGroup) -> String {
        let message = "Skipped \(group.testName)"
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }

    func formatSwiftTestingTestSkippedReason(group: SwiftTestingTestSkippedReasonCaptureGroup) -> String {
        let message = "Skipped \(group.testName)" + (group.reason.map { ".(\($0))" } ?? "")
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }

    func formatSwiftTestingIssue(group: SwiftTestingIssueCaptureGroup) -> String {
        let message = "Recorded an issue" + (group.issueDetails.map { " (\($0))" } ?? "")
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }

    func formatSwiftTestingIssueArguments(group: SwiftTestingIssueArgumentCaptureGroup) -> String {
        let message = "Recorded an issue" + (group.numberOfArguments.map { " (\($0)) argument(s)" } ?? "")
        return outputGitHubActionsLog(
            annotationType: .notice,
            message: message
        )
    }
}

private struct FileComponents {
    private let path: String
    private let line: Int?
    private let column: Int?

    init(path: String, line: Int?, column: Int?) {
        self.path = path
        self.line = line
        self.column = column
    }

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

private extension String {
    func asFileComponents() -> FileComponents {
        let _components = split(separator: ":").map(String.init)
        assert((1...3).contains(_components.count))

        guard let path = _components[safe: 0] else {
            return FileComponents(path: self, line: nil, column: nil)
        }

        let components = _components.dropFirst().compactMap(Int.init)
        assert((0...2).contains(components.count))

        return FileComponents(path: path, line: components[safe: 0], column: components[safe: 1])
    }
}
