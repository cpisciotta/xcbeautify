import Foundation
import Colorizer

struct TerminalRenderer: OutputRendering {
    let colored: Bool

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let testCase = group.testCase
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + testCase + ", " + failingReason : Format.indent + TestStatus.fail + " "  + testCase + ", " + failingReason
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let file = group.file
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + file + ", " + failingReason : Format.indent + TestStatus.fail + " "  + file + ", " + failingReason
    }

    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String {
        return colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + line : Format.indent + TestStatus.fail + " "  + line
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        let testCase = group.testCase
        return colored ? Format.indent + TestStatus.pending.foreground.Yellow + " "  + testCase + " [PENDING]" : Format.indent + TestStatus.pending + " "  + testCase + " [PENDING]"
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        let testCase = group.testCase
        let name = group.name
        let unitName = group.unitName
        let value = group.value

        let deviation = colored ? group.deviation.coloredDeviation() : group.deviation
        let formattedValue = colored && unitName == "seconds" ? value.coloredTime() : value

        return Format.indent + (colored ? TestStatus.measure.foreground.Yellow : TestStatus.measure) + " "  + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
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
        return colored ? Symbol.error + " " + errorMessage.f.Red : Symbol.asciiError + " " + errorMessage
    }

    func formatCompleteError(line: String) -> String {
        return colored ? Symbol.error + " " + line.f.Red : Symbol.asciiError + " " + line
    }

    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
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
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        return colored ? "\(Symbol.error) \(filePath): \(reason.f.Red)" : "\(Symbol.asciiError) \(filePath): \(reason)"
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
    }

    func formatCompleteWarning(line: String) -> String {
        return colored ? Symbol.warning + " " + line.f.Yellow : Symbol.asciiWarning + " " + line
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
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
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let message = group.warningMessage
        return colored ? "\(Symbol.warning) \(prefix.f.Yellow)\(message.f.Yellow)" : "\(Symbol.asciiWarning) \(prefix)\(message)"
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
    }
    
    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String? {
        let wholeError = group.wholeError
        return (colored ? "\(Symbol.error) \(Format.indent)\(wholeError.f.Red)" : "\(Symbol.asciiError) \(Format.indent)\(wholeError)")
    }
    
    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        let symbolLocation = group.symbolLocation
        return colored ? "\(Symbol.error) \(symbolLocation.f.Red)" : "\(Symbol.asciiError) \(symbolLocation)"
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
    }

    func formatSummary(line: String) -> String {
        return colored ? line.f.Green.s.Bold : line
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
        return colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    func formatPackageEnd() -> String {
        return colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return colored ? Symbol.warning + " " + message.f.Yellow : Symbol.asciiWarning + " " + message
    }

    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String {
        return colored ? line.s.Bold.f.Red : line
    }

    func format(testSummary: TestSummary) -> String {
        if testSummary.isSuccess() {
            return colored ? "Tests Passed: \(testSummary.description)".s.Bold.f.Green : "Tests Passed: \(testSummary.description)"
        } else {
            return colored ? "Tests Failed: \(testSummary.description)".s.Bold.f.Red : "Tests Failed: \(testSummary.description)"
        }
    }
}
