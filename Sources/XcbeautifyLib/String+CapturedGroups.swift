import Foundation

extension String {
    private func captureGroup(with pattern: String) -> [String] {
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

extension String {
    func captureGroup(with pattern: String) -> CaptureGroup? {
        let results: [String] = captureGroup(with: pattern)

        let captureGroups: [any CaptureGroup.Type] = [
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

        let captureGroupType: CaptureGroup.Type? = captureGroups.first { captureGroup in
            captureGroup.pattern == pattern
        }

        guard let captureGroupType else {
            assertionFailure()
            return nil
        }

        let captureGroup = captureGroupType.init(groups: results)
        assert(captureGroup != nil)
        return captureGroup
    }
}
