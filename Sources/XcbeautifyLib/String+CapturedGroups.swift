import Foundation

extension String {
    private func captureGroup(with pattern: Pattern) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern.rawValue, options: [.caseInsensitive])
        } catch {
            return results
        }

        let matches = regex.matches(in: self, range: NSRange(location:0, length: self.utf16.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            guard let matchedString = substring(with: capturedGroupIndex) else { continue }
            results.append(matchedString)
        }

        return results
    }
}

extension String {
    func captureGroup(with pattern: Pattern) -> CaptureGroup {
        let results: [String] = captureGroup(with: pattern)

        switch pattern {
        case .analyze:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return AnalyzeCaptureGroup(filePath: filePath, fileName: fileName, target: target)

        case .buildTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return BuildTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case .aggregateTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return AggregateTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case .analyzeTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return AnalyzeTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case .checkDependencies:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case .shellCommand:
            assert(results.count >= 2)
            guard let commandPath = results[safe: 0], let arguments = results[safe: 1] else { return EmptyCaptureGroup() }
            return ShellCommandCaptureGroup(commandPath: commandPath, arguments: arguments)

        case .cleanRemove:
            assert(results.count >= 1)
            guard let directory = results[safe: 0] else { return EmptyCaptureGroup() }
            return CleanRemoveCaptureGroup(directory: directory.lastPathComponent)

        case .cleanTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return CleanTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case .codesign:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return CodesignCaptureGroup(file: file)

        case .codesignFramework:
            assert(results.count >= 1)
            guard let frameworkPath = results[safe: 0] else { return EmptyCaptureGroup() }
            return CodesignFrameworkCaptureGroup(frameworkPath: frameworkPath)

        case .compile:
#if os(Linux)
            assert(results.count >= 2)
            guard let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return CompileCaptureGroup(filename: fileName, target: target)
#else
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return CompileCaptureGroup(filePath: filePath, filename: fileName, target: target)
#endif

        case .compileCommand:
            assert(results.count >= 2)
            guard let compilerCommand = results[safe: 0], let filePath = results[safe: 1] else { return EmptyCaptureGroup() }
            return CompileCommandCaptureGroup(compilerCommand: compilerCommand, filePath: filePath)

        case .compileXib:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return CompileXibCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case .compileStoryboard:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return CompileStoryboardCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case .copyHeader:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return CopyHeaderCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case .copyPlist:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return CopyPlistCaptureGroup(file: file.lastPathComponent, target: target)

        case .copyStrings:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return CopyStringsCaptureGroup(file: file.lastPathComponent, target: target)

        case .cpresource:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return CpresourceCaptureGroup(file: file.lastPathComponent, target: target)

        case .executed:
            assert(results.count >= 4)
            guard let _numberOfTests = results[safe: 0], let _numberOfFailures = results[safe: 1], let _numberOfUnexpectedFailures = results[safe: 2], let _wallClockTimeInSeconds = results[safe: 3] else { return EmptyCaptureGroup() }
            guard let numberOfTests = Int(_numberOfTests), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return EmptyCaptureGroup() }
            return ExecutedWithoutSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case .executedWithSkipped:
            assert(results.count >= 5)
            guard let _numberOfTests = results[safe: 0], let _numberOfSkipped = results[safe: 1], let _numberOfFailures = results[safe: 2], let _numberOfUnexpectedFailures = results[safe: 3], let _wallClockTimeInSeconds = results[safe: 4] else { return EmptyCaptureGroup() }
            guard let numberOfTests = Int(_numberOfTests), let numberOfSkipped = Int(_numberOfSkipped), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return EmptyCaptureGroup() }
            return ExecutedWithSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfSkipped: numberOfSkipped, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case .failingTest:
            assert(results.count >= 4)
            guard let file = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2], let reason = results[safe: 3] else { return EmptyCaptureGroup() }
            return FailingTestCaptureGroup(file: file, testSuite: testSuite, testCase: testCase, reason: reason)

        case .uiFailingTest:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let reason = results[safe: 1] else { return EmptyCaptureGroup() }
            return UIFailingTestCaptureGroup(file: file, reason: reason)

        case .restartingTest:
            assert(results.count >= 3)
            guard let testSuiteAndTestCase = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2] else { return EmptyCaptureGroup() }
            return RestartingTestCaptureGroup(testSuiteAndTestCase: testSuiteAndTestCase, testSuite: testSuite, testCase: testCase)

        case .generateCoverageData:
            assert(results.count >= 0)
            return GenerateCoverageDataCaptureGroup()

        case .generatedCoverageReport:
            assert(results.count >= 1)
            guard let coverageReportFilePath = results[safe: 0] else { return EmptyCaptureGroup() }
            return GeneratedCoverageReportCaptureGroup(coverageReportFilePath: coverageReportFilePath)

        case .generateDsym:
            assert(results.count >= 2)
            guard let dsym = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return GenerateDSYMCaptureGroup(dsym: dsym, target: target)

        case .libtool:
            assert(results.count >= 2)
            guard let fileName = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return LibtoolCaptureGroup(fileName: fileName, target: target)

        case .linking:
