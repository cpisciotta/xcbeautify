public class Parser {
    
    private let colored: Bool
    
    private let additionalLines: () -> String?

    public var summary: TestSummary? = nil

    public var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(.analyzeMatcher, outputType: .task),
        innerParser(.buildTargetMatcher, outputType: .task),
        innerParser(.aggregateTargetMatcher, outputType: .task),
        innerParser(.analyzeTargetMatcher, outputType: .task),
        innerParser(.checkDependenciesMatcher, outputType: .task),
        innerParser(.cleanRemoveMatcher, outputType: .task),
        innerParser(.cleanTargetMatcher, outputType: .task),
        innerParser(.codesignFrameworkMatcher, outputType: .task),
        innerParser(.codesignMatcher, outputType: .task),
        innerParser(.compileMatcher, outputType: .task),
        innerParser(.compileCommandMatcher, outputType: .task),
        innerParser(.compileXibMatcher, outputType: .task),
        innerParser(.compileStoryboardMatcher, outputType: .task),
        innerParser(.copyHeaderMatcher, outputType: .task),
        innerParser(.copyPlistMatcher, outputType: .task),
        innerParser(.copyStringsMatcher, outputType: .task),
        innerParser(.cpresourceMatcher, outputType: .task),
        innerParser(.failingTestMatcher, outputType: .error),
        innerParser(.uiFailingTestMatcher, outputType: .error),
        innerParser(.restartingTestMatcher, outputType: .test),
        innerParser(.generateCoverageDataMatcher, outputType: .task),
        innerParser(.generatedCoverageReportMatcher, outputType: .task),
        innerParser(.generateDsymMatcher, outputType: .task),
        innerParser(.libtoolMatcher, outputType: .task),
        innerParser(.linkingMatcher, outputType: .task),
        innerParser(.testCasePassedMatcher, outputType: .test),
        innerParser(.testCaseStartedMatcher, outputType: .test),
        innerParser(.testCasePendingMatcher, outputType: .test),
        innerParser(.testCaseMeasuredMatcher, outputType: .test),
        innerParser(.phaseSuccessMatcher, outputType: .result),
        innerParser(.phaseScriptExecutionMatcher, outputType: .task),
        innerParser(.processPchMatcher, outputType: .task),
        innerParser(.processPchCommandMatcher, outputType: .task),
        innerParser(.preprocessMatcher, outputType: .task),
        innerParser(.pbxcpMatcher, outputType: .task),
        innerParser(.processInfoPlistMatcher, outputType: .task),
        innerParser(.testsRunCompletionMatcher, outputType: .test),
        innerParser(.testSuiteStartedMatcher, outputType: .test),
        innerParser(.testSuiteStartMatcher, outputType: .test),
        innerParser(.tiffutilMatcher, outputType: .task),
        innerParser(.touchMatcher, outputType: .task),
        innerParser(.writeFileMatcher, outputType: .task),
        innerParser(.writeAuxiliaryFilesMatcher, outputType: .task),
        innerParser(.parallelTestCasePassedMatcher, outputType: .test),
        innerParser(.parallelTestCaseAppKitPassedMatcher, outputType: .test),
        innerParser(.parallelTestingStartedMatcher, outputType: .test),
        innerParser(.parallelTestingPassedMatcher, outputType: .test),
        innerParser(.parallelTestSuiteStartedMatcher, outputType: .test),
        innerParser(.ldWarningMatcher, outputType: .warning),
        innerParser(.compileWarningMatcher, outputType: .warning),
        innerParser(.genericWarningMatcher, outputType: .warning),
        innerParser(.willNotBeCodeSignedMatcher, outputType: .warning),
        innerParser(.clangErrorMatcher, outputType: .error),
        innerParser(.checkDependenciesErrorsMatcher, outputType: .error),
        innerParser(.provisioningProfileRequiredMatcher, outputType: .warning),
        innerParser(.noCertificateMatcher, outputType: .warning),
        innerParser(.fileMissingErrorMatcher, outputType: .error),
        innerParser(.xcodebuildErrorMatcher, outputType: .error),
        innerParser(.compileErrorMatcher, outputType: .error),
        innerParser(.cursorMatcher, outputType: .warning),
        innerParser(.fatalErrorMatcher, outputType: .error),
        innerParser(.ldErrorMatcher, outputType: .error),
        innerParser(.linkerDuplicateSymbolsLocationMatcher, outputType: .error),
        innerParser(.linkerDuplicateSymbolsMatcher, outputType: .error),
        innerParser(.linkerUndefinedSymbolLocationMatcher, outputType: .error),
        innerParser(.linkerUndefinedSymbolsMatcher, outputType: .error),
        innerParser(.podsErrorMatcher, outputType: .error),
        innerParser(.symbolReferencedFromMatcher, outputType: .warning),
        innerParser(.moduleIncludesErrorMatcher, outputType: .error),
        innerParser(.parallelTestingFailedMatcher, outputType: .error),
        innerParser(.parallelTestCaseFailedMatcher, outputType: .error),
        innerParser(.shellCommandMatcher, outputType: .task),
        innerParser(.undefinedSymbolLocationMatcher, outputType: .warning),
        innerParser(.packageFetching, outputType: .task),
        innerParser(.packageUpdating, outputType: .task),
        innerParser(.packageCheckingOut, outputType: .task),
        innerParser(.packageGraphResolvingStart, outputType: .task),
        innerParser(.packageGraphResolvingEnded, outputType: .task),
        innerParser(.packageGraphResolvedItem, outputType: .task),
        innerParser(.duplicateLocalizedStringKey, outputType: .warning)
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
            
            if Regex.executedMatcher.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored)
                return nil
            }

            if Regex.executedWithSkippedMatcher.match(string: line) {
                outputType = OutputType.task
                parseSummarySkipped(line: line, colored: colored)
                return nil
            }

            if Regex.testSuiteAllTestsPassedMatcher.match(string: line) {
                needToRecordSummary = true
                return nil
            }

            if Regex.testSuiteAllTestsFailedMatcher.match(string: line) {
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
        
        let group: [String] = line.captureGroup(with: .executed)
        summary = TestSummary(
            testsCount: Int(group[0]) ?? 0,
            skippedCount: 0,
            failuresCount: Int(group[1]) ?? 0,
            unexpectedCount: Int(group[2]) ?? 0,
            time: Double(group[3]) ?? 0,
            colored: colored,
            testSummary: summary)
        
        needToRecordSummary = false
    }
    
    private func parseSummarySkipped(line: String, colored: Bool) {
        if !needToRecordSummary {
            return
        }
        
        let group: [String] = line.captureGroup(with: .executedWithSkipped)
        summary = TestSummary(
            testsCount: Int(group[0]) ?? 0,
            skippedCount: Int(group[1]) ?? 0,
            failuresCount: Int(group[2]) ?? 0,
            unexpectedCount: Int(group[3]) ?? 0,
            time: Double(group[4]) ?? 0,
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
