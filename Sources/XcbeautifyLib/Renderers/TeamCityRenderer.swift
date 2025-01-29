import Colorizer
import Foundation

struct TeamCityRenderer: OutputRendering {
    let colored: Bool
    let additionalLines: () -> String?

    init(colored: Bool, additionalLines: @escaping () -> String?) {
        self.colored = colored
        self.additionalLines = additionalLines
    }

    private func outputTeamCityInfo(text: String, details: String) -> String {
        """
        ##teamcity[message text='\(text)' errorDetails='\(details.teamCityEscaped())' status='INFO']
        \(text)
        """
    }

    private func outputTeamCityProblem(text: String, filePath: String) -> String {
        """
        ##teamcity[buildProblem description='\(filePath)']
        \(text)
        """
    }

    private func outputTeamCityError(text: String, details: String) -> String {
        """
        ##teamcity[message text='\(text)' errorDetails='\(details.teamCityEscaped())' status='ERROR']
        \(text)
        """
    }

    private func outputTeamCityWarning(text: String, details: String) -> String {
        """
        ##teamcity[message text='\([text, details.teamCityEscaped()].joined(separator: "|n"))' status='WARNING']
        \(text)
        """
    }

    func formatError(group: any ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        let outputString = colored ? Symbol.error + " " + errorMessage.f.Red : Symbol.asciiError + " " + errorMessage

        return outputTeamCityError(text: "Build error", details: outputString)
    }

    func formatCompileError(group: CompileErrorCaptureGroup) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        let outputString = colored ?
            """
            \(Symbol.error) \(filePath): \(reason.f.Red)
            \(line)
            \(cursor.f.Cyan)
            """
            :
            """
            \(Symbol.asciiError) \(filePath): \(reason)
            \(line)
            \(cursor)
            """

        return outputTeamCityProblem(text: outputString, filePath: filePath)
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        return outputTeamCityError(
            text: "File missing error",
            details: colored ? "\(Symbol.error) \(filePath): \(reason.f.Red)" : "\(Symbol.asciiError) \(filePath): \(reason)"
        )
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return outputTeamCityWarning(
            text: "Xcodebuild warning",
            details: colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
        )
    }

    func formatUndefinedSymbolLocation(group: UndefinedSymbolLocationCaptureGroup) -> String {
        outputTeamCityWarning(
            text: "Undefined symbol location",
            details: colored ? Symbol.warning + " " + group.wholeWarning.f.Yellow : Symbol.asciiWarning + " " + group.wholeWarning
        )
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        let outputString = colored ?
            """
            \(Symbol.warning)  \(filePath): \(reason.f.Yellow)
            \(line)
            \(cursor.f.Green)
            """
            :
            """
            \(Symbol.asciiWarning)  \(filePath): \(reason)
            \(line)
            \(cursor)
            """

        return outputTeamCityWarning(text: "Compile warning", details: outputString)
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let message = group.warningMessage
        return outputTeamCityWarning(
            text: "Linker warning",
            details: colored ? "\(Symbol.warning) \(prefix.f.Yellow)\(message.f.Yellow)" : "\(Symbol.asciiWarning) \(prefix)\(message)"
        )
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return outputTeamCityWarning(
            text: "Linker error. Undefined symbols error",
            details: colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
        )
    }

    // TODO: Print file path
    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return outputTeamCityError(
            text: "Linker error. Duplicated symbols",
            details: colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
        )
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return outputTeamCityWarning(
            text: "Codesign error",
            details: colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
        )
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputTeamCityWarning(
            text: "Duplicated localized string key",
            details: colored ? Symbol.warning + " " + message.f.Yellow : Symbol.asciiWarning + " " + message
        )
    }

    func formatSwiftTestingRunCompletion(group: SwiftTestingRunCompletionCaptureGroup) -> String {
        let outputString = "Test run with \(group.numberOfTests) tests passed after \(group.totalTime) seconds"
        return outputTeamCityInfo(text: "Test run succeeded", details: outputString)
    }

    func formatSwiftTestingRunFailed(group: SwiftTestingRunFailedCaptureGroup) -> String {
        let outputString = "\(group.numberOfTests) tests failed after \(group.totalTime) seconds with \(group.numberOfIssues) issue(s)"
        return outputTeamCityError(text: "Test run failed", details: outputString)
    }

    func formatSwiftTestingSuiteFailed(group: SwiftTestingSuiteFailedCaptureGroup) -> String {
        let outputString = "\(group.suiteName) failed after \(group.timeTaken) seconds with \(group.numberOfIssues) issue(s)"
        return outputTeamCityError(text: "Suite failed", details: outputString)
    }

    func formatSwiftTestingTestFailed(group: SwiftTestingTestFailedCaptureGroup) -> String {
        let message = "\(group.testName) (\(group.timeTaken) seconds) \(group.numberOfIssues) issue(s)"
        let outputString = colored ? message.f.Red : message
        return outputTeamCityError(text: "Test failed", details: outputString)
    }

    func formatSwiftTestingTestSkipped(group: SwiftTestingTestSkippedCaptureGroup) -> String {
        let testName = colored ? group.testName.f.Yellow : group.testName
        return outputTeamCityWarning(text: "Test skipped", details: testName)
    }

    func formatSwiftTestingTestSkippedReason(group: SwiftTestingTestSkippedReasonCaptureGroup) -> String {
        let testName = colored ? group.testName.f.Yellow : group.testName
        let reason = group.reason.map { " (\($0))" } ?? ""
        let outputString = "\(testName)\(reason)"
        return outputTeamCityWarning(text: "Test skipped", details: outputString)
    }

    func formatSwiftTestingIssue(group: SwiftTestingIssueCaptureGroup) -> String {
        let issueDetails = group.issueDetails.map { "(\($0))" } ?? ""
        return outputTeamCityWarning(text: "Recorded an issue", details: issueDetails)
    }

    func formatSwiftTestingIssueArguments(group: SwiftTestingIssueArgumentCaptureGroup) -> String {
        let arguments = group.numberOfArguments.map { "(\($0) argument(s))" } ?? ""
        return outputTeamCityWarning(text: "Recorded an issue", details: arguments)
    }
}

private extension String {
    func teamCityEscaped() -> String {
        // According to the documentation: https://www.jetbrains.com/help/teamcity/service-messages.html#Escaped+Values
        replacingOccurrences(of: "|", with: "||")
            .replacingOccurrences(of: "'", with: "|'")
            .replacingOccurrences(of: "\n", with: "|n")
            .replacingOccurrences(of: "\r", with: "|r")
            .replacingOccurrences(of: "\\u{", with: "|u{") // Assuming the unicode format in Swift is \\u{NNNN}
            .replacingOccurrences(of: "[", with: "|[")
            .replacingOccurrences(of: "]", with: "|]")
    }
}
