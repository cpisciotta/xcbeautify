public class Parser {
    public init() {}

    public var summary: TestSummary? = nil

    public var outputType: OutputType = OutputType.undefined

    public func parse(line: String, colored: Bool = true, additionalLines: @escaping () -> (String?)) -> String? {
        switch line {
            case Matcher.analyzeMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .analyze, colored: colored, additionalLines: additionalLines)
            case Matcher.buildTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .buildTarget, colored: colored, additionalLines: additionalLines)
            case Matcher.aggregateTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .aggregateTarget, colored: colored, additionalLines: additionalLines)
            case Matcher.analyzeTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .analyzeTarget, colored: colored, additionalLines: additionalLines)
            case Matcher.checkDependenciesMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .checkDependencies, colored: colored, additionalLines: additionalLines)
            case Matcher.cleanRemoveMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cleanRemove, colored: colored, additionalLines: additionalLines)
            case Matcher.cleanTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cleanTarget, colored: colored, additionalLines: additionalLines)
            case Matcher.codesignFrameworkMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .codesignFramework, colored: colored, additionalLines: additionalLines)
            case Matcher.codesignMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .codesign, colored: colored, additionalLines: additionalLines)
            case Matcher.compileMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compile, colored: colored, additionalLines: additionalLines)
            case Matcher.compileCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileCommand, colored: colored, additionalLines: additionalLines)
            case Matcher.compileXibMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileXib, colored: colored, additionalLines: additionalLines)
            case Matcher.compileStoryboardMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileStoryboard, colored: colored, additionalLines: additionalLines)
            case Matcher.copyHeaderMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyHeader, colored: colored, additionalLines: additionalLines)
            case Matcher.copyPlistMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyPlist, colored: colored, additionalLines: additionalLines)
            case Matcher.copyStringsMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyStrings, colored: colored, additionalLines: additionalLines)
            case Matcher.cpresourceMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cpresource, colored: colored, additionalLines: additionalLines)
            case Matcher.executedMatcher:
                outputType = OutputType.task
                parseSummary(line: line, colored: colored)
                return nil
            case Matcher.failingTestMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .failingTest, colored: colored, additionalLines: additionalLines)
            case Matcher.uiFailingTestMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .uiFailingTest, colored: colored, additionalLines: additionalLines)
            case Matcher.restartingTestsMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .restartingTests, colored: colored, additionalLines: additionalLines)
            case Matcher.generateCoverageDataMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generateCoverageData, colored: colored, additionalLines: additionalLines)
            case Matcher.generatedCoverageReportMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generatedCoverageReport, colored: colored, additionalLines: additionalLines)
            case Matcher.generateDsymMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generateDsym, colored: colored, additionalLines: additionalLines)
            case Matcher.libtoolMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .libtool, colored: colored, additionalLines: additionalLines)
            case Matcher.linkingMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .linking, colored: colored, additionalLines: additionalLines)
            case Matcher.testCasePassedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testCasePassed, colored: colored, additionalLines: additionalLines)
            case Matcher.testCaseStartedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testCaseStarted, colored: colored, additionalLines: additionalLines)
            case Matcher.testCasePendingMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testCasePending, colored: colored, additionalLines: additionalLines)
            case Matcher.testCaseMeasuredMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testCaseMeasured, colored: colored, additionalLines: additionalLines)
            case Matcher.phaseSuccessMatcher:
                outputType = OutputType.result
                return line.beautify(pattern: .phaseSuccess, colored: colored, additionalLines: additionalLines)
            case Matcher.phaseScriptExecutionMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .phaseScriptExecution, colored: colored, additionalLines: additionalLines)
            case Matcher.processPchMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processPch, colored: colored, additionalLines: additionalLines)
            case Matcher.processPchCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processPchCommand, colored: colored, additionalLines: additionalLines)
            case Matcher.preprocessMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .preprocess, colored: colored, additionalLines: additionalLines)
            case Matcher.pbxcpMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .pbxcp, colored: colored, additionalLines: additionalLines)
            case Matcher.processInfoPlistMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processInfoPlist, colored: colored, additionalLines: additionalLines)
            case Matcher.testsRunCompletionMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testsRunCompletion, colored: colored, additionalLines: additionalLines)
            case Matcher.testSuiteStartedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testSuiteStarted, colored: colored, additionalLines: additionalLines)
            case Matcher.testSuiteStartMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .testSuiteStart, colored: colored, additionalLines: additionalLines)
            case Matcher.tiffutilMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .tiffutil, colored: colored, additionalLines: additionalLines)
            case Matcher.touchMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .touch, colored: colored, additionalLines: additionalLines)
            case Matcher.writeFileMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .writeFile, colored: colored, additionalLines: additionalLines)
            case Matcher.writeAuxiliaryFilesMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .writeAuxiliaryFiles, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestCasePassedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .parallelTestCasePassed, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestCaseAppKitPassedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .parallelTestCaseAppKitPassed, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestingStartedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .parallelTestingStarted, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestingPassedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .parallelTestingPassed, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestSuiteStartedMatcher:
                outputType = OutputType.test
                return line.beautify(pattern: .parallelTestSuiteStarted, colored: colored, additionalLines: additionalLines)
            
            case Matcher.compileWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .compileWarning, colored: colored, additionalLines: additionalLines)
            case Matcher.ldWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .ldWarning, colored: colored, additionalLines: additionalLines)
            case Matcher.genericWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .genericWarning, colored: colored, additionalLines: additionalLines)
            case Matcher.willNotBeCodeSignedMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .willNotBeCodeSigned, colored: colored, additionalLines: additionalLines)
            case Matcher.clangErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .clangError, colored: colored, additionalLines: additionalLines)
            case Matcher.checkDependenciesErrorsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .checkDependenciesErrors, colored: colored, additionalLines: additionalLines)
            case Matcher.provisioningProfileRequiredMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .provisioningProfileRequired, colored: colored, additionalLines: additionalLines)
            case Matcher.noCertificateMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .noCertificate, colored: colored, additionalLines: additionalLines)
            case Matcher.compileErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .compileError, colored: colored, additionalLines: additionalLines)
            case Matcher.cursorMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .cursor, colored: colored, additionalLines: additionalLines)
            case Matcher.fatalErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .fatalError, colored: colored, additionalLines: additionalLines)
            case Matcher.fileMissingErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .fileMissingError, colored: colored, additionalLines: additionalLines)
            case Matcher.ldErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .ldError, colored: colored, additionalLines: additionalLines)
            case Matcher.linkerDuplicateSymbolsLocationMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerDuplicateSymbolsLocation, colored: colored, additionalLines: additionalLines)
            case Matcher.linkerDuplicateSymbolsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerDuplicateSymbols, colored: colored, additionalLines: additionalLines)
            case Matcher.linkerUndefinedSymbolLocationMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerUndefinedSymbolLocation, colored: colored, additionalLines: additionalLines)
            case Matcher.linkerUndefinedSymbolsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerUndefinedSymbols, colored: colored, additionalLines: additionalLines)
            case Matcher.podsErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .podsError, colored: colored, additionalLines: additionalLines)
            case Matcher.symbolReferencedFromMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .symbolReferencedFrom, colored: colored, additionalLines: additionalLines)
            case Matcher.moduleIncludesErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .moduleIncludesError, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestingFailedMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .parallelTestingFailed, colored: colored, additionalLines: additionalLines)
            case Matcher.parallelTestCaseFailedMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .parallelTestCaseFailed, colored: colored, additionalLines: additionalLines)
            case Matcher.shellCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .shellCommand, colored: colored, additionalLines: additionalLines)
            case Matcher.undefinedSymbolLocationMatcher:
                outputType = .warning
                return line.beautify(pattern: .undefinedSymbolLocation, colored: colored, additionalLines: additionalLines)
            case Matcher.packageGraphResolvingStart:
                outputType = .task
                return line.beautify(pattern: .packageGraphResolvingStart, colored: colored, additionalLines: additionalLines)
            case Matcher.packageGraphResolvingEnded:
                outputType = .task
                return line.beautify(pattern: .packageGraphResolvingEnded, colored: colored, additionalLines: additionalLines)
            case Matcher.packageGraphResolvedItem:
                outputType = .task
                return line.beautify(pattern: .packageGraphResolvedItem, colored: colored, additionalLines: additionalLines)
            default:
                outputType = OutputType.undefined
                return nil
        }
    }

    func parseSummary(line: String, colored: Bool) {
        let groups = line.capturedGroups(with: .executed)
        summary = TestSummary(
            testsCount: groups[0],
            failuresCount: groups[1],
            unexpectedCount: groups[2],
            time: groups[3],
            colored: colored)
    }
}
