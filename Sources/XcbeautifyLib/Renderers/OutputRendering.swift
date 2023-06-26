import Foundation

protocol OutputRendering {
    var colored: Bool { get }

    func beautify(line: String, pattern: Pattern, additionalLines: @escaping () -> (String?)) -> String?

    func format(testSummary: TestSummary) -> String

    func format(line: String, command: String, pattern: Pattern, arguments: String) -> String?
    func formatAnalyze(group: AnalyzeCaptureGroup) -> String
    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String
    func formatCodeSign(group: CodesignCaptureGroup) -> String
    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String
    func formatCompile(group: CompileFileCaptureGroup) -> String
    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String?
    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines:  @escaping () -> (String?)) -> String
    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines:  @escaping () -> (String?)) -> String
    func formatCompleteError(line: String) -> String
    func formatCompleteWarning(line: String) -> String
    func formatCopy(group: CopyCaptureGroup) -> String
    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String
    func formatCursor(group: CursorCaptureGroup) -> String?
    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String
    func formatError(group: ErrorCaptureGroup) -> String
    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String?
    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String?
    func formatFailingTest(group: FailingTestCaptureGroup) -> String
    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String
    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String
    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String
    func formatLdWarning(group: LDWarningCaptureGroup) -> String
    func formatLibtool(group: LibtoolCaptureGroup) -> String
    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String
    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String?
    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String?
    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String
    func formatLinking(group: LinkingCaptureGroup) -> String
    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String
    func formatPackageEnd() -> String
    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String
    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String
    func formatPackageStart() -> String
    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String
    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String
    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String
    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String
    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String
    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String
    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String
    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String
    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String
    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String
    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String
    func formatProcessPch(group: ProcessPchCaptureGroup) -> String
    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String
    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String
    func formatShellCommand(group: ShellCommandCaptureGroup) -> String?
    func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String
    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String
    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String
    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String
    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String?
    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String?
    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String?
    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup)  -> String?
    func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String
    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String
    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String?
    func formatTouch(group: TouchCaptureGroup) -> String
    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String
    func formatWarning(group: GenericWarningCaptureGroup) -> String
    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String
    func formatWriteAuxiliaryFiles(group: WriteAuxiliaryFilesCaptureGroup) -> String?
    func formatWriteFile(group: WriteFileCaptureGroup) -> String?
}

