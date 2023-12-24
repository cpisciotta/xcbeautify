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
        case Pattern.analyze:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return AnalyzeCaptureGroup(filePath: filePath, fileName: fileName, target: target)

        case Pattern.buildTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return BuildTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case Pattern.aggregateTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return AggregateTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case Pattern.analyzeTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return AnalyzeTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case Pattern.checkDependencies:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case Pattern.shellCommand:
            assert(results.count >= 2)
            guard let commandPath = results[safe: 0], let arguments = results[safe: 1] else { return nil }
            return ShellCommandCaptureGroup(commandPath: commandPath, arguments: arguments)

        case Pattern.cleanRemove:
            assert(results.count >= 1)
            guard let directory = results[safe: 0] else { return nil }
            return CleanRemoveCaptureGroup(directory: directory.lastPathComponent)

        case Pattern.cleanTarget:
            assert(results.count >= 3)
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return nil }
            return CleanTargetCaptureGroup(target: target, project: project, configuration: configuration)

        case Pattern.codesign:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return nil }
            return CodesignCaptureGroup(file: file)

        case Pattern.codesignFramework:
            assert(results.count >= 1)
            guard let frameworkPath = results[safe: 0] else { return nil }
            return CodesignFrameworkCaptureGroup(frameworkPath: frameworkPath)

        case Pattern.compile:
#if os(Linux)
            assert(results.count >= 2)
            guard let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileCaptureGroup(filename: fileName, target: target)
#else
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileCaptureGroup(filePath: filePath, filename: fileName, target: target)
#endif

        case Pattern.compileCommand:
            assert(results.count >= 2)
            guard let compilerCommand = results[safe: 0], let filePath = results[safe: 1] else { return nil }
            return CompileCommandCaptureGroup(compilerCommand: compilerCommand, filePath: filePath)

        case Pattern.compileXib:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileXibCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case Pattern.compileStoryboard:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results.last else { return nil }
            return CompileStoryboardCaptureGroup(filePath: filePath, filename: fileName, target: target)

        case Pattern.copyHeader:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return nil }
            return CopyHeaderCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case Pattern.copyPlist:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CopyPlistCaptureGroup(file: file.lastPathComponent, target: target)

        case Pattern.copyStrings:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CopyStringsCaptureGroup(file: file.lastPathComponent, target: target)

        case Pattern.cpresource:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let target = results.last else { return nil }
            return CpresourceCaptureGroup(file: file.lastPathComponent, target: target)

        case Pattern.executedWithoutSkipped:
            assert(results.count >= 4)
            guard let _numberOfTests = results[safe: 0], let _numberOfFailures = results[safe: 1], let _numberOfUnexpectedFailures = results[safe: 2], let _wallClockTimeInSeconds = results[safe: 3] else { return nil }
            guard let numberOfTests = Int(_numberOfTests), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
            return ExecutedWithoutSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case Pattern.executedWithSkipped:
            assert(results.count >= 5)
            guard let _numberOfTests = results[safe: 0], let _numberOfSkipped = results[safe: 1], let _numberOfFailures = results[safe: 2], let _numberOfUnexpectedFailures = results[safe: 3], let _wallClockTimeInSeconds = results[safe: 4] else { return nil }
            guard let numberOfTests = Int(_numberOfTests), let numberOfSkipped = Int(_numberOfSkipped), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
            return ExecutedWithSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfSkipped: numberOfSkipped, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)

        case Pattern.failingTest:
            assert(results.count >= 4)
            guard let file = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2], let reason = results[safe: 3] else { return nil }
            return FailingTestCaptureGroup(file: file, testSuite: testSuite, testCase: testCase, reason: reason)

        case Pattern.uiFailingTest:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let reason = results[safe: 1] else { return nil }
            return UIFailingTestCaptureGroup(file: file, reason: reason)

        case Pattern.restartingTest:
            assert(results.count >= 3)
            guard let testSuiteAndTestCase = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2] else { return nil }
            return RestartingTestCaptureGroup(testSuiteAndTestCase: testSuiteAndTestCase, testSuite: testSuite, testCase: testCase)

        case Pattern.generateCoverageData:
            assert(results.count >= 0)
            return GenerateCoverageDataCaptureGroup()

        case Pattern.generatedCoverageReport:
            assert(results.count >= 1)
            guard let coverageReportFilePath = results[safe: 0] else { return nil }
            return GeneratedCoverageReportCaptureGroup(coverageReportFilePath: coverageReportFilePath)

        case Pattern.generateDsym:
            assert(results.count >= 2)
            guard let dsym = results[safe: 0], let target = results.last else { return nil }
            return GenerateDSYMCaptureGroup(dsym: dsym, target: target)

        case Pattern.libtool:
            assert(results.count >= 2)
            guard let fileName = results[safe: 0], let target = results.last else { return nil }
            return LibtoolCaptureGroup(fileName: fileName, target: target)

        case Pattern.linking:
#if os(Linux)
            assert(results.count >= 1)
            guard let target = results[safe: 0] else { return nil }
            return LinkingCaptureGroup(target: target)
