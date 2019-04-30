public class Parser {
    public init() {}

    public var summary: TestSummary? = nil

    public func parse(line: String, colored: Bool = true) -> String? {
        switch line {
        case Matcher.analyzeMatcher:
            return line.beautify(pattern: .analyze, colored: colored)
        case Matcher.buildTargetMatcher:
            return line.beautify(pattern: .buildTarget, colored: colored)
        case Matcher.aggregateTargetMatcher:
            return line.beautify(pattern: .aggregateTarget, colored: colored)
        case Matcher.analyzeTargetMatcher:
            return line.beautify(pattern: .analyzeTarget, colored: colored)
        case Matcher.checkDependenciesMatcher:
            return line.beautify(pattern: .checkDependencies, colored: colored)
        case Matcher.shellCommandMatcher:
            return line.beautify(pattern: .shellCommand, colored: colored)
        case Matcher.cleanRemoveMatcher:
            return line.beautify(pattern: .cleanRemove, colored: colored)
        case Matcher.cleanTargetMatcher:
            return line.beautify(pattern: .cleanTarget, colored: colored)
        case Matcher.codesignMatcher:
            return line.beautify(pattern: .codesign, colored: colored)
        case Matcher.codesignFrameworkMatcher:
            return line.beautify(pattern: .codesignFramework, colored: colored)
        case Matcher.compileMatcher:
            return line.beautify(pattern: .compile, colored: colored)
        case Matcher.compileCommandMatcher:
            return line.beautify(pattern: .compileCommand, colored: colored)
        case Matcher.compileXibMatcher:
            return line.beautify(pattern: .compileXib, colored: colored)
        case Matcher.compileStoryboardMatcher:
            return line.beautify(pattern: .compileStoryboard, colored: colored)
        case Matcher.copyHeaderMatcher:
            return line.beautify(pattern: .copyHeader, colored: colored)
        case Matcher.copyPlistMatcher:
            return line.beautify(pattern: .copyPlist, colored: colored)
        case Matcher.copyStringsMatcher:
            return line.beautify(pattern: .copyStrings, colored: colored)
        case Matcher.cpresourceMatcher:
            return line.beautify(pattern: .cpresource, colored: colored)
        case Matcher.executedMatcher:
            parseSummary(line: line, colored: colored)
            return nil
        case Matcher.failingTestMatcher:
            return line.beautify(pattern: .failingTest, colored: colored)
        case Matcher.uiFailingTestMatcher:
            return line.beautify(pattern: .uiFailingTest, colored: colored)
        case Matcher.restartingTestsMatcher:
            return line.beautify(pattern: .restartingTests, colored: colored)
        case Matcher.generateDsymMatcher:
            return line.beautify(pattern: .generateDsym, colored: colored)
        case Matcher.libtoolMatcher:
            return line.beautify(pattern: .libtool, colored: colored)
        case Matcher.linkingMatcher:
            return line.beautify(pattern: .linking, colored: colored)
        case Matcher.testCasePassedMatcher:
            return line.beautify(pattern: .testCasePassed, colored: colored)
        case Matcher.testCaseStartedMatcher:
            return line.beautify(pattern: .testCaseStarted, colored: colored)
        case Matcher.testCasePendingMatcher:
            return line.beautify(pattern: .testCasePending, colored: colored)
        case Matcher.testCaseMeasuredMatcher:
            return line.beautify(pattern: .testCaseMeasured, colored: colored)
        case Matcher.phaseSuccessMatcher:
            return line.beautify(pattern: .phaseSuccess, colored: colored)
        case Matcher.phaseScriptExecutionMatcher:
            return line.beautify(pattern: .phaseScriptExecution, colored: colored)
        case Matcher.processPchMatcher:
            return line.beautify(pattern: .processPch, colored: colored)
        case Matcher.processPchCommandMatcher:
            return line.beautify(pattern: .processPchCommand, colored: colored)
        case Matcher.preprocessMatcher:
            return line.beautify(pattern: .preprocess, colored: colored)
        case Matcher.pbxcpMatcher:
            return line.beautify(pattern: .pbxcp, colored: colored)
        case Matcher.processInfoPlistMatcher:
            return line.beautify(pattern: .processInfoPlist, colored: colored)
        case Matcher.testsRunCompletionMatcher:
            return line.beautify(pattern: .testsRunCompletion, colored: colored)
        case Matcher.testSuiteStartedMatcher:
            return line.beautify(pattern: .testSuiteStarted, colored: colored)
        case Matcher.testSuiteStartMatcher:
            return line.beautify(pattern: .testSuiteStart, colored: colored)
        case Matcher.tiffutilMatcher:
            return line.beautify(pattern: .tiffutil, colored: colored)
        case Matcher.touchMatcher:
            return line.beautify(pattern: .touch, colored: colored)
        case Matcher.writeFileMatcher:
            return line.beautify(pattern: .writeFile, colored: colored)
        case Matcher.writeAuxiliaryFilesMatcher:
            return line.beautify(pattern: .writeAuxiliaryFiles, colored: colored)
        case Matcher.compileWarningMatcher:
            return line.beautify(pattern: .compileWarning, colored: colored)
        case Matcher.ldWarningMatcher:
            return line.beautify(pattern: .ldWarning, colored: colored)
        case Matcher.genericWarningMatcher:
            return line.beautify(pattern: .genericWarning, colored: colored)
        case Matcher.willNotBeCodeSignedMatcher:
            return line.beautify(pattern: .willNotBeCodeSigned, colored: colored)
        case Matcher.clangErrorMatcher:
            return line.beautify(pattern: .clangError, colored: colored)
        case Matcher.checkDependenciesErrorsMatcher:
            return line.beautify(pattern: .checkDependenciesErrors, colored: colored)
        case Matcher.provisioningProfileRequiredMatcher:
            return line.beautify(pattern: .provisioningProfileRequired, colored: colored)
        case Matcher.noCertificateMatcher:
            return line.beautify(pattern: .noCertificate, colored: colored)
        case Matcher.compileErrorMatcher:
            return line.beautify(pattern: .compileError, colored: colored)
        case Matcher.cursorMatcher:
            return line.beautify(pattern: .cursor, colored: colored)
        case Matcher.fatalErrorMatcher:
            return line.beautify(pattern: .fatalError, colored: colored)
        case Matcher.fileMissingErrorMatcher:
            return line.beautify(pattern: .fileMissingError, colored: colored)
        case Matcher.ldErrorMatcher:
            return line.beautify(pattern: .ldError, colored: colored)
        case Matcher.linkerDuplicateSymbolsLocationMatcher:
            return line.beautify(pattern: .linkerDuplicateSymbolsLocation, colored: colored)
        case Matcher.linkerDuplicateSymbolsMatcher:
            return line.beautify(pattern: .linkerDuplicateSymbols, colored: colored)
        case Matcher.linkerUndefinedSymbolLocationMatcher:
            return line.beautify(pattern: .linkerUndefinedSymbolLocation, colored: colored)
        case Matcher.linkerUndefinedSymbolsMatcher:
            return line.beautify(pattern: .linkerUndefinedSymbols, colored: colored)
        case Matcher.podsErrorMatcher:
            return line.beautify(pattern: .podsError, colored: colored)
        case Matcher.symbolReferencedFromMatcher:
            return line.beautify(pattern: .symbolReferencedFrom, colored: colored)
        case Matcher.moduleIncludesErrorMatcher:
            return line.beautify(pattern: .moduleIncludesError, colored: colored)
        case Matcher.parallelTestCasePassedMatcher:
            return line.beautify(pattern: .parallelTestCasePassed, colored: colored)
        case Matcher.parallelTestCaseAppKitPassedMatcher:
            return line.beautify(pattern: .parallelTestCaseAppKitPassed, colored: colored)
        case Matcher.parallelTestCaseFailedMatcher:
            return line.beautify(pattern: .parallelTestCaseFailed, colored: colored)
        case Matcher.parallelTestingStartedMatcher:
            return line.beautify(pattern: .parallelTestingStarted, colored: colored)
        default:
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
