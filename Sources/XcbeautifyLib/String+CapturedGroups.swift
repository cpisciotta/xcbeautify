import Foundation

extension String {
    private static let captureGroups: [any CaptureGroup.Type] = [
        AnalyzeCaptureGroup.self,
        BuildTargetCaptureGroup.self,
        AggregateTargetCaptureGroup.self,
        AnalyzeTargetCaptureGroup.self,
        CheckDependenciesCaptureGroup.self,
        ShellCommandCaptureGroup.self,
        CleanRemoveCaptureGroup.self,
        CleanTargetCaptureGroup.self,
        CodesignCaptureGroup.self,
        CodesignFrameworkCaptureGroup.self,
        CompileCaptureGroup.self,
        SwiftCompileCaptureGroup.self,
        CompileCommandCaptureGroup.self,
        CompileXibCaptureGroup.self,
        CompileStoryboardCaptureGroup.self,
        CopyHeaderCaptureGroup.self,
        CopyPlistCaptureGroup.self,
        CopyStringsCaptureGroup.self,
        CpresourceCaptureGroup.self,
        ExecutedWithoutSkippedCaptureGroup.self,
        ExecutedWithSkippedCaptureGroup.self,
        FailingTestCaptureGroup.self,
        UIFailingTestCaptureGroup.self,
        RestartingTestCaptureGroup.self,
        GenerateCoverageDataCaptureGroup.self,
        GeneratedCoverageReportCaptureGroup.self,
        GenerateDSYMCaptureGroup.self,
        LibtoolCaptureGroup.self,
        LinkingCaptureGroup.self,
        TestCasePassedCaptureGroup.self,
        TestCaseStartedCaptureGroup.self,
        TestCasePendingCaptureGroup.self,
        TestCaseMeasuredCaptureGroup.self,
        ParallelTestCasePassedCaptureGroup.self,
        ParallelTestCaseAppKitPassedCaptureGroup.self,
        ParallelTestCaseFailedCaptureGroup.self,
        ParallelTestingStartedCaptureGroup.self,
        ParallelTestingPassedCaptureGroup.self,
        ParallelTestingFailedCaptureGroup.self,
        ParallelTestSuiteStartedCaptureGroup.self,
        PhaseSuccessCaptureGroup.self,
        PhaseScriptExecutionCaptureGroup.self,
        ProcessPchCaptureGroup.self,
        ProcessPchCommandCaptureGroup.self,
        PreprocessCaptureGroup.self,
        PbxcpCaptureGroup.self,
        ProcessInfoPlistCaptureGroup.self,
        TestsRunCompletionCaptureGroup.self,
        TestSuiteStartedCaptureGroup.self,
        TestSuiteStartCaptureGroup.self,
        TestSuiteAllTestsPassedCaptureGroup.self,
        TestSuiteAllTestsFailedCaptureGroup.self,
        TIFFutilCaptureGroup.self,
        TouchCaptureGroup.self,
        WriteFileCaptureGroup.self,
        WriteAuxiliaryFilesCaptureGroup.self,
        CompileWarningCaptureGroup.self,
        LDWarningCaptureGroup.self,
        GenericWarningCaptureGroup.self,
        WillNotBeCodeSignedCaptureGroup.self,
        DuplicateLocalizedStringKeyCaptureGroup.self,
        ClangErrorCaptureGroup.self,
        CheckDependenciesErrorsCaptureGroup.self,
        ProvisioningProfileRequiredCaptureGroup.self,
        NoCertificateCaptureGroup.self,
        CompileErrorCaptureGroup.self,
        CursorCaptureGroup.self,
        FatalErrorCaptureGroup.self,
        FileMissingErrorCaptureGroup.self,
        LDErrorCaptureGroup.self,
        LinkerDuplicateSymbolsLocationCaptureGroup.self,
        LinkerDuplicateSymbolsCaptureGroup.self,
        LinkerUndefinedSymbolLocationCaptureGroup.self,
        LinkerUndefinedSymbolsCaptureGroup.self,
        PodsErrorCaptureGroup.self,
        SymbolReferencedFromCaptureGroup.self,
        ModuleIncludesErrorCaptureGroup.self,
        UndefinedSymbolLocationCaptureGroup.self,
        PackageFetchingCaptureGroup.self,
        PackageUpdatingCaptureGroup.self,
        PackageCheckingOutCaptureGroup.self,
        PackageGraphResolvingStartCaptureGroup.self,
        PackageGraphResolvingEndedCaptureGroup.self,
        PackageGraphResolvedItemCaptureGroup.self,
        XcodebuildErrorCaptureGroup.self,
    ]

    func captureGroup(with pattern: String) -> CaptureGroup? {
        let captureGroupType: CaptureGroup.Type? = Self.captureGroups.first { captureGroup in
            captureGroup.pattern == pattern
        }

        guard let captureGroupType else {
            assertionFailure()
            return nil
        }

        let groups: [String] = captureGroupType.regex.captureGroups(for: self)

        let captureGroup = captureGroupType.init(groups: groups)
        assert(captureGroup != nil)
        return captureGroup
    }
}
