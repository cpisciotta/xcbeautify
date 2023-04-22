public class Parser {
    
    private let colored: Bool
    
    private let additionalLines: () -> String?

    public var summary: TestSummary? = nil

    public var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(Matcher.analyzeMatcher, outputType: .task),
        innerParser(Matcher.buildTargetMatcher, outputType: .task),
        innerParser(Matcher.aggregateTargetMatcher, outputType: .task),
        innerParser(Matcher.analyzeTargetMatcher, outputType: .task),
        innerParser(Matcher.checkDependenciesMatcher, outputType: .task),
        innerParser(Matcher.cleanRemoveMatcher, outputType: .task),
        innerParser(Matcher.cleanTargetMatcher, outputType: .task),
        innerParser(Matcher.codesignFrameworkMatcher, outputType: .task),
        innerParser(Matcher.codesignMatcher, outputType: .task),
        innerParser(Matcher.compileMatcher, outputType: .task),
        innerParser(Matcher.compileCommandMatcher, outputType: .task),
        innerParser(Matcher.compileXibMatcher, outputType: .task),
        innerParser(Matcher.compileStoryboardMatcher, outputType: .task),
        innerParser(Matcher.copyHeaderMatcher, outputType: .task),
        innerParser(Matcher.copyPlistMatcher, outputType: .task),
        innerParser(Matcher.copyStringsMatcher, outputType: .task),
        innerParser(Matcher.cpresourceMatcher, outputType: .task),
        innerParser(Matcher.failingTestMatcher, outputType: .error),
        innerParser(Matcher.uiFailingTestMatcher, outputType: .error),
        innerParser(Matcher.restartingTestMatcher, outputType: .test),
        innerParser(Matcher.generateCoverageDataMatcher, outputType: .task),
        innerParser(Matcher.generatedCoverageReportMatcher, outputType: .task),
        innerParser(Matcher.generateDsymMatcher, outputType: .task),
        innerParser(Matcher.libtoolMatcher, outputType: .task),
        innerParser(Matcher.linkingMatcher, outputType: .task),
        innerParser(Matcher.testCasePassedMatcher, outputType: .test),
        innerParser(Matcher.testCaseStartedMatcher, outputType: .test),
        innerParser(Matcher.testCasePendingMatcher, outputType: .test),
        innerParser(Matcher.testCaseMeasuredMatcher, outputType: .test),
        innerParser(Matcher.phaseSuccessMatcher, outputType: .result),
        innerParser(Matcher.phaseScriptExecutionMatcher, outputType: .task),
        innerParser(Matcher.processPchMatcher, outputType: .task),
        innerParser(Matcher.processPchCommandMatcher, outputType: .task),
        innerParser(Matcher.preprocessMatcher, outputType: .task),
        innerParser(Matcher.pbxcpMatcher, outputType: .task),
        innerParser(Matcher.processInfoPlistMatcher, outputType: .task),
        innerParser(Matcher.testsRunCompletionMatcher, outputType: .test),
        innerParser(Matcher.testSuiteStartedMatcher, outputType: .test),
        innerParser(Matcher.testSuiteStartMatcher, outputType: .test),
        innerParser(Matcher.tiffutilMatcher, outputType: .task),
        innerParser(Matcher.touchMatcher, outputType: .task),
        innerParser(Matcher.writeFileMatcher, outputType: .task),
        innerParser(Matcher.writeAuxiliaryFilesMatcher, outputType: .task),
        innerParser(Matcher.parallelTestCasePassedMatcher, outputType: .test),
        innerParser(Matcher.parallelTestCaseAppKitPassedMatcher, outputType: .test),
        innerParser(Matcher.parallelTestingStartedMatcher, outputType: .test),
        innerParser(Matcher.parallelTestingPassedMatcher, outputType: .test),
        innerParser(Matcher.parallelTestSuiteStartedMatcher, outputType: .test),
        innerParser(Matcher.ldWarningMatcher, outputType: .warning),
        innerParser(Matcher.compileWarningMatcher, outputType: .warning),
        innerParser(Matcher.genericWarningMatcher, outputType: .warning),
        innerParser(Matcher.willNotBeCodeSignedMatcher, outputType: .warning),
        innerParser(Matcher.clangErrorMatcher, outputType: .error),
        innerParser(Matcher.checkDependenciesErrorsMatcher, outputType: .error),
        innerParser(Matcher.provisioningProfileRequiredMatcher, outputType: .warning),
        innerParser(Matcher.noCertificateMatcher, outputType: .warning),
        innerParser(Matcher.fileMissingErrorMatcher, outputType: .error),
        innerParser(Matcher.xcodebuildErrorMatcher, outputType: .error),
        innerParser(Matcher.compileErrorMatcher, outputType: .error),
        innerParser(Matcher.cursorMatcher, outputType: .warning),
        innerParser(Matcher.fatalErrorMatcher, outputType: .error),
        innerParser(Matcher.ldErrorMatcher, outputType: .error),
        innerParser(Matcher.linkerDuplicateSymbolsLocationMatcher, outputType: .error),
        innerParser(Matcher.linkerDuplicateSymbolsMatcher, outputType: .error),
        innerParser(Matcher.linkerUndefinedSymbolLocationMatcher, outputType: .error),
        innerParser(Matcher.linkerUndefinedSymbolsMatcher, outputType: .error),
        innerParser(Matcher.podsErrorMatcher, outputType: .error),
        innerParser(Matcher.symbolReferencedFromMatcher, outputType: .warning),
        innerParser(Matcher.moduleIncludesErrorMatcher, outputType: .error),
        innerParser(Matcher.parallelTestingFailedMatcher, outputType: .error),
        innerParser(Matcher.parallelTestCaseFailedMatcher, outputType: .error),
        innerParser(Matcher.shellCommandMatcher, outputType: .task),
        innerParser(Matcher.undefinedSymbolLocationMatcher, outputType: .warning),
        innerParser(Matcher.packageFetching, outputType: .task),
        innerParser(Matcher.packageUpdating, outputType: .task),
        innerParser(Matcher.packageCheckingOut, outputType: .task),
        innerParser(Matcher.packageGraphResolvingStart, outputType: .task),
        innerParser(Matcher.packageGraphResolvingEnded, outputType: .task),
        innerParser(Matcher.packageGraphResolvedItem, outputType: .task),
        innerParser(Matcher.duplicateLocalizedStringKey, outputType: .warning)
    ]
    
    // MARK: - Init
    
    public init(
        colored: Bool = true,
        preserveUnbeautifiedLines: Bool = false,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored
        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.additionalLines = additionalLines
    }
    public func parse(line: String) -> String? {
        
        // Find first parser that can parse specified string
        guard let idx = innerParsers.firstIndex(where: { $0.regex.match(string: line)}) else {
            
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
            return preserveUnbeautifiedLines ? line : nil
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
        
        let groups = line.capturedGroups(with: .executed)
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
        
        let groups = line.capturedGroups(with: .executedWithSkipped)
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
    
    private func innerParser(_ regex: Regex, outputType: OutputType) -> InnerParser {
        return InnerParser(additionalLines: additionalLines, colored: colored, regex: regex, outputType: outputType)
    }
    
    private struct InnerParser {
        
        fileprivate struct Result {
            let outputType: OutputType
            let value: String?
        }
        
        let additionalLines: () -> String?
        let colored: Bool
        let regex: Regex
        let outputType: OutputType
        
        func parse(line: String) -> Result {
            return .init(outputType: outputType, value: line.beautify(pattern: regex.pattern, colored: colored, additionalLines: additionalLines))
        }
    }

}
