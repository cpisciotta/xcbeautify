//
// OutputRendering.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

/// A renderer is responsible for formatting raw xcodebuild output.
/// `OutputRendering` defines many default implementations for output that is similarly formatted across renderers.
protocol OutputRendering {
    /// Indicates if the renderer should color its formatted output.
    var colored: Bool { get }

    /// A closure that provides the subsequent console output when needed (i.e. multi-line output).
    var additionalLines: () -> String? { get }

    func formatAnalyze(group: AnalyzeCaptureGroup) -> String
    func formatCheckDependencies() -> String
    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String
    func formatCodeSign(group: CodesignCaptureGroup) -> String
    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String
    func formatCompilationResult(group: CompilationResultCaptureGroup) -> String?
    func formatCompile(group: any CompileFileCaptureGroup) -> String
    func formatCreateUniversalBinary(group: CreateUniversalBinaryCaptureGroup) -> String
    func formatSwiftCompiling(group: SwiftCompilingCaptureGroup) -> String?
    func formatCompileAssetCatalog(group: CompileAssetCatalogCaptureGroup) -> String
    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String?
    func formatCompileError(group: CompileErrorCaptureGroup) -> String
    func formatCompileXCStrings(group: CompileXCStringsCaptureGroup) -> String
    func formatCompileWarning(group: CompileWarningCaptureGroup) -> String
    func formatCopy(group: any CopyCaptureGroup) -> String
    func formatCopyFiles(group: CopyFilesCaptureGroup) -> String
    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String
    func formatCreateBuildDirectory(group: CreateBuildDirectoryCaptureGroup) -> String?
    func formatCursor(group: CursorCaptureGroup) -> String?
    func formatDataModelCodegen(group: DataModelCodegenCaptureGroup) -> String
    func formatDetectedEncoding(group: DetectedEncodingCaptureGroup) -> String?
    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String
    func formatEmitSwiftModule(group: EmitSwiftModuleCaptureGroup) -> String?
    func formatError(group: any ErrorCaptureGroup) -> String
    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String
    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String
    func formatExplicitDependencyCaptureGroup(group: ExplicitDependencyCaptureGroup) -> String?
    func formatExtractAppIntents(group: ExtractAppIntentsMetadataCaptureGroup) -> String
    func formatFailingTest(group: FailingTestCaptureGroup) -> String
    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String
    func formatGenerateAssetSymbols(group: GenerateAssetSymbolsCaptureGroup) -> String
    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String
    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String
    func formatLdWarning(group: LDWarningCaptureGroup) -> String
    func formatLibtool(group: LibtoolCaptureGroup) -> String
    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String
    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String?
    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String
    func formatLinking(group: LinkingCaptureGroup) -> String
    func formatNonPCHClangCommand(group: NonPCHClangCommandCaptureGroup) -> String?
    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String
    func formatPackageEnd() -> String
    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String
    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String
    func formatPackageStart() -> String
    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String
    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String
    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String
    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String
    func formatParallelTestCaseSkipped(group: ParallelTestCaseSkippedCaptureGroup) -> String
    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String
    func formatParallelTestingPassed(group: ParallelTestingPassedCaptureGroup) -> String
    func formatParallelTestingStarted(group: ParallelTestingStartedCaptureGroup) -> String
    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String
    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String
    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String
    func formatPrecompileModule(group: PrecompileModuleCaptureGroup) -> String?
    func formatPreprocess(group: PreprocessCaptureGroup) -> String
    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String
    func formatProcessPch(group: ProcessPchCaptureGroup) -> String
    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String
    func formatRegisterExecutionPolicyException(group: RegisterExecutionPolicyExceptionCaptureGroup) -> String
    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String
    func formatScanDependencies(group: ScanDependenciesCaptureGroup) -> String?
    func formatShellCommand(group: ShellCommandCaptureGroup) -> String?
    func formatSigning(group: SigningCaptureGroup) -> String
    func formatSymLink(group: SymLinkCaptureGroup) -> String?
    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String
    func formatTargetCommand(command: String, group: any TargetCaptureGroup) -> String
    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String
    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String
    func formatTestCaseSkipped(group: TestCaseSkippedCaptureGroup) -> String
    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String?
    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String
    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String
    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup) -> String
    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String
    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String?
    func formatTouch(group: TouchCaptureGroup) -> String
    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String
    func formatUndefinedSymbolLocation(group: UndefinedSymbolLocationCaptureGroup) -> String
    func formatValidate(group: ValidateCaptureGroup) -> String
    func formatValidateEmbeddedBinary(group: ValidateEmbeddedBinaryCaptureGroup) -> String
    func formatWarning(group: GenericWarningCaptureGroup) -> String
    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String
    func formatWriteAuxiliaryFile(group: WriteAuxiliaryFileCaptureGroup) -> String?
    func formatWriteFile(group: WriteFileCaptureGroup) -> String?
    func formatSwiftDriverJobDiscoveryEmittingModule(group: SwiftDriverJobDiscoveryEmittingModuleCaptureGroup) -> String?
    func formatTestingStarted(group: TestingStartedCaptureGroup) -> String
    func formatSwiftDriverJobDiscoveryCompiling(group: SwiftDriverJobDiscoveryCompilingCaptureGroup) -> String?
    func formatSwiftEmitModule(group: SwiftEmitModuleCaptureGroup) -> String?
    func formatSwiftMergeGeneratedHeaders(group: SwiftMergeGeneratedHeadersCaptureGroup) -> String?
    func formatSwiftTestingRunStarted(group: SwiftTestingRunStartedCaptureGroup) -> String
    func formatSwiftTestingRunCompletion(group: SwiftTestingRunCompletionCaptureGroup) -> String
    func formatSwiftTestingRunFailed(group: SwiftTestingRunFailedCaptureGroup) -> String
    func formatSwiftTestingSuiteStarted(group: SwiftTestingSuiteStartedCaptureGroup) -> String
    func formatSwiftTestingTestStarted(group: SwiftTestingTestStartedCaptureGroup) -> String?
    func formatSwiftTestingSuitePassed(group: SwiftTestingSuitePassedCaptureGroup) -> String
    func formatSwiftTestingSuiteFailed(group: SwiftTestingSuiteFailedCaptureGroup) -> String
    func formatSwiftTestingTestFailed(group: SwiftTestingTestFailedCaptureGroup) -> String
    func formatSwiftTestingTestPassed(group: SwiftTestingTestPassedCaptureGroup) -> String
    func formatSwiftTestingTestSkipped(group: SwiftTestingTestSkippedCaptureGroup) -> String
    func formatSwiftTestingTestSkippedReason(group: SwiftTestingTestSkippedReasonCaptureGroup) -> String
    func formatSwiftTestingIssue(group: SwiftTestingIssueCaptureGroup) -> String
    func formatSwiftTestingIssueArguments(group: SwiftTestingIssueArgumentCaptureGroup) -> String
    func formatSwiftTestingPassingArgument(group: SwiftTestingPassingArgumentCaptureGroup) -> String?
    func formatSwiftDriverCompilationTarget(group: SwiftDriverCompilationTarget) -> String?
    func formatMkDirCaptureGroup(group: MkDirCaptureGroup) -> String?
    func formatNote(group: NoteCaptureGroup) -> String
}

