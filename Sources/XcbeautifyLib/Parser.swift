import Foundation

package class Parser {

    private lazy var captureGroupTypes: [CaptureGroup.Type] = [
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

    package func parse(line: String) -> CaptureGroup? {
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

        let groups: [String] = line.captureGroup(with: captureGroupType.pattern)
        guard let captureGroup = captureGroupType.init(groups: groups) else {
            assertionFailure()
            return nil
        }

        // Move found parser to the top, so next time it will be checked first
        captureGroupTypes.insert(captureGroupTypes.remove(at: idx), at: 0)

        return captureGroup
    }
}

private extension String {
    func captureGroup(with pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])

            let matches = regex.matches(in: self, range: NSRange(location: 0, length: utf16.count))
            guard let match = matches.first else { return [] }

            let lastRangeIndex = match.numberOfRanges - 1
            guard lastRangeIndex >= 1 else { return [] }

            return (1...lastRangeIndex).compactMap { index in
                let capturedGroupIndex = match.range(at: index)
                return substring(with: capturedGroupIndex)
            }
        } catch {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
}
