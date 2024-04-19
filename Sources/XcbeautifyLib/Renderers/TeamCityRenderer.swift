import Colorizer
import Foundation

struct TeamCityRenderer: OutputRendering {
    let colored: Bool
    let additionalLines: () -> String?
    let terminalRenderer: TerminalRenderer

    init(colored: Bool, additionalLines: @escaping () -> String?) {
        self.colored = colored
        self.additionalLines = additionalLines
        self.terminalRenderer = TerminalRenderer(colored: colored, additionalLines: additionalLines)
    }

    private func outputTeamCityProblem(text: String, filePath: String) -> String {
        """
        ##teamcity[buildProblem description='\(filePath)']
        \(text)
        """
    }

    func outputTeamCityError(text: String, details: String) -> String {
        """
        ##teamcity[message text='\(text)' errorDetails='\(details.teamCityEscaped())' status='ERROR']
        \(text)
        """
    }

    func outputTeamCityWarning(text: String, details: String) -> String {
        """
        ##teamcity[message text='\([text, details.teamCityEscaped()].joined(separator: "|n"))' status='WARNING']
        \(text)
        """
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        return self.terminalRenderer.formatFailingTest(group: group)
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        return self.terminalRenderer.formatUIFailingTest(group: group)
    }

    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String {
        return self.terminalRenderer.formatRestartingTest(group: group)
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        return self.terminalRenderer.formatTestCasePending(group: group)
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        return self.terminalRenderer.formatTestCaseMeasured(group: group)
    }

    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String {
        return self.terminalRenderer.formatTestCasePassed(group: group)
    }

    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String {
        return self.terminalRenderer.formatParallelTestCasePassed(group: group)
    }

    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String {
        return self.terminalRenderer.formatParallelTestCaseAppKitPassed(group: group)
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        return self.terminalRenderer.formatParallelTestCaseFailed(group: group)
    }

    func formatError(group: ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        let outputString = colored ? Symbol.error + " " + errorMessage.f.Red : Symbol.asciiError + " " + errorMessage

        return outputTeamCityError(text: "Build error", details: outputString)
    }

    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String {
        return self.terminalRenderer.formatSymbolReferencedFrom(group: group)
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

    func formatSummary(line: String) -> String {
        return self.terminalRenderer.formatSummary(line: line)
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        return self.terminalRenderer.formatPackageFetching(group: group)
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        return self.terminalRenderer.formatPackageUpdating(group: group)
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        return self.terminalRenderer.formatPackageCheckingOut(group: group)
    }

    func formatPackageStart() -> String {
        return self.terminalRenderer.formatPackageStart()
    }

    func formatPackageEnd() -> String {
        return self.terminalRenderer.formatPackageEnd()
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        return self.terminalRenderer.formatPackageItem(group: group)
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputTeamCityWarning(
            text: "Duplicated localized string key",
            details: colored ? Symbol.warning + " " + message.f.Yellow : Symbol.asciiWarning + " " + message
        )
    }

    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String {
        self.terminalRenderer.formatParallelTestingFailed(group: group)
    }

    func format(testSummary: TestSummary) -> String {
        self.terminalRenderer.format(testSummary: testSummary)
    }
    
    func formatParallelTestCaseSkipped(group: ParallelTestCaseSkippedCaptureGroup) -> String {
        self.terminalRenderer.formatParallelTestCaseSkipped(group: group)
    }
    
    func formatTestCaseSkipped(group: TestCaseSkippedCaptureGroup) -> String {
        self.terminalRenderer.formatTestCaseSkipped(group: group)
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
