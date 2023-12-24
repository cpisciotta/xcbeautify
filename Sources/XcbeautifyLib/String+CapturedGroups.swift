import Foundation

extension String {
    private func captureGroup(with pattern: Pattern) -> [String] {
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
    func captureGroup(with pattern: Pattern) -> CaptureGroup? {
        let results: [String] = captureGroup(with: pattern)

        switch pattern {
        case AnalyzeCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return AnalyzeCaptureGroup(filePath: filePath, fileName: fileName, target: target)

        case BuildTargetCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return BuildTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case AggregateTargetCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return AggregateTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case AnalyzeTargetCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return AnalyzeTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case CheckDependenciesCaptureGroup.pattern:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case ShellCommandCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let commandPath = results[safe: 0], let arguments = results[safe: 1] else { return nil }
            return ShellCommandCaptureGroup(commandPath: commandPath, arguments: arguments)

        case CleanRemoveCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let directory = results[safe: 0] else { return nil }
            return CleanRemoveCaptureGroup(directory: directory.lastPathComponent)

        case CleanTargetCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return CleanTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case CodesignCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return nil }
            return CodesignCaptureGroup(file: file)

        case CodesignFrameworkCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let frameworkPath = results[safe: 0] else { return nil }
            return CodesignFrameworkCaptureGroup(frameworkPath: frameworkPath)

        case CompileCaptureGroup.pattern:
#if os(Linux)
            assert(results.count >= 2)
            guard let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileCaptureGroup(filename: fileName, target: target)
#else
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileCaptureGroup(filePath: filePath, filename: fileName, target: target)
#endif

        case CompileCommandCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let compilerCommand = results[safe: 0], let filePath = results[safe: 1] else { return nil }
            return CompileCommandCaptureGroup(compilerCommand: compilerCommand, filePath: filePath)

        case CompileXibCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileXibCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case CompileStoryboardCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileStoryboardCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case CopyHeaderCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return nil }
            return CopyHeaderCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case CopyPlistCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CopyPlistCaptureGroup(file: file.lastPathComponent, target: target)

        case CopyStringsCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CopyStringsCaptureGroup(file: file.lastPathComponent, target: target)

        case CpresourceCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CpresourceCaptureGroup(file: file.lastPathComponent, target: target)

        case ExecutedWithoutSkippedCaptureGroup.pattern:
            assert(results.count >= 4)
            guard let _numberOfTests = results[safe: 0], let _numberOfFailures = results[safe: 1], let _numberOfUnexpectedFailures = results[safe: 2], let _wallClockTimeInSeconds = results[safe: 3] else { return nil }
            guard let numberOfTests = Int(_numberOfTests), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
            return ExecutedWithoutSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case ExecutedWithSkippedCaptureGroup.pattern:
            assert(results.count >= 5)
            guard let _numberOfTests = results[safe: 0], let _numberOfSkipped = results[safe: 1], let _numberOfFailures = results[safe: 2], let _numberOfUnexpectedFailures = results[safe: 3], let _wallClockTimeInSeconds = results[safe: 4] else { return nil }
            guard let numberOfTests = Int(_numberOfTests), let numberOfSkipped = Int(_numberOfSkipped), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
            return ExecutedWithSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfSkipped: numberOfSkipped, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case FailingTestCaptureGroup.pattern:
            assert(results.count >= 4)
            guard let file = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2], let reason = results[safe: 3] else { return nil }
            return FailingTestCaptureGroup(file: file, testSuite: testSuite, testCase: testCase, reason: reason)

        case UIFailingTestCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let reason = results[safe: 1] else { return nil }
            return UIFailingTestCaptureGroup(file: file, reason: reason)

        case RestartingTestCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let testSuiteAndTestCase = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2] else { return nil }
            return RestartingTestCaptureGroup(testSuiteAndTestCase: testSuiteAndTestCase, testSuite: testSuite, testCase: testCase)

        case GenerateCoverageDataCaptureGroup.pattern:
            assert(results.count >= 0)
            return GenerateCoverageDataCaptureGroup()

        case GeneratedCoverageReportCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let coverageReportFilePath = results[safe: 0] else { return nil }
            return GeneratedCoverageReportCaptureGroup(coverageReportFilePath: coverageReportFilePath)

        case GenerateDSYMCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let dsym = results[safe: 0], let target = results.last else { return nil }
            return GenerateDSYMCaptureGroup(dsym: dsym, target: target)

        case LibtoolCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let fileName = results[safe: 0], let target = results.last else { return nil }
            return LibtoolCaptureGroup(fileName: fileName, target: target)

        case LinkingCaptureGroup.pattern:
#if os(Linux)
            assert(results.count >= 1)
            guard let target = results[safe: 0] else { return nil }
            return LinkingCaptureGroup(target: target)
#else
            assert(results.count >= 2)
            guard let binaryFileName = results[safe: 0], let target = results.last else { return nil }
            return LinkingCaptureGroup(binaryFilename: binaryFileName.lastPathComponent, target: target)
#endif

        case TestCasePassedCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return nil }
            return TestCasePassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case TestCaseStartedCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return nil }
            return TestCaseStartedCaptureGroup(suite: suite, testCase: testCase)

        case TestCasePendingCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return nil }
            return TestCasePendingCaptureGroup(suite: suite, testCase: testCase)

        case TestCaseMeasuredCaptureGroup.pattern:
            assert(results.count >= 6)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let name = results[safe: 2], let unitName = results[safe: 3], let value = results[safe: 4], let deviation = results[safe: 5] else { return nil }
            return TestCaseMeasuredCaptureGroup(suite: suite, testCase: testCase, name: name, unitName: unitName, value: value, deviation: deviation)

        case ParallelTestCasePassedCaptureGroup.pattern:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return nil }
            return ParallelTestCasePassedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case ParallelTestCaseAppKitPassedCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return nil }
            return ParallelTestCaseAppKitPassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case ParallelTestCaseFailedCaptureGroup.pattern:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return nil }
            return ParallelTestCaseFailedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case ParallelTestingStartedCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingStartedCaptureGroup(device: device)

        case ParallelTestingPassedCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingPassedCaptureGroup(device: device)

        case ParallelTestingFailedCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingFailedCaptureGroup(device: device)

        case ParallelTestSuiteStartedCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let device = results[safe: 1] else { return nil }
            return ParallelTestSuiteStartedCaptureGroup(suite: suite, device: device)

        case PhaseSuccessCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let phase = results[safe: 0] else { return nil }
            return PhaseSuccessCaptureGroup(phase: phase)

        case PhaseScriptExecutionCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let phaseName = results[safe: 0], let target = results.last else { return nil }
            return PhaseScriptExecutionCaptureGroup(phaseName: phaseName, target: target)

        case ProcessPchCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let buildTarget = results.last else { return nil }
            return ProcessPchCaptureGroup(file: file, buildTarget: buildTarget)

        case ProcessPchCommandCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let filePath = results.last else { return nil }
            return ProcessPchCommandCaptureGroup(filePath: filePath)

        case PreprocessCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return nil }
            return PreprocessCaptureGroup(file: file)

        case PbxcpCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return nil }
            return PbxcpCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case ProcessInfoPlistCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1] else { return nil }

            // TODO: Test with target included
            if results.count == 2 {
                // Xcode 9 excludes target output
                return ProcessInfoPlistCaptureGroup(filePath: filePath, filename: fileName, target: nil)
            } else {
                // Xcode 10+ includes target output
                return ProcessInfoPlistCaptureGroup(filePath: filePath, filename: fileName, target: results.last)
            }

        case TestsRunCompletionCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let result = results[safe: 1], let time = results[safe: 2] else { return nil }
            return TestsRunCompletionCaptureGroup(suite: suite, result: result, time: time)

        case TestSuiteStartedCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let time = results[safe: 1] else { return nil }
            return TestSuiteStartedCaptureGroup(suite: suite, time: time)

        case TestSuiteStartCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let testSuiteName = results[safe: 0] else { return nil }
            return TestSuiteStartCaptureGroup(testSuiteName: testSuiteName)

        case TestSuiteAllTestsPassedCaptureGroup.pattern:
            assert(results.count >= 0)
            return TestSuiteAllTestsPassedCaptureGroup()

        case TestSuiteAllTestsFailedCaptureGroup.pattern:
            assert(results.count >= 0)
            return TestSuiteAllTestsFailedCaptureGroup()

        case TIFFutilCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let fileName = results[safe: 0] else { return nil }
            return TIFFutilCaptureGroup(filename: fileName)

        case TouchCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let fileName = results[safe: 1], let target = results.last else { return nil }
            return TouchCaptureGroup(filename: fileName, target: target)

        case WriteFileCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let filePath = results[safe: 0] else { return nil }
            return WriteFileCaptureGroup(filePath: filePath)

        case WriteAuxiliaryFilesCaptureGroup.pattern:
            assert(results.count >= 0)
            return WriteAuxiliaryFilesCaptureGroup()

        case CompileWarningCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let reason = results[safe: 2] else { return nil }
            return CompileWarningCaptureGroup(filePath: filePath, filename: fileName, reason: reason)

        case LDWarningCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let ldPrefix = results[safe: 0], let warningMessage = results[safe: 1] else { return nil }
            return LDWarningCaptureGroup(ldPrefix: ldPrefix, warningMessage: warningMessage)

        case GenericWarningCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return nil }
            return GenericWarningCaptureGroup(wholeWarning: wholeWarning)

        case WillNotBeCodeSignedCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return nil }
            return WillNotBeCodeSignedCaptureGroup(wholeWarning: wholeWarning)

        case DuplicateLocalizedStringKeyCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeMessage = results[safe: 0] else { return nil }
            return DuplicateLocalizedStringKeyCaptureGroup(warningMessage: wholeMessage)

        case ClangErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ClangErrorCaptureGroup(wholeError: wholeError)

        case CheckDependenciesErrorsCaptureGroup.pattern:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case ProvisioningProfileRequiredCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ProvisioningProfileRequiredCaptureGroup(wholeError: wholeError)

        case NoCertificateCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return NoCertificateCaptureGroup(wholeError: wholeError)

        case CompileErrorCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let isFatalError = results[safe: 1], let reason = results[safe: 2] else { return nil }
            return CompileErrorCaptureGroup(filePath: filePath, isFatalError: isFatalError, reason: reason)

        case CursorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let cursor = results[safe: 0] else { return nil }
            return CursorCaptureGroup(cursor: cursor)

        case FatalErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return FatalErrorCaptureGroup(wholeError: wholeError)

        case FileMissingErrorCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let reason = results[safe: 0], let filePath = results[safe: 1] else { return nil }
            return FileMissingErrorCaptureGroup(reason: reason, filePath: filePath)

        case LDErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return LDErrorCaptureGroup(wholeError: wholeError)

        case LinkerDuplicateSymbolsLocationCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return LinkerDuplicateSymbolsLocationCaptureGroup(wholeError: wholeError)

        case LinkerDuplicateSymbolsCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)

        case LinkerUndefinedSymbolLocationCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case LinkerUndefinedSymbolsCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case PodsErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return PodsErrorCaptureGroup(wholeError: wholeError)

        case SymbolReferencedFromCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let reference = results[safe: 0] else { return nil }
            return SymbolReferencedFromCaptureGroup(reference: reference)

        case ModuleIncludesErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ModuleIncludesErrorCaptureGroup(wholeError: wholeError)

        case UndefinedSymbolLocationCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let target = results[safe: 0], let fileName = results[safe: 1] else { return nil }
            return UndefinedSymbolLocationCaptureGroup(target: target, filename: fileName)

        case PackageFetchingCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return nil }
            return PackageFetchingCaptureGroup(source: source)

        case PackageUpdatingCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return nil }
            return PackageUpdatingCaptureGroup(source: source)

        case PackageCheckingOutCaptureGroup.pattern:
            assert(results.count >= 2)
            guard let version = results[safe: 0], let package = results[safe: 1] else { return nil }
            return PackageCheckingOutCaptureGroup(version: version, package: package)

        case PackageGraphResolvingStartCaptureGroup.pattern:
            assert(results.count >= 0)
            return PackageGraphResolvingStartCaptureGroup()

        case PackageGraphResolvingEndedCaptureGroup.pattern:
            assert(results.count >= 0)
            return PackageGraphResolvingEndedCaptureGroup()

        case PackageGraphResolvedItemCaptureGroup.pattern:
            assert(results.count >= 3)
            guard let packageName = results[safe: 0], let packageURL = results[safe: 1], let packageVersion = results[safe: 2] else { return nil }
            return PackageGraphResolvedItemCaptureGroup(packageName: packageName, packageURL: packageURL, packageVersion: packageVersion)

        case XcodebuildErrorCaptureGroup.pattern:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return XcodebuildErrorCaptureGroup(wholeError: wholeError)

        default:
            assertionFailure()
            return nil
        }
    }
}
