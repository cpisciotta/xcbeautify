import Foundation

extension String {
    func capturedGroups(with pattern: Pattern) -> [String] {
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
    func capturedGroups(with pattern: Pattern) -> CaptureGroup {
        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern.rawValue, options: [.caseInsensitive])
        } catch {
            return EmptyCaptureGroup()
        }

        let matches = regex.matches(in: self, range: NSRange(location:0, length: self.utf16.count))

        guard let match = matches.first else { return EmptyCaptureGroup() }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return EmptyCaptureGroup() }

        var results = [String]()

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            guard let matchedString = substring(with: capturedGroupIndex) else { continue }
            results.append(matchedString)
        }

        switch pattern {
        case .analyze:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1] else { return EmptyCaptureGroup() }
            return AnalyzeCaptureGroup(filePath: filePath, fileName: fileName)
        case .buildTarget:
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return BuildTargetCaptureGroup(target: target, project: project, configuration: configuration)
        case .aggregateTarget:
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return AggregateTargetCaptureGroup(target: target, project: project, configuration: configuration)
        case .analyzeTarget:
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return AnalyzeTargetCaptureGroup(target: target, project: project, configuration: configuration)
        case .checkDependencies:
            return CheckDependenciesCaptureGroup()
        case .shellCommand:
            guard let commandPath = results[safe: 0], let arguments = results[safe: 1] else { return EmptyCaptureGroup() }
            return ShellCommandCaptureGroup(commandPath: commandPath, arguments: arguments)
        case .cleanRemove:
            return CleanRemoveCaptureGroup()
        case .cleanTarget:
            guard let target = results[safe: 0], let project = results[safe: 1], let configuration = results[safe: 2] else { return EmptyCaptureGroup() }
            return CleanTargetCaptureGroup(target: target, project: project, configuration: configuration)
        case .codesign:
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return CodesignCaptureGroup(file: file)
        case .codesignFramework:
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return CodesignFrameworkCaptureGroup(file: file)
#if os(Linux)
        case .compile:
            guard let fileName = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return CompileCaptureGroup(filename: fileName, target: target)
#else
        case .compile:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileCaptureGroup(filePath: filePath, filename: fileName, target: target)
#endif
        case .compileCommand:
            guard let compilerCommand = results[safe: 0], let filePath = results[safe: 1] else { return EmptyCaptureGroup() }
            return CompileCommandCaptureGroup(compilerCommand: compilerCommand, filePath: filePath)
        case .compileXib:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileXibCaptureGroup(filePath: filePath, filename: fileName, target: target)
        case .compileStoryboard:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileStoryboardCaptureGroup(filePath: filePath, filename: fileName, target: target)
        case .copyHeader:
            guard let sourceFile = results[safe: 0], let targetFile = results[safe: 1], let target = results[safe: 2] else { return EmptyCaptureGroup() }
            return CopyHeaderCaptureGroup(sourceFile: sourceFile, targetFile: targetFile, target: target)
        case .copyPlist:
            guard let sourceFile = results[safe: 0], let targetFile = results[safe: 1] else { return EmptyCaptureGroup() }
            return CopyPlistCaptureGroup(sourceFile: sourceFile, targetFile: targetFile)
        case .copyStrings:
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return CopyStringsCaptureGroup(file: file)
        case .cpresource:
            guard let resource = results[safe: 0] else { return EmptyCaptureGroup() }
            return CpresourceCaptureGroup(resource: resource)
        case .executed:
            guard let numberOfTests = results[safe: 0], let numberOfFailures = results[safe: 1], let numberOfUnexpectedFailures = results[safe: 2], let wallClockTimeInSeconds = results[safe: 3] else { return EmptyCaptureGroup() }
            return ExecutedCaptureGroup(numberOfTests: numberOfTests, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)
        case .executedWithSkipped:
            guard let numberOfTests = results[safe: 0], let numberOfSkipped = results[safe: 1], let numberOfFailures = results[safe: 2], let numberOfUnexpectedFailures = results[safe: 3], let wallClockTimeInSeconds = results[safe: 4] else { return EmptyCaptureGroup() }
            return ExecutedWithSkippedCaptureGroup(numberOfTests: numberOfTests, numberOfSkipped: numberOfSkipped, numberOfFailures: numberOfFailures, numberOfUnexpectedFailures: numberOfUnexpectedFailures, wallClockTimeInSeconds: wallClockTimeInSeconds)
        case .failingTest:
            guard let file = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2], let reason = results[safe: 3] else { return EmptyCaptureGroup() }
            return FailingTestCaptureGroup(file: file, testSuite: testSuite, testCase: testCase, reason: reason)
        case .uiFailingTest:
            guard let file = results[safe: 0], let reason = results[safe: 1] else { return EmptyCaptureGroup() }
            return UIFailingTestCaptureGroup(file: file, reason: reason)
        case .restartingTest:
            guard let testSuiteAndTestCase = results[safe: 0], let testSuite = results[safe: 1], let testCase = results[safe: 2] else { return EmptyCaptureGroup() }
            return RestartingTestCaptureGroup(testSuiteAndTestCase: testSuiteAndTestCase, testSuite: testSuite, testCase: testCase)
        case .generateCoverageData:
            return GenerateCoverageDataCaptureGroup()
        case .generatedCoverageReport:
            guard let coverageReportFilePath = results[safe: 0] else { return EmptyCaptureGroup() }
            return GeneratedCoverageReportCaptureGroup(coverageReportFilePath: coverageReportFilePath)
        case .generateDsym:
            guard let dsym = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return GenerateDSYMCaptureGroup(dsym: dsym, target: target)
        case .libtool:
            guard let library = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return LibtoolCaptureGroup(library: library, target: target)
