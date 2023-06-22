import Foundation

struct GitHubRenderer: OutputRendering {
    let colored = false

    func format(line: String, command: String, pattern: Pattern, arguments: String) -> String? {
        ""
    }

    func formatAnalyze(group: AnalyzeCaptureGroup) -> String {
        ""
    }

    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String {
        ""
    }

    func formatCodeSign(group: CodesignCaptureGroup) -> String {
        ""
    }

    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String {
        ""
    }

    func formatCompile(group: CompileFileCaptureGroup) -> String {
        ""
    }

    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        ""
    }

    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        ""
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String {
        ""
    }

    func formatCompleteError(line: String) -> String {
        ""
    }

    func formatCompleteWarning(line: String) -> String {
        ""
    }

    func formatCopy(group: CopyCaptureGroup) -> String {
        ""
    }

    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String {
        ""
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        ""
    }

    func formatError(group: ErrorCaptureGroup) -> String {
        ""
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        ""
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        ""
    }

    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String {
        ""
    }

    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String {
        ""
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        ""
    }

    func formatLibtool(group: LibtoolCaptureGroup) -> String {
        ""
    }

    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        ""
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        ""
    }

    func formatLinking(group: LinkingCaptureGroup) -> String {
        ""
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        ""
    }

    func formatPackageEnd() -> String {
        ""
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        ""
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        ""
    }

    func formatPackageStart() -> String {
        ""
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        ""
    }

    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String {
        ""
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        ""
    }

    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String {
        ""
    }

    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String {
        ""
    }

    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String {
        ""
    }

    func formatProcessPch(group: ProcessPchCaptureGroup) -> String {
        ""
    }

    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String {
        ""
    }

    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String {
        ""
    }

    func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String {
        ""
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        ""
    }

    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String {
        ""
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        ""
    }

    func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String {
        ""
    }

    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String {
        ""
    }

    func formatTouch(group: TouchCaptureGroup) -> String {
        ""
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        ""
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        ""
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        ""
    }
}
