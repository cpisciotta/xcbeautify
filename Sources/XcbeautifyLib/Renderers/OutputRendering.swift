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
    func formatSwiftTestingParameterizedTestPassed(group: SwiftTestingParameterizedTestPassedCaptureGroup) -> String
    func formatSwiftTestingParameterizedTestFailed(group: SwiftTestingParameterizedTestFailedCaptureGroup) -> String
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
        return colored ? "[\(target.cyan())] \("Analyzing".bold()) \(filename)" : "[\(target)] Analyzing \(filename)"
    }

    func formatCheckDependencies() -> String {
        colored ? "Check dependencies".bold() : "Check dependencies"
    }

    func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String {
        let directory = group.directory
        return colored ? "\("Cleaning".bold()) \(directory)" : "Cleaning \(directory)"
    }

    func formatCodeSign(group: CodesignCaptureGroup) -> String {
        let command = "Signing"
        let sourceFile = group.file
        return colored ? command.bold() + " " + sourceFile.lastPathComponent : command + " " + sourceFile.lastPathComponent
    }

    func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String {
        let frameworkPath = group.frameworkPath
        return colored ? "\("Signing".bold()) \(frameworkPath)" : "Signing \(frameworkPath)"
    }

    func formatCompile(group: any CompileFileCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Compiling".bold()) \(filename)" : "[\(target)] Compiling \(filename)"
    }

    func formatCompileAssetCatalog(group: CompileAssetCatalogCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Compile Asset Catalog".bold()) \(filename)" : "[\(target)] Compile Asset Catalog \(filename)"
    }

    func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        nil
    }

    func formatCompileXCStrings(group: CompileXCStringsCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Compile XCStrings".bold()) \(filename)" : "[\(target)] Compile XCStrings \(filename)"
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
        return colored ? "[\(target.cyan())] \("Copying".bold()) \(filename)" : "[\(target)] Copying \(filename)"
    }

    func formatCopyFiles(group: CopyFilesCaptureGroup) -> String {
        let target = group.target
        let firstFilename = group.firstFilename
        let secondFilename = group.secondFilename
        return colored ? "[\(target.cyan())] \("Copy".bold()) \(firstFilename) -> \(secondFilename)" : "[\(target)] Copy \(firstFilename) -> \(secondFilename)"
    }

    func formatCreateBuildDirectory(group: CreateBuildDirectoryCaptureGroup) -> String? {
        nil
    }

    func formatCreateUniversalBinary(group: CreateUniversalBinaryCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return colored ? "[\(target.cyan())] \("Create Universal Binary".bold()) \(filename)" : "[\(target)] Create Universal Binary \(filename)"
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
        colored ? "\("Generating".bold()) code coverage data..." : "Generating code coverage data..."
    }

    func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String {
        let filePath = group.coverageReportFilePath
        return colored ? "\("Generated".bold()) code coverage report: \(filePath.italic())" : "Generated code coverage report: \(filePath)"
    }

    func formatDetectedEncoding(group: DetectedEncodingCaptureGroup) -> String? {
        nil
    }

    func formatExtractAppIntents(group: ExtractAppIntentsMetadataCaptureGroup) -> String {
        let target = group.target
        return colored ? "[\(target.cyan())] \("Extract App Intents Metadata".bold())" : "[\(target)] Extract App Intents Metadata"
    }

    func formatGenerateAssetSymbols(group: GenerateAssetSymbolsCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Generate Asset Symbols".bold()) \(filename)" : "[\(target)] Generate Asset Symbols \(filename)"
    }

    func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String {
        let dsym = group.dsym
        let target = group.target
        return colored ? "[\(target.cyan())] \("Generating".bold()) \(dsym)" : "[\(target)] Generating \(dsym)"
    }

    func formatLibtool(group: LibtoolCaptureGroup) -> String {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Building library".bold()) \(filename)" : "[\(target)] Building library \(filename)"
    }

    func formatLinkerUndefinedSymbolLocation(group: LinkerUndefinedSymbolLocationCaptureGroup) -> String? {
        nil
    }

    func formatLinking(group: LinkingCaptureGroup) -> String {
        let target = group.target
        #if os(Linux)
        return colored ? "[\(target.cyan())] \("Linking".bold())" : "[\(target)] Linking"
        #else
        let filename = group.binaryFilename
        return colored ? "[\(target.cyan())] \("Linking".bold()) \(filename)" : "[\(target)] Linking \(filename)"
        #endif
    }

    func formatNonPCHClangCommand(group: NonPCHClangCommandCaptureGroup) -> String? {
        nil
    }

    func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String {
        let version = group.version
        let package = group.package
        return colored ? "Checking out " + package.bold() + " @ " + version.green() : "Checking out \(package) @ \(version)"
    }

    func formatPackageEnd() -> String {
        colored ? "Resolved source packages".bold().green() : "Resolved source packages"
    }

    func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String {
        let source = group.source
        return "Fetching " + source
    }

    func formatPackageItem(group: PackageGraphResolvedItemCaptureGroup) -> String {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return colored ? name.bold().cyan() + " - " + url.bold() + " @ " + version.green() : "\(name) - \(url) @ \(version)"
    }

    func formatPackageStart() -> String {
        colored ? "Resolving Package Graph".bold().cyan() : "Resolving Package Graph"
    }

    func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String {
        let source = group.source
        return "Updating " + source
    }

    func formatParallelTestingPassed(group: ParallelTestingPassedCaptureGroup) -> String {
        colored ? group.wholeMessage.bold().green() : group.wholeMessage
    }

    func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return colored ? heading.bold().cyan() : heading
    }

    func formatParallelTestingStarted(group: ParallelTestingStartedCaptureGroup) -> String {
        colored ? group.wholeMessage.bold().cyan() : group.wholeMessage
    }

    func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String {
        let phaseName = group.phaseName
        let target = group.target
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        return colored ? "[\(target.cyan())] \("Running script".bold()) \(strippedPhaseName)" : "[\(target)] Running script \(strippedPhaseName)"
    }

    func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String {
        let phase = group.phase.capitalized
        return colored ? "\(phase) Succeeded".bold().green() : "\(phase) Succeeded"
    }

    func formatPrecompileModule(group: PrecompileModuleCaptureGroup) -> String? {
        nil
    }

    func formatPreprocess(group: PreprocessCaptureGroup) -> String {
        let target = group.target
        let file = group.file
        return colored ? "[\(target.cyan())] \("Preprocess".bold()) \(file)" : "[\(target)] Preprocess \(file)"
    }

    func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String {
        let plist = group.filename

        if let target = group.target {
            // Xcode 10+ output
            return colored ? "[\(target.cyan())] \("Processing".bold()) \(plist)" : "[\(target)] \("Processing") \(plist)"
        } else {
            // Xcode 9 output
            return colored ? "Processing".bold() + " " + plist : "Processing" + " " + plist
        }
    }

    func formatProcessPch(group: ProcessPchCaptureGroup) -> String {
        let filename = group.file
        let target = group.buildTarget
        return colored ? "[\(target.cyan())] \("Processing".bold()) \(filename)" : "[\(target)] Processing \(filename)"
    }

    func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String {
        let filePath = group.filePath
        return colored ? "\("Preprocessing".bold()) \(filePath)" : "Preprocessing \(filePath)"
    }

    func formatRegisterExecutionPolicyException(group: RegisterExecutionPolicyExceptionCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return colored ? "[\(target.cyan())] \("RegisterExecutionPolicyException".bold()) \(filename)" : "[\(target)] RegisterExecutionPolicyException \(filename)"
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
        return colored ? "[\(target.cyan())] \("Signing".bold()) \(file)" : "[\(target)] Signing \(file)"
    }

    func formatTargetCommand(command: String, group: any TargetCaptureGroup) -> String {
        let target = group.target
        let project = group.project
        let configuration = group.configuration
        return colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".bold().cyan() : "\(command) target \(target) of project \(project) with configuration \(configuration)"
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
        return colored ? "[\(target.cyan())] \("Touching".bold()) \(filename)" : "[\(target)] Touching \(filename)"
    }

    func formatValidate(group: ValidateCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return colored ? "[\(target.cyan())] \("Validate".bold()) \(filename)" : "[\(target)] Validate \(filename)"
    }

    func formatValidateEmbeddedBinary(group: ValidateEmbeddedBinaryCaptureGroup) -> String {
        let target = group.target
        let filename = group.filename
        return colored ? "[\(target.cyan())] \("Validate Embedded Binary".bold()) \(filename)" : "[\(target)] Validate Embedded Binary \(filename)"
    }

    func formatWriteAuxiliaryFile(group: WriteAuxiliaryFileCaptureGroup) -> String? {
        let filename = group.filename
        let target = group.target
        return colored ? "[\(target.cyan())] \("Write Auxiliary File".bold()) \(filename)" : "[\(target)] Write Auxiliary File \(filename)"
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
        colored ? group.message.bold() : group.message
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

    func formatSwiftTestingParameterizedTestPassed(group: SwiftTestingParameterizedTestPassedCaptureGroup) -> String {
        let testName = group.testName
        let timeTaken = group.timeTaken
        let testCasesInfo = " with \(group.numberOfTestCases) test case\(group.numberOfTestCases == 1 ? "" : "s")"
        return colored ? Format.indent + TestStatus.pass.green() + " " + testName + testCasesInfo + " (\(timeTaken.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testName + testCasesInfo + " (\(timeTaken) seconds)"
    }

    func formatSwiftTestingParameterizedTestFailed(group: SwiftTestingParameterizedTestFailedCaptureGroup) -> String {
        let testCasesInfo = " with \(group.numberOfTestCases) test case\(group.numberOfTestCases == 1 ? "" : "s")"
        let message = "\(group.testName)\(testCasesInfo) (\(group.timeTaken) seconds) \(group.numberOfIssues) issue(s)"
        let wholeMessage = colored ? TestStatus.fail.red() + " " + message.red() : TestStatus.fail + " " + message
        return Format.indent + wholeMessage
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
        colored ? "note: ".bold().cyan() + group.note : "note: " + group.note
    }

    func formatDataModelCodegen(group: DataModelCodegenCaptureGroup) -> String {
        colored ? "[\(group.target.cyan())] \("DataModelCodegen".bold()) \(group.path)" : "[\(group.target)] DataModelCodegen \(group.path)"
    }
}
