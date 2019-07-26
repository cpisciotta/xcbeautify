public enum OutputType {
    case UNDEFINED
    case TASK
    case WARN_ERR
    case RESULT
}

public class Parser {
    public init() {}

    public var summary: TestSummary? = nil

    public var outputType: OutputType = .UNDEFINED

    public func parse(line: String, colored: Bool = true) -> String? {
        switch line {
            case Matcher.analyzeMatcher:
                outputType = .TASK
                return line.beautify(pattern: .analyze, colored: colored)
            case Matcher.buildTargetMatcher:
                outputType = .TASK
                return line.beautify(pattern: .buildTarget, colored: colored)
            case Matcher.aggregateTargetMatcher:
                outputType = .TASK
                return line.beautify(pattern: .aggregateTarget, colored: colored)
            case Matcher.analyzeTargetMatcher:
                outputType = .TASK
                return line.beautify(pattern: .analyzeTarget, colored: colored)
            case Matcher.checkDependenciesMatcher:
                outputType = .TASK
                return line.beautify(pattern: .checkDependencies, colored: colored)
            case Matcher.shellCommandMatcher:
                outputType = .TASK
                return line.beautify(pattern: .shellCommand, colored: colored)
            case Matcher.cleanRemoveMatcher:
                outputType = .TASK
                return line.beautify(pattern: .cleanRemove, colored: colored)
            case Matcher.cleanTargetMatcher:
                outputType = .TASK
                return line.beautify(pattern: .cleanTarget, colored: colored)
            case Matcher.codesignFrameworkMatcher:
                outputType = .TASK
                return line.beautify(pattern: .codesignFramework, colored: colored)
            case Matcher.codesignMatcher:
                outputType = .TASK
                return line.beautify(pattern: .codesign, colored: colored)
            case Matcher.compileMatcher:
                outputType = .TASK
                return line.beautify(pattern: .compile, colored: colored)
            case Matcher.compileCommandMatcher:
                outputType = .TASK
                return line.beautify(pattern: .compileCommand, colored: colored)
            case Matcher.compileXibMatcher:
                outputType = .TASK
                return line.beautify(pattern: .compileXib, colored: colored)
            case Matcher.compileStoryboardMatcher:
                outputType = .TASK
                return line.beautify(pattern: .compileStoryboard, colored: colored)
            case Matcher.copyHeaderMatcher:
                outputType = .TASK
                return line.beautify(pattern: .copyHeader, colored: colored)
            case Matcher.copyPlistMatcher:
                outputType = .TASK
                return line.beautify(pattern: .copyPlist, colored: colored)
            case Matcher.copyStringsMatcher:
                outputType = .TASK
                return line.beautify(pattern: .copyStrings, colored: colored)
            case Matcher.cpresourceMatcher:
                outputType = .TASK
                return line.beautify(pattern: .cpresource, colored: colored)
            case Matcher.executedMatcher:
                outputType = .TASK
                parseSummary(line: line, colored: colored)
                return nil
            case Matcher.failingTestMatcher:
                outputType = .TASK
                return line.beautify(pattern: .failingTest, colored: colored)
            case Matcher.uiFailingTestMatcher:
                outputType = .TASK
                return line.beautify(pattern: .uiFailingTest, colored: colored)
            case Matcher.restartingTestsMatcher:
                outputType = .TASK
                return line.beautify(pattern: .restartingTests, colored: colored)
            case Matcher.generateDsymMatcher:
                outputType = .TASK
                return line.beautify(pattern: .generateDsym, colored: colored)
            case Matcher.libtoolMatcher:
                outputType = .TASK
                return line.beautify(pattern: .libtool, colored: colored)
            case Matcher.linkingMatcher:
                outputType = .TASK
                return line.beautify(pattern: .linking, colored: colored)
            case Matcher.testCasePassedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testCasePassed, colored: colored)
            case Matcher.testCaseStartedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testCaseStarted, colored: colored)
            case Matcher.testCasePendingMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testCasePending, colored: colored)
            case Matcher.testCaseMeasuredMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testCaseMeasured, colored: colored)
            case Matcher.phaseSuccessMatcher:
                outputType = .RESULT
                return line.beautify(pattern: .phaseSuccess, colored: colored)
            case Matcher.phaseScriptExecutionMatcher:
                outputType = .TASK
                return line.beautify(pattern: .phaseScriptExecution, colored: colored)
            case Matcher.processPchMatcher:
                outputType = .TASK
                return line.beautify(pattern: .processPch, colored: colored)
            case Matcher.processPchCommandMatcher:
                outputType = .TASK
                return line.beautify(pattern: .processPchCommand, colored: colored)
            case Matcher.preprocessMatcher:
                outputType = .TASK
                return line.beautify(pattern: .preprocess, colored: colored)
            case Matcher.pbxcpMatcher:
                outputType = .TASK
                return line.beautify(pattern: .pbxcp, colored: colored)
            case Matcher.processInfoPlistMatcher:
                outputType = .TASK
                return line.beautify(pattern: .processInfoPlist, colored: colored)
            case Matcher.testsRunCompletionMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testsRunCompletion, colored: colored)
            case Matcher.testSuiteStartedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testSuiteStarted, colored: colored)
            case Matcher.testSuiteStartMatcher:
                outputType = .TASK
                return line.beautify(pattern: .testSuiteStart, colored: colored)
            case Matcher.tiffutilMatcher:
                outputType = .TASK
                return line.beautify(pattern: .tiffutil, colored: colored)
            case Matcher.touchMatcher:
                outputType = .TASK
                return line.beautify(pattern: .touch, colored: colored)
            case Matcher.writeFileMatcher:
                outputType = .TASK
                return line.beautify(pattern: .writeFile, colored: colored)
            case Matcher.writeAuxiliaryFilesMatcher:
                outputType = .TASK
                return line.beautify(pattern: .writeAuxiliaryFiles, colored: colored)
            case Matcher.parallelTestCasePassedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .parallelTestCasePassed, colored: colored)
            case Matcher.parallelTestCaseAppKitPassedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .parallelTestCaseAppKitPassed, colored: colored)
            case Matcher.parallelTestingStartedMatcher:
                outputType = .TASK
                return line.beautify(pattern: .parallelTestingStarted, colored: colored)
            
            // WARNING + ERROR = WARN_ERR
            case Matcher.compileWarningMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .compileWarning, colored: colored)
            case Matcher.ldWarningMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .ldWarning, colored: colored)
            case Matcher.genericWarningMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .genericWarning, colored: colored)
            case Matcher.willNotBeCodeSignedMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .willNotBeCodeSigned, colored: colored)
            case Matcher.clangErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .clangError, colored: colored)
            case Matcher.checkDependenciesErrorsMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .checkDependenciesErrors, colored: colored)
            case Matcher.provisioningProfileRequiredMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .provisioningProfileRequired, colored: colored)
            case Matcher.noCertificateMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .noCertificate, colored: colored)
            case Matcher.compileErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .compileError, colored: colored)
            case Matcher.cursorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .cursor, colored: colored)
            case Matcher.fatalErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .fatalError, colored: colored)
            case Matcher.fileMissingErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .fileMissingError, colored: colored)
            case Matcher.ldErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .ldError, colored: colored)
            case Matcher.linkerDuplicateSymbolsLocationMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .linkerDuplicateSymbolsLocation, colored: colored)
            case Matcher.linkerDuplicateSymbolsMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .linkerDuplicateSymbols, colored: colored)
            case Matcher.linkerUndefinedSymbolLocationMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .linkerUndefinedSymbolLocation, colored: colored)
            case Matcher.linkerUndefinedSymbolsMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .linkerUndefinedSymbols, colored: colored)
            case Matcher.podsErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .podsError, colored: colored)
            case Matcher.symbolReferencedFromMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .symbolReferencedFrom, colored: colored)
            case Matcher.moduleIncludesErrorMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .moduleIncludesError, colored: colored)
            case Matcher.parallelTestCaseFailedMatcher:
                outputType = .WARN_ERR
                return line.beautify(pattern: .parallelTestCaseFailed, colored: colored)
            default:
                outputType = .UNDEFINED
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
