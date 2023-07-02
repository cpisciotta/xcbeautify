import Foundation

struct GitHubRenderer: OutputRendering {
    private enum AnnotationType: String {
        case notice
        case warning
        case error
    }

    let colored = false

    func formatAnalyze(group: AnalyzeCaptureGroup) -> String {
        let filename = group.fileName
        let target = group.target
        return "[\(target)] Analyzing \(filename)"
    }

    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String {
        let directory = group.directory
        return "Cleaning \(directory)"
    }

    func formatCodeSign(group: CodesignCaptureGroup) -> String {
        let command = "Signing"
        let sourceFile = group.file
        return command + " " + sourceFile.lastPathComponent
    }

    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String {
        let frameworkPath = group.frameworkPath
        return "Signing \(frameworkPath)"
    }

    func formatProcessPch(group: ProcessPchCaptureGroup) -> String {
        let filename = group.file
        let target = group.buildTarget
        return "[\(target)] Processing \(filename)"
    }

    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String {
        let filePath = group.filePath
        return "Preprocessing \(filePath)"
    }

    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        return nil
    }

    func formatCompile(group: CompileFileCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target)] Compiling \(filename)"
    }

    func formatCopy(group: CopyCaptureGroup) -> String {
        let filename = group.file
        let target = group.target
        return "[\(target)] Copying \(filename)"
    }

    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String {
        let dsym = group.dsym
        let target = group.target
        return "[\(target)] Generating \(dsym)"
    }

    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String {
        return "Generating code coverage data..."
    }

    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String {
        let filePath = group.coverageReportFilePath
        return "Generated code coverage report: \(filePath)"
    }

    func formatLibtool(group: LibtoolCaptureGroup) -> String {
        let filename = group.fileName
        let target = group.target
        return "[\(target)] Building library \(filename)"
    }

    func formatTouch(group: TouchCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target)] Touching \(filename)"
    }

    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String {
        let phase = group.phase.capitalized
        return "\(phase) Succeeded"
    }

    func formatLinking(group: LinkingCaptureGroup) -> String {
        let target = group.target
#if os(Linux)
        return "[\(target)] Linking"
#else
        let filename = group.binaryFilename
        return "[\(target)] Linking \(filename)"
#endif
    }

    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String {
        let phaseName = group.phaseName
        let target = group.target
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        return "[\(target)] Running script \(strippedPhaseName)"
    }

    func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String {
        let testSuite = group.testSuiteName
        return testSuite
    }

    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let heading = "Test Suite \(testSuite) started"
        return heading
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return heading
    }

    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String {
        return line
    }

    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String {
        return line
    }

    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String {
        // TODO: Extract to shared property
        let indent = "    "
        let testCase = group.testCase
        let time = group.time
        return indent + TestStatus.pass + " " + testCase + " (\(time) seconds)"
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        let indent = "    "
        let testCase = group.testCase
        return indent + TestStatus.pending + " "  + testCase + " [PENDING]"
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        let indent = "    "
        let testCase = group.testCase
        let name = group.name
        let unitName = group.unitName
        let value = group.value
        let deviation = group.deviation

        let formattedValue: String
        if unitName == "seconds" {
            formattedValue = value
        } else {
            formattedValue = value
        }
        return indent + TestStatus.measure + " "  + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
    }

    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String {
        let indent = "    "
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return indent + TestStatus.pass + " " + testCase + " on '\(device)' (\(time) seconds)"
    }

    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String {
        let indent = "    "
        let testCase = group.testCase
        let time = group.time
        return indent + TestStatus.pass + " " + testCase + " (\(time)) seconds)"
    }

    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String {
        let plist = group.filename

        if let target = group.target {
            // Xcode 10+ output
            return "[\(target)] \("Processing") \(plist)"
        } else {
            // Xcode 9 output
            return "Processing" + " " + plist
        }
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
        return "Checking out \(package) @ \(version)"
    }

    func formatPackageStart() -> String {
        return "Resolving Package Graph"
    }

    func formatPackageEnd() -> String {
        return "Resolved source packages"
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String  {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return "\(name) - \(url) @ \(version)"
    }

    private func outputGitHubActionsLog(
        annotationType: AnnotationType,
        fileComponents: FileComponents? = nil,
        message: String
    ) -> String {
        let formattedFileComponents = fileComponents?.formatted ?? ""
        return "::\(annotationType.rawValue) \(formattedFileComponents)::\(message)"
    }

    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = colored ?
            """
            \(Symbol.error): \(reason.f.Red)
            \(line)
            \(cursor.f.Cyan)
            """
            :
            """
            \(Symbol.asciiError): \(reason)
            \(line)
            \(cursor)
            """

        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let fileComponents = filePath.asFileComponents()
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = colored ?
            """
            \(Symbol.warning): \(reason.f.Yellow)
            \(line)
            \(cursor.f.Green)
            """
            :
            """
            \(Symbol.asciiWarning): \(reason)
            \(line)
            \(cursor)
            """

        return outputGitHubActionsLog(
            annotationType: .warning,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatCompleteError(line: String) -> String {
        return outputGitHubActionsLog(
            annotationType: .error,
            message: colored ? Symbol.error + " " + line.f.Red : Symbol.asciiError + " " + line
        )
    }

    func formatCompleteWarning(line: String) -> String {
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: colored ? Symbol.warning + " " + line.f.Yellow : Symbol.asciiWarning + " " + line
        )
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: colored ? Symbol.warning + " " + message.f.Yellow : Symbol.asciiWarning + " " + message
        )
    }

    func formatError(group: ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        return outputGitHubActionsLog(
            annotationType: .error,
            message: colored ? Symbol.error + " " + errorMessage.f.Red : Symbol.asciiError + " " + errorMessage
        )
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let indent = "    "
        let file = group.file
        let fileComponents = file.asFileComponents()
        let testCase = group.testCase
        let failingReason = group.reason
        let message = colored ? indent + TestStatus.fail.foreground.Red + " "  + testCase + ", " + failingReason : indent + TestStatus.fail + " "  + testCase + ", " + failingReason
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
        let message = colored ? "\(Symbol.error): \(reason.f.Red)" : "\(Symbol.asciiError): \(reason)"
        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let warningMessage = group.warningMessage
        let message = colored ? "\(Symbol.warning) \(prefix.f.Yellow)\(warningMessage.f.Yellow)" : "\(Symbol.asciiWarning) \(prefix)\(warningMessage)"
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        let message = colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
        return outputGitHubActionsLog(annotationType: .error, message: message)
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        let message = colored ? "\(Symbol.error) \(reason.f.Red)" : "\(Symbol.asciiError) \(reason)"
        return outputGitHubActionsLog(annotationType: .error, message: message)
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        let message = colored ? "    \(TestStatus.fail.f.Red) \(testCase) on '\(device)' (\(time.coloredTime(colored: colored)) seconds)" : "    \(TestStatus.fail) \(testCase) on '\(device)' (\(time) seconds)"
        return outputGitHubActionsLog(
            annotationType: .error,
            message: message
        )
    }

    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String {
        let message = colored ? line.s.Bold.f.Red : line
        return outputGitHubActionsLog(
            annotationType: .error,
            message: message
        )
    }

    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String {
        let indent = "    "
        let message = colored ? indent + TestStatus.fail.foreground.Red + " "  + line : indent + TestStatus.fail + " "  + line
        return outputGitHubActionsLog(
            annotationType: .error,
            message: message
        )
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let indent = "    "
        let file = group.file
        let fileComponents = file.asFileComponents()
        let failingReason = group.reason
        let message = colored ? indent + TestStatus.fail.foreground.Red + ": " + failingReason : indent + TestStatus.fail + ": " + failingReason
        return outputGitHubActionsLog(
            annotationType: .error,
            fileComponents: fileComponents,
            message: message
        )
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        let message = colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        let message = colored ? Symbol.warning + " " + warningMessage.f.Yellow : Symbol.asciiWarning + " " + warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func format(testSummary: TestSummary) -> String {
        if testSummary.isSuccess() {
            let message = "Tests Passed: \(testSummary.description)"
            return outputGitHubActionsLog(annotationType: .notice, message: message)
        } else {
            let message = "Tests Failed: \(testSummary.description)"
            return outputGitHubActionsLog(annotationType: .error, message: message)
        }
    }
}

extension GitHubRenderer {
    func formatTestSummary(isSuccess: Bool, description: String) -> String {
        if isSuccess {
            return outputGitHubActionsLog(
                annotationType: .notice,
                message: colored ? "Tests Passed: \(description)".s.Bold.f.Green : "Tests Passed: \(description)"
            )
        } else {
            return outputGitHubActionsLog(
                annotationType: .error,
                message: colored ? "Tests Failed: \(description)".s.Bold.f.Red : "Tests Failed: \(description)"
            )
        }
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
        let _components = self.split(separator: ":").map(String.init)
        assert((1...3).contains(_components.count))

        guard let path = _components[safe: 0] else {
            return FileComponents(path: self, line: nil, column: nil)
        }

        let components = _components.dropFirst().compactMap(Int.init)
        assert((0...2).contains(components.count))

        return FileComponents(path: path, line: components[safe: 0], column: components[safe: 1])
    }

}
