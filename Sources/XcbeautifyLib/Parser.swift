public class Parser {
    
    private let colored: Bool

    private let renderer: OutputRendering
    
    private let additionalLines: () -> String?

    private(set) var summary: TestSummary? = nil

    private(set) var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(captureGroup: AnalyzeCaptureGroup.self),
        innerParser(captureGroup: BuildTargetCaptureGroup.self),
        innerParser(captureGroup: AggregateTargetCaptureGroup.self),
        innerParser(captureGroup: AnalyzeTargetCaptureGroup.self),
        innerParser(captureGroup: CheckDependenciesCaptureGroup.self),
        innerParser(captureGroup: CleanRemoveCaptureGroup.self),
        innerParser(captureGroup: CleanTargetCaptureGroup.self),
        innerParser(captureGroup: CodesignFrameworkCaptureGroup.self),
        innerParser(captureGroup: CodesignCaptureGroup.self),
        innerParser(captureGroup: CompileCaptureGroup.self),
        innerParser(captureGroup: CompileCommandCaptureGroup.self),
        innerParser(captureGroup: CompileXibCaptureGroup.self),
        innerParser(captureGroup: CompileStoryboardCaptureGroup.self),
        innerParser(captureGroup: CopyHeaderCaptureGroup.self),
        innerParser(captureGroup: CopyPlistCaptureGroup.self),
        innerParser(captureGroup: CopyStringsCaptureGroup.self),
        innerParser(captureGroup: CpresourceCaptureGroup.self),
        innerParser(captureGroup: FailingTestCaptureGroup.self),
        innerParser(captureGroup: UIFailingTestCaptureGroup.self),
        innerParser(captureGroup: RestartingTestCaptureGroup.self),
        innerParser(captureGroup: GenerateCoverageDataCaptureGroup.self),
        innerParser(captureGroup: GeneratedCoverageReportCaptureGroup.self),
        innerParser(captureGroup: GenerateDSYMCaptureGroup.self),
        innerParser(captureGroup: LibtoolCaptureGroup.self),
        innerParser(captureGroup: LinkingCaptureGroup.self),
        innerParser(captureGroup: TestCasePassedCaptureGroup.self),
        innerParser(captureGroup: TestCaseStartedCaptureGroup.self),
        innerParser(captureGroup: TestCasePendingCaptureGroup.self),
        innerParser(captureGroup: TestCaseMeasuredCaptureGroup.self),
        innerParser(captureGroup: PhaseSuccessCaptureGroup.self),
        innerParser(captureGroup: PhaseScriptExecutionCaptureGroup.self),
        innerParser(captureGroup: ProcessPchCaptureGroup.self),
        innerParser(captureGroup: ProcessPchCommandCaptureGroup.self),
        innerParser(captureGroup: PreprocessCaptureGroup.self),
        innerParser(captureGroup: PbxcpCaptureGroup.self),
        innerParser(captureGroup: ProcessInfoPlistCaptureGroup.self),
        innerParser(captureGroup: TestsRunCompletionCaptureGroup.self),
        innerParser(captureGroup: TestSuiteStartedCaptureGroup.self),
        innerParser(captureGroup: TestSuiteStartCaptureGroup.self),
        innerParser(captureGroup: TIFFutilCaptureGroup.self),
        innerParser(captureGroup: TouchCaptureGroup.self),
        innerParser(captureGroup: WriteFileCaptureGroup.self),
        innerParser(captureGroup: WriteAuxiliaryFilesCaptureGroup.self),
        innerParser(captureGroup: ParallelTestCasePassedCaptureGroup.self),
        innerParser(captureGroup: ParallelTestCaseAppKitPassedCaptureGroup.self),
        innerParser(captureGroup: ParallelTestingStartedCaptureGroup.self),
        innerParser(captureGroup: ParallelTestingPassedCaptureGroup.self),
        innerParser(captureGroup: ParallelTestSuiteStartedCaptureGroup.self),
        innerParser(captureGroup: LDWarningCaptureGroup.self),
        innerParser(captureGroup: CompileWarningCaptureGroup.self),
        innerParser(captureGroup: GenericWarningCaptureGroup.self),
        innerParser(captureGroup: WillNotBeCodeSignedCaptureGroup.self),
        innerParser(captureGroup: ClangErrorCaptureGroup.self),
        innerParser(captureGroup: CheckDependenciesErrorsCaptureGroup.self),
        innerParser(captureGroup: ProvisioningProfileRequiredCaptureGroup.self),
        innerParser(captureGroup: NoCertificateCaptureGroup.self),
        innerParser(captureGroup: FileMissingErrorCaptureGroup.self),
        innerParser(captureGroup: XcodebuildErrorCaptureGroup.self),
        innerParser(captureGroup: CompileErrorCaptureGroup.self),
        innerParser(captureGroup: CursorCaptureGroup.self),
        innerParser(captureGroup: FatalErrorCaptureGroup.self),
        innerParser(captureGroup: LDErrorCaptureGroup.self),
        innerParser(captureGroup: LinkerDuplicateSymbolsLocationCaptureGroup.self),
        innerParser(captureGroup: LinkerDuplicateSymbolsCaptureGroup.self),
        innerParser(captureGroup: LinkerUndefinedSymbolLocationCaptureGroup.self),
        innerParser(captureGroup: LinkerUndefinedSymbolsCaptureGroup.self),
        innerParser(captureGroup: PodsErrorCaptureGroup.self),
        innerParser(captureGroup: SymbolReferencedFromCaptureGroup.self),
        innerParser(captureGroup: ModuleIncludesErrorCaptureGroup.self),
        innerParser(captureGroup: ParallelTestingFailedCaptureGroup.self),
        innerParser(captureGroup: ParallelTestCaseFailedCaptureGroup.self),
        innerParser(captureGroup: ShellCommandCaptureGroup.self),
        innerParser(captureGroup: UndefinedSymbolLocationCaptureGroup.self),
        innerParser(captureGroup: PackageFetchingCaptureGroup.self),
        innerParser(captureGroup: PackageUpdatingCaptureGroup.self),
        innerParser(captureGroup: PackageCheckingOutCaptureGroup.self),
        innerParser(captureGroup: PackageGraphResolvingStartCaptureGroup.self),
        innerParser(captureGroup: PackageGraphResolvingEndedCaptureGroup.self),
        innerParser(captureGroup: PackageGraphResolvedItemCaptureGroup.self),
        innerParser(captureGroup: DuplicateLocalizedStringKeyCaptureGroup.self),
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
                outputType = ExecutedWithoutSkippedCaptureGroup.outputType
                parseSummary(line: line, colored: colored, skipped: false)
                return nil
            }

            if ExecutedWithSkippedCaptureGroup.regex.match(string: line) {
                outputType = ExecutedWithSkippedCaptureGroup.outputType
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

    private func innerParser(captureGroup: CaptureGroup.Type) -> InnerParser {
        return InnerParser(
            additionalLines: additionalLines,
            renderer: renderer,
            regex: captureGroup.regex,
            outputType: captureGroup.outputType
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
