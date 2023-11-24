import Foundation

public struct XCFormatter {
    private let renderer: OutputRendering
    private let colored: Bool
    private let additionalLines: () -> String?

    public init(
        renderer: Renderer,
        colored: Bool,
        additionalLines: @escaping () -> String?
    ) {
        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }
        self.colored = colored
        self.additionalLines = additionalLines
    }

    public func beautify(
        captureGroup: CaptureGroup,
        line: String
    ) -> String? {
        switch captureGroup {
        case let group as AggregateTargetCaptureGroup:
            return renderer.formatTargetCommand(command: "Aggregate", group: group)
        case let group as AnalyzeCaptureGroup:
            return renderer.formatAnalyze(group: group)
        case let group as AnalyzeTargetCaptureGroup:
            return renderer.formatTargetCommand(command: "Analyze", group: group)
        case let group as BuildTargetCaptureGroup:
            return renderer.formatTargetCommand(command: "Build", group: group)
        case _ as CheckDependenciesCaptureGroup:
            return renderer.format(line: line, command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case let group as CheckDependenciesErrorsCaptureGroup:
            return renderer.formatError(group: group)
        case let group as ClangErrorCaptureGroup:
            return renderer.formatError(group: group)
        case let group as CleanRemoveCaptureGroup:
            return renderer.formatCleanRemove(group: group)
        case let group as CleanTargetCaptureGroup:
            return renderer.formatTargetCommand(command: "Clean", group: group)
        case let group as CodesignCaptureGroup:
            return renderer.formatCodeSign(group: group)
        case let group as CodesignFrameworkCaptureGroup:
            return renderer.formatCodeSignFramework(group: group)
        case let group as CompileCaptureGroup:
            return renderer.formatCompile(group: group)
        case let group as CompileCommandCaptureGroup:
            return renderer.formatCompileCommand(group: group)
        case let group as CompileErrorCaptureGroup:
            return renderer.formatCompileError(group: group, additionalLines: additionalLines)
        case let group as CompileStoryboardCaptureGroup:
            return renderer.formatCompile(group: group)
        case let group as CompileWarningCaptureGroup:
            return renderer.formatCompileWarning(group: group, additionalLines: additionalLines)
        case let group as CompileXibCaptureGroup:
            return renderer.formatCompile(group: group)
        case let group as CopyHeaderCaptureGroup:
            return renderer.formatCopy(group: group)
        case let group as CopyPlistCaptureGroup:
            return renderer.formatCopy(group: group)
        case let group as CopyStringsCaptureGroup:
            return renderer.formatCopy(group: group)
        case let group as CpresourceCaptureGroup:
            return renderer.formatCopy(group: group)
        case let group as CursorCaptureGroup:
            return renderer.formatCursor(group: group)
        case let group as DuplicateLocalizedStringKeyCaptureGroup:
            return renderer.formatDuplicateLocalizedStringKey(group: group)
        case let group as ExecutedWithoutSkippedCaptureGroup:
            return renderer.formatExecutedWithoutSkipped(group: group)
        case let group as ExecutedWithSkippedCaptureGroup:
            return renderer.formatExecutedWithSkipped(group: group)
        case let group as FailingTestCaptureGroup:
            return renderer.formatFailingTest(group: group)
        case let group as FatalErrorCaptureGroup:
            return renderer.formatError(group: group)
        case let group as FileMissingErrorCaptureGroup:
            return renderer.formatFileMissingError(group: group)
        case let group as GenerateCoverageDataCaptureGroup:
            return renderer.formatGenerateCoverageData(group: group)
        case let group as GeneratedCoverageReportCaptureGroup:
            return renderer.formatCoverageReport(group: group)
        case let group as GenerateDSYMCaptureGroup:
            return renderer.formatGenerateDsym(group: group)
        case let group as GenericWarningCaptureGroup:
            return renderer.formatWarning(group: group)
        case let group as LDErrorCaptureGroup:
            return renderer.formatError(group: group)
        case let group as LDWarningCaptureGroup:
            return renderer.formatLdWarning(group: group)
        case let group as LibtoolCaptureGroup:
            return renderer.formatLibtool(group: group)
        case let group as LinkerDuplicateSymbolsCaptureGroup:
            return renderer.formatLinkerDuplicateSymbolsError(group: group)
        case let group as LinkerDuplicateSymbolsLocationCaptureGroup:
            return renderer.formatLinkerDuplicateSymbolsLocation(group: group)
        case let group as LinkerUndefinedSymbolLocationCaptureGroup:
            return renderer.formatLinkerUndefinedSymbolLocation(group: group)
        case let group as LinkerUndefinedSymbolsCaptureGroup:
            return renderer.formatLinkerUndefinedSymbolsError(group: group)
        case let group as LinkingCaptureGroup:
            return renderer.formatLinking(group: group)
        case let group as ModuleIncludesErrorCaptureGroup:
            return renderer.formatError(group: group)
        case let group as NoCertificateCaptureGroup:
            return renderer.formatError(group: group)
        case let group as PackageCheckingOutCaptureGroup:
            return renderer.formatPackageCheckingOut(group: group)
        case let group as PackageFetchingCaptureGroup:
            return renderer.formatPackageFetching(group: group)
        case let group as PackageGraphResolvedItemCaptureGroup:
            return renderer.formatPackageItem(group: group)
        case _ as PackageGraphResolvingEndedCaptureGroup:
            return renderer.formatPackageEnd()
        case _ as PackageGraphResolvingStartCaptureGroup:
            return renderer.formatPackageStart()
        case let group as PackageUpdatingCaptureGroup:
            return renderer.formatPackageUpdating(group: group)
        case let group as ParallelTestCaseAppKitPassedCaptureGroup:
            return renderer.formatParallelTestCaseAppKitPassed(group: group)
        case let group as ParallelTestCaseFailedCaptureGroup:
            return renderer.formatParallelTestCaseFailed(group: group)
        case let group as ParallelTestCasePassedCaptureGroup:
            return renderer.formatParallelTestCasePassed(group: group)
        case let group as ParallelTestingFailedCaptureGroup:
            return renderer.formatParallelTestingFailed(line: line, group: group)
        case let group as ParallelTestingPassedCaptureGroup:
            return renderer.formatParallelTestingPassed(line: line, group: group)
        case let group as ParallelTestingStartedCaptureGroup:
            return renderer.formatParallelTestingStarted(line: line, group: group)
        case let group as ParallelTestSuiteStartedCaptureGroup:
            return renderer.formatParallelTestSuiteStarted(group: group)
        case let group as PbxcpCaptureGroup:
            return renderer.formatCopy(group: group)
        case let group as PhaseScriptExecutionCaptureGroup:
            return renderer.formatPhaseScriptExecution(group: group)
        case let group as PhaseSuccessCaptureGroup:
            return renderer.formatPhaseSuccess(group: group)
        case let group as PodsErrorCaptureGroup:
            return renderer.formatError(group: group)
        case _ as PreprocessCaptureGroup:
            return renderer.format(line: line, command: "Preprocessing", pattern: .preprocess, arguments: "$1")
        case let group as ProcessInfoPlistCaptureGroup:
            return renderer.formatProcessInfoPlist(group: group)
        case let group as ProcessPchCaptureGroup:
            return renderer.formatProcessPch(group: group)
        case let group as ProcessPchCommandCaptureGroup:
            return renderer.formatProcessPchCommand(group: group)
        case let group as ProvisioningProfileRequiredCaptureGroup:
            return renderer.formatError(group: group)
        case let group as RestartingTestCaptureGroup:
            return renderer.formatRestartingTest(line: line, group: group)
        case let group as ShellCommandCaptureGroup:
            return renderer.formatShellCommand(group: group)
        case _ as SymbolReferencedFromCaptureGroup:
            return renderer.formatCompleteError(line: line)
        case let group as TestCaseMeasuredCaptureGroup:
            return renderer.formatTestCaseMeasured(group: group)
        case let group as TestCasePassedCaptureGroup:
            return renderer.formatTestCasePassed(group: group)
        case let group as TestCasePendingCaptureGroup:
            return renderer.formatTestCasePending(group: group)
        case let group as TestCaseStartedCaptureGroup:
            return renderer.formatTestCasesStarted(group: group)
        case let group as TestsRunCompletionCaptureGroup:
            return renderer.formatTestsRunCompletion(group: group)
        case let group as TestSuiteAllTestsFailedCaptureGroup:
            return renderer.formatTestSuiteAllTestsFailed(group: group)
        case let group as TestSuiteAllTestsPassedCaptureGroup:
            return renderer.formatTestSuiteAllTestsPassed(group: group)
        case let group as TestSuiteStartCaptureGroup:
            return renderer.formatTestSuiteStart(group: group)
        case let group as TestSuiteStartedCaptureGroup:
            return renderer.formatTestSuiteStarted(group: group)
        case let group as TIFFutilCaptureGroup:
            return renderer.formatTIFFUtil(group: group)
        case let group as TouchCaptureGroup:
            return renderer.formatTouch(group: group)
        case let group as UIFailingTestCaptureGroup:
            return renderer.formatUIFailingTest(group: group)
        case _ as UndefinedSymbolLocationCaptureGroup:
            return renderer.formatCompleteWarning(line: line)
        case let group as WillNotBeCodeSignedCaptureGroup:
            return renderer.formatWillNotBeCodesignWarning(group: group)
        case let group as WriteAuxiliaryFilesCaptureGroup:
            return renderer.formatWriteAuxiliaryFiles(group: group)
        case let group as WriteFileCaptureGroup:
            return renderer.formatWriteFile(group: group)
        case let group as XcodebuildErrorCaptureGroup:
            return renderer.formatError(group: group)
        default:
            assertionFailure()
            return nil
        }
    }
}
