import Foundation

protocol OutputRendering {
    var colored: Bool { get }

    func beautify(line: String, pattern: Pattern, additionalLines: @escaping () -> (String?)) -> String?

    func format(testSummary: TestSummary) -> String

    func format(line: String, command: String, pattern: Pattern, arguments: String) -> String?
    func formatAnalyze(group: AnalyzeCaptureGroup) -> String
    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String
    func formatCodeSign(group: CodesignCaptureGroup) -> String
    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String
    func formatCompile(group: CompileFileCaptureGroup) -> String
    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String?
    func formatCompileError(group: CompileErrorCaptureGroup, additionalLines:  @escaping () -> (String?)) -> String
    func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines:  @escaping () -> (String?)) -> String
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
    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup)  -> String?
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
        pattern: Pattern,
        additionalLines: @escaping () -> (String?)
    ) -> String? {
        guard let group: CaptureGroup = line.captureGroup(with: pattern) else {
            assertionFailure("Expected a known CaptureGroup from the given Pattern!")
            return nil
        }

        switch (pattern, group) {
        case (Pattern.aggregateTarget, let group as AggregateTargetCaptureGroup):
            return formatTargetCommand(command: "Aggregate", group: group)
        case (Pattern.analyze, let group as AnalyzeCaptureGroup):
            return formatAnalyze(group: group)
        case (Pattern.analyzeTarget, let group as AnalyzeTargetCaptureGroup):
            return formatTargetCommand(command: "Analyze", group: group)
        case (Pattern.buildTarget, let group as BuildTargetCaptureGroup):
            return formatTargetCommand(command: "Build", group: group)
        case (Pattern.checkDependencies, _ as CheckDependenciesCaptureGroup):
            return format(line: line, command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case (Pattern.checkDependenciesErrors, let group as CheckDependenciesErrorsCaptureGroup):
            return formatError(group: group)
        case (Pattern.clangError, let group as ClangErrorCaptureGroup):
            return formatError(group: group)
        case (Pattern.cleanRemove, let group as CleanRemoveCaptureGroup):
            return formatCleanRemove(group: group)
        case (Pattern.cleanTarget, let group as CleanTargetCaptureGroup):
            return formatTargetCommand(command: "Clean", group: group)
        case (Pattern.codesign, let group as CodesignCaptureGroup):
            return formatCodeSign(group: group)
        case (Pattern.codesignFramework, let group as CodesignFrameworkCaptureGroup):
            return formatCodeSignFramework(group: group)
        case (Pattern.compile, let group as CompileCaptureGroup):
            return formatCompile(group: group)
        case (Pattern.compileCommand, let group as CompileCommandCaptureGroup):
            return formatCompileCommand(group: group)
        case (Pattern.compileError, let group as CompileErrorCaptureGroup):
            return formatCompileError(group: group, additionalLines: additionalLines)
        case (Pattern.compileStoryboard, let group as CompileStoryboardCaptureGroup):
            return formatCompile(group: group)
        case (Pattern.compileWarning, let group as CompileWarningCaptureGroup):
            return formatCompileWarning(group: group, additionalLines: additionalLines)
        case (Pattern.compileXib, let group as CompileXibCaptureGroup):
            return formatCompile(group: group)
        case (Pattern.copyHeader, let group as CopyHeaderCaptureGroup):
            return formatCopy(group: group)
        case (Pattern.copyPlist, let group as CopyPlistCaptureGroup):
            return formatCopy(group: group)
        case (Pattern.copyStrings, let group as CopyStringsCaptureGroup):
            return formatCopy(group: group)
        case (Pattern.cpresource, let group as CpresourceCaptureGroup):
            return formatCopy(group: group)
        case (Pattern.cursor, let group as CursorCaptureGroup):
            return formatCursor(group: group)
        case (Pattern.duplicateLocalizedStringKey, let group as DuplicateLocalizedStringKeyCaptureGroup):
            return formatDuplicateLocalizedStringKey(group: group)
        case (Pattern.executedWithoutSkipped, let group as ExecutedWithoutSkippedCaptureGroup):
            return formatExecutedWithoutSkipped(group: group)
        case (Pattern.executedWithSkipped, let group as ExecutedWithSkippedCaptureGroup):
            return formatExecutedWithSkipped(group: group)
        case (Pattern.failingTest, let group as FailingTestCaptureGroup):
            return formatFailingTest(group: group)
        case (Pattern.fatalError, let group as FatalErrorCaptureGroup):
            return formatError(group: group)
        case (Pattern.fileMissingError, let group as FileMissingErrorCaptureGroup):
            return formatFileMissingError(group: group)
        case (Pattern.generateCoverageData, let group as GenerateCoverageDataCaptureGroup):
            return formatGenerateCoverageData(group: group)
        case (Pattern.generatedCoverageReport, let group as GeneratedCoverageReportCaptureGroup):
            return formatCoverageReport(group: group)
        case (Pattern.generateDsym, let group as GenerateDSYMCaptureGroup):
            return formatGenerateDsym(group: group)
        case (Pattern.genericWarning, let group as GenericWarningCaptureGroup):
            return formatWarning(group: group)
        case (Pattern.ldError, let group as LDErrorCaptureGroup):
            return formatError(group: group)
        case (Pattern.ldWarning, let group as LDWarningCaptureGroup):
            return formatLdWarning(group: group)
        case (Pattern.libtool, let group as LibtoolCaptureGroup):
            return formatLibtool(group: group)
        case (Pattern.linkerDuplicateSymbols, let group as LinkerDuplicateSymbolsCaptureGroup):
            return formatLinkerDuplicateSymbolsError(group: group)
        case (Pattern.linkerDuplicateSymbolsLocation, let group as LinkerDuplicateSymbolsLocationCaptureGroup):
            return formatLinkerDuplicateSymbolsLocation(group: group)
        case (Pattern.linkerUndefinedSymbolLocation, let group as LinkerUndefinedSymbolLocationCaptureGroup):
            return formatLinkerUndefinedSymbolLocation(group: group)
        case (Pattern.linkerUndefinedSymbols, let group as LinkerUndefinedSymbolsCaptureGroup):
            return formatLinkerUndefinedSymbolsError(group: group)
        case (Pattern.linking, let group as LinkingCaptureGroup):
            return formatLinking(group: group)
        case (Pattern.moduleIncludesError, let group as ModuleIncludesErrorCaptureGroup):
            return formatError(group: group)
        case (Pattern.noCertificate, let group as NoCertificateCaptureGroup):
            return formatError(group: group)
        case (Pattern.packageCheckingOut, let group as PackageCheckingOutCaptureGroup):
            return formatPackageCheckingOut(group: group)
        case (Pattern.packageFetching, let group as PackageFetchingCaptureGroup):
            return formatPackageFetching(group: group)
        case (Pattern.packageGraphResolvedItem, let group as PackageGraphResolvedItemCaptureGroup):
            return formatPackageItem(group: group)
        case (Pattern.packageGraphResolvingEnded, _ as PackageGraphResolvingEndedCaptureGroup):
            return formatPackageEnd()
        case (Pattern.packageGraphResolvingStart, _ as PackageGraphResolvingStartCaptureGroup):
            return formatPackageStart()
        case (Pattern.packageUpdating, let group as PackageUpdatingCaptureGroup):
            return formatPackageUpdating(group: group)
        case (Pattern.parallelTestCaseAppKitPassed, let group as ParallelTestCaseAppKitPassedCaptureGroup):
            return formatParallelTestCaseAppKitPassed(group: group)
        case (Pattern.parallelTestCaseFailed, let group as ParallelTestCaseFailedCaptureGroup):
            return formatParallelTestCaseFailed(group: group)
        case (Pattern.parallelTestCasePassed, let group as ParallelTestCasePassedCaptureGroup):
            return formatParallelTestCasePassed(group: group)
        case (Pattern.parallelTestingFailed, let group as ParallelTestingFailedCaptureGroup):
            return formatParallelTestingFailed(line: line, group: group)
        case (Pattern.parallelTestingPassed, let group as ParallelTestingPassedCaptureGroup):
            return formatParallelTestingPassed(line: line, group: group)
        case (Pattern.parallelTestingStarted, let group as ParallelTestingStartedCaptureGroup):
            return formatParallelTestingStarted(line: line, group: group)
        case (Pattern.parallelTestSuiteStarted, let group as ParallelTestSuiteStartedCaptureGroup):
            return formatParallelTestSuiteStarted(group: group)
        case (Pattern.pbxcp, let group as PbxcpCaptureGroup):
            return formatCopy(group: group)
        case (Pattern.phaseScriptExecution, let group as PhaseScriptExecutionCaptureGroup):
            return formatPhaseScriptExecution(group: group)
        case (Pattern.phaseSuccess, let group as PhaseSuccessCaptureGroup):
            return formatPhaseSuccess(group: group)
        case (Pattern.podsError, let group as PodsErrorCaptureGroup):
            return formatError(group: group)
        case (Pattern.preprocess, _ as PreprocessCaptureGroup):
            return format(line: line, command: "Preprocessing", pattern: pattern, arguments: "$1")
        case (Pattern.processInfoPlist, let group as ProcessInfoPlistCaptureGroup):
            return formatProcessInfoPlist(group: group)
        case (Pattern.processPch, let group as ProcessPchCaptureGroup):
            return formatProcessPch(group: group)
        case (Pattern.processPchCommand, let group as ProcessPchCommandCaptureGroup):
            return formatProcessPchCommand(group: group)
        case (Pattern.provisioningProfileRequired, let group as ProvisioningProfileRequiredCaptureGroup):
            return formatError(group: group)
        case (Pattern.restartingTest, let group as RestartingTestCaptureGroup):
            return formatRestartingTest(line: line, group: group)
        case (Pattern.shellCommand, let group as ShellCommandCaptureGroup):
            return formatShellCommand(group: group)
        case (Pattern.symbolReferencedFrom, _ as SymbolReferencedFromCaptureGroup):
            return formatCompleteError(line: line)
        case (Pattern.testCaseMeasured, let group as TestCaseMeasuredCaptureGroup):
            return formatTestCaseMeasured(group: group)
        case (Pattern.testCasePassed, let group as TestCasePassedCaptureGroup):
            return formatTestCasePassed(group: group)
        case (Pattern.testCasePending, let group as TestCasePendingCaptureGroup):
            return formatTestCasePending(group: group)
        case (Pattern.testCaseStarted, let group as TestCaseStartedCaptureGroup):
            return formatTestCasesStarted(group: group)
        case (Pattern.testsRunCompletion, let group as TestsRunCompletionCaptureGroup):
            return formatTestsRunCompletion(group: group)
        case (Pattern.testSuiteAllTestsFailed, let group as TestSuiteAllTestsFailedCaptureGroup):
            return formatTestSuiteAllTestsFailed(group: group)
        case (Pattern.testSuiteAllTestsPassed, let group as TestSuiteAllTestsPassedCaptureGroup):
            return formatTestSuiteAllTestsPassed(group: group)
        case (Pattern.testSuiteStart, let group as TestSuiteStartCaptureGroup):
            return formatTestSuiteStart(group: group)
        case (Pattern.testSuiteStarted, let group as TestSuiteStartedCaptureGroup):
            return formatTestSuiteStarted(group: group)
        case (Pattern.tiffutil, let group as TIFFutilCaptureGroup):
            return formatTIFFUtil(group: group)
        case (Pattern.touch, let group as TouchCaptureGroup):
            return formatTouch(group: group)
        case (Pattern.uiFailingTest, let group as UIFailingTestCaptureGroup):
            return formatUIFailingTest(group: group)
        case (Pattern.undefinedSymbolLocation, _ as UndefinedSymbolLocationCaptureGroup):
            return formatCompleteWarning(line: line)
        case (Pattern.willNotBeCodeSigned, let group as WillNotBeCodeSignedCaptureGroup):
            return formatWillNotBeCodesignWarning(group: group)
        case (Pattern.writeAuxiliaryFiles, let group as WriteAuxiliaryFilesCaptureGroup):
            return formatWriteAuxiliaryFiles(group: group)
        case (Pattern.writeFile, let group as WriteFileCaptureGroup):
            return formatWriteFile(group: group)
        case (Pattern.xcodebuildError, let group as XcodebuildErrorCaptureGroup):
            return formatError(group: group)
        case (_, _):
            assertionFailure()
            return nil
        }
    }
}

