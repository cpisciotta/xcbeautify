import Foundation

/// Maps raw `xcodebuild` output to a `CaptureGroup`.
package final class Parser {
    private lazy var captureGroupTypes: [any CaptureGroup.Type] = [
        AnalyzeCaptureGroup.self,
        BuildTargetCaptureGroup.self,
        AggregateTargetCaptureGroup.self,
        AnalyzeTargetCaptureGroup.self,
        CheckDependenciesCaptureGroup.self,
        CleanRemoveCaptureGroup.self,
        CleanTargetCaptureGroup.self,
        CodesignFrameworkCaptureGroup.self,
        CodesignCaptureGroup.self,
        CompilationResultCaptureGroup.self,
        CompileCaptureGroup.self,
        SwiftCompileCaptureGroup.self,
        SwiftCompilingCaptureGroup.self,
        CompileCommandCaptureGroup.self,
        CompileXibCaptureGroup.self,
        CompileStoryboardCaptureGroup.self,
        CopyHeaderCaptureGroup.self,
        CopyPlistCaptureGroup.self,
        CopyStringsCaptureGroup.self,
        CpresourceCaptureGroup.self,
        FailingTestCaptureGroup.self,
        UIFailingTestCaptureGroup.self,
        RestartingTestCaptureGroup.self,
        GenerateCoverageDataCaptureGroup.self,
        GeneratedCoverageReportCaptureGroup.self,
        GenerateDSYMCaptureGroup.self,
        LibtoolCaptureGroup.self,
        LinkingCaptureGroup.self,
        TestCasePassedCaptureGroup.self,
        TestCaseSkippedCaptureGroup.self,
        TestCaseStartedCaptureGroup.self,
        TestCasePendingCaptureGroup.self,
        TestCaseMeasuredCaptureGroup.self,
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
        TIFFutilCaptureGroup.self,
        TouchCaptureGroup.self,
        WriteFileCaptureGroup.self,
        WriteAuxiliaryFileCaptureGroup.self,
        ParallelTestCasePassedCaptureGroup.self,
        ParallelTestCaseSkippedCaptureGroup.self,
        ParallelTestCaseAppKitPassedCaptureGroup.self,
        ParallelTestingStartedCaptureGroup.self,
        ParallelTestingPassedCaptureGroup.self,
        ParallelTestSuiteStartedCaptureGroup.self,
        LDWarningCaptureGroup.self,
        CompileWarningCaptureGroup.self,
        GenericWarningCaptureGroup.self,
        WillNotBeCodeSignedCaptureGroup.self,
        ClangErrorCaptureGroup.self,
        CheckDependenciesErrorsCaptureGroup.self,
        ProvisioningProfileRequiredCaptureGroup.self,
        NoCertificateCaptureGroup.self,
        FileMissingErrorCaptureGroup.self,
        XcodebuildErrorCaptureGroup.self,
        CompileErrorCaptureGroup.self,
        CursorCaptureGroup.self,
        FatalErrorCaptureGroup.self,
        LDErrorCaptureGroup.self,
        LinkerDuplicateSymbolsLocationCaptureGroup.self,
        LinkerDuplicateSymbolsCaptureGroup.self,
        LinkerUndefinedSymbolLocationCaptureGroup.self,
        LinkerUndefinedSymbolsCaptureGroup.self,
        PodsErrorCaptureGroup.self,
        SymbolReferencedFromCaptureGroup.self,
        ModuleIncludesErrorCaptureGroup.self,
        ParallelTestingFailedCaptureGroup.self,
        ParallelTestCaseFailedCaptureGroup.self,
        ShellCommandCaptureGroup.self,
        UndefinedSymbolLocationCaptureGroup.self,
        PackageFetchingCaptureGroup.self,
        PackageUpdatingCaptureGroup.self,
        PackageCheckingOutCaptureGroup.self,
        PackageGraphResolvingStartCaptureGroup.self,
        PackageGraphResolvingEndedCaptureGroup.self,
        PackageGraphResolvedItemCaptureGroup.self,
        DuplicateLocalizedStringKeyCaptureGroup.self,
        SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.self,
        ExecutedWithoutSkippedCaptureGroup.self,
        ExecutedWithSkippedCaptureGroup.self,
        TestSuiteAllTestsPassedCaptureGroup.self,
        TestSuiteAllTestsFailedCaptureGroup.self,
    ]

    // MARK: - Init

    package init() { }

    /// Maps raw `xcodebuild` output to a `CaptureGroup`.
    /// - Parameter line: The raw `xcodebuild` output.
    /// - Returns: The `CaptureGroup` if `line` is recognized. Otherwise, `nil`.
    package func parse(line: String) -> (any CaptureGroup)? {
        if line.isEmpty {
            return nil
        }

        // Find first parser that can parse specified string
        guard let idx = captureGroupTypes.firstIndex(where: { $0.regex.match(string: line) }) else {
            return nil
        }

        guard let captureGroupType = captureGroupTypes[safe: idx] else {
            assertionFailure()
            return nil
        }

        let groups: [String] = captureGroupType.regex.captureGroups(for: line)
        guard let captureGroup = captureGroupType.init(groups: groups) else {
            assertionFailure()
            return nil
        }

        // Move found parser to the top, so next time it will be checked first
        captureGroupTypes.insert(captureGroupTypes.remove(at: idx), at: 0)

        return captureGroup
    }
}
