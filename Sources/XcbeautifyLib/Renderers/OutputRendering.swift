import Foundation

protocol OutputRendering {
    var colored: Bool { get }

    func beautify(line: String, pattern: String, additionalLines: @escaping () -> (String?)) -> String?

    func format(testSummary: TestSummary) -> String

    func format(line: String, command: String, pattern: String, arguments: String) -> String?
    func formatAnalyze(group: AnalyzeCaptureGroup) -> String
    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String
    func formatCodeSign(group: CodesignCaptureGroup) -> String
    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String
    func formatCompile(group: CompileFileCaptureGroup) -> String
    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String?
    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String
    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String
    func formatCompleteError(line: String) -> String
    func formatCompleteWarning(line: String) -> String
    func formatCopy(group: CopyCaptureGroup) -> String
    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String
    func formatCursor(group: CursorCaptureGroup) -> String?
    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String
    func formatError(group: ErrorCaptureGroup) -> String
    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String?
    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String?
    func formatFailingTest(group: FailingTestCaptureGroup) -> String
    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String
    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String
    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String
    func formatLdWarning(group: LDWarningCaptureGroup) -> String
    func formatLibtool(group: LibtoolCaptureGroup) -> String
    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String
    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String?
    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String?
    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String
    func formatLinking(group: LinkingCaptureGroup) -> String
    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String
    func formatPackageEnd() -> String
    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String
    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String
    func formatPackageStart() -> String
    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String
    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String
    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String
    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String
    func formatParallelTestingFailed(line: String, group: ParallelTestingFailedCaptureGroup) -> String
    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String
    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String
    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String
    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String
    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String
    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String
    func formatProcessPch(group: ProcessPchCaptureGroup) -> String
    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String
    func formatRestartingTest(line: String, group: RestartingTestCaptureGroup) -> String
    func formatShellCommand(group: ShellCommandCaptureGroup) -> String?
    func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String
    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String
    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String
    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String
    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String?
    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String?
    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String?
    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup) -> String?
    func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String
    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String
    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String?
    func formatTouch(group: TouchCaptureGroup) -> String
    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String
    func formatWarning(group: GenericWarningCaptureGroup) -> String
    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String
    func formatWriteAuxiliaryFiles(group: WriteAuxiliaryFilesCaptureGroup) -> String?
    func formatWriteFile(group: WriteFileCaptureGroup) -> String?
}

