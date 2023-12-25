public class Parser {
    
    private let colored: Bool

    private let renderer: OutputRendering
    
    private let additionalLines: () -> String?

    private(set) var summary: TestSummary? = nil

    private(set) var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType: OutputType = OutputType.undefined
    
    private lazy var innerParsers: [InnerParser] = [
        innerParser(AnalyzeCaptureGroup.regex, outputType: AnalyzeCaptureGroup.outputType),
        innerParser(BuildTargetCaptureGroup.regex, outputType: BuildTargetCaptureGroup.outputType),
        innerParser(AggregateTargetCaptureGroup.regex, outputType: AggregateTargetCaptureGroup.outputType),
        innerParser(AnalyzeTargetCaptureGroup.regex, outputType: AnalyzeTargetCaptureGroup.outputType),
        innerParser(CheckDependenciesCaptureGroup.regex, outputType: CheckDependenciesCaptureGroup.outputType),
        innerParser(CleanRemoveCaptureGroup.regex, outputType: CleanRemoveCaptureGroup.outputType),
        innerParser(CleanTargetCaptureGroup.regex, outputType: CleanTargetCaptureGroup.outputType),
        innerParser(CodesignFrameworkCaptureGroup.regex, outputType: CodesignFrameworkCaptureGroup.outputType),
        innerParser(CodesignCaptureGroup.regex, outputType: CodesignCaptureGroup.outputType),
        innerParser(CompileCaptureGroup.regex, outputType: CompileCaptureGroup.outputType),
        innerParser(CompileCommandCaptureGroup.regex, outputType: CompileCommandCaptureGroup.outputType),
        innerParser(CompileXibCaptureGroup.regex, outputType: CompileXibCaptureGroup.outputType),
        innerParser(CompileStoryboardCaptureGroup.regex, outputType: CompileStoryboardCaptureGroup.outputType),
        innerParser(CopyHeaderCaptureGroup.regex, outputType: CopyHeaderCaptureGroup.outputType),
        innerParser(CopyPlistCaptureGroup.regex, outputType: CopyPlistCaptureGroup.outputType),
        innerParser(CopyStringsCaptureGroup.regex, outputType: CopyStringsCaptureGroup.outputType),
        innerParser(CpresourceCaptureGroup.regex, outputType: CpresourceCaptureGroup.outputType),
        innerParser(FailingTestCaptureGroup.regex, outputType: FailingTestCaptureGroup.outputType),
        innerParser(UIFailingTestCaptureGroup.regex, outputType: UIFailingTestCaptureGroup.outputType),
        innerParser(RestartingTestCaptureGroup.regex, outputType: RestartingTestCaptureGroup.outputType),
        innerParser(GenerateCoverageDataCaptureGroup.regex, outputType: GenerateCoverageDataCaptureGroup.outputType),
        innerParser(GeneratedCoverageReportCaptureGroup.regex, outputType: GeneratedCoverageReportCaptureGroup.outputType),
        innerParser(GenerateDSYMCaptureGroup.regex, outputType: GenerateDSYMCaptureGroup.outputType),
        innerParser(LibtoolCaptureGroup.regex, outputType: LibtoolCaptureGroup.outputType),
        innerParser(LinkingCaptureGroup.regex, outputType: LinkingCaptureGroup.outputType),
        innerParser(TestCasePassedCaptureGroup.regex, outputType: TestCasePassedCaptureGroup.outputType),
        innerParser(TestCaseStartedCaptureGroup.regex, outputType: TestCaseStartedCaptureGroup.outputType),
        innerParser(TestCasePendingCaptureGroup.regex, outputType: TestCasePendingCaptureGroup.outputType),
        innerParser(TestCaseMeasuredCaptureGroup.regex, outputType: TestCaseMeasuredCaptureGroup.outputType),
        innerParser(PhaseSuccessCaptureGroup.regex, outputType: PhaseSuccessCaptureGroup.outputType),
        innerParser(PhaseScriptExecutionCaptureGroup.regex, outputType: PhaseScriptExecutionCaptureGroup.outputType),
        innerParser(ProcessPchCaptureGroup.regex, outputType: ProcessPchCaptureGroup.outputType),
        innerParser(ProcessPchCommandCaptureGroup.regex, outputType: ProcessPchCommandCaptureGroup.outputType),
        innerParser(PreprocessCaptureGroup.regex, outputType: PreprocessCaptureGroup.outputType),
        innerParser(PbxcpCaptureGroup.regex, outputType: PbxcpCaptureGroup.outputType),
        innerParser(ProcessInfoPlistCaptureGroup.regex, outputType: ProcessInfoPlistCaptureGroup.outputType),
        innerParser(TestsRunCompletionCaptureGroup.regex, outputType: TestsRunCompletionCaptureGroup.outputType),
        innerParser(TestSuiteStartedCaptureGroup.regex, outputType: TestSuiteStartedCaptureGroup.outputType),
        innerParser(TestSuiteStartCaptureGroup.regex, outputType: TestSuiteStartCaptureGroup.outputType),
        innerParser(TIFFutilCaptureGroup.regex, outputType: TIFFutilCaptureGroup.outputType),
        innerParser(TouchCaptureGroup.regex, outputType: TouchCaptureGroup.outputType),
        innerParser(WriteFileCaptureGroup.regex, outputType: WriteFileCaptureGroup.outputType),
        innerParser(WriteAuxiliaryFilesCaptureGroup.regex, outputType: WriteAuxiliaryFilesCaptureGroup.outputType),
        innerParser(ParallelTestCasePassedCaptureGroup.regex, outputType: ParallelTestCasePassedCaptureGroup.outputType),
        innerParser(ParallelTestCaseAppKitPassedCaptureGroup.regex, outputType: ParallelTestCaseAppKitPassedCaptureGroup.outputType),
        innerParser(ParallelTestingStartedCaptureGroup.regex, outputType: ParallelTestingStartedCaptureGroup.outputType),
        innerParser(ParallelTestingPassedCaptureGroup.regex, outputType: ParallelTestingPassedCaptureGroup.outputType),
        innerParser(ParallelTestSuiteStartedCaptureGroup.regex, outputType: ParallelTestSuiteStartedCaptureGroup.outputType),
        innerParser(LDWarningCaptureGroup.regex, outputType: LDWarningCaptureGroup.outputType),
        innerParser(CompileWarningCaptureGroup.regex, outputType: CompileWarningCaptureGroup.outputType),
        innerParser(GenericWarningCaptureGroup.regex, outputType: GenericWarningCaptureGroup.outputType),
        innerParser(WillNotBeCodeSignedCaptureGroup.regex, outputType: WillNotBeCodeSignedCaptureGroup.outputType),
        innerParser(ClangErrorCaptureGroup.regex, outputType: ClangErrorCaptureGroup.outputType),
        innerParser(CheckDependenciesErrorsCaptureGroup.regex, outputType: CheckDependenciesErrorsCaptureGroup.outputType),
        innerParser(ProvisioningProfileRequiredCaptureGroup.regex, outputType: ProvisioningProfileRequiredCaptureGroup.outputType),
        innerParser(NoCertificateCaptureGroup.regex, outputType: NoCertificateCaptureGroup.outputType),
        innerParser(FileMissingErrorCaptureGroup.regex, outputType: FileMissingErrorCaptureGroup.outputType),
        innerParser(XcodebuildErrorCaptureGroup.regex, outputType: XcodebuildErrorCaptureGroup.outputType),
        innerParser(CompileErrorCaptureGroup.regex, outputType: CompileErrorCaptureGroup.outputType),
        innerParser(CursorCaptureGroup.regex, outputType: CursorCaptureGroup.outputType),
        innerParser(FatalErrorCaptureGroup.regex, outputType: FatalErrorCaptureGroup.outputType),
        innerParser(LDErrorCaptureGroup.regex, outputType: LDErrorCaptureGroup.outputType),
        innerParser(LinkerDuplicateSymbolsLocationCaptureGroup.regex, outputType: LinkerDuplicateSymbolsLocationCaptureGroup.outputType),
        innerParser(LinkerDuplicateSymbolsCaptureGroup.regex, outputType: LinkerDuplicateSymbolsCaptureGroup.outputType),
        innerParser(LinkerUndefinedSymbolLocationCaptureGroup.regex, outputType: LinkerUndefinedSymbolLocationCaptureGroup.outputType),
        innerParser(LinkerUndefinedSymbolsCaptureGroup.regex, outputType: LinkerUndefinedSymbolsCaptureGroup.outputType),
        innerParser(PodsErrorCaptureGroup.regex, outputType: PodsErrorCaptureGroup.outputType),
        innerParser(SymbolReferencedFromCaptureGroup.regex, outputType: SymbolReferencedFromCaptureGroup.outputType),
        innerParser(ModuleIncludesErrorCaptureGroup.regex, outputType: ModuleIncludesErrorCaptureGroup.outputType),
        innerParser(ParallelTestingFailedCaptureGroup.regex, outputType: ParallelTestingFailedCaptureGroup.outputType),
        innerParser(ParallelTestCaseFailedCaptureGroup.regex, outputType: ParallelTestCaseFailedCaptureGroup.outputType),
        innerParser(ShellCommandCaptureGroup.regex, outputType: ShellCommandCaptureGroup.outputType),
        innerParser(UndefinedSymbolLocationCaptureGroup.regex, outputType: UndefinedSymbolLocationCaptureGroup.outputType),
        innerParser(PackageFetchingCaptureGroup.regex, outputType: PackageFetchingCaptureGroup.outputType),
        innerParser(PackageUpdatingCaptureGroup.regex, outputType: PackageUpdatingCaptureGroup.outputType),
        innerParser(PackageCheckingOutCaptureGroup.regex, outputType: PackageCheckingOutCaptureGroup.outputType),
        innerParser(PackageGraphResolvingStartCaptureGroup.regex, outputType: PackageGraphResolvingStartCaptureGroup.outputType),
        innerParser(PackageGraphResolvingEndedCaptureGroup.regex, outputType: PackageGraphResolvingEndedCaptureGroup.outputType),
        innerParser(PackageGraphResolvedItemCaptureGroup.regex, outputType: PackageGraphResolvedItemCaptureGroup.outputType),
        innerParser(DuplicateLocalizedStringKeyCaptureGroup.regex, outputType: DuplicateLocalizedStringKeyCaptureGroup.outputType)
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
