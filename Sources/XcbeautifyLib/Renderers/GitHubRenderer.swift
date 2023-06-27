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

    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String {
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

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return "    \(TestStatus.fail) \(testCase) on '\(device)' (\(time) seconds)"
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
        file: String? = nil,
        line: Int? = nil,
        column: Int? = nil,
        message: String
    ) -> String {
        guard let file else {
            return "::\(annotationType.rawValue) ::\(message)"
        }

        guard let line else {
            return "::\(annotationType) file=\(file)::\(message)"
        }

        guard let column else {
            return "::\(annotationType) file=\(file),line=\(line)::\(message)"
        }

        return "::\(annotationType) file=\(file),line=\(line),col=\(column)::\(message)"
    }

    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = """
            \(colored ? reason.f.Red : reason)
            \(line)
            \(colored ? cursor.f.Cyan : cursor)
        """

        return outputGitHubActionsLog(
            annotationType: .error,
            file: filePath,
            line: nil,
            column: nil,
            message: message
        )
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""

        let message = """
            \(colored ? reason.f.Yellow : reason)
            \(line)
            \(colored ? cursor.f.Green : cursor)
        """

        return outputGitHubActionsLog(
            annotationType: .warning,
            file: filePath,
            line: nil,
            column: nil,
            message: message
        )
    }

    func formatCompleteError(line: String) -> String {
        return outputGitHubActionsLog(
            annotationType: .error,
            message: colored ? line.f.Red : line
        )
    }

    func formatCompleteWarning(line: String) -> String {
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: colored ? line.f.Red : line
        )
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: colored ? message.f.Yellow : message
        )
    }

    func formatError(group: ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        return outputGitHubActionsLog(
            annotationType: .error,
            message: colored ? errorMessage.f.Red : errorMessage
        )
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let indent = "    "
        let file = group.file
        let testCase = group.testCase
        let failingReason = group.reason
        return outputGitHubActionsLog(
            annotationType: .error,
            file: file,
            line: nil,
            message: indent + testCase + ", " + failingReason
        )
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        let message = colored ? reason.f.Red : reason
        return outputGitHubActionsLog(
            annotationType: .error,
            file: filePath,
            line: nil,
            message: message
        )
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let warningMessage = group.warningMessage
        let message = colored ? "\(prefix.f.Yellow)\(warningMessage.f.Yellow)" : "\(prefix)\(warningMessage)"
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        let message = colored ? reason.f.Red : reason
        return outputGitHubActionsLog(annotationType: .error, message: message)
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        let message = colored ? reason.f.Red : reason
        return outputGitHubActionsLog(annotationType: .error, message: message)
    }

    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String {
        let indent = "    "
        let message = indent + line
        return outputGitHubActionsLog(
            annotationType: .error,
            file: nil,
            line: nil,
            message: message
        )
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let indent = "    "
        let file = group.file
        let failingReason = group.reason
        let message = indent + file + ", " + failingReason
        return outputGitHubActionsLog(
            annotationType: .error,
            file: file,
            line: nil,
            message: message
        )
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        let message = colored ? warningMessage.f.Yellow : warningMessage
        return outputGitHubActionsLog(
            annotationType: .warning,
            message: message
        )
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        let message = colored ? warningMessage.f.Yellow : warningMessage
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
