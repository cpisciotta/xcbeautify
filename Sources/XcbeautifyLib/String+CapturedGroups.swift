import Foundation

extension String {
    private func captureGroup(with pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])

            let matches = regex.matches(in: self, range: NSRange(location:0, length: self.utf16.count))
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

        switch pattern {
        case AnalyzeCaptureGroup.pattern:            
            return AnalyzeCaptureGroup(groups: results)

        case BuildTargetCaptureGroup.pattern:            
            return BuildTargetCaptureGroup(groups: results)

        case AggregateTargetCaptureGroup.pattern:            
            return AggregateTargetCaptureGroup(groups: results)

        case AnalyzeTargetCaptureGroup.pattern:            
            return AnalyzeTargetCaptureGroup(groups: results)

        case CheckDependenciesCaptureGroup.pattern:            
            return CheckDependenciesCaptureGroup(groups: results)

        case ShellCommandCaptureGroup.pattern:            
            return ShellCommandCaptureGroup(groups: results)

        case CleanRemoveCaptureGroup.pattern:            
            return CleanRemoveCaptureGroup(groups: results)

        case CleanTargetCaptureGroup.pattern:            
            return CleanTargetCaptureGroup(groups: results)

        case CodesignCaptureGroup.pattern:            
            return CodesignCaptureGroup(groups: results)

        case CodesignFrameworkCaptureGroup.pattern:            
            return CodesignFrameworkCaptureGroup(groups: results)

        case CompileCaptureGroup.pattern:            
            return CompileCaptureGroup(groups: results)

        case CompileCommandCaptureGroup.pattern:            
            return CompileCommandCaptureGroup(groups: results)

        case CompileXibCaptureGroup.pattern:            
            return CompileXibCaptureGroup(groups: results)

        case CompileStoryboardCaptureGroup.pattern:            
            return CompileStoryboardCaptureGroup(groups: results)

        case CopyHeaderCaptureGroup.pattern:            
            return CopyHeaderCaptureGroup(groups: results)

        case CopyPlistCaptureGroup.pattern:            
            return CopyPlistCaptureGroup(groups: results)

        case CopyStringsCaptureGroup.pattern:            
            return CopyStringsCaptureGroup(groups: results)

        case CpresourceCaptureGroup.pattern:            
            return CpresourceCaptureGroup(groups: results)

        case ExecutedWithoutSkippedCaptureGroup.pattern:            
            return ExecutedWithoutSkippedCaptureGroup(groups: results)

        case ExecutedWithSkippedCaptureGroup.pattern:            
            return ExecutedWithSkippedCaptureGroup(groups: results)

        case FailingTestCaptureGroup.pattern:            
            return FailingTestCaptureGroup(groups: results)

        case UIFailingTestCaptureGroup.pattern:            
            return UIFailingTestCaptureGroup(groups: results)

        case RestartingTestCaptureGroup.pattern:            
            return RestartingTestCaptureGroup(groups: results)

        case GenerateCoverageDataCaptureGroup.pattern:            
            return GenerateCoverageDataCaptureGroup(groups: results)

        case GeneratedCoverageReportCaptureGroup.pattern:            
            return GeneratedCoverageReportCaptureGroup(groups: results)

        case GenerateDSYMCaptureGroup.pattern:            
            return GenerateDSYMCaptureGroup(groups: results)

        case LibtoolCaptureGroup.pattern:            
            return LibtoolCaptureGroup(groups: results)
            
        case LinkingCaptureGroup.pattern:            
            return LinkingCaptureGroup(groups: results)

        case TestCasePassedCaptureGroup.pattern:            
            return TestCasePassedCaptureGroup(groups: results)

        case TestCaseStartedCaptureGroup.pattern:            
            return TestCaseStartedCaptureGroup(groups: results)

        case TestCasePendingCaptureGroup.pattern:            
            return TestCasePendingCaptureGroup(groups: results)

        case TestCaseMeasuredCaptureGroup.pattern:            
            return TestCaseMeasuredCaptureGroup(groups: results)

        case ParallelTestCasePassedCaptureGroup.pattern:            
            return ParallelTestCasePassedCaptureGroup(groups: results)

        case ParallelTestCaseAppKitPassedCaptureGroup.pattern:            
            return ParallelTestCaseAppKitPassedCaptureGroup(groups: results)

        case ParallelTestCaseFailedCaptureGroup.pattern:            
            return ParallelTestCaseFailedCaptureGroup(groups: results)

        case ParallelTestingStartedCaptureGroup.pattern:            
            return ParallelTestingStartedCaptureGroup(groups: results)

        case ParallelTestingPassedCaptureGroup.pattern:            
            return ParallelTestingPassedCaptureGroup(groups: results)

        case ParallelTestingFailedCaptureGroup.pattern:            
            return ParallelTestingFailedCaptureGroup(groups: results)

        case ParallelTestSuiteStartedCaptureGroup.pattern:            
            return ParallelTestSuiteStartedCaptureGroup(groups: results)

        case PhaseSuccessCaptureGroup.pattern:            
            return PhaseSuccessCaptureGroup(groups: results)

        case PhaseScriptExecutionCaptureGroup.pattern:            
            return PhaseScriptExecutionCaptureGroup(groups: results)

        case ProcessPchCaptureGroup.pattern:            
            return ProcessPchCaptureGroup(groups: results)

        case ProcessPchCommandCaptureGroup.pattern:            
            return ProcessPchCommandCaptureGroup(groups: results)

        case PreprocessCaptureGroup.pattern:            
            return PreprocessCaptureGroup(groups: results)

        case PbxcpCaptureGroup.pattern:            
            return PbxcpCaptureGroup(groups: results)

        case ProcessInfoPlistCaptureGroup.pattern:            
            return ProcessInfoPlistCaptureGroup(groups: results)

        case TestsRunCompletionCaptureGroup.pattern:            
            return TestsRunCompletionCaptureGroup(groups: results)

        case TestSuiteStartedCaptureGroup.pattern:            
            return TestSuiteStartedCaptureGroup(groups: results)

        case TestSuiteStartCaptureGroup.pattern:            
            return TestSuiteStartCaptureGroup(groups: results)

        case TestSuiteAllTestsPassedCaptureGroup.pattern:            
            return TestSuiteAllTestsPassedCaptureGroup(groups: results)

        case TestSuiteAllTestsFailedCaptureGroup.pattern:            
            return TestSuiteAllTestsFailedCaptureGroup(groups: results)

        case TIFFutilCaptureGroup.pattern:            
            return TIFFutilCaptureGroup(groups: results)

        case TouchCaptureGroup.pattern:            
            return TouchCaptureGroup(groups: results)

        case WriteFileCaptureGroup.pattern:            
            return WriteFileCaptureGroup(groups: results)

        case WriteAuxiliaryFilesCaptureGroup.pattern:            
            return WriteAuxiliaryFilesCaptureGroup(groups: results)

        case CompileWarningCaptureGroup.pattern:            
            return CompileWarningCaptureGroup(groups: results)

        case LDWarningCaptureGroup.pattern:            
            return LDWarningCaptureGroup(groups: results)

        case GenericWarningCaptureGroup.pattern:            
            return GenericWarningCaptureGroup(groups: results)

        case WillNotBeCodeSignedCaptureGroup.pattern:            
            return WillNotBeCodeSignedCaptureGroup(groups: results)

        case DuplicateLocalizedStringKeyCaptureGroup.pattern:            
            return DuplicateLocalizedStringKeyCaptureGroup(groups: results)

        case ClangErrorCaptureGroup.pattern:            
            return ClangErrorCaptureGroup(groups: results)

        case CheckDependenciesErrorsCaptureGroup.pattern:            
            return CheckDependenciesErrorsCaptureGroup(groups: results)

        case ProvisioningProfileRequiredCaptureGroup.pattern:            
            return ProvisioningProfileRequiredCaptureGroup(groups: results)

        case NoCertificateCaptureGroup.pattern:            
            return NoCertificateCaptureGroup(groups: results)

        case CompileErrorCaptureGroup.pattern:            
            return CompileErrorCaptureGroup(groups: results)

        case CursorCaptureGroup.pattern:            
            return CursorCaptureGroup(groups: results)

        case FatalErrorCaptureGroup.pattern:            
            return FatalErrorCaptureGroup(groups: results)

        case FileMissingErrorCaptureGroup.pattern:            
            return FileMissingErrorCaptureGroup(groups: results)

        case LDErrorCaptureGroup.pattern:            
            return LDErrorCaptureGroup(groups: results)

        case LinkerDuplicateSymbolsLocationCaptureGroup.pattern:            
            return LinkerDuplicateSymbolsLocationCaptureGroup(groups: results)

        case LinkerDuplicateSymbolsCaptureGroup.pattern:            
            return LinkerDuplicateSymbolsCaptureGroup(groups: results)

        case LinkerUndefinedSymbolLocationCaptureGroup.pattern:            
            return LinkerUndefinedSymbolLocationCaptureGroup(groups: results)

        case LinkerUndefinedSymbolsCaptureGroup.pattern:            
            return LinkerUndefinedSymbolsCaptureGroup(groups: results)

        case PodsErrorCaptureGroup.pattern:            
            return PodsErrorCaptureGroup(groups: results)

        case SymbolReferencedFromCaptureGroup.pattern:            
            return SymbolReferencedFromCaptureGroup(groups: results)

        case ModuleIncludesErrorCaptureGroup.pattern:            
            return ModuleIncludesErrorCaptureGroup(groups: results)

        case UndefinedSymbolLocationCaptureGroup.pattern:            
            return UndefinedSymbolLocationCaptureGroup(groups: results)

        case PackageFetchingCaptureGroup.pattern:            
            return PackageFetchingCaptureGroup(groups: results)

        case PackageUpdatingCaptureGroup.pattern:            
            return PackageUpdatingCaptureGroup(groups: results)

        case PackageCheckingOutCaptureGroup.pattern:            
            return PackageCheckingOutCaptureGroup(groups: results)

        case PackageGraphResolvingStartCaptureGroup.pattern:            
            return PackageGraphResolvingStartCaptureGroup(groups: results)

        case PackageGraphResolvingEndedCaptureGroup.pattern:            
            return PackageGraphResolvingEndedCaptureGroup(groups: results)

        case PackageGraphResolvedItemCaptureGroup.pattern:            
            return PackageGraphResolvedItemCaptureGroup(groups: results)

        case XcodebuildErrorCaptureGroup.pattern:
            return XcodebuildErrorCaptureGroup(groups: results)

        default:
            assertionFailure()
            return nil
        }
    }
}
