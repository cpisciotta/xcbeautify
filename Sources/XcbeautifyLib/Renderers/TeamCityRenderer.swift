import Colorizer
import Foundation

struct TeamCityRenderer: OutputRendering {
    private enum ProblemLevel: String {
        case FAILURE
        case WARNING
    }

    let colored: Bool

    private func outputTeamCityProblem(text: String, filePath: String) -> String {
        """
        ##teamcity[buildProblem description='\(filePath)']
        \(text)
        """
    }

    func outputTeamCityError(text: String, details: String) -> String {
        formatTeamCityServiceMessage(text: text, details: details, level: .FAILURE)
    }

    func outputTeamCityWarning(text: String, details: String) -> String {
        formatTeamCityServiceMessage(text: text, details: details, level: .WARNING)
    }

    private func formatTeamCityServiceMessage(text: String, details: String, level: ProblemLevel) -> String {
        """
        ##teamcity[message text='\(text)' errorDetails='\(details.teamCityEscaped())' status='\(level.rawValue)']
        \(text)
        """
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let testCase = group.testCase
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.foreground.Red + " " + testCase + ", " + failingReason : Format.indent + TestStatus.fail + " " + testCase + ", " + failingReason
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let file = group.file
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.foreground.Red + " " + file + ", " + failingReason : Format.indent + TestStatus.fail + " " + file + ", " + failingReason
    }

    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String {
        colored ? Format.indent + TestStatus.fail.foreground.Red + " " + group.wholeMessage : Format.indent + TestStatus.fail + " " + group.wholeMessage
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        let testCase = group.testCase
        return colored ? Format.indent + TestStatus.pending.foreground.Yellow + " " + testCase + " [PENDING]" : Format.indent + TestStatus.pending + " " + testCase + " [PENDING]"
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        let testCase = group.testCase
        let name = group.name
        let unitName = group.unitName
        let value = group.value

        let deviation = colored ? group.deviation.coloredDeviation() : group.deviation
        let formattedValue = colored && unitName == "seconds" ? value.coloredTime() : value

        return Format.indent + (colored ? TestStatus.measure.foreground.Yellow : TestStatus.measure) + " " + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
    }

    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String {
        let testCase = group.testCase
        let time = group.time
        return colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " (\(time) seconds)"
    }

    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " on '\(device)' (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " on '\(device)' (\(time) seconds)"
    }

    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String {
        let testCase = group.testCase
        let time = group.time
        return colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " (\(time)) seconds)"
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return colored ? "    \(TestStatus.fail.f.Red) \(testCase) on '\(device)' (\(time.coloredTime()) seconds)" : "    \(TestStatus.fail) \(testCase) on '\(device)' (\(time) seconds)"
    }

    func formatError(group: ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        let outputString = colored ? Symbol.error + " " + errorMessage.f.Red : Symbol.asciiError + " " + errorMessage

        return outputTeamCityError(text: "Build error", details: outputString)
    }

    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String {
        colored ? Symbol.error + " " + group.wholeError.f.Red : Symbol.asciiError + " " + group.wholeError
    }

    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
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

    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
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
        colored ? line.f.Green.s.Bold : line
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        let source = group.source
        return "Fetching " + source
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        let source = group.source
        return "Updating " + source
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        let version = group.version
        let package = group.package
        return colored ? "Checking out " + package.s.Bold + " @ " + version.f.Green : "Checking out \(package) @ \(version)"
    }

    func formatPackageStart() -> String {
        colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    func formatPackageEnd() -> String {
        colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputTeamCityWarning(
            text: "Duplicated localized string key",
            details: colored ? Symbol.warning + " " + message.f.Yellow : Symbol.asciiWarning + " " + message
        )
    }

    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String {
        colored ? group.wholeError.s.Bold.f.Red : group.wholeError
    }

    func format(testSummary: TestSummary) -> String {
        if testSummary.isSuccess() {
            colored ? "Tests Passed: \(testSummary.description)".s.Bold.f.Green : "Tests Passed: \(testSummary.description)"
        } else {
            colored ? "Tests Failed: \(testSummary.description)".s.Bold.f.Red : "Tests Failed: \(testSummary.description)"
        }
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