#if os(Linux)
            assert(results.count >= 1)
            guard let target = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkingCaptureGroup(target: target)
#else
            assert(results.count >= 2)
            guard let binaryFileName = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return LinkingCaptureGroup(binaryFilename: binaryFileName.lastPathComponent, target: target)
#endif

        case .testCasePassed:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return TestCasePassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case .testCaseStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestCaseStartedCaptureGroup(suite: suite, testCase: testCase)

        case .testCasePending:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestCasePendingCaptureGroup(suite: suite, testCase: testCase)

        case .testCaseMeasured:
            assert(results.count >= 6)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let name = results[safe: 2], let unitName = results[safe: 3], let value = results[safe: 4], let deviation = results[safe: 5] else { return EmptyCaptureGroup() }
            return TestCaseMeasuredCaptureGroup(suite: suite, testCase: testCase, name: name, unitName: unitName, value: value, deviation: deviation)

        case .parallelTestCasePassed:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return EmptyCaptureGroup() }
            return ParallelTestCasePassedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case .parallelTestCaseAppKitPassed:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return ParallelTestCaseAppKitPassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case .parallelTestCaseFailed:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return EmptyCaptureGroup() }
            return ParallelTestCaseFailedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case .parallelTestingStarted:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingStartedCaptureGroup(device: device)

        case .parallelTestingPassed:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingPassedCaptureGroup(device: device)

        case .parallelTestingFailed:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingFailedCaptureGroup(device: device)

        case .parallelTestSuiteStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let device = results[safe: 1] else { return EmptyCaptureGroup() }
            return ParallelTestSuiteStartedCaptureGroup(suite: suite, device: device)

        case .phaseSuccess:
            assert(results.count >= 1)
            guard let phase = results[safe: 0] else { return EmptyCaptureGroup() }
            return PhaseSuccessCaptureGroup(phase: phase)

        case .phaseScriptExecution:
            assert(results.count >= 2)
            guard let phaseName = results[safe: 0], let target = results.last else { return EmptyCaptureGroup() }
            return PhaseScriptExecutionCaptureGroup(phaseName: phaseName, target: target)

        case .processPch:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let buildTarget = results.last else { return EmptyCaptureGroup() }
            return ProcessPchCaptureGroup(file: file, buildTarget: buildTarget)

        case .processPchCommand:
            assert(results.count >= 1)
            guard let filePath = results.last else { return EmptyCaptureGroup() }
            return ProcessPchCommandCaptureGroup(filePath: filePath)

        case .preprocess:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return PreprocessCaptureGroup(file: file)

        case .pbxcp:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return PbxcpCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case .processInfoPlist:
            assert(results.count >= 2)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1] else { return EmptyCaptureGroup() }

            // TODO: Test with target included
            if results.count == 2 {
                // Xcode 9 excludes target output
                return ProcessInfoPlistCaptureGroup(filePath: filePath, filename: fileName, target: nil)
            } else {
                // Xcode 10+ includes target output
                return ProcessInfoPlistCaptureGroup(filePath: filePath, filename: fileName, target: results.last)
            }

        case .testsRunCompletion:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let result = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return TestsRunCompletionCaptureGroup(suite: suite, result: result, time: time)

        case .testSuiteStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let time = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestSuiteStartedCaptureGroup(suite: suite, time: time)

        case .testSuiteStart:
            assert(results.count >= 1)
            guard let testSuiteName = results[safe: 0] else { return EmptyCaptureGroup() }
            return TestSuiteStartCaptureGroup(testSuiteName: testSuiteName)

        case .testSuiteAllTestsPassed:
            assert(results.count >= 0)
            return TestSuiteAllTestsPassedCaptureGroup()

        case .testSuiteAllTestsFailed:
            assert(results.count >= 0)
            return TestSuiteAllTestsFailedCaptureGroup()

        case .tiffutil:
            assert(results.count >= 1)
            guard let fileName = results[safe: 0] else { return EmptyCaptureGroup() }
            return TIFFutilCaptureGroup(filename: fileName)

        case .touch:
            assert(results.count >= 3)
            guard let fileName = results[safe: 1], let target = results.last else { return EmptyCaptureGroup() }
            return TouchCaptureGroup(filename: fileName, target: target)

        case .writeFile:
            assert(results.count >= 1)
            guard let filePath = results[safe: 0] else { return EmptyCaptureGroup() }
            return WriteFileCaptureGroup(filePath: filePath)

        case .writeAuxiliaryFiles:
            assert(results.count >= 0)
            return WriteAuxiliaryFilesCaptureGroup()

        case .compileWarning:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let reason = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileWarningCaptureGroup(filePath: filePath, filename: fileName, reason: reason)

        case .ldWarning:
            assert(results.count >= 2)
            guard let ldPrefix = results[safe: 0], let warningMessage = results[safe: 1] else { return EmptyCaptureGroup() }
            return LDWarningCaptureGroup(ldPrefix: ldPrefix, warningMessage: warningMessage)

        case .genericWarning:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return EmptyCaptureGroup() }
            return GenericWarningCaptureGroup(wholeWarning: wholeWarning)

        case .willNotBeCodeSigned:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return EmptyCaptureGroup() }
            return WillNotBeCodeSignedCaptureGroup(wholeWarning: wholeWarning)

        case .duplicateLocalizedStringKey:
            assert(results.count >= 1)
            guard let wholeMessage = results[safe: 0] else { return EmptyCaptureGroup() }
            return DuplicateLocalizedStringKeyCaptureGroup(warningMessage: wholeMessage)

        case .clangError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return ClangErrorCaptureGroup(wholeError: wholeError)

        case .checkDependenciesErrors:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case .provisioningProfileRequired:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return ProvisioningProfileRequiredCaptureGroup(wholeError: wholeError)

        case .noCertificate:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return NoCertificateCaptureGroup(wholeError: wholeError)

        case .compileError:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let isFatalError = results[safe: 1], let reason = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileErrorCaptureGroup(filePath: filePath, isFatalError: isFatalError, reason: reason)

        case .cursor:
            assert(results.count >= 1)
            guard let cursor = results[safe: 0] else { return EmptyCaptureGroup() }
            return CursorCaptureGroup(cursor: cursor)

        case .fatalError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return FatalErrorCaptureGroup(wholeError: wholeError)

        case .fileMissingError:
            assert(results.count >= 2)
            guard let reason = results[safe: 0], let filePath = results[safe: 1] else { return EmptyCaptureGroup() }
            return FileMissingErrorCaptureGroup(reason: reason, filePath: filePath)

        case .ldError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return LDErrorCaptureGroup(wholeError: wholeError)

        case .linkerDuplicateSymbolsLocation:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)

        case .linkerDuplicateSymbols:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)

        case .linkerUndefinedSymbolLocation:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case .linkerUndefinedSymbols:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case .podsError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return PodsErrorCaptureGroup(wholeError: wholeError)

        case .symbolReferencedFrom:
            assert(results.count >= 1)
            guard let reference = results[safe: 0] else { return EmptyCaptureGroup() }
            return SymbolReferencedFromCaptureGroup(reference: reference)

        case .moduleIncludesError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return ModuleIncludesErrorCaptureGroup(wholeError: wholeError)

        case .undefinedSymbolLocation:
            assert(results.count >= 2)
            guard let target = results[safe: 0], let fileName = results[safe: 1] else { return EmptyCaptureGroup() }
            return UndefinedSymbolLocationCaptureGroup(target: target, filename: fileName)

        case .packageFetching:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return EmptyCaptureGroup() }
            return PackageFetchingCaptureGroup(source: source)

        case .packageUpdating:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return EmptyCaptureGroup() }
            return PackageUpdatingCaptureGroup(source: source)

        case .packageCheckingOut:
            assert(results.count >= 2)
            guard let version = results[safe: 0], let package = results[safe: 1] else { return EmptyCaptureGroup() }
            return PackageCheckingOutCaptureGroup(version: version, package: package)

        case .packageGraphResolvingStart:
            assert(results.count >= 0)
            return PackageGraphResolvingStartCaptureGroup()

        case .packageGraphResolvingEnded:
            assert(results.count >= 0)
            return PackageGraphResolvingEndedCaptureGroup()

        case .packageGraphResolvedItem:
            assert(results.count >= 3)
            guard let packageName = results[safe: 0], let packageURL = results[safe: 1], let packageVersion = results[safe: 2] else { return EmptyCaptureGroup() }
            return PackageGraphResolvedItemCaptureGroup(packageName: packageName, packageURL: packageURL, packageVersion: packageVersion)

        case .xcodebuildError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return XcodebuildErrorCaptureGroup(wholeError: wholeError)
        }
    }
}
