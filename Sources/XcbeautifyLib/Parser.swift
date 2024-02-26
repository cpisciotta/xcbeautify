public class Parser {
    private let colored: Bool

    private let renderer: OutputRendering

    private let additionalLines: () -> String?

    private(set) var summary: TestSummary?

    private(set) var needToRecordSummary = false

    public var preserveUnbeautifiedLines = false

    public var outputType = OutputType.undefined

    private lazy var captureGroupTypes: [CaptureGroup.Type] = [
        AnalyzeCaptureGroup.self,
        BuildTargetCaptureGroup.self,
        AggregateTargetCaptureGroup.self,
        AnalyzeTargetCaptureGroup.self,
        CheckDependenciesCaptureGroup.self,
        CleanRemoveCaptureGroup.self,
        CleanTargetCaptureGroup.self,
        CodesignFrameworkCaptureGroup.self,
        CodesignCaptureGroup.self,
        CompileCaptureGroup.self,
        SwiftCompileCaptureGroup.self,
        SwiftCompilingCaptureGroup.self,
        CompileCommandCaptureGroup.self,
        CompileXibCaptureGroup.self,
        CompileStoryboardCaptureGroup.self,
        CopyHeaderCaptureGroup.self,
        CopyPlistCaptureGroup.self,
        CopyStringsCaptureGroup.self,
        CpresourceCaptureGroup.self,
        FailingTestCaptureGroup.self,
        UIFailingTestCaptureGroup.self,
        RestartingTestCaptureGroup.self,
        GenerateCoverageDataCaptureGroup.self,
        GeneratedCoverageReportCaptureGroup.self,
        GenerateDSYMCaptureGroup.self,
        LibtoolCaptureGroup.self,
        LinkingCaptureGroup.self,
        TestCasePassedCaptureGroup.self,
        TestCaseStartedCaptureGroup.self,
        TestCasePendingCaptureGroup.self,
        TestCaseMeasuredCaptureGroup.self,
        PhaseSuccessCaptureGroup.self,
        PhaseScriptExecutionCaptureGroup.self,
        ProcessPchCaptureGroup.self,
        ProcessPchCommandCaptureGroup.self,
        PreprocessCaptureGroup.self,
        PbxcpCaptureGroup.self,
        ProcessInfoPlistCaptureGroup.self,
        TestsRunCompletionCaptureGroup.self,
        TestSuiteStartedCaptureGroup.self,
        TestSuiteStartCaptureGroup.self,
        TIFFutilCaptureGroup.self,
        TouchCaptureGroup.self,
        WriteFileCaptureGroup.self,
        WriteAuxiliaryFilesCaptureGroup.self,
        ParallelTestCasePassedCaptureGroup.self,
        ParallelTestCaseAppKitPassedCaptureGroup.self,
        ParallelTestingStartedCaptureGroup.self,
        ParallelTestingPassedCaptureGroup.self,
        ParallelTestSuiteStartedCaptureGroup.self,
        LDWarningCaptureGroup.self,
        CompileWarningCaptureGroup.self,
        GenericWarningCaptureGroup.self,
        WillNotBeCodeSignedCaptureGroup.self,
        ClangErrorCaptureGroup.self,
        CheckDependenciesErrorsCaptureGroup.self,
        ProvisioningProfileRequiredCaptureGroup.self,
        NoCertificateCaptureGroup.self,
        FileMissingErrorCaptureGroup.self,
        XcodebuildErrorCaptureGroup.self,
        CompileErrorCaptureGroup.self,
        CursorCaptureGroup.self,
        FatalErrorCaptureGroup.self,
        LDErrorCaptureGroup.self,
        LinkerDuplicateSymbolsLocationCaptureGroup.self,
        LinkerDuplicateSymbolsCaptureGroup.self,
        LinkerUndefinedSymbolLocationCaptureGroup.self,
        LinkerUndefinedSymbolsCaptureGroup.self,
        PodsErrorCaptureGroup.self,
        SymbolReferencedFromCaptureGroup.self,
        ModuleIncludesErrorCaptureGroup.self,
        ParallelTestingFailedCaptureGroup.self,
        ParallelTestCaseFailedCaptureGroup.self,
        ShellCommandCaptureGroup.self,
        UndefinedSymbolLocationCaptureGroup.self,
        PackageFetchingCaptureGroup.self,
        PackageUpdatingCaptureGroup.self,
        PackageCheckingOutCaptureGroup.self,
        PackageGraphResolvingStartCaptureGroup.self,
        PackageGraphResolvingEndedCaptureGroup.self,
        PackageGraphResolvedItemCaptureGroup.self,
        DuplicateLocalizedStringKeyCaptureGroup.self,
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
        if line.isEmpty {
            outputType = .undefined
            return nil
        }

        // Find first parser that can parse specified string
        guard let idx = captureGroupTypes.firstIndex(where: { $0.regex.match(string: line) }) else {
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

        guard let captureGroupType = captureGroupTypes[safe: idx] else {
            assertionFailure()
            return nil
        }

        let formattedOutput = renderer.beautify(
            line: line,
            pattern: captureGroupType.pattern,
            additionalLines: additionalLines
        )

        outputType = captureGroupType.outputType

        // Move found parser to the top, so next time it will be checked first
        captureGroupTypes.insert(captureGroupTypes.remove(at: idx), at: 0)

        return formattedOutput
    }

    public func formattedSummary() -> String? {
        guard let summary else { return nil }
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
}