#if os(Linux)
        case .linking:
            guard let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return LinkingCaptureGroup(target: target)
#else
        case .linking:
            guard let binaryFileName = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return LinkingCaptureGroup(binaryFilename: binaryFileName, target: target)
#endif
        case .testCasePassed:
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return TestCasePassedCaptureGroup(suite: suite, testCase: testCase, time: time)
        case .testCaseStarted:
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestCaseStartedCaptureGroup(suite: suite, testCase: testCase)
        case .testCasePending:
            guard let suite = results[safe: 0], let testCase = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestCasePendingCaptureGroup(suite: suite, testCase: testCase)
        case .testCaseMeasured:
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return TestCaseMeasuredCaptureGroup(suite: suite, testCase: testCase, time: time)
        case .parallelTestCasePassed:
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingPassedCaptureGroup(device: device)
        case .parallelTestCaseAppKitPassed:
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return ParallelTestCaseAppKitPassedCaptureGroup(suite: suite, testCase: testCase, time: time)
        case .parallelTestCaseFailed:
            guard let suite = results[safe: 0], let testCase = results[safe: 1], let installedAppFileAndID = results[safe: 2], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return ParallelTestCaseFailedCaptureGroup(suite: suite, testCase: testCase, installedAppFileAndID: installedAppFileAndID, time: time)
        case .parallelTestingStarted:
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingStartedCaptureGroup(device: device)
        case .parallelTestingPassed:
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingPassedCaptureGroup(device: device)
        case .parallelTestingFailed:
            guard let device = results[safe: 0] else { return EmptyCaptureGroup() }
            return ParallelTestingFailedCaptureGroup(device: device)
        case .parallelTestSuiteStarted:
            guard let suite = results[safe: 0], let device = results[safe: 1] else { return EmptyCaptureGroup() }
            return ParallelTestSuiteStartedCaptureGroup(suite: suite, device: device)
        case .phaseSuccess:
            return PhaseSuccessCaptureGroup()
        case .phaseScriptExecution:
            guard let phaseName = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return PhaseScriptExecutionCaptureGroup(phaseName: phaseName, target: target)
        case .processPch:
            guard let file = results[safe: 0], let buildTarget = results[safe: 1] else { return EmptyCaptureGroup() }
            return ProcessPchCaptureGroup(file: file, buildTarget: buildTarget)
        case .processPchCommand:
            guard let filePath = results[safe: 0] else { return EmptyCaptureGroup() }
            return ProcessPchCommandCaptureGroup(filePath: filePath)
        case .preprocess:
            guard let file = results[safe: 0] else { return EmptyCaptureGroup() }
            return PreprocessCaptureGroup(file: file)
        case .pbxcp:
            guard let sourceFile = results[safe: 0], let targetFile = results[safe: 1], let buildTarget = results[safe: 2] else { return EmptyCaptureGroup() }
            return PbxcpCaptureGroup(sourceFile: sourceFile, targetFile: targetFile, buildTarget: buildTarget)
        case .processInfoPlist:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let target = results[safe: 2] else { return EmptyCaptureGroup() }
            return ProcessInfoPlistCaptureGroup(filePath: filePath, filename: fileName, target: target)
        case .testsRunCompletion:
            guard let suite = results[safe: 0], let result = results[safe: 1], let time = results[safe: 2] else { return EmptyCaptureGroup() }
            return TestsRunCompletionCaptureGroup(suite: suite, result: result, time: time)
        case .testSuiteStarted:
            guard let suite = results[safe: 0], let time = results[safe: 1] else { return EmptyCaptureGroup() }
            return TestSuiteStartedCaptureGroup(suite: suite, time: time)
        case .testSuiteStart:
            guard let testSuiteName = results[safe: 0] else { return EmptyCaptureGroup() }
            return TestSuiteStartCaptureGroup(testSuiteName: testSuiteName)
        case .testSuiteAllTestsPassed:
            return TestSuiteAllTestsPassedCaptureGroup()
        case .testSuiteAllTestsFailed:
            return TestSuiteAllTestsFailedCaptureGroup()
        case .tiffutil:
            guard let fileName = results[safe: 0] else { return EmptyCaptureGroup() }
            return TIFFutilCaptureGroup(filename: fileName)
        case .touch:
            guard let fileName = results[safe: 0], let target = results[safe: 1] else { return EmptyCaptureGroup() }
            return TouchCaptureGroup(filename: fileName, target: target)
        case .writeFile:
            guard let filePath = results[safe: 0] else { return EmptyCaptureGroup() }
            return WriteFileCaptureGroup(filePath: filePath)
        case .writeAuxiliaryFiles:
            return WriteAuxiliaryFilesCaptureGroup()
        case .compileWarning:
            guard let filePath = results[safe: 0], let fileName = results[safe: 1], let reason = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileWarningCaptureGroup(filePath: filePath, filename: fileName, reason: reason)
        case .ldWarning:
            guard let ldPrefix = results[safe: 0], let warningMessage = results[safe: 1]  else { return EmptyCaptureGroup() }
            return LDWarningCaptureGroup(ldPrefix: ldPrefix, warningMessage: warningMessage)
        case .genericWarning:
            guard let wholeWarning = results[safe: 0] else { return EmptyCaptureGroup() }
            return GenericWarningCaptureGroup(wholeWarning: wholeWarning)
        case .willNotBeCodeSigned:
            guard let wholeWarning = results[safe: 0] else { return EmptyCaptureGroup() }
            return WillNotBeCodeSignedCaptureGroup(wholeWarning: wholeWarning)
        case .duplicateLocalizedStringKey:
            guard let wholeMessage = results[safe: 0] else { return EmptyCaptureGroup() }
            return DuplicateLocalizedStringKeyCaptureGroup(warningMessage: wholeMessage)
        case .clangError:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return ClangErrorCaptureGroup(wholeError: wholeError)
        case .checkDependenciesErrors:
            return CheckDependenciesCaptureGroup()
        case .provisioningProfileRequired:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return ProvisioningProfileRequiredCaptureGroup(wholeError: wholeError)
        case .noCertificate:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return NoCertificateCaptureGroup(wholeError: wholeError)
        case .compileError:
            guard let filePath = results[safe: 0], let isFatalError = results[safe: 1], let reason = results[safe: 2] else { return EmptyCaptureGroup() }
            return CompileErrorCaptureGroup(filePath: filePath, isFatalError: isFatalError, reason: reason)
        case .cursor:
            guard let cursor = results[safe: 0] else { return EmptyCaptureGroup() }
            return CursorCaptureGroup(cursor: cursor)
        case .fatalError:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return FatalErrorCaptureGroup(wholeError: wholeError)
        case .fileMissingError:
            guard let wholeError = results[safe: 0], let filePath = results[safe: 1] else { return EmptyCaptureGroup() }
            return FileMissingErrorCaptureGroup(wholeError: wholeError, filePath: filePath)
        case .ldError:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return LDErrorCaptureGroup(wholeError: wholeError)
        case .linkerDuplicateSymbolsLocation:
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)
        case .linkerDuplicateSymbols:
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerDuplicateSymbolsCaptureGroup(reason: reason)
        case .linkerUndefinedSymbolLocation:
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)
        case .linkerUndefinedSymbols:
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return LinkerUndefinedSymbolsCaptureGroup(reason: reason)
        case .podsError:
            guard let reason = results[safe: 0] else { return EmptyCaptureGroup() }
            return PodsErrorCaptureGroup(reason: reason)
        case .symbolReferencedFrom:
            guard let reference = results[safe: 0] else { return EmptyCaptureGroup() }
            return SymbolReferencedFromCaptureGroup(reference: reference)
        case .moduleIncludesError:
            guard let errorReason = results[safe: 0] else { return EmptyCaptureGroup() }
            return ModuleIncludesErrorCaptureGroup(errorReason: errorReason)
        case .undefinedSymbolLocation:
            guard let target = results[safe: 0], let fileName = results[safe: 1] else { return EmptyCaptureGroup() }
            return UndefinedSymbolLocationCaptureGroup(target: target, filename: fileName)
        case .packageFetching:
            return PackageFetchingCaptureGroup()
        case .packageUpdating:
            return PackageUpdatingCaptureGroup()
        case .packageCheckingOut:
            return PackageCheckingOutCaptureGroup()
        case .packageGraphResolvingStart:
            return PackageGraphResolvingStartCaptureGroup()
        case .packageGraphResolvingEnded:
            return PackageGraphResolvingEndedCaptureGroup()
        case .packageGraphResolvedItem:
            guard let packageName = results[safe: 0], let packageURL = results[safe: 1], let packageVersion = results[safe: 2] else { return EmptyCaptureGroup() }
            return PackageGraphResolvedItemCaptureGroup(packageName: packageName, packageURL: packageURL, packageVersion: packageVersion)
        case .xcodebuildError:
            guard let wholeError = results[safe: 0] else { return EmptyCaptureGroup() }
            return XcodebuildErrorCaptureGroup(wholeError: wholeError)
        }
    }
}
