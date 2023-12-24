public class Parser {
    
    private let colored: Bool

    private let renderer: OutputRendering
    
    private let additionalLines: () -> String?

    private(set) var summary: TestSummary? = nil

    private(set) var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(AnalyzeCaptureGroup.regex, outputType: .task),
        innerParser(BuildTargetCaptureGroup.regex, outputType: .task),
        innerParser(AggregateTargetCaptureGroup.regex, outputType: .task),
        innerParser(AnalyzeTargetCaptureGroup.regex, outputType: .task),
        innerParser(CheckDependenciesCaptureGroup.regex, outputType: .task),
        innerParser(CleanRemoveCaptureGroup.regex, outputType: .task),
        innerParser(CleanTargetCaptureGroup.regex, outputType: .task),
        innerParser(CodesignFrameworkCaptureGroup.regex, outputType: .task),
        innerParser(CodesignCaptureGroup.regex, outputType: .task),
        innerParser(CompileCaptureGroup.regex, outputType: .task),
        innerParser(CompileCommandCaptureGroup.regex, outputType: .task),
        innerParser(CompileXibCaptureGroup.regex, outputType: .task),
        innerParser(CompileStoryboardCaptureGroup.regex, outputType: .task),
        innerParser(CopyHeaderCaptureGroup.regex, outputType: .task),
        innerParser(CopyPlistCaptureGroup.regex, outputType: .task),
        innerParser(CopyStringsCaptureGroup.regex, outputType: .task),
        innerParser(CpresourceCaptureGroup.regex, outputType: .task),
        innerParser(FailingTestCaptureGroup.regex, outputType: .error),
        innerParser(UIFailingTestCaptureGroup.regex, outputType: .error),
        innerParser(RestartingTestCaptureGroup.regex, outputType: .test),
        innerParser(GenerateCoverageDataCaptureGroup.regex, outputType: .task),
        innerParser(GeneratedCoverageReportCaptureGroup.regex, outputType: .task),
        innerParser(GenerateDSYMCaptureGroup.regex, outputType: .task),
        innerParser(LibtoolCaptureGroup.regex, outputType: .task),
        innerParser(LinkingCaptureGroup.regex, outputType: .task),
        innerParser(TestCasePassedCaptureGroup.regex, outputType: .testCase),
        innerParser(TestCaseStartedCaptureGroup.regex, outputType: .testCase),
        innerParser(TestCasePendingCaptureGroup.regex, outputType: .testCase),
        innerParser(TestCaseMeasuredCaptureGroup.regex, outputType: .testCase),
        innerParser(PhaseSuccessCaptureGroup.regex, outputType: .result),
        innerParser(PhaseScriptExecutionCaptureGroup.regex, outputType: .task),
        innerParser(ProcessPchCaptureGroup.regex, outputType: .task),
        innerParser(ProcessPchCommandCaptureGroup.regex, outputType: .task),
        innerParser(PreprocessCaptureGroup.regex, outputType: .task),
        innerParser(PbxcpCaptureGroup.regex, outputType: .task),
        innerParser(ProcessInfoPlistCaptureGroup.regex, outputType: .task),
        innerParser(TestsRunCompletionCaptureGroup.regex, outputType: .test),
        innerParser(TestSuiteStartedCaptureGroup.regex, outputType: .test),
        innerParser(TestSuiteStartCaptureGroup.regex, outputType: .test),
        innerParser(TIFFutilCaptureGroup.regex, outputType: .task),
        innerParser(TouchCaptureGroup.regex, outputType: .task),
        innerParser(WriteFileCaptureGroup.regex, outputType: .task),
        innerParser(WriteAuxiliaryFilesCaptureGroup.regex, outputType: .task),
        innerParser(ParallelTestCasePassedCaptureGroup.regex, outputType: .testCase),
        innerParser(ParallelTestCaseAppKitPassedCaptureGroup.regex, outputType: .testCase),
        innerParser(ParallelTestingStartedCaptureGroup.regex, outputType: .test),
        innerParser(ParallelTestingPassedCaptureGroup.regex, outputType: .test),
        innerParser(ParallelTestSuiteStartedCaptureGroup.regex, outputType: .test),
        innerParser(LDWarningCaptureGroup.regex, outputType: .warning),
        innerParser(CompileWarningCaptureGroup.regex, outputType: .warning),
        innerParser(GenericWarningCaptureGroup.regex, outputType: .warning),
        innerParser(WillNotBeCodeSignedCaptureGroup.regex, outputType: .warning),
        innerParser(ClangErrorCaptureGroup.regex, outputType: .error),
        innerParser(CheckDependenciesErrorsCaptureGroup.regex, outputType: .error),
        innerParser(ProvisioningProfileRequiredCaptureGroup.regex, outputType: .error),
        innerParser(NoCertificateCaptureGroup.regex, outputType: .warning),
        innerParser(FileMissingErrorCaptureGroup.regex, outputType: .error),
        innerParser(XcodebuildErrorCaptureGroup.regex, outputType: .error),
        innerParser(CompileErrorCaptureGroup.regex, outputType: .error),
        innerParser(CursorCaptureGroup.regex, outputType: .warning),
        innerParser(FatalErrorCaptureGroup.regex, outputType: .error),
        innerParser(LDErrorCaptureGroup.regex, outputType: .error),
        innerParser(LinkerDuplicateSymbolsLocationCaptureGroup.regex, outputType: .error),
        innerParser(LinkerDuplicateSymbolsCaptureGroup.regex, outputType: .error),
        innerParser(LinkerUndefinedSymbolLocationCaptureGroup.regex, outputType: .error),
        innerParser(LinkerUndefinedSymbolsCaptureGroup.regex, outputType: .error),
        innerParser(PodsErrorCaptureGroup.regex, outputType: .error),
        innerParser(SymbolReferencedFromCaptureGroup.regex, outputType: .error),
        innerParser(ModuleIncludesErrorCaptureGroup.regex, outputType: .error),
        innerParser(ParallelTestingFailedCaptureGroup.regex, outputType: .nonContextualError),
        innerParser(ParallelTestCaseFailedCaptureGroup.regex, outputType: .error),
        innerParser(ShellCommandCaptureGroup.regex, outputType: .task),
        innerParser(UndefinedSymbolLocationCaptureGroup.regex, outputType: .warning),
        innerParser(PackageFetchingCaptureGroup.regex, outputType: .task),
        innerParser(PackageUpdatingCaptureGroup.regex, outputType: .task),
        innerParser(PackageCheckingOutCaptureGroup.regex, outputType: .task),
        innerParser(PackageGraphResolvingStartCaptureGroup.regex, outputType: .task),
        innerParser(PackageGraphResolvingEndedCaptureGroup.regex, outputType: .task),
        innerParser(PackageGraphResolvedItemCaptureGroup.regex, outputType: .task),
        innerParser(DuplicateLocalizedStringKeyCaptureGroup.regex, outputType: .warning)
    ]
    
    // MARK: - Init
    
    public init(
        colored: Bool = true,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool = false,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.additionalLines = additionalLines
    }

    public func parse(line: String) -> String? {
        
        // Find first parser that can parse specified string
        guard let idx = innerParsers.firstIndex(where: { $0.regex.match(string: line)}) else {
            
            // Some uncommon cases, which have additional logic and don't follow default flow
            
            if ExecutedWithoutSkippedCaptureGroup.regex.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored, skipped: false)
                return nil
            }

            if ExecutedWithSkippedCaptureGroup.regex.match(string: line) {
                outputType = OutputType.task
                parseSummary(line: line, colored: colored, skipped: true)
                return nil
            }

            if TestSuiteAllTestsPassedCaptureGroup.regex.match(string: line) {
                needToRecordSummary = true
                return nil
            }

            if TestSuiteAllTestsFailedCaptureGroup.regex.match(string: line) {
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

    public func formattedSummary() -> String? {
        guard let summary = summary else { return nil }
        return renderer.format(testSummary: summary)
    }

    // MARK: Private

    private func parseSummary(line: String, colored: Bool, skipped: Bool) {
        guard needToRecordSummary else { return }
        defer { needToRecordSummary = false }

        guard let _group: CaptureGroup = line.captureGroup(with: skipped ? ExecutedWithSkippedCaptureGroup.pattern : ExecutedWithoutSkippedCaptureGroup.pattern) else { return }
        guard let group = _group as? ExecutedCaptureGroup else { return }

        summary += TestSummary(
            testsCount: group.numberOfTests,
            skippedCount: group.numberOfSkipped,
            failuresCount: group.numberOfFailures,
            unexpectedCount: group.numberOfUnexpectedFailures,
            time: group.wallClockTimeInSeconds
        )
    }

    private func innerParser(_ regex: Regex, outputType: OutputType) -> InnerParser {
        return InnerParser(
            additionalLines: additionalLines,
            renderer: renderer,
            regex: regex,
            outputType: outputType
        )
    }
    
    private struct InnerParser {
        
        fileprivate struct Result {
            let outputType: OutputType
            let value: String?
        }
        
        let additionalLines: () -> String?
        let renderer: OutputRendering
        let regex: Regex
        let outputType: OutputType
        
        func parse(line: String) -> Result {
            return Result(
                outputType: outputType,
                value: renderer.beautify(
                    line: line,
                    pattern: regex.pattern,
                    additionalLines: additionalLines
                )
            )
        }
    }

}