extension OutputRendering {
    func formatAnalyze(group: AnalyzeCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Analyzing".bold(if: colored)) \(filename)"
    }

    func formatCheckDependencies() -> String {
        "Check dependencies".bold(if: colored)
    }

    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String {
        let directory = group.directory
        return "\("Cleaning".bold(if: colored)) \(directory)"
    }

    func formatCodeSign(group: CodesignCaptureGroup) -> String {
        let command = "Signing"
        let sourceFile = group.file
        return command.bold(if: colored) + " " + sourceFile.lastPathComponent
    }

    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String {
        let frameworkPath = group.frameworkPath
        return "\("Signing".bold(if: colored)) \(frameworkPath)"
    }

    func formatCompile(group: any CompileFileCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Compiling".bold(if: colored)) \(filename)"
    }

    func formatCompileAssetCatalog(group: CompileAssetCatalogCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Compile Asset Catalog".bold(if: colored)) \(filename)"
    }

    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        nil
    }

    func formatCompileXCStrings(group: CompileXCStringsCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Compile XCStrings".bold(if: colored)) \(filename)"
    }

    func formatCompilationResult(group: CompilationResultCaptureGroup) -> String? {
        nil
    }

    func formatSwiftCompiling(group: SwiftCompilingCaptureGroup) -> String? {
        nil
    }

    func formatCopy(group: any CopyCaptureGroup) -> String {
        let filename = group.file
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Copying".bold(if: colored)) \(filename)"
    }

    func formatCopyFiles(group: CopyFilesCaptureGroup) -> String {
        let target = group.target
        let firstFilename = group.firstFilename
        let secondFilename = group.secondFilename
        return "[\(target.cyan(if: colored))] \("Copy".bold(if: colored)) \(firstFilename) -> \(secondFilename)"
    }

    func formatCreateBuildDirectory(group: CreateBuildDirectoryCaptureGroup) -> String? {
        nil
    }

    func formatCreateUniversalBinary(group: CreateUniversalBinaryCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return "[\(target.cyan(if: colored))] \("Create Universal Binary".bold(if: colored)) \(filename)"
    }

    func formatCursor(group: CursorCaptureGroup) -> String? {
        nil
    }

    func formatEmitSwiftModule(group: EmitSwiftModuleCaptureGroup) -> String? {
        nil
    }

    func formatExecutedWithoutSkipped(group: ExecutedWithoutSkippedCaptureGroup) -> String {
        group.wholeResult
    }

    func formatExecutedWithSkipped(group: ExecutedWithSkippedCaptureGroup) -> String {
        group.wholeResult
    }

    func formatExplicitDependencyCaptureGroup(group: ExplicitDependencyCaptureGroup) -> String? {
        nil
    }

    func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String {
        "\("Generating".bold(if: colored)) code coverage data..."
    }

    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String {
        let filePath = group.coverageReportFilePath
        return "\("Generated".bold(if: colored)) code coverage report: \(filePath.italic(if: colored))"
    }

    func formatDetectedEncoding(group: DetectedEncodingCaptureGroup) -> String? {
        nil
    }

    func formatExtractAppIntents(group: ExtractAppIntentsMetadataCaptureGroup) -> String {
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Extract App Intents Metadata".bold(if: colored))"
    }

    func formatGenerateAssetSymbols(group: GenerateAssetSymbolsCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Generate Asset Symbols".bold(if: colored)) \(filename)"
    }

    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String {
        let dsym = group.dsym
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Generating".bold(if: colored)) \(dsym)"
    }

    func formatLibtool(group: LibtoolCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Building library".bold(if: colored)) \(filename)"
    }

    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        nil
    }

    func formatLinking(group: LinkingCaptureGroup) -> String {
        let target = group.target
        #if os(Linux)
        return "[\(target.cyan(if: colored))] \("Linking".bold(if: colored))"
        #else
        let filename = group.binaryFilename
        return "[\(target.cyan(if: colored))] \("Linking".bold(if: colored)) \(filename)"
        #endif
    }

    func formatNonPCHClangCommand(group: NonPCHClangCommandCaptureGroup) -> String? {
        nil
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        let version = group.version
        let package = group.package
        return "Checking out " + package.bold(if: colored) + " @ " + version.green(if: colored)
    }

    func formatPackageEnd() -> String {
        "Resolved source packages".bold(if: colored).green(if: colored)
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        let source = group.source
        return "Fetching " + source
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return name.bold().cyan(if: colored) + " - " + url.bold(if: colored) + " @ " + version.green(if: colored)
    }

    func formatPackageStart() -> String {
        "Resolving Package Graph".bold(if: colored).cyan(if: colored)
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        let source = group.source
        return "Updating " + source
    }

    func formatParallelTestingPassed(group: ParallelTestingPassedCaptureGroup) -> String {
        group.wholeMessage.bold(if: colored).green(if: colored)
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return heading.bold(if: colored).cyan(if: colored)
    }

    func formatParallelTestingStarted(group: ParallelTestingStartedCaptureGroup) -> String {
        group.wholeMessage.bold(if: colored).cyan(if: colored)
    }

    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String {
        let phaseName = group.phaseName
        let target = group.target
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        return "[\(target.cyan(if: colored))] \("Running script".bold(if: colored)) \(strippedPhaseName)"
    }

    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String {
        let phase = group.phase.capitalized
        return"\(phase) Succeeded".bold(if: colored).green(if: colored)
    }

    func formatPrecompileModule(group: PrecompileModuleCaptureGroup) -> String? {
        nil
    }

    func formatPreprocess(group: PreprocessCaptureGroup) -> String {
        let target = group.target
        let file = group.file
        return "[\(target.cyan(if: colored))] \("Preprocess".bold(if: colored)) \(file)"
    }

    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String {
        let plist = group.filename

        if let target = group.target {
            // Xcode 10+ output
            return "[\(target.cyan(if: colored))] \("Processing".bold(if: colored)) \(plist)"
        } else {
            // Xcode 9 output
            return "Processing".bold(if: colored) + " " + plist
        }
    }

    func formatProcessPch(group: ProcessPchCaptureGroup) -> String {
        let filename = group.file
        let target = group.buildTarget
        return "[\(target.cyan(if: colored))] \("Processing".bold(if: colored)) \(filename)"
    }

    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String {
        let filePath = group.filePath
        return "\("Preprocessing".bold(if: colored)) \(filePath)"
    }

    func formatRegisterExecutionPolicyException(group: RegisterExecutionPolicyExceptionCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return "[\(target.cyan(if: colored))] \("RegisterExecutionPolicyException".bold(if: colored)) \(filename)"
    }

    func formatScanDependencies(group: ScanDependenciesCaptureGroup) -> String? {
        nil
    }

    func formatShellCommand(group: ShellCommandCaptureGroup) -> String? {
        nil
    }

    func formatSigning(group: SigningCaptureGroup) -> String {
        let target = group.target
        let file = group.file
        return "[\(target.cyan(if: colored))] \("Signing".bold(if: colored)) \(file)"
    }

    func formatTargetCommand(command: String, group: any TargetCaptureGroup) -> String {
        let target = group.target
        let project = group.project
        let configuration = group.configuration
        return "\(command) target \(target) of project \(project) with configuration \(configuration)".bold(if: colored).cyan(if: colored)
    }

    func formatTestCasesStarted(group: TestCaseStartedCaptureGroup) -> String? {
        nil
    }

    func formatTestsRunCompletion(group: TestsRunCompletionCaptureGroup) -> String {
        group.wholeResult
    }

    func formatTestSuiteAllTestsFailed(group: TestSuiteAllTestsFailedCaptureGroup) -> String {
        group.wholeResult
    }

    func formatTestSuiteAllTestsPassed(group: TestSuiteAllTestsPassedCaptureGroup) -> String {
        group.wholeResult
    }

    func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String {
        "Test Suite '\(group.suiteName)' started at \(group.time)"
    }

    func formatTIFFUtil(group: TIFFutilCaptureGroup) -> String? {
        nil
    }

    func formatTouch(group: TouchCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Touching".bold(if: colored)) \(filename)"
    }

    func formatValidate(group: ValidateCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return "[\(target.cyan(if: colored))] \("Validate".bold(if: colored)) \(filename)"
    }

    func formatValidateEmbeddedBinary(group: ValidateEmbeddedBinaryCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return "[\(target.cyan(if: colored))] \("Validate Embedded Binary".bold(if: colored)) \(filename)"
    }

    func formatWriteAuxiliaryFile(group: WriteAuxiliaryFileCaptureGroup) -> String? {
        let filename = group.filename
        let target = group.target
        return "[\(target.cyan(if: colored))] \("Write Auxiliary File".bold(if: colored)) \(filename)"
    }

    func formatWriteFile(group: WriteFileCaptureGroup) -> String? {
        nil
    }

    func formatSwiftDriverJobDiscoveryEmittingModule(group: SwiftDriverJobDiscoveryEmittingModuleCaptureGroup) -> String? {
        nil
    }

    func formatSwiftDriverJobDiscoveryCompiling(group: SwiftDriverJobDiscoveryCompilingCaptureGroup) -> String? {
        nil
    }

    func formatFailingTest(group: FailingTestCaptureGroup) -> String {
        let testCase = group.testCase
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.red() + " " + testCase + ", " + failingReason : Format.indent + TestStatus.fail + " " + testCase + ", " + failingReason
    }

    func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String {
        let file = group.file
        let failingReason = group.reason
        return colored ? Format.indent + TestStatus.fail.red() + " " + file + ", " + failingReason : Format.indent + TestStatus.fail + " " + file + ", " + failingReason
    }

    func formatRestartingTest(group: RestartingTestCaptureGroup) -> String {
        colored ? Format.indent + TestStatus.fail.red() + " " + group.wholeMessage : Format.indent + TestStatus.fail + " " + group.wholeMessage
    }

    func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String {
        let testCase = group.testCase
        let name = group.name
        let unitName = group.unitName
        let value = group.value

        let deviation = colored ? group.deviation.coloredDeviation() : group.deviation
        let formattedValue = colored && unitName == "seconds" ? value.coloredTime() : value

        return Format.indent + (colored ? TestStatus.measure.yellow() : TestStatus.measure) + " " + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
    }

    func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String {
        let testCase = group.testCase
        let time = group.time
        return colored ? Format.indent + TestStatus.pass.green() + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " (\(time) seconds)"
    }

    func formatTestCaseSkipped(group: TestCaseSkippedCaptureGroup) -> String {
        let testCase = group.testCase
        let time = group.time
        return colored ? Format.indent + TestStatus.skipped.yellow() + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.skipped + " " + testCase + " (\(time) seconds)"
    }

    func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String {
        let suite = group.suite
        let testCase = group.testCase
        let device = group.device
        let time = group.time

        return formatParallelTestCase(result: TestStatus.pass, suite: suite, testCase: testCase, device: device, time: time)
    }

    func formatParallelTestCaseSkipped(group: ParallelTestCaseSkippedCaptureGroup) -> String {
        let suite = group.suite
        let testCase = group.testCase
        let device = group.device
        let time = group.time

        return formatParallelTestCase(result: TestStatus.skipped, suite: suite, testCase: testCase, device: device, time: time)
    }

    func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String {
        let suite = group.suite
        let testCase = group.testCase
        let time = group.time

        return formatParallelTestCase(result: TestStatus.pass, suite: suite, testCase: testCase, device: nil, time: time)
    }

    func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String {
        let suite = group.suite
        let testCase = group.testCase
        let device = group.device
        let time = group.time

        return formatParallelTestCase(result: TestStatus.fail, suite: suite, testCase: testCase, device: device, time: time)
    }

    private func formatParallelTestCase(
        result: String,
        suite: String,
        testCase: String,
        device: String?,
        time: String
    ) -> String {
        let deviceString = device.map { " on '\($0)'" } ?? ""

        let styledResult: String
        switch result {
        case TestStatus.pass:
            styledResult = result.green()
        case TestStatus.fail:
            styledResult = result.red()
        case TestStatus.skipped:
            styledResult = result.yellow()
        default:
            assertionFailure("Unexpected result: \(result)")
            styledResult = result
        }

        return colored
            ? Format.indent + styledResult + " [" + suite.cyan() + "] " + testCase + deviceString + " (\(time.coloredTime()) seconds)"
            : Format.indent + result + " [" + suite + "] " + testCase + deviceString + " (\(time) seconds)"
    }

    func formatError(group: any ErrorCaptureGroup) -> String {
        let errorMessage = group.wholeError
        return colored ? Symbol.error + " " + errorMessage.red() : Symbol.asciiError + " " + errorMessage
    }

    func formatSymLink(group: SymLinkCaptureGroup) -> String? {
        nil
    }

    func formatSymbolReferencedFrom(group: SymbolReferencedFromCaptureGroup) -> String {
        colored ? Symbol.error + " " + group.wholeError.red() : Symbol.asciiError + " " + group.wholeError
    }

    func formatCompileError(group: CompileErrorCaptureGroup) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
            """
            \(Symbol.error) \(filePath): \(reason.red())
            \(line)
            \(cursor.cyan())
            """
            :
            """
            \(Symbol.asciiError) \(filePath): \(reason)
            \(line)
            \(cursor)
            """
    }

    func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        return colored ? "\(Symbol.error) \(filePath): \(reason.red())" : "\(Symbol.asciiError) \(filePath): \(reason)"
    }

    func formatWarning(group: GenericWarningCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return colored ? Symbol.warning + " " + warningMessage.yellow() : Symbol.asciiWarning + " " + warningMessage
    }

    func formatUndefinedSymbolLocation(group: UndefinedSymbolLocationCaptureGroup) -> String {
        colored ? Symbol.warning + " " + group.wholeWarning.yellow() : Symbol.asciiWarning + " " + group.wholeWarning
    }

    func formatCompileWarning(group: CompileWarningCaptureGroup) -> String {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
            """
            \(Symbol.warning)  \(filePath): \(reason.yellow())
            \(line)
            \(cursor.green())
            """
            :
            """
            \(Symbol.asciiWarning)  \(filePath): \(reason)
            \(line)
            \(cursor)
            """
    }

    func formatLdWarning(group: LDWarningCaptureGroup) -> String {
        let prefix = group.ldPrefix
        let message = group.warningMessage
        return colored ? "\(Symbol.warning) \(prefix.yellow())\(message.yellow())" : "\(Symbol.asciiWarning) \(prefix)\(message)"
    }

    func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return colored ? "\(Symbol.error) \(reason.red())" : "\(Symbol.asciiError) \(reason)"
    }

    // TODO: Print file path
    func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String {
        let reason = group.reason
        return colored ? "\(Symbol.error) \(reason.red())" : "\(Symbol.asciiError) \(reason)"
    }

    func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String {
        let warningMessage = group.wholeWarning
        return colored ? Symbol.warning + " " + warningMessage.yellow() : Symbol.asciiWarning + " " + warningMessage
    }

    func formatSummary(line: String) -> String {
        colored ? line.green().bold() : line
    }

    func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String {
        let message = group.warningMessage
        return colored ? Symbol.warning + " " + message.yellow() : Symbol.asciiWarning + " " + message
    }

    func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String {
        colored ? group.wholeError.bold().red() : group.wholeError
    }

    func formatTestingStarted(group: TestingStartedCaptureGroup) -> String {
        colored ? group.wholeMessage.bold().cyan() : group.wholeMessage
    }

    func formatSwiftEmitModule(group: SwiftEmitModuleCaptureGroup) -> String? {
        nil
    }

    func formatSwiftMergeGeneratedHeaders(group: SwiftMergeGeneratedHeadersCaptureGroup) -> String? {
        nil
    }

    func formatSwiftTestingRunStarted(group: SwiftTestingRunStartedCaptureGroup) -> String {
        group.message.bold(if: colored)
    }

    func formatSwiftTestingRunCompletion(group: SwiftTestingRunCompletionCaptureGroup) -> String {
        "Test run with \(group.numberOfTests) tests passed after \(group.totalTime) seconds"
    }

    func formatSwiftTestingRunFailed(group: SwiftTestingRunFailedCaptureGroup) -> String {
        "Test run with \(group.numberOfTests) tests failed after \(group.totalTime) seconds with \(group.numberOfIssues) issue(s)"
    }

    func formatSwiftTestingSuiteStarted(group: SwiftTestingSuiteStartedCaptureGroup) -> String {
        "Suite \(group.suiteName) started"
    }

    func formatSwiftTestingTestStarted(group: SwiftTestingTestStartedCaptureGroup) -> String? {
        nil
    }

    func formatSwiftTestingSuitePassed(group: SwiftTestingSuitePassedCaptureGroup) -> String {
        "Suite \(group.suiteName) passed after \(group.timeTaken) seconds"
    }

    func formatSwiftTestingSuiteFailed(group: SwiftTestingSuiteFailedCaptureGroup) -> String {
        "Suite \(group.suiteName) failed after \(group.timeTaken) seconds with \(group.numberOfIssues) issue(s)"
    }

    func formatSwiftTestingTestFailed(group: SwiftTestingTestFailedCaptureGroup) -> String {
        let message = "\(group.testName) (\(group.timeTaken) seconds) \(group.numberOfIssues) issue(s)"
        let wholeMessage = colored ? TestStatus.fail.red() + " " + message.red() : TestStatus.fail + " " + message
        return Format.indent + wholeMessage
    }

    func formatSwiftTestingTestPassed(group: SwiftTestingTestPassedCaptureGroup) -> String {
        let testName = group.testName
        let timeTaken = group.timeTaken
        return colored ? Format.indent + TestStatus.pass.green() + " " + testName + " (\(timeTaken.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testName + " (\(timeTaken) seconds)"
    }

    func formatSwiftTestingTestSkipped(group: SwiftTestingTestSkippedCaptureGroup) -> String {
        let testName = group.testName + " skipped"
        return colored ? Format.indent + TestStatus.skipped.yellow() + " " + testName : Format.indent + TestStatus.skipped + " " + testName
    }

    func formatSwiftTestingTestSkippedReason(group: SwiftTestingTestSkippedReasonCaptureGroup) -> String {
        let testName = group.testName + " skipped"
        let reason = group.reason.map { " (\(String($0)))" } ?? ""
        return colored ? Format.indent + TestStatus.skipped.yellow() + " " + testName + reason : Format.indent + TestStatus.skipped + " " + testName + reason
    }

    func formatSwiftTestingIssue(group: SwiftTestingIssueCaptureGroup) -> String {
        let issueDetails = group.issueDetails.map { " at \($0)" } ?? ""
        let message = " Test \(group.testDescription) recorded an issue\(issueDetails)"
        return colored ? Format.indent + Symbol.warning.yellow() + " " + message : Format.indent + Symbol.asciiWarning + " " + message
    }

    func formatSwiftTestingIssueArguments(group: SwiftTestingIssueArgumentCaptureGroup) -> String {
        let argumentsInfo = group.numberOfArguments.map { " with \($0) argument(s)" } ?? ""
        let message = " Test \(group.testDescription) recorded an issue\(argumentsInfo)"
        return colored ? Format.indent + Symbol.warning.yellow() + " " + message : Format.indent + Symbol.asciiWarning + " " + message
    }

    func formatSwiftTestingPassingArgument(group: SwiftTestingPassingArgumentCaptureGroup) -> String? {
        nil
    }

    func formatSwiftDriverTarget(group: SwiftDriverTargetCaptureGroup) -> String? {
        nil
    }

    func formatSwiftDriverCompilationTarget(group: SwiftDriverCompilationTarget) -> String? {
        nil
    }

    func formatSwiftDriverCompilationRequirements(group: SwiftDriverCompilationRequirementsCaptureGroup) -> String? {
        nil
    }

    func formatMkDirCaptureGroup(group: MkDirCaptureGroup) -> String? {
        nil
    }

    func formatNote(group: NoteCaptureGroup) -> String {
        "note: ".bold(if: colored).cyan(if: colored) + group.note
    }

    func formatDataModelCodegen(group: DataModelCodegenCaptureGroup) -> String {
        "[\(group.target.cyan(if: colored))] \("DataModelCodegen".bold(if: colored)) \(group.path)"
    }
}
