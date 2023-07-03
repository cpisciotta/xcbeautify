public class Parser {
    
    private let colored: Bool
    
    private let additionalLines: () -> String?

    public var summary: TestSummary? = nil

    public var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(.analyze, outputType: .task),
        innerParser(.buildTarget, outputType: .task),
        innerParser(.aggregateTarget, outputType: .task),
        innerParser(.analyzeTarget, outputType: .task),
        innerParser(.checkDependencies, outputType: .task),
        innerParser(.cleanRemove, outputType: .task),
        innerParser(.cleanTarget, outputType: .task),
        innerParser(.codesignFramework, outputType: .task),
        innerParser(.codesign, outputType: .task),
        innerParser(.compile, outputType: .task),
        innerParser(.compileCommand, outputType: .task),
        innerParser(.compileXib, outputType: .task),
        innerParser(.compileStoryboard, outputType: .task),
        innerParser(.copyHeader, outputType: .task),
        innerParser(.copyPlist, outputType: .task),
        innerParser(.copyStrings, outputType: .task),
        innerParser(.cpresource, outputType: .task),
        innerParser(.failingTest, outputType: .error),
        innerParser(.uiFailingTest, outputType: .error),
        innerParser(.restartingTest, outputType: .test),
        innerParser(.generateCoverageData, outputType: .task),
        innerParser(.generatedCoverageReport, outputType: .task),
        innerParser(.generateDsym, outputType: .task),
        innerParser(.libtool, outputType: .task),
        innerParser(.linking, outputType: .task),
        innerParser(.testCasePassed, outputType: .test),
        innerParser(.testCaseStarted, outputType: .test),
        innerParser(.testCasePending, outputType: .test),
        innerParser(.testCaseMeasured, outputType: .test),
        innerParser(.phaseSuccess, outputType: .result),
        innerParser(.phaseScriptExecution, outputType: .task),
        innerParser(.processPch, outputType: .task),
        innerParser(.processPchCommand, outputType: .task),
        innerParser(.preprocess, outputType: .task),
        innerParser(.pbxcp, outputType: .task),
        innerParser(.processInfoPlist, outputType: .task),
        innerParser(.testsRunCompletion, outputType: .test),
        innerParser(.testSuiteStarted, outputType: .test),
        innerParser(.testSuiteStart, outputType: .test),
        innerParser(.tiffutil, outputType: .task),
        innerParser(.touch, outputType: .task),
        innerParser(.writeFile, outputType: .task),
        innerParser(.writeAuxiliaryFiles, outputType: .task),
        innerParser(.parallelTestCasePassed, outputType: .test),
        innerParser(.parallelTestCaseAppKitPassed, outputType: .test),
        innerParser(.parallelTestingStarted, outputType: .test),
        innerParser(.parallelTestingPassed, outputType: .test),
        innerParser(.parallelTestSuiteStarted, outputType: .test),
        innerParser(.ldWarning, outputType: .warning),
        innerParser(.compileWarning, outputType: .warning),
        innerParser(.genericWarning, outputType: .warning),
        innerParser(.willNotBeCodeSigned, outputType: .warning),
        innerParser(.clangError, outputType: .error),
        innerParser(.checkDependenciesErrors, outputType: .error),
        innerParser(.provisioningProfileRequired, outputType: .warning),
        innerParser(.noCertificate, outputType: .warning),
        innerParser(.fileMissingError, outputType: .error),
        innerParser(.xcodebuildError, outputType: .error),
        innerParser(.compileError, outputType: .error),
        innerParser(.cursor, outputType: .warning),
        innerParser(.fatalError, outputType: .error),
        innerParser(.ldError, outputType: .error),
        innerParser(.linkerDuplicateSymbolsLocation, outputType: .error),
        innerParser(.linkerDuplicateSymbols, outputType: .error),
        innerParser(.linkerUndefinedSymbolLocation, outputType: .error),
        innerParser(.linkerUndefinedSymbols, outputType: .error),
        innerParser(.podsError, outputType: .error),
        innerParser(.symbolReferencedFrom, outputType: .warning),
        innerParser(.moduleIncludesError, outputType: .error),
        innerParser(.parallelTestingFailed, outputType: .error),
        innerParser(.parallelTestCaseFailed, outputType: .error),
        innerParser(.shellCommand, outputType: .task),
        innerParser(.undefinedSymbolLocation, outputType: .warning),
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
            
            if Regex.executedWithoutSkipped.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored, skipped: false)
                return nil
            }

            if Regex.executedWithSkipped.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored, skipped: true)
                return nil
            }

            if Regex.testSuiteAllTestsPassed.match(string: line) {
                needToRecordSummary = true
                return nil
            }

            if Regex.testSuiteAllTestsFailed.match(string: line) {
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

    private func parseSummary(line: String, colored: Bool, skipped: Bool) {
        guard needToRecordSummary else { return }
        defer { needToRecordSummary = false }

        let _group: CaptureGroup = line.captureGroup(with: skipped ? .executedWithSkipped : .executedWithoutSkipped)
        guard let group = _group as? ExecutedCaptureGroup else { return }

        summary = TestSummary(
            testsCount: group.numberOfTests,
            skippedCount: group.numberOfSkipped,
            failuresCount: group.numberOfFailures,
            unexpectedCount: group.numberOfUnexpectedFailures,
            time: group.wallClockTimeInSeconds,
            colored: colored,
            testSummary: summary
        )
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
