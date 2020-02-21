public class Parser {
    public init() {}

    public var summary: TestSummary? = nil

    public var outputType: OutputType = OutputType.undefined

    public func parse(line: String, colored: Bool = true) -> String? {
        switch line {
            case Matcher.analyzeMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .analyze, colored: colored)
            case Matcher.buildTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .buildTarget, colored: colored)
            case Matcher.aggregateTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .aggregateTarget, colored: colored)
            case Matcher.analyzeTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .analyzeTarget, colored: colored)
            case Matcher.checkDependenciesMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .checkDependencies, colored: colored)
            case Matcher.cleanRemoveMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cleanRemove, colored: colored)
            case Matcher.cleanTargetMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cleanTarget, colored: colored)
            case Matcher.codesignFrameworkMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .codesignFramework, colored: colored)
            case Matcher.codesignMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .codesign, colored: colored)
            case Matcher.compileMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compile, colored: colored)
            case Matcher.compileCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileCommand, colored: colored)
            case Matcher.compileXibMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileXib, colored: colored)
            case Matcher.compileStoryboardMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .compileStoryboard, colored: colored)
            case Matcher.copyHeaderMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyHeader, colored: colored)
            case Matcher.copyPlistMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyPlist, colored: colored)
            case Matcher.copyStringsMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .copyStrings, colored: colored)
            case Matcher.cpresourceMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .cpresource, colored: colored)
            case Matcher.executedMatcher:
                outputType = OutputType.task
                parseSummary(line: line, colored: colored)
                return nil
            case Matcher.failingTestMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .failingTest, colored: colored)
            case Matcher.uiFailingTestMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .uiFailingTest, colored: colored)
            case Matcher.restartingTestsMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .restartingTests, colored: colored)
            case Matcher.generateCoverageDataMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generateCoverageData, colored: colored)
            case Matcher.generatedCoverageReportMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generatedCoverageReport, colored: colored)
            case Matcher.generateDsymMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .generateDsym, colored: colored)
            case Matcher.libtoolMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .libtool, colored: colored)
            case Matcher.linkingMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .linking, colored: colored)
            case Matcher.testCasePassedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testCasePassed, colored: colored)
            case Matcher.testCaseStartedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testCaseStarted, colored: colored)
            case Matcher.testCasePendingMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testCasePending, colored: colored)
            case Matcher.testCaseMeasuredMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testCaseMeasured, colored: colored)
            case Matcher.phaseSuccessMatcher:
                outputType = OutputType.result
                return line.beautify(pattern: .phaseSuccess, colored: colored)
            case Matcher.phaseScriptExecutionMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .phaseScriptExecution, colored: colored)
            case Matcher.processPchMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processPch, colored: colored)
            case Matcher.processPchCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processPchCommand, colored: colored)
            case Matcher.preprocessMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .preprocess, colored: colored)
            case Matcher.pbxcpMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .pbxcp, colored: colored)
            case Matcher.processInfoPlistMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .processInfoPlist, colored: colored)
            case Matcher.testsRunCompletionMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testsRunCompletion, colored: colored)
            case Matcher.testSuiteStartedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testSuiteStarted, colored: colored)
            case Matcher.testSuiteStartMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .testSuiteStart, colored: colored)
            case Matcher.tiffutilMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .tiffutil, colored: colored)
            case Matcher.touchMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .touch, colored: colored)
            case Matcher.writeFileMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .writeFile, colored: colored)
            case Matcher.writeAuxiliaryFilesMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .writeAuxiliaryFiles, colored: colored)
            case Matcher.parallelTestCasePassedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .parallelTestCasePassed, colored: colored)
            case Matcher.parallelTestCaseAppKitPassedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .parallelTestCaseAppKitPassed, colored: colored)
            case Matcher.parallelTestingStartedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .parallelTestingStarted, colored: colored)
            case Matcher.parallelTestingPassedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .parallelTestingPassed, colored: colored)
            case Matcher.parallelTestSuiteStartedMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .parallelTestSuiteStarted, colored: colored)
            
            case Matcher.compileWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .compileWarning, colored: colored)
            case Matcher.ldWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .ldWarning, colored: colored)
            case Matcher.genericWarningMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .genericWarning, colored: colored)
            case Matcher.willNotBeCodeSignedMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .willNotBeCodeSigned, colored: colored)
            case Matcher.clangErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .clangError, colored: colored)
            case Matcher.checkDependenciesErrorsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .checkDependenciesErrors, colored: colored)
            case Matcher.provisioningProfileRequiredMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .provisioningProfileRequired, colored: colored)
            case Matcher.noCertificateMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .noCertificate, colored: colored)
            case Matcher.compileErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .compileError, colored: colored)
            case Matcher.cursorMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .cursor, colored: colored)
            case Matcher.fatalErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .fatalError, colored: colored)
            case Matcher.fileMissingErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .fileMissingError, colored: colored)
            case Matcher.ldErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .ldError, colored: colored)
            case Matcher.linkerDuplicateSymbolsLocationMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerDuplicateSymbolsLocation, colored: colored)
            case Matcher.linkerDuplicateSymbolsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerDuplicateSymbols, colored: colored)
            case Matcher.linkerUndefinedSymbolLocationMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerUndefinedSymbolLocation, colored: colored)
            case Matcher.linkerUndefinedSymbolsMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .linkerUndefinedSymbols, colored: colored)
            case Matcher.podsErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .podsError, colored: colored)
            case Matcher.symbolReferencedFromMatcher:
                outputType = OutputType.warning
                return line.beautify(pattern: .symbolReferencedFrom, colored: colored)
            case Matcher.moduleIncludesErrorMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .moduleIncludesError, colored: colored)
            case Matcher.parallelTestingFailedMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .parallelTestingFailed, colored: colored)
            case Matcher.parallelTestCaseFailedMatcher:
                outputType = OutputType.error
                return line.beautify(pattern: .parallelTestCaseFailed, colored: colored)
            case Matcher.shellCommandMatcher:
                outputType = OutputType.task
                return line.beautify(pattern: .shellCommand, colored: colored)
            case Matcher.undefinedSymbolLocationMatcher:
                outputType = .warning
                return line.beautify(pattern: .undefinedSymbolLocation, colored: colored)
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