extension OutputRendering {

    func format(line: String, command: String, pattern: Pattern, arguments: String) -> String? {
        let template = command.style.Bold + " " + arguments

        guard let formatted = try? NSRegularExpression(pattern: pattern)
            .stringByReplacingMatches(
                in: line,
                range: NSRange(location: 0, length: line.count),
                withTemplate: template)
        else {
            return nil
        }

        return formatted
    }

    func formatAnalyze(group: AnalyzeCaptureGroup) -> String {
        let filename = group.fileName
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
        return nil
    }

    func formatCopy(group: CopyCaptureGroup) -> String {
        let filename = group.file
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Copying".s.Bold) \(filename)" : "[\(target)] Copying \(filename)"
    }

    func formatCursor(group: CursorCaptureGroup) -> String? {
        return nil
    }

    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String? {
        return nil
    }

    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String? {
        return nil
    }

    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String {
        return colored ? "\("Generating".s.Bold) code coverage data..." : "Generating code coverage data..."
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
        let filename = group.fileName
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Building library".s.Bold) \(filename)" : "[\(target)] Building library \(filename)"
    }

    func formatLinkerDuplicateSymbolsLocation(group: LinkerDuplicateSymbolsLocationCaptureGroup) -> String? {
        return nil
    }

    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        return nil
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
        return colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
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
        return colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        let source = group.source
        return "Updating " + source
    }

    func formatParallelTestingPassed(line: String, group: ParallelTestingPassedCaptureGroup) -> String {
        return colored ? line.s.Bold.f.Green : line
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return colored ? heading.s.Bold.f.Cyan : heading
    }

    func formatParallelTestingStarted(line: String, group: ParallelTestingStartedCaptureGroup) -> String {
        return colored ? line.s.Bold.f.Cyan : line
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
        return nil
    }

    func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String {
        let target = group.target
        let project = group.project
        let configuration = group.configuration
        return colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan : "\(command) target \(target) of project \(project) with configuration \(configuration)"
    }

    func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String {
        let testCase = group.testCase
        return colored ? Format.indent + TestStatus.pending.foreground.Yellow + " "  + testCase + " [PENDING]" : Format.indent + TestStatus.pending + " "  + testCase + " [PENDING]"
    }

    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String? {
        return nil
    }

    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String? {
        return nil
    }

    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String? {
        return nil
    }

    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup)  -> String? {
        return nil
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
        return nil
    }

    func formatTouch(group: TouchCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.f.Cyan)] \("Touching".s.Bold) \(filename)" : "[\(target)] Touching \(filename)"
    }

    func formatWriteAuxiliaryFiles(group: WriteAuxiliaryFilesCaptureGroup) -> String? {
        return nil
    }

    func formatWriteFile(group: WriteFileCaptureGroup) -> String? {
        return nil
    }

}