extension OutputRendering {
    func beautify(
        line: String,
        pattern: String,
        additionalLines: @escaping () -> (String?)
    ) -> String? {
        guard let group: CaptureGroup = line.captureGroup(with: pattern) else {
            assertionFailure("Expected a known CaptureGroup from the given pattern!")
            return nil
        }

        assert(pattern == group.pattern)

        switch group {
        case let group as AggregateTargetCaptureGroup:
            return formatTargetCommand(command: "Aggregate", group: group)
        case let group as AnalyzeCaptureGroup:
            return formatAnalyze(group: group)
        case let group as AnalyzeTargetCaptureGroup:
            return formatTargetCommand(command: "Analyze", group: group)
        case let group as BuildTargetCaptureGroup:
            return formatTargetCommand(command: "Build", group: group)
        case is CheckDependenciesCaptureGroup:
            return format(line: line, command: "Check Dependencies", pattern: CheckDependenciesCaptureGroup.pattern, arguments: "")
        case let group as CheckDependenciesErrorsCaptureGroup:
            return formatError(group: group)
        case let group as ClangErrorCaptureGroup:
            return formatError(group: group)
        case let group as CleanRemoveCaptureGroup:
            return formatCleanRemove(group: group)
        case let group as CleanTargetCaptureGroup:
            return formatTargetCommand(command: "Clean", group: group)
        case let group as CodesignCaptureGroup:
            return formatCodeSign(group: group)
        case let group as CodesignFrameworkCaptureGroup:
            return formatCodeSignFramework(group: group)
        case let group as CompileCaptureGroup:
            return formatCompile(group: group)
        case let group as CompileCommandCaptureGroup:
            return formatCompileCommand(group: group)
        case let group as CompileErrorCaptureGroup:
            return formatCompileError(group: group, additionalLines: additionalLines)
        case let group as CompileStoryboardCaptureGroup:
            return formatCompile(group: group)
        case let group as CompileWarningCaptureGroup:
            return formatCompileWarning(group: group, additionalLines: additionalLines)
        case let group as CompileXibCaptureGroup:
            return formatCompile(group: group)
        case let group as CopyHeaderCaptureGroup:
            return formatCopy(group: group)
        case let group as CopyPlistCaptureGroup:
            return formatCopy(group: group)
        case let group as CopyStringsCaptureGroup:
            return formatCopy(group: group)
        case let group as CpresourceCaptureGroup:
            return formatCopy(group: group)
        case let group as CursorCaptureGroup:
            return formatCursor(group: group)
        case let group as DuplicateLocalizedStringKeyCaptureGroup:
            return formatDuplicateLocalizedStringKey(group: group)
        case let group as ExecutedWithoutSkippedCaptureGroup:
            return formatExecutedWithoutSkipped(group: group)
        case let group as ExecutedWithSkippedCaptureGroup:
            return formatExecutedWithSkipped(group: group)
        case let group as FailingTestCaptureGroup:
            return formatFailingTest(group: group)
        case let group as FatalErrorCaptureGroup:
            return formatError(group: group)
        case let group as FileMissingErrorCaptureGroup:
            return formatFileMissingError(group: group)
        case let group as GenerateCoverageDataCaptureGroup:
            return formatGenerateCoverageData(group: group)
        case let group as GeneratedCoverageReportCaptureGroup:
            return formatCoverageReport(group: group)
        case let group as GenerateDSYMCaptureGroup:
            return formatGenerateDsym(group: group)
        case let group as GenericWarningCaptureGroup:
            return formatWarning(group: group)
        case let group as LDErrorCaptureGroup:
            return formatError(group: group)
        case let group as LDWarningCaptureGroup:
            return formatLdWarning(group: group)
        case let group as LibtoolCaptureGroup:
            return formatLibtool(group: group)
        case let group as LinkerDuplicateSymbolsCaptureGroup:
            return formatLinkerDuplicateSymbolsError(group: group)
        case let group as LinkerDuplicateSymbolsLocationCaptureGroup:
            return formatLinkerDuplicateSymbolsLocation(group: group)
        case let group as LinkerUndefinedSymbolLocationCaptureGroup:
            return formatLinkerUndefinedSymbolLocation(group: group)
        case let group as LinkerUndefinedSymbolsCaptureGroup:
            return formatLinkerUndefinedSymbolsError(group: group)
        case let group as LinkingCaptureGroup:
            return formatLinking(group: group)
        case let group as ModuleIncludesErrorCaptureGroup:
            return formatError(group: group)
        case let group as NoCertificateCaptureGroup:
            return formatError(group: group)
        case let group as PackageCheckingOutCaptureGroup:
            return formatPackageCheckingOut(group: group)
        case let group as PackageFetchingCaptureGroup:
            return formatPackageFetching(group: group)
        case let group as PackageGraphResolvedItemCaptureGroup:
            return formatPackageItem(group: group)
        case is PackageGraphResolvingEndedCaptureGroup:
            return formatPackageEnd()
        case is PackageGraphResolvingStartCaptureGroup:
            return formatPackageStart()
        case let group as PackageUpdatingCaptureGroup:
            return formatPackageUpdating(group: group)
        case let group as ParallelTestCaseAppKitPassedCaptureGroup:
            return formatParallelTestCaseAppKitPassed(group: group)
        case let group as ParallelTestCaseFailedCaptureGroup:
            return formatParallelTestCaseFailed(group: group)
        case let group as ParallelTestCasePassedCaptureGroup:
            return formatParallelTestCasePassed(group: group)
        case let group as ParallelTestingFailedCaptureGroup:
            return formatParallelTestingFailed(line: line, group: group)
        case let group as ParallelTestingPassedCaptureGroup:
            return formatParallelTestingPassed(line: line, group: group)
        case let group as ParallelTestingStartedCaptureGroup:
            return formatParallelTestingStarted(line: line, group: group)
        case let group as ParallelTestSuiteStartedCaptureGroup:
            return formatParallelTestSuiteStarted(group: group)
        case let group as PbxcpCaptureGroup:
            return formatCopy(group: group)
        case let group as PhaseScriptExecutionCaptureGroup:
            return formatPhaseScriptExecution(group: group)
        case let group as PhaseSuccessCaptureGroup:
            return formatPhaseSuccess(group: group)
        case let group as PodsErrorCaptureGroup:
            return formatError(group: group)
        case is PreprocessCaptureGroup:
            return format(line: line, command: "Preprocessing", pattern: pattern, arguments: "$1")
        case let group as ProcessInfoPlistCaptureGroup:
            return formatProcessInfoPlist(group: group)
        case let group as ProcessPchCaptureGroup:
            return formatProcessPch(group: group)
        case let group as ProcessPchCommandCaptureGroup:
            return formatProcessPchCommand(group: group)
        case let group as ProvisioningProfileRequiredCaptureGroup:
            return formatError(group: group)
        case let group as RestartingTestCaptureGroup:
            return formatRestartingTest(line: line, group: group)
        case let group as ShellCommandCaptureGroup:
            return formatShellCommand(group: group)
        case is SymbolReferencedFromCaptureGroup:
            return formatCompleteError(line: line)
        case let group as TestCaseMeasuredCaptureGroup:
            return formatTestCaseMeasured(group: group)
        case let group as TestCasePassedCaptureGroup:
            return formatTestCasePassed(group: group)
        case let group as TestCasePendingCaptureGroup:
            return formatTestCasePending(group: group)
        case let group as TestCaseStartedCaptureGroup:
            return formatTestCasesStarted(group: group)
        case let group as TestsRunCompletionCaptureGroup:
            return formatTestsRunCompletion(group: group)
        case let group as TestSuiteAllTestsFailedCaptureGroup:
            return formatTestSuiteAllTestsFailed(group: group)
        case let group as TestSuiteAllTestsPassedCaptureGroup:
            return formatTestSuiteAllTestsPassed(group: group)
        case let group as TestSuiteStartCaptureGroup:
            return formatTestSuiteStart(group: group)
        case let group as TestSuiteStartedCaptureGroup:
            return formatTestSuiteStarted(group: group)
        case let group as TIFFutilCaptureGroup:
            return formatTIFFUtil(group: group)
        case let group as TouchCaptureGroup:
            return formatTouch(group: group)
        case let group as UIFailingTestCaptureGroup:
            return formatUIFailingTest(group: group)
        case is UndefinedSymbolLocationCaptureGroup:
            return formatCompleteWarning(line: line)
        case let group as WillNotBeCodeSignedCaptureGroup:
            return formatWillNotBeCodesignWarning(group: group)
        case let group as WriteAuxiliaryFilesCaptureGroup:
            return formatWriteAuxiliaryFiles(group: group)
        case let group as WriteFileCaptureGroup:
            return formatWriteFile(group: group)
        case let group as XcodebuildErrorCaptureGroup:
            return formatError(group: group)
        default:
            assertionFailure()
            return nil
        }
    }
}