extension OutputRendering {
    func beautify(
        line: String,
        pattern: Pattern,
        additionalLines: @escaping () -> (String?)
    ) -> String? {
        let group: CaptureGroup = line.captureGroup(with: pattern)

        switch (pattern, group) {
        case (.analyze, let group as AnalyzeCaptureGroup):
            return formatAnalyze(group: group)
        case (.compile, let group as CompileCaptureGroup):
            return formatCompile(group: group)
        case (.compileXib, let group as CompileXibCaptureGroup):
            return formatCompile(group: group)
        case (.compileStoryboard, let group as CompileStoryboardCaptureGroup):
            return formatCompile(group: group)
        case (.compileCommand, let group as CompileCommandCaptureGroup):
            return formatCompileCommand(group: group)
        case (.buildTarget, let group as BuildTargetCaptureGroup):
            return formatTargetCommand(command: "Build", group: group)
        case (.analyzeTarget, let group as AnalyzeTargetCaptureGroup):
            return formatTargetCommand(command: "Analyze", group: group)
        case (.aggregateTarget, let group as AggregateTargetCaptureGroup):
            return formatTargetCommand(command: "Aggregate", group: group)
        case (.cleanTarget, let group as CleanTargetCaptureGroup):
            return formatTargetCommand(command: "Clean", group: group)
        case (.generateCoverageData, let group as GenerateCoverageDataCaptureGroup):
            return formatGenerateCoverageData(group: group)
        case (.generatedCoverageReport, let group as GeneratedCoverageReportCaptureGroup):
            return formatCoverageReport(group: group)
        case (.generateDsym, let group as GenerateDSYMCaptureGroup):
            return formatGenerateDsym(group: group)
        case (.libtool, let group as LibtoolCaptureGroup):
            return formatLibtool(group: group)
        case (.linking, let group as LinkingCaptureGroup):
            return formatLinking(group: group)
        case (.testSuiteStarted, let group as TestSuiteStartedCaptureGroup):
            return formatTestSuiteStarted(group: group)
        case (.testSuiteStart, let group as TestSuiteStartCaptureGroup):
            return formatTestSuiteStart(group: group)
        case (.parallelTestingStarted, let group as ParallelTestingStartedCaptureGroup):
            return formatParallelTestingStarted(line: line, group: group)
        case (.parallelTestingPassed, let group as ParallelTestingPassedCaptureGroup):
            return formatParallelTestingPassed(line: line, group: group)
        case (.parallelTestingFailed, let group as ParallelTestingFailedCaptureGroup):
            return formatParallelTestingFailed(line: line, group: group)
        case (.parallelTestSuiteStarted, let group as ParallelTestSuiteStartedCaptureGroup):
            return formatParallelTestSuiteStarted(group: group)
        case (.testSuiteAllTestsPassed, let group as TestSuiteAllTestsPassedCaptureGroup):
            return formatTestSuiteAllTestsPassed(group: group)
        case (.testSuiteAllTestsFailed, let group as TestSuiteAllTestsFailedCaptureGroup):
            return formatTestSuiteAllTestsFailed(group: group)
        case (.failingTest, let group as FailingTestCaptureGroup):
            return formatFailingTest(group: group)
        case (.uiFailingTest, let group as UIFailingTestCaptureGroup):
            return formatUIFailingTest(group: group)
        case (.restartingTest, let group as RestartingTestCaptureGroup):
            return formatRestartingTest(line: line, group: group)
        case (.testCasePassed, let group as TestCasePassedCaptureGroup):
            return formatTestCasePassed(group: group)
        case (.testCasePending, let group as TestCasePendingCaptureGroup):
            return formatTestCasePending(group: group)
        case (.testCaseMeasured, let group as TestCaseMeasuredCaptureGroup):
            return formatTestCaseMeasured(group: group)
        case (.testsRunCompletion, let group as TestsRunCompletionCaptureGroup):
            return formatTestsRunCompletion(group: group)
        case (.parallelTestCasePassed, let group as ParallelTestCasePassedCaptureGroup):
            return formatParallelTestCasePassed(group: group)
        case (.parallelTestCaseAppKitPassed, let group as ParallelTestCaseAppKitPassedCaptureGroup):
            return formatParallelTestCaseAppKitPassed(group: group)
        case (.parallelTestCaseFailed, let group as ParallelTestCaseFailedCaptureGroup):
            return formatParallelTestCaseFailed(group: group)
        case (.codesign, let group as CodesignCaptureGroup):
            return formatCodeSign(group: group)
        case (.codesignFramework, let group as CodesignFrameworkCaptureGroup):
            return formatCodeSignFramework(group: group)
        case (.copyHeader, let group as CopyHeaderCaptureGroup):
            return formatCopy(group: group)
        case (.copyPlist, let group as CopyPlistCaptureGroup):
            return formatCopy(group: group)
        case (.copyStrings, let group as CopyStringsCaptureGroup):
            return formatCopy(group: group)
        case (.cpresource, let group as CpresourceCaptureGroup):
            return formatCopy(group: group)
        case (.pbxcp, let group as PbxcpCaptureGroup):
            return formatCopy(group: group)
        case (.checkDependencies, let group as CheckDependenciesCaptureGroup):
            return format(line: line, command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case (.processInfoPlist, let group as ProcessInfoPlistCaptureGroup):
            return formatProcessInfoPlist(group: group)
        case (.processPch, let group as ProcessPchCaptureGroup):
            return formatProcessPch(group: group)
        case (.touch, let group as TouchCaptureGroup):
            return formatTouch(group: group)
        case (.phaseSuccess, let group as PhaseSuccessCaptureGroup):
            return formatPhaseSuccess(group: group)
        case (.phaseScriptExecution, let group as PhaseScriptExecutionCaptureGroup):
            return formatPhaseScriptExecution(group: group)
        case (.preprocess, let group as PreprocessCaptureGroup):
            return format(line: line, command: "Preprocessing", pattern: pattern, arguments: "$1")
        case (.processPchCommand, let group as ProcessPchCommandCaptureGroup):
            return formatProcessPchCommand(group: group)
        case (.writeFile, let group as WriteFileCaptureGroup):
            return formatWriteFile(group: group)
        case (.writeAuxiliaryFiles, let group as WriteAuxiliaryFilesCaptureGroup):
            return formatWriteAuxiliaryFiles(group: group)
        case (.shellCommand, let group as ShellCommandCaptureGroup):
            return formatShellCommand(group: group)
        case (.cleanRemove, let group as CleanRemoveCaptureGroup):
            return formatCleanRemove(group: group)
        case (.executedWithoutSkipped, let group as ExecutedWithoutSkippedCaptureGroup):
            return formatExecutedWithoutSkipped(group: group)
        case (.executedWithSkipped, let group as ExecutedWithSkippedCaptureGroup):
            return formatExecutedWithSkipped(group: group)
        case (.testCaseStarted, let group as TestCaseStartedCaptureGroup):
            return formatTestCasesStarted(group: group)
        case (.tiffutil, let group as TIFFutilCaptureGroup):
            return formatTIFFUtil(group: group)
        case (.compileWarning, let group as CompileWarningCaptureGroup):
            return formatCompileWarning(group: group, additionalLines: additionalLines)
        case (.ldWarning, let group as LDWarningCaptureGroup):
            return formatLdWarning(group: group)
        case (.genericWarning, let group as GenericWarningCaptureGroup):
            return formatWarning(group: group)
        case (.willNotBeCodeSigned, let group as WillNotBeCodeSignedCaptureGroup):
            return formatWillNotBeCodesignWarning(group: group)
        case (.clangError, let group as ClangErrorCaptureGroup):
            return formatError(group: group)
        case (.fatalError, let group as FatalErrorCaptureGroup):
            return formatError(group: group)
        case (.ldError, let group as LDErrorCaptureGroup):
            return formatError(group: group)
        case (.podsError, let group as PodsErrorCaptureGroup):
            return formatError(group: group)
        case (.moduleIncludesError, let group as ModuleIncludesErrorCaptureGroup):
            return formatError(group: group)
        case (.xcodebuildError, let group as XcodebuildErrorCaptureGroup):
            return formatError(group: group)
        case (.compileError, let group as CompileErrorCaptureGroup):
            return formatCompileError(group: group, additionalLines: additionalLines)
        case (.fileMissingError, let group as FileMissingErrorCaptureGroup):
            return formatFileMissingError(group: group)
        case (.checkDependenciesErrors, let group as CheckDependenciesErrorsCaptureGroup):
            return formatError(group: group)
        case (.provisioningProfileRequired, let group as ProvisioningProfileRequiredCaptureGroup):
            return formatError(group: group)
        case (.noCertificate, let group as NoCertificateCaptureGroup):
            return formatError(group: group)
        case (.cursor, let group as CursorCaptureGroup):
            return formatCursor(group: group)
        case (.linkerDuplicateSymbolsLocation, let group as LinkerDuplicateSymbolsLocationCaptureGroup):
            return formatLinkerDuplicateSymbolsLocation(group: group)
        case (.linkerDuplicateSymbols, let group as LinkerDuplicateSymbolsCaptureGroup):
            return formatLinkerDuplicateSymbolsError(group: group)
        case (.linkerUndefinedSymbolLocation, let group as LinkerUndefinedSymbolLocationCaptureGroup):
            return formatLinkerUndefinedSymbolLocation(group: group)
        case (.linkerUndefinedSymbols, let group as LinkerUndefinedSymbolsCaptureGroup):
            return formatLinkerUndefinedSymbolsError(group: group)
        case (.symbolReferencedFrom, let group as SymbolReferencedFromCaptureGroup):
            return formatCompleteError(line: line)
        case (.undefinedSymbolLocation, let group as UndefinedSymbolLocationCaptureGroup):
            return formatCompleteWarning(line: line)
        case (.packageFetching, let group as PackageFetchingCaptureGroup):
            return formatPackageFetching(group: group)
        case (.packageUpdating, let group as PackageUpdatingCaptureGroup):
            return formatPackageUpdating(group: group)
        case (.packageCheckingOut, let group as PackageCheckingOutCaptureGroup):
            return formatPackageCheckingOut(group: group)
        case (.packageGraphResolvingStart, let group as PackageGraphResolvingStartCaptureGroup):
            return formatPackageStart()
        case (.packageGraphResolvingEnded, let group as PackageGraphResolvingEndedCaptureGroup):
            return formatPackageEnd()
        case (.packageGraphResolvedItem, let group as PackageGraphResolvedItemCaptureGroup):
            return formatPackageItem(group: group)
        case (.duplicateLocalizedStringKey, let group as DuplicateLocalizedStringKeyCaptureGroup):
            return formatDuplicateLocalizedStringKey(group: group)
        case (_, _):
            assertionFailure()
            return nil
        }
    }
}

extension OutputRendering {
    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup)  -> String? {
        return nil
    }

    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String? {
        return nil
    }

    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String? {
        return nil
    }

    func formatWriteFile(group: WriteFileCaptureGroup) -> String? {
        return nil
    }

    func formatWriteAuxiliaryFiles(group: WriteAuxiliaryFilesCaptureGroup) -> String? {
        return nil
    }

    func formatShellCommand(group: ShellCommandCaptureGroup) -> String? {
        return nil
    }

    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String? {
        return nil
    }

    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String? {
        return nil
    }

    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String? {
        return nil
    }

    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String? {
        return nil
    }

    func formatCursor(group: CursorCaptureGroup) -> String? {
        return nil
    }

    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String? {
        return nil
    }

    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        return nil
    }
}
