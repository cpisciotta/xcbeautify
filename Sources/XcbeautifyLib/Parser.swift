public class Parser {
    
    private let colored: Bool
    
    private let additionalLines: () -> String?

    public var summary: TestSummary? = nil

    public var needToRecordSummary = false

    public var outputType: OutputType = OutputType.undefined
    
    private var platformSpecificInnerParsers: [InnerParser] {
#if os(Linux)
        return [
            innerParser(Matcher.compileMatcher, outputType: .task, formatter: Formatter.formatCompileLinux),
            innerParser(Matcher.linkingMatcher, outputType: .task, formatter: Formatter.formatLinkingLinux),
        ]
#else
        return [
            innerParser(Matcher.compileMatcher, outputType: .task, formatter: Formatter.formatCompile),
            innerParser(Matcher.linkingMatcher, outputType: .task, formatter: Formatter.formatLinking),
        ]
#endif
    }
    
    private lazy var innerParsers: [InnerParser] = platformSpecificInnerParsers + [
        innerParser(Matcher.analyzeMatcher , outputType: .task, formatter: Formatter.formatAnalyze),
        innerParser(Matcher.buildTargetMatcher, outputType: .task, formatter: Formatter.formatBuildTargetCommand),
        innerParser(Matcher.aggregateTargetMatcher, outputType: .task, formatter: Formatter.formatAggregateTargetCommand),
        innerParser(Matcher.analyzeTargetMatcher, outputType: .task, formatter: Formatter.formatAnalyzeTargetCommand),
        innerParser(Matcher.checkDependenciesMatcher, outputType: .task, formatter: Formatter.formatCheckDependencies),
        innerParser(Matcher.cleanRemoveMatcher, outputType: .task, formatter: Formatter.formatCleanRemove),
        innerParser(Matcher.cleanTargetMatcher, outputType: .task, formatter: Formatter.formatCleanTargetCommand),
        innerParser(Matcher.codesignFrameworkMatcher, outputType: .task, formatter: Formatter.formatCodeSignFramework),
        innerParser(Matcher.codesignMatcher, outputType: .task, formatter: Formatter.formatCodeSigning),
        innerParser(Matcher.compileCommandMatcher, outputType: .task, formatter: Formatter.formatCompileCommand),
        innerParser(Matcher.compileXibMatcher, outputType: .task, formatter: Formatter.formatCompile),
        innerParser(Matcher.compileStoryboardMatcher, outputType: .task, formatter: Formatter.formatCompile),
        innerParser(Matcher.copyHeaderMatcher, outputType: .task, formatter: Formatter.formatCopy),
        innerParser(Matcher.copyPlistMatcher, outputType: .task, formatter: Formatter.formatCopy),
        innerParser(Matcher.copyStringsMatcher, outputType: .task, formatter: Formatter.formatCopy),
        innerParser(Matcher.cpresourceMatcher, outputType: .task, formatter: Formatter.formatCopy),
        innerParser(Matcher.failingTestMatcher, outputType: .error, formatter: Formatter.formatTest(pattern: .failingTest)),
        innerParser(Matcher.uiFailingTestMatcher, outputType: .error, formatter: Formatter.formatTest(pattern: .uiFailingTest)),
        innerParser(Matcher.restartingTestsMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .restartingTests)),
        innerParser(Matcher.generateCoverageDataMatcher, outputType: .task, formatter: Formatter.formatCodeCoverage(pattern: .generateCoverageData)),
        innerParser(Matcher.generatedCoverageReportMatcher, outputType: .task, formatter: Formatter.formatCodeCoverage(pattern: .generatedCoverageReport)),
        innerParser(Matcher.generateDsymMatcher, outputType: .task, formatter: Formatter.formatGenerateDsym),
        innerParser(Matcher.libtoolMatcher, outputType: .task, formatter: Formatter.formatLibtool),
        innerParser(Matcher.testCasePassedMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .testCasePassed)),
        innerParser(Matcher.testCaseStartedMatcher, outputType: .test, formatter: Formatter.formatNil),
        innerParser(Matcher.testCasePendingMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .testCasePending)),
        innerParser(Matcher.testCaseMeasuredMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .testCaseMeasured)),
        innerParser(Matcher.phaseSuccessMatcher, outputType: .result, formatter: Formatter.formatPhaseSuccess),
        innerParser(Matcher.phaseScriptExecutionMatcher, outputType: .task, formatter: Formatter.formatPhaseScriptExecution),
        innerParser(Matcher.processPchMatcher, outputType: .task, formatter: Formatter.formatProcessPch),
        innerParser(Matcher.processPchCommandMatcher, outputType: .task, formatter: Formatter.formatProcessPchCommand),
        innerParser(Matcher.preprocessMatcher, outputType: .task, formatter: Formatter.formatPreprocess),
        innerParser(Matcher.pbxcpMatcher, outputType: .task, formatter: Formatter.formatCopy),
        innerParser(Matcher.processInfoPlistMatcher, outputType: .task, formatter: Formatter.formatProcessInfoPlist),
        innerParser(Matcher.testsRunCompletionMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .testsRunCompletion)),
        innerParser(Matcher.testSuiteStartedMatcher, outputType: .test, formatter: Formatter.formatTestHeading(pattern: .testSuiteStarted)),
        innerParser(Matcher.testSuiteStartMatcher, outputType: .test, formatter: Formatter.formatTestHeading(pattern: .testSuiteStart)),
        innerParser(Matcher.tiffutilMatcher, outputType: .task, formatter: Formatter.formatNil),
        innerParser(Matcher.touchMatcher, outputType: .task, formatter: Formatter.formatTouch),
        innerParser(Matcher.writeFileMatcher, outputType: .task, formatter: Formatter.formatNil),
        innerParser(Matcher.writeAuxiliaryFilesMatcher, outputType: .task, formatter: Formatter.formatNil),
        innerParser(Matcher.parallelTestCasePassedMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .parallelTestCasePassed)),
        innerParser(Matcher.parallelTestCaseAppKitPassedMatcher, outputType: .test, formatter: Formatter.formatTest(pattern: .parallelTestCaseAppKitPassed)),
        innerParser(Matcher.parallelTestingStartedMatcher, outputType: .test, formatter: Formatter.formatTestHeading(pattern: .parallelTestingStarted)),
        innerParser(Matcher.parallelTestingPassedMatcher, outputType: .test, formatter: Formatter.formatTestHeading(pattern: .parallelTestingPassed)),
        innerParser(Matcher.parallelTestSuiteStartedMatcher, outputType: .test, formatter: Formatter.formatTestHeading(pattern: .parallelTestSuiteStarted)),
        innerParser(Matcher.compileWarningMatcher, outputType: .warning, formatter: Formatter.formatCompileWarning),
        innerParser(Matcher.ldWarningMatcher, outputType: .warning, formatter: Formatter.formatLdWarning),
        innerParser(Matcher.genericWarningMatcher, outputType: .warning, formatter: Formatter.formatWarning),
        innerParser(Matcher.willNotBeCodeSignedMatcher, outputType: .warning, formatter: Formatter.formatWillNotBeCodesignWarning),
        innerParser(Matcher.clangErrorMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.checkDependenciesErrorsMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.provisioningProfileRequiredMatcher, outputType: .warning, formatter: Formatter.formatError),
        innerParser(Matcher.noCertificateMatcher, outputType: .warning, formatter: Formatter.formatError),
        innerParser(Matcher.compileErrorMatcher, outputType: .error, formatter: Formatter.formatCompileError),
        innerParser(Matcher.cursorMatcher, outputType: .warning, formatter: Formatter.formatNil),
        innerParser(Matcher.fatalErrorMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.fileMissingErrorMatcher, outputType: .error, formatter: Formatter.formatFileMissingError),
        innerParser(Matcher.ldErrorMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.linkerDuplicateSymbolsLocationMatcher, outputType: .error, formatter: Formatter.formatNil),
        innerParser(Matcher.linkerDuplicateSymbolsMatcher, outputType: .error, formatter: Formatter.formatLinkerDuplicateSymbolsError),
        innerParser(Matcher.linkerUndefinedSymbolLocationMatcher, outputType: .error, formatter: Formatter.formatNil),
        innerParser(Matcher.linkerUndefinedSymbolsMatcher, outputType: .error, formatter: Formatter.formatLinkerUndefinedSymbolsError),
        innerParser(Matcher.podsErrorMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.symbolReferencedFromMatcher, outputType: .warning, formatter: Formatter.formatCompleteError),
        innerParser(Matcher.moduleIncludesErrorMatcher, outputType: .error, formatter: Formatter.formatError),
        innerParser(Matcher.parallelTestingFailedMatcher, outputType: .error, formatter: Formatter.formatTestHeading(pattern: .parallelTestingFailed)),
        innerParser(Matcher.parallelTestCaseFailedMatcher, outputType: .error, formatter: Formatter.formatTest(pattern: .parallelTestCaseFailed)),
        innerParser(Matcher.shellCommandMatcher, outputType: .task, formatter: Formatter.formatNil),
        innerParser(Matcher.undefinedSymbolLocationMatcher, outputType: .warning, formatter: Formatter.formatCompleteWarning),
        innerParser(Matcher.packageGraphResolvingStart, outputType: .task, formatter: Formatter.formatPackageStart),
        innerParser(Matcher.packageGraphResolvingEnded, outputType: .task, formatter: Formatter.formatPackageEnd),
        innerParser(Matcher.packageGraphResolvedItem, outputType: .task, formatter: Formatter.formatPackgeItem)
    ]
    
    // MARK: - Init
    
    public init(colored: Bool = true, additionalLines: @escaping () -> (String?)) {
        self.colored = colored
        self.additionalLines = additionalLines
    }
    
    public func parse(line: String) -> String? {
        
        // Find first parser that can parse specified string
        guard let idx = innerParsers.firstIndex(where: { $0.match(string: line)}) else {
            
            // Some uncommon cases, which have additional logic and don't follow default flow
            
            if Matcher.executedMatcher.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored)
                return nil
            }

            if Matcher.executedWithSkippedMatcher.match(string: line) {
                outputType = OutputType.task
                parseSummarySkipped(line: line, colored: colored)
                return nil
            }

            if Matcher.testSuiteAllTestsPassedMatcher.match(string: line) {
                needToRecordSummary = true
                return nil
            }

            if Matcher.testSuiteAllTestsFailedMatcher.match(string: line) {
                needToRecordSummary = true
                return nil
            }
            
            // Nothing found?
            outputType = OutputType.undefined
            return nil
        }
        
        let parser = innerParsers[idx]
        
        let result = parser.parse(line: line)
        outputType = result.outputType
        
        // Move found parser to the top, so next time it will be checked first
        innerParsers.insert(innerParsers.remove(at: idx), at: 0)
        
        return result.value
    }

    
    // MARK: Private

    private func parseSummary(line: String, colored: Bool) {
        guard needToRecordSummary else {
            return
        }
        
        let groups = RegexMatcher(pattern: .executed).capturedGroups(string: line)
        summary = TestSummary(
            testsCount: Int(groups[0]) ?? 0,
            skippedCount: 0,
            failuresCount: Int(groups[1]) ?? 0,
            unexpectedCount: Int(groups[2]) ?? 0,
            time: Double(groups[3]) ?? 0,
            colored: colored,
            testSummary: summary)
        
        needToRecordSummary = false
    }
    
    private func parseSummarySkipped(line: String, colored: Bool) {
        if !needToRecordSummary {
            return
        }
        
        let groups = RegexMatcher(pattern: .executedWithSkipped).capturedGroups(string: line)
        summary = TestSummary(
            testsCount: Int(groups[0]) ?? 0,
            skippedCount: Int(groups[1]) ?? 0,
            failuresCount: Int(groups[2]) ?? 0,
            unexpectedCount: Int(groups[3]) ?? 0,
            time: Double(groups[4]) ?? 0,
            colored: colored,
            testSummary: summary)
        
        needToRecordSummary = false
    }
    
    private func innerParser(_ parser: Matching, outputType: OutputType, formatter: @escaping (Formatter) -> ((Matching) -> String?)) -> InnerParser {
        return InnerParser(outputType: outputType, colored: colored, matcher: parser) { string in formatter(string)(parser) }
    }

    private func innerParser(_ parser: Matching, outputType: OutputType, formatter: @escaping (Formatter) -> ((Matching, @escaping () -> (String?)) -> String?)) -> InnerParser {
        return InnerParser(outputType: outputType, colored: colored, matcher: parser) { string in formatter(string)(parser, self.additionalLines) }
    }
    
    private struct InnerParser {
        
        fileprivate struct Result {
            let outputType: OutputType
            let value: String?
        }
        
        let outputType: OutputType
        let colored: Bool
        let matcher: Matching
        let format: (Formatter) -> String?
        
        func parse(line: String) -> Result {
            let formatter = Formatter(colored: colored, string: line)
            return .init(outputType: outputType, value: format(formatter))
        }
        
        func match(string: String) -> Bool {
            return matcher.match(string: string)
        }
    }

}