extension OutputRendering {
    func format(line: String, command: String, pattern: String, arguments: String) -> String? {
        let template = command.style.Bold + " " + arguments

        guard let formatted = try? NSRegularExpression(pattern: pattern)
            .stringByReplacingMatches(
                in: line,
                range: NSRange(location: 0, length: line.count),
                withTemplate: template
            )
        else {
            return nil
        }

        return formatted
    }

    func formatAnalyze(group: AnalyzeCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Analyzing".s.Bold) \(filename)" : "[\(target)] Analyzing \(filename)"
    }

    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String {
        let directory = group.directory
        return colored ? "\("Cleaning".s.Bold) \(directory)" : "Cleaning \(directory)"
    }

    func formatCodeSign(group: CodesignCaptureGroup) -> String {
        let command = "Signing"
        let sourceFile = group.file
        return colored ? command.s.Bold + " " + sourceFile.lastPathComponent : command + " " + sourceFile.lastPathComponent
    }

    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String {
        let frameworkPath = group.frameworkPath
        return colored ? "\("Signing".s.Bold) \(frameworkPath)" : "Signing \(frameworkPath)"
    }

    func formatCompile(group: CompileFileCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Compiling".s.Bold) \(filename)" : "[\(target)] Compiling \(filename)"
    }

    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        nil
    }

    func formatCopy(group: CopyCaptureGroup) -> String {
        let filename = group.file
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Copying".s.Bold) \(filename)" : "[\(target)] Copying \(filename)"
    }

    func formatCursor(group: CursorCaptureGroup) -> String? {
        nil
    }

    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String? {
        nil
    }

    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String? {
        nil
    }

    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String {
        colored ? "\("Generating".s.Bold) code coverage data..." : "Generating code coverage data..."
    }

    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String {
        let filePath = group.coverageReportFilePath
        return colored ? "\("Generated".s.Bold) code coverage report: \(filePath.s.Italic)" : "Generated code coverage report: \(filePath)"
    }

    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String {
        let dsym = group.dsym
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Generating".s.Bold) \(dsym)" : "[\(target)] Generating \(dsym)"
    }

    func formatLibtool(group: LibtoolCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Building library".s.Bold) \(filename)" : "[\(target)] Building library \(filename)"
    }

    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String? {
        nil
    }

    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        nil
    }

    func formatLinking(group: LinkingCaptureGroup) -> String {
        let target = group.target
        #if os(Linux)
        return colored ? "[\(target.f.Cyan)] \("Linking".s.Bold)" : "[\(target)] Linking"
        #else
        let filename = group.binaryFilename
        return colored ? "[\(target.f.Cyan)] \("Linking".s.Bold) \(filename)" : "[\(target)] Linking \(filename)"
        #endif
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        let version = group.version
        let package = group.package
        return colored ? "Checking out " + package.s.Bold + " @ " + version.f.Green : "Checking out \(package) @ \(version)"
    }

    func formatPackageEnd() -> String {
        colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        let source = group.source
        return "Fetching " + source
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    func formatPackageStart() -> String {
        colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        let source = group.source
        return "Updating " + source
    }

    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String {
        colored ? line.s.Bold.f.Green : line
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return colored ? heading.s.Bold.f.Cyan : heading
    }

    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String {
        colored ? line.s.Bold.f.Cyan : line
    }

    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String {
        let phaseName = group.phaseName
        let target = group.target
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        return colored ? "[\(target.f.Cyan)] \("Running script".s.Bold) \(strippedPhaseName)" : "[\(target)] Running script \(strippedPhaseName)"
    }

    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String {
        let phase = group.phase.capitalized
        return colored ? "\(phase) Succeeded".s.Bold.f.Green : "\(phase) Succeeded"
    }

    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String {
        let plist = group.filename

        if let target = group.target {
            // Xcode 10+ output
            return colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(plist)" : "[\(target)] \("Processing") \(plist)"
        } else {
            // Xcode 9 output
            return colored ? "Processing".s.Bold + " " + plist : "Processing" + " " + plist
        }
    }

    func formatProcessPch(group: ProcessPchCaptureGroup) -> String {
        let filename = group.file
        let target = group.buildTarget
        return colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(filename)" : "[\(target)] Processing \(filename)"
    }

    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String {
        let filePath = group.filePath
        return colored ? "\("Preprocessing".s.Bold) \(filePath)" : "Preprocessing \(filePath)"
    }

    func formatShellCommand(group: ShellCommandCaptureGroup) -> String? {
        nil
    }

    func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String {
        let target = group.target
        let project = group.project
        let configuration = group.configuration
        return colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan : "\(command) target \(target) of project \(project) with configuration \(configuration)"
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        let testCase = group.testCase
        return colored ? Format.indent + TestStatus.pending.foreground.Yellow + " " + testCase + " [PENDING]" : Format.indent + TestStatus.pending + " " + testCase + " [PENDING]"
    }

    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String? {
        nil
    }

    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String? {
        nil
    }

    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String? {
        nil
    }

    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup) -> String? {
        nil
    }

    func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String {
        let testSuite = group.testSuiteName
        return colored ? testSuite.s.Bold : testSuite
    }

    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let heading = "Test Suite \(testSuite) started"
        return colored ? heading.s.Bold.f.Cyan : heading
    }

    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String? {
        nil
    }

    func formatTouch(group: TouchCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Touching".s.Bold) \(filename)" : "[\(target)] Touching \(filename)"
    }

    func formatWriteAuxiliaryFiles(group: WriteAuxiliaryFilesCaptureGroup) -> String? {
        nil
    }

    func formatWriteFile(group: WriteFileCaptureGroup) -> String? {
        nil
    }
}
