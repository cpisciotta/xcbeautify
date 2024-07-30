import Foundation

package class Parser {
    private let colored: Bool

    private let renderer: any OutputRendering

    private let additionalLines: () -> String?

    private let preserveUnbeautifiedLines: Bool

    package private(set) var outputType = OutputType.undefined

    private lazy var captureGroupTypes: [any CaptureGroup.Type] = [
        AnalyzeCaptureGroup.self,
        BuildTargetCaptureGroup.self,
        AggregateTargetCaptureGroup.self,
        AnalyzeTargetCaptureGroup.self,
        CheckDependenciesCaptureGroup.self,
        CleanRemoveCaptureGroup.self,
        CleanTargetCaptureGroup.self,
        CodesignFrameworkCaptureGroup.self,
        CodesignCaptureGroup.self,
        CompilationResultCaptureGroup.self,
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
        TestCaseSkippedCaptureGroup.self,
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
        WriteAuxiliaryFileCaptureGroup.self,
        ParallelTestCasePassedCaptureGroup.self,
        ParallelTestCaseSkippedCaptureGroup.self,
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
        SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.self,
        ExecutedWithoutSkippedCaptureGroup.self,
        ExecutedWithSkippedCaptureGroup.self,
        TestSuiteAllTestsPassedCaptureGroup.self,
        TestSuiteAllTestsFailedCaptureGroup.self,
    ]

    // MARK: - Init

    package init(
        colored: Bool = true,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool = false,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored, additionalLines: additionalLines)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer(colored: colored, additionalLines: additionalLines)
        case .teamcity:
            self.renderer = TeamCityRenderer(colored: colored, additionalLines: additionalLines)
        }

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.additionalLines = additionalLines
    }

    package func parse(line: String) -> String? {
        if line.isEmpty {
            outputType = .undefined
            return nil
        }

        // Find first parser that can parse specified string
        guard let idx = captureGroupTypes.firstIndex(where: { $0.regex.match(string: line) }) else {
            // Some uncommon cases, which have additional logic and don't follow default flow

            #if DEBUG
            if ProcessInfo.processInfo.environment["XCB_RECORD_UNCAPTURED"] == "true" {
                recordUncapturedOutput(line: line)
            }
            #endif

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
            pattern: captureGroupType.pattern
        )

        outputType = captureGroupType.outputType

        // Move found parser to the top, so next time it will be checked first
        captureGroupTypes.insert(captureGroupTypes.remove(at: idx), at: 0)

        return formattedOutput
    }

    #if DEBUG
    private func recordUncapturedOutput(line: String) {
        assert(ProcessInfo.processInfo.environment["XCB_RECORD_UNCAPTURED"] == "true")

        let filePath = FileManager.default.currentDirectoryPath.appending("/uncaptured.txt")

        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil)
        }

        let handle = FileHandle(forWritingAtPath: filePath)!
        handle.seekToEndOfFile()
        handle.write(line.appending("\n").data(using: .utf8)!)
        handle.closeFile()
    }
    #endif

}