#else
            assert(results.count >= 2)
            guard let binaryFileName = results[safe: 0], let target = results.last else { return nil }
            return LinkingCaptureGroup(binaryFilename: binaryFileName.lastPathComponent, target: target)
#endif

        case Pattern.testCasePassed:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return nil }
            return TestCasePassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case Pattern.testCaseStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return nil }
            return TestCaseStartedCaptureGroup(suite: suite, testCase: testCase)

        case Pattern.testCasePending:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return nil }
            return TestCasePendingCaptureGroup(suite: suite, testCase: testCase)

        case Pattern.testCaseMeasured:
            assert(results.count >= 6)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let name = results[safe: 2], let unitName = results[safe: 3], let value = results[safe: 4], let deviation = results[safe: 5] else { return nil }
            return TestCaseMeasuredCaptureGroup(suite: suite, testCase: testCase, name: name, unitName: unitName, value: value, deviation: deviation)

        case Pattern.parallelTestCasePassed:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return nil }
            return ParallelTestCasePassedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case Pattern.parallelTestCaseAppKitPassed:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return nil }
            return ParallelTestCaseAppKitPassedCaptureGroup(suite: suite, testCase: testCase, time: time)

        case Pattern.parallelTestCaseFailed:
            assert(results.count >= 4)
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let device = results[safe: 2], let time = results[safe: 3] else { return nil }
            return ParallelTestCaseFailedCaptureGroup(suite: suite, testCase: testCase, device: device, time: time)

        case Pattern.parallelTestingStarted:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingStartedCaptureGroup(device: device)

        case Pattern.parallelTestingPassed:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingPassedCaptureGroup(device: device)

        case Pattern.parallelTestingFailed:
            assert(results.count >= 1)
            guard let device = results[safe: 0] else { return nil }
            return ParallelTestingFailedCaptureGroup(device: device)

        case Pattern.parallelTestSuiteStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let device = results[safe: 1] else { return nil }
            return ParallelTestSuiteStartedCaptureGroup(suite: suite, device: device)

        case Pattern.phaseSuccess:
            assert(results.count >= 1)
            guard let phase = results[safe: 0] else { return nil }
            return PhaseSuccessCaptureGroup(phase: phase)

        case Pattern.phaseScriptExecution:
            assert(results.count >= 2)
            guard let phaseName = results[safe: 0], let target = results.last else { return nil }
            return PhaseScriptExecutionCaptureGroup(phaseName: phaseName, target: target)

        case Pattern.processPch:
            assert(results.count >= 2)
            guard let file = results[safe: 0], let buildTarget = results.last else { return nil }
            return ProcessPchCaptureGroup(file: file, buildTarget: buildTarget)

        case Pattern.processPchCommand:
            assert(results.count >= 1)
            guard let filePath = results.last else { return nil }
            return ProcessPchCommandCaptureGroup(filePath: filePath)

        case Pattern.preprocess:
            assert(results.count >= 1)
            guard let file = results[safe: 0] else { return nil }
            return PreprocessCaptureGroup(file: file)

        case Pattern.pbxcp:
            assert(results.count >= 3)
            guard let file = results[safe: 0], let targetFile = results[safe: 1], let target = results.last else { return nil }
            return PbxcpCaptureGroup(file: file.lastPathComponent, targetFile: targetFile, target: target)

        case Pattern.processInfoPlist:
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

        case Pattern.testsRunCompletion:
            assert(results.count >= 3)
            guard let suite = results[safe: 0], let result = results[safe: 1], let time = results[safe: 2] else { return nil }
            return TestsRunCompletionCaptureGroup(suite: suite, result: result, time: time)

        case Pattern.testSuiteStarted:
            assert(results.count >= 2)
            guard let suite = results[safe: 0], let time = results[safe: 1] else { return nil }
            return TestSuiteStartedCaptureGroup(suite: suite, time: time)

        case Pattern.testSuiteStart:
            assert(results.count >= 1)
            guard let testSuiteName = results[safe: 0] else { return nil }
            return TestSuiteStartCaptureGroup(testSuiteName: testSuiteName)

        case Pattern.testSuiteAllTestsPassed:
            assert(results.count >= 0)
            return TestSuiteAllTestsPassedCaptureGroup()

        case Pattern.testSuiteAllTestsFailed:
            assert(results.count >= 0)
            return TestSuiteAllTestsFailedCaptureGroup()

        case Pattern.tiffutil:
            assert(results.count >= 1)
            guard let fileName = results[safe: 0] else { return nil }
            return TIFFutilCaptureGroup(filename: fileName)

        case Pattern.touch:
            assert(results.count >= 3)
            guard let fileName = results[safe: 1], let target = results.last else { return nil }
            return TouchCaptureGroup(filename: fileName, target: target)

        case Pattern.writeFile:
            assert(results.count >= 1)
            guard let filePath = results[safe: 0] else { return nil }
            return WriteFileCaptureGroup(filePath: filePath)

        case Pattern.writeAuxiliaryFiles:
            assert(results.count >= 0)
            return WriteAuxiliaryFilesCaptureGroup()

        case Pattern.compileWarning:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let reason = results[safe: 2] else { return nil }
            return CompileWarningCaptureGroup(filePath: filePath, filename: fileName, reason: reason)

        case Pattern.ldWarning:
            assert(results.count >= 2)
            guard let ldPrefix = results[safe: 0], let warningMessage = results[safe: 1] else { return nil }
            return LDWarningCaptureGroup(ldPrefix: ldPrefix, warningMessage: warningMessage)

        case Pattern.genericWarning:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return nil }
            return GenericWarningCaptureGroup(wholeWarning: wholeWarning)

        case Pattern.willNotBeCodeSigned:
            assert(results.count >= 1)
            guard let wholeWarning = results[safe: 0] else { return nil }
            return WillNotBeCodeSignedCaptureGroup(wholeWarning: wholeWarning)

        case Pattern.duplicateLocalizedStringKey:
            assert(results.count >= 1)
            guard let wholeMessage = results[safe: 0] else { return nil }
            return DuplicateLocalizedStringKeyCaptureGroup(warningMessage: wholeMessage)

        case Pattern.clangError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ClangErrorCaptureGroup(wholeError: wholeError)

        case Pattern.checkDependenciesErrors:
            assert(results.count >= 0)
            return CheckDependenciesCaptureGroup()

        case Pattern.provisioningProfileRequired:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ProvisioningProfileRequiredCaptureGroup(wholeError: wholeError)

        case Pattern.noCertificate:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return NoCertificateCaptureGroup(wholeError: wholeError)

        case Pattern.compileError:
            assert(results.count >= 3)
            guard let filePath = results[safe: 0], let isFatalError = results[safe: 1], let reason = results[safe: 2] else { return nil }
            return CompileErrorCaptureGroup(filePath: filePath, isFatalError: isFatalError, reason: reason)

        case Pattern.cursor:
            assert(results.count >= 1)
            guard let cursor = results[safe: 0] else { return nil }
            return CursorCaptureGroup(cursor: cursor)

        case Pattern.fatalError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return FatalErrorCaptureGroup(wholeError: wholeError)

        case Pattern.fileMissingError:
            assert(results.count >= 2)
            guard let reason = results[safe: 0], let filePath = results[safe: 1] else { return nil }
            return FileMissingErrorCaptureGroup(reason: reason, filePath: filePath)

        case Pattern.ldError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return LDErrorCaptureGroup(wholeError: wholeError)

        case Pattern.linkerDuplicateSymbolsLocation:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return LinkerDuplicateSymbolsLocationCaptureGroup(wholeError: wholeError)

        case Pattern.linkerDuplicateSymbols:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)

        case Pattern.linkerUndefinedSymbolLocation:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case Pattern.linkerUndefinedSymbols:
            assert(results.count >= 1)
            guard let reason = results[safe: 0] else { return nil }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)

        case Pattern.podsError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return PodsErrorCaptureGroup(wholeError: wholeError)

        case Pattern.symbolReferencedFrom:
            assert(results.count >= 1)
            guard let reference = results[safe: 0] else { return nil }
            return SymbolReferencedFromCaptureGroup(reference: reference)

        case Pattern.moduleIncludesError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return ModuleIncludesErrorCaptureGroup(wholeError: wholeError)

        case Pattern.undefinedSymbolLocation:
            assert(results.count >= 2)
            guard let target = results[safe: 0], let fileName = results[safe: 1] else { return nil }
            return UndefinedSymbolLocationCaptureGroup(target: target, filename: fileName)

        case Pattern.packageFetching:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return nil }
            return PackageFetchingCaptureGroup(source: source)

        case Pattern.packageUpdating:
            assert(results.count >= 1)
            guard let source = results[safe: 0] else { return nil }
            return PackageUpdatingCaptureGroup(source: source)

        case Pattern.packageCheckingOut:
            assert(results.count >= 2)
            guard let version = results[safe: 0], let package = results[safe: 1] else { return nil }
            return PackageCheckingOutCaptureGroup(version: version, package: package)

        case Pattern.packageGraphResolvingStart:
            assert(results.count >= 0)
            return PackageGraphResolvingStartCaptureGroup()

        case Pattern.packageGraphResolvingEnded:
            assert(results.count >= 0)
            return PackageGraphResolvingEndedCaptureGroup()

        case Pattern.packageGraphResolvedItem:
            assert(results.count >= 3)
            guard let packageName = results[safe: 0], let packageURL = results[safe: 1], let packageVersion = results[safe: 2] else { return nil }
            return PackageGraphResolvedItemCaptureGroup(packageName: packageName, packageURL: packageURL, packageVersion: packageVersion)

        case Pattern.xcodebuildError:
            assert(results.count >= 1)
            guard let wholeError = results[safe: 0] else { return nil }
            return XcodebuildErrorCaptureGroup(wholeError: wholeError)

        default:
            assertionFailure()
            return nil
        }
    }
}
