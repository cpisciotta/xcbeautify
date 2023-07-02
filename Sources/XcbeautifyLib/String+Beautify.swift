import Foundation
import Colorizer

private var _colored = true

extension String {
    func beautify(pattern: Pattern, colored: Bool, additionalLines: @escaping () -> (String?)) -> String? {
        _colored = colored

        let group: CaptureGroup = self.captureGroup(with: pattern)

        switch (pattern, group) {
        case (.analyze, let group as AnalyzeCaptureGroup):
            return formatAnalyze(group: group)
        case (.compile, let group as CompileCaptureGroup):
            return formatCompile(group: group)
        case (.compileXib, let group as CompileXibCaptureGroup):
            return formatCompile(group: group)
        case (.compileStoryboard, let group as CompileStoryboardCaptureGroup):
            return formatCompile(group: group)
        case (.compileCommand, let group as CompileCommandCaptureGroup):
            return formatCompileCommand(group: group)
        case (.buildTarget, let group as BuildTargetCaptureGroup):
            return formatTargetCommand(command: "Build", group: group)
        case (.analyzeTarget, let group as AnalyzeTargetCaptureGroup):
            return formatTargetCommand(command: "Analyze", group: group)
        case (.aggregateTarget, let group as AggregateTargetCaptureGroup):
            return formatTargetCommand(command: "Aggregate", group: group)
        case (.cleanTarget, let group as CleanTargetCaptureGroup):
            return formatTargetCommand(command: "Clean", group: group)
        case (.generateCoverageData, let group as GenerateCoverageDataCaptureGroup):
            return formatGenerateCoverageData(group: group)
        case (.generatedCoverageReport, let group as GeneratedCoverageReportCaptureGroup):
            return formatCoverageReport(group: group)
        case (.generateDsym, let group as GenerateDSYMCaptureGroup):
            return formatGenerateDsym(group: group)
        case (.libtool, let group as LibtoolCaptureGroup):
            return formatLibtool(group: group)
        case (.linking, let group as LinkingCaptureGroup):
            return formatLinking(group: group)
        case (.testSuiteStarted, let group as TestSuiteStartedCaptureGroup):
            return formatTestSuiteStarted(group: group)
        case (.testSuiteStart, let group as TestSuiteStartCaptureGroup):
            return formatTestSuiteStart(group: group)
        case (.parallelTestingStarted, let group as ParallelTestingStartedCaptureGroup):
            return formatParallelTestingStarted(group: group)
        case (.parallelTestingPassed, let group as ParallelTestingPassedCaptureGroup):
            return formatParallelTestingPassed(group: group)
        case (.parallelTestingFailed, let group as ParallelTestingFailedCaptureGroup):
            return formatParallelTestingFailed(group: group)
        case (.parallelTestSuiteStarted, let group as ParallelTestSuiteStartedCaptureGroup):
            return formatParallelTestSuiteStarted(group: group)
        case (.testSuiteAllTestsPassed, _ as TestSuiteAllTestsPassedCaptureGroup):
            return nil
        case (.testSuiteAllTestsFailed, _ as TestSuiteAllTestsFailedCaptureGroup):
            return nil
        case (.failingTest, let group as FailingTestCaptureGroup):
            return formatFailingTest(group: group)
        case (.uiFailingTest, let group as UIFailingTestCaptureGroup):
            return formatUIFailingTest(group: group)
        case (.restartingTest, let group as RestartingTestCaptureGroup):
            return formatRestartingTest(group: group)
        case (.testCasePassed, let group as TestCasePassedCaptureGroup):
            return formatTestCasePassed(group: group)
        case (.testCasePending, let group as TestCasePendingCaptureGroup):
            return formatTestCasePending(group: group)
        case (.testCaseMeasured, let group as TestCaseMeasuredCaptureGroup):
            return formatTestCaseMeasured(group: group)
        case (.testsRunCompletion, _ as TestsRunCompletionCaptureGroup):
            return nil
        case (.parallelTestCasePassed, let group as ParallelTestCasePassedCaptureGroup):
            return formatParallelTestCasePassed(group: group)
        case (.parallelTestCaseAppKitPassed, let group as ParallelTestCaseAppKitPassedCaptureGroup):
            return formatParallelTestCaseAppKitPassed(group: group)
        case (.parallelTestCaseFailed, let group as ParallelTestCaseFailedCaptureGroup):
            return formatParallelTestCaseFailed(group: group)
        case (.codesign, let group as CodesignCaptureGroup):
            return formatCodeSign(group: group)
        case (.codesignFramework, let group as CodesignFrameworkCaptureGroup):
            return formatCodeSignFramework(group: group)
        case (.copyHeader, let group as CopyHeaderCaptureGroup):
            return formatCopy(group: group)
        case (.copyPlist, let group as CopyPlistCaptureGroup):
            return formatCopy(group: group)
        case (.copyStrings, let group as CopyStringsCaptureGroup):
            return formatCopy(group: group)
        case (.cpresource, let group as CpresourceCaptureGroup):
            return formatCopy(group: group)
        case (.pbxcp, let group as PbxcpCaptureGroup):
            return formatCopy(group: group)
        case (.checkDependencies, _ as CheckDependenciesCaptureGroup):
            return format(command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case (.processInfoPlist, let group as ProcessInfoPlistCaptureGroup):
            return formatProcessInfoPlist(group: group)
        case (.processPch, let group as ProcessPchCaptureGroup):
            return formatProcessPch(group: group)
        case (.touch, let group as TouchCaptureGroup):
            return formatTouch(group: group)
        case (.phaseSuccess, let group as PhaseSuccessCaptureGroup):
            return formatPhaseSuccess(group: group)
        case (.phaseScriptExecution, let group as PhaseScriptExecutionCaptureGroup):
            return formatPhaseScriptExecution(group: group)
        case (.preprocess, _ as PreprocessCaptureGroup):
            return format(command: "Preprocessing", pattern: pattern, arguments: "$1")
        case (.processPchCommand, let group as ProcessPchCommandCaptureGroup):
            return formatProcessPchCommand(group: group)
        case (.writeFile, _ as WriteFileCaptureGroup):
            return nil
        case (.writeAuxiliaryFiles, _ as WriteAuxiliaryFilesCaptureGroup):
            return nil
        case (.shellCommand, _ as ShellCommandCaptureGroup):
            return nil
        case (.cleanRemove, let group as CleanRemoveCaptureGroup):
            return formatCleanRemove(group: group)
        case (.executed, _ as ExecutedCaptureGroup):
            return nil
        case (.executedWithSkipped, _ as ExecutedWithSkippedCaptureGroup):
            return nil
        case (.testCaseStarted, _ as TestCaseStartedCaptureGroup):
            return nil
        case (.tiffutil, _ as TIFFutilCaptureGroup):
            return nil
        case (.compileWarning, let group as CompileWarningCaptureGroup):
            return formatCompileWarning(group: group, additionalLines: additionalLines)
        case (.ldWarning, let group as LDWarningCaptureGroup):
            return formatLdWarning(group: group)
        case (.genericWarning, let group as GenericWarningCaptureGroup):
            return formatWarning(group: group)
        case (.willNotBeCodeSigned, let group as WillNotBeCodeSignedCaptureGroup):
            return formatWillNotBeCodesignWarning(group: group)
        case (.clangError, let group as ClangErrorCaptureGroup):
            return formatError(group: group)
        case (.fatalError, let group as FatalErrorCaptureGroup):
            return formatError(group: group)
        case (.ldError, let group as LDErrorCaptureGroup):
            return formatError(group: group)
        case (.podsError, let group as PodsErrorCaptureGroup):
            return formatError(group: group)
        case (.moduleIncludesError, let group as ModuleIncludesErrorCaptureGroup):
            return formatError(group: group)
        case (.xcodebuildError, let group as XcodebuildErrorCaptureGroup):
            return formatError(group: group)
        case (.compileError, let group as CompileErrorCaptureGroup):
            return formatCompileError(group: group, additionalLines: additionalLines)
        case (.fileMissingError, let group as FileMissingErrorCaptureGroup):
            return formatFileMissingError(group: group)
        case (.checkDependenciesErrors, let group as CheckDependenciesErrorsCaptureGroup):
            return formatError(group: group)
        case (.provisioningProfileRequired, let group as ProvisioningProfileRequiredCaptureGroup):
            return formatError(group: group)
        case (.noCertificate, let group as NoCertificateCaptureGroup):
            return formatError(group: group)
        case (.cursor, _ as CursorCaptureGroup):
            return nil
        case (.linkerDuplicateSymbolsLocation, _ as LinkerDuplicateSymbolsLocationCaptureGroup):
            return nil
        case (.linkerDuplicateSymbols, let group as LinkerDuplicateSymbolsCaptureGroup):
            return formatLinkerDuplicateSymbolsError(group: group)
        case (.linkerUndefinedSymbolLocation, _ as LinkerUndefinedSymbolLocationCaptureGroup):
            return nil
        case (.linkerUndefinedSymbols, let group as LinkerUndefinedSymbolsCaptureGroup):
            return formatLinkerUndefinedSymbolsError(group: group)
        case (.symbolReferencedFrom, _ as SymbolReferencedFromCaptureGroup):
            return formatCompleteError()
        case (.undefinedSymbolLocation, _ as UndefinedSymbolLocationCaptureGroup):
            return formatCompleteWarning()
        case (.packageFetching, let group as PackageFetchingCaptureGroup):
            return formatPackageFetching(group: group)
        case (.packageUpdating, let group as PackageUpdatingCaptureGroup):
            return formatPackageUpdating(group: group)
        case (.packageCheckingOut, let group as PackageCheckingOutCaptureGroup):
            return formatPackageCheckingOut(group: group)
        case (.packageGraphResolvingStart, _ as PackageGraphResolvingStartCaptureGroup):
            return formatPackageStart()
        case (.packageGraphResolvingEnded, _ as PackageGraphResolvingEndedCaptureGroup):
            return formatPackageEnd()
        case (.packageGraphResolvedItem, let group as PackageGraphResolvedItemCaptureGroup):
            return formatPackgeItem(group: group)
        case (.duplicateLocalizedStringKey, let group as DuplicateLocalizedStringKeyCaptureGroup):
            return formatDuplicateLocalizedStringKey(group: group)
        case (_, _):
            assertionFailure()
            return nil
        }
    }

    // MARK: - Private

    private func formatTargetCommand(command: String, group: TargetCaptureGroup) -> String {
        let target = group.target
        let project = group.project
        let configuration = group.configuration
        return _colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan : "\(command) target \(target) of project \(project) with configuration \(configuration)"
    }

    private func format(command: String, pattern: Pattern, arguments: String) -> String? {
        let template = command.style.Bold + " " + arguments

        guard let formatted =
            try? NSRegularExpression(pattern: pattern.rawValue)
                .stringByReplacingMatches(
                    in: self,
                    range: NSRange(location: 0, length: count),
                    withTemplate: template)
            else {
                return nil
        }

        return formatted
    }

    private func formatAnalyze(group: AnalyzeCaptureGroup) -> String? {
        let filename = group.fileName
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Analyzing".s.Bold) \(filename)" : "[\(target)] Analyzing \(filename)"
    }

    private func formatCleanRemove(group: CleanRemoveCaptureGroup) -> String? {
        let directory = group.directory
        return _colored ? "\("Cleaning".s.Bold) \(directory)" : "Cleaning \(directory)"
    }

    private func formatCodeSign(group: CodesignCaptureGroup) -> String? {
        let command = "Signing"
        let sourceFile = group.file
        return _colored ? command.s.Bold + " " + sourceFile.lastPathComponent : command + " " + sourceFile.lastPathComponent
    }

    private func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String? {
        let frameworkPath = group.frameworkPath
        return _colored ? "\("Signing".s.Bold) \(frameworkPath)" : "Signing \(frameworkPath)"
    }

    private func formatProcessPch(group: ProcessPchCaptureGroup) -> String? {
        let filename = group.file
        let target = group.buildTarget
        return _colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(filename)" : "[\(target)] Processing \(filename)"
    }

    private func formatProcessPchCommand(group: ProcessPchCommandCaptureGroup) -> String? {
        let filePath = group.filePath
        return _colored ? "\("Preprocessing".s.Bold) \(filePath)" : "Preprocessing \(filePath)"
    }

    private func formatCompileCommand(group: CompileCommandCaptureGroup) -> String? {
        return nil
    }

    private func formatCompile(group: CompileFileCaptureGroup) -> String? {
        let filename = group.filename
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Compiling".s.Bold) \(filename)" : "[\(target)] Compiling \(filename)"
    }

    private func formatCopy(group: CopyCaptureGroup) -> String? {
        let filename = group.file
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Copying".s.Bold) \(filename)" : "[\(target)] Copying \(filename)"
    }

    private func formatGenerateDsym(group: GenerateDSYMCaptureGroup) -> String? {
        let dsym = group.dsym
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Generating".s.Bold) \(dsym)" : "[\(target)] Generating \(dsym)"
    }

    private func formatGenerateCoverageData(group: GenerateCoverageDataCaptureGroup) -> String? {
        return _colored ? "\("Generating".s.Bold) code coverage data..." : "Generating code coverage data..."
    }

    private func formatCoverageReport(group: GeneratedCoverageReportCaptureGroup) -> String? {
        let filePath = group.coverageReportFilePath
        return _colored ? "\("Generated".s.Bold) code coverage report: \(filePath.s.Italic)" : "Generated code coverage report: \(filePath)"
    }

    private func formatLibtool(group: LibtoolCaptureGroup) -> String? {
        let filename = group.fileName
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Building library".s.Bold) \(filename)" : "[\(target)] Building library \(filename)"
    }

    private func formatTouch(group: TouchCaptureGroup) -> String? {
        let filename = group.filename
        let target = group.target
        return _colored ? "[\(target.f.Cyan)] \("Touching".s.Bold) \(filename)" : "[\(target)] Touching \(filename)"
    }

    private func formatPhaseSuccess(group: PhaseSuccessCaptureGroup) -> String? {
        let phase = group.phase.capitalized
        return _colored ? "\(phase) Succeeded".s.Bold.f.Green : "\(phase) Succeeded"
    }

    private func formatLinking(group: LinkingCaptureGroup) -> String? {
        let target = group.target
#if os(Linux)
        return _colored ? "[\(target.f.Cyan)] \("Linking".s.Bold)" : "[\(target)] Linking"
#else
        let filename = group.binaryFilename
        return _colored ? "[\(target.f.Cyan)] \("Linking".s.Bold) \(filename)" : "[\(target)] Linking \(filename)"
#endif
    }

    private func formatPhaseScriptExecution(group: PhaseScriptExecutionCaptureGroup) -> String? {
        let phaseName = group.phaseName
        let target = group.target
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        return _colored ? "[\(target.f.Cyan)] \("Running script".s.Bold) \(strippedPhaseName)" : "[\(target)] Running script \(strippedPhaseName)"
    }

    private func formatTestSuiteStart(group: TestSuiteStartCaptureGroup) -> String? {
        let testSuite = group.testSuiteName
        return _colored ? testSuite.s.Bold : testSuite
    }

    private func formatTestSuiteStarted(group: TestSuiteStartedCaptureGroup) -> String? {
        let testSuite = group.suite
        let heading = "Test Suite \(testSuite) started"
        return _colored ? heading.s.Bold.f.Cyan : heading
    }

    private func formatParallelTestSuiteStarted(group: ParallelTestSuiteStartedCaptureGroup) -> String? {
        let testSuite = group.suite
        let deviceDescription = " on '\(group.device)'"
        let heading = "Test Suite \(testSuite) started\(deviceDescription)"
        return _colored ? heading.s.Bold.f.Cyan : heading
    }

    private func formatParallelTestingStarted(group: ParallelTestingStartedCaptureGroup) -> String? {
        return _colored ? s.Bold.f.Cyan : self
    }

    private func formatParallelTestingPassed(group: ParallelTestingPassedCaptureGroup) -> String? {
        return _colored ? s.Bold.f.Green : self
    }

    private func formatParallelTestingFailed(group: ParallelTestingFailedCaptureGroup) -> String? {
        return _colored ? s.Bold.f.Red : self
    }

    private func formatTestCasePassed(group: TestCasePassedCaptureGroup) -> String? {
        // TODO: Extract to shared property
        let testCase = group.testCase
        let time = group.time
        return _colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " (\(time) seconds)"
    }

    private func formatFailingTest(group: FailingTestCaptureGroup) -> String? {
        let testCase = group.testCase
        let failingReason = group.reason
        return _colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + testCase + ", " + failingReason : Format.indent + TestStatus.fail + " "  + testCase + ", " + failingReason
    }

    private func formatUIFailingTest(group: UIFailingTestCaptureGroup) -> String? {
        let file = group.file
        let failingReason = group.reason
        return _colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + file + ", " + failingReason : Format.indent + TestStatus.fail + " "  + file + ", " + failingReason
    }

    private func formatRestartingTest(group: RestartingTestCaptureGroup) -> String? {
        return _colored ? Format.indent + TestStatus.fail.foreground.Red + " "  + self : Format.indent + TestStatus.fail + " "  + self
    }

    private func formatTestCasePending(group: TestCasePendingCaptureGroup) -> String? {
        let testCase = group.testCase
        return _colored ? Format.indent + TestStatus.pending.foreground.Yellow + " "  + testCase + " [PENDING]" : Format.indent + TestStatus.pending + " "  + testCase + " [PENDING]"
    }

    private func formatTestCaseMeasured(group: TestCaseMeasuredCaptureGroup) -> String? {
        let testCase = group.testCase
        let name = group.name
        let unitName = group.unitName
        let value = group.value
        let deviation = group.deviation.coloredDeviation()

        let formattedValue: String
        if unitName == "seconds" {
            formattedValue = value.coloredTime()
        } else {
            formattedValue = value
        }
        return Format.indent + (_colored ? TestStatus.measure.foreground.Yellow : TestStatus.measure) + " "  + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
    }

    private func formatParallelTestCasePassed(group: ParallelTestCasePassedCaptureGroup) -> String? {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return _colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " on '\(device)' (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " on '\(device)' (\(time) seconds)"
    }

    private func formatParallelTestCaseAppKitPassed(group: ParallelTestCaseAppKitPassedCaptureGroup) -> String? {
        let testCase = group.testCase
        let time = group.time
        return _colored ? Format.indent + TestStatus.pass.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : Format.indent + TestStatus.pass + " " + testCase + " (\(time)) seconds)"
    }

    private func formatParallelTestCaseFailed(group: ParallelTestCaseFailedCaptureGroup) -> String? {
        let testCase = group.testCase
        let device = group.device
        let time = group.time
        return _colored ? "    \(TestStatus.fail.f.Red) \(testCase) on '\(device)' (\(time.coloredTime()) seconds)" : "    \(TestStatus.fail) \(testCase) on '\(device)' (\(time) seconds)"
    }

    private func formatError(group: ErrorCaptureGroup) -> String? {
        let errorMessage = group.wholeError
        return _colored ? Symbol.error.rawValue + " " + errorMessage.f.Red : Symbol.asciiError.rawValue + " " + errorMessage
    }

    private func formatCompleteError() -> String? {
        return _colored ? Symbol.error.rawValue + " " + self.f.Red : Symbol.asciiError.rawValue + " " + self
    }

    private func formatCompileError(group: CompileErrorCaptureGroup, additionalLines: @escaping () -> (String?)) -> String? {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return _colored ?
            """
            \(Symbol.error.rawValue) \(filePath): \(reason.f.Red)
            \(line)
            \(cursor.f.Cyan)
            """
            :
            """
            \(Symbol.asciiError.rawValue) \(filePath): \(reason)
            \(line)
            \(cursor)
            """
    }

    private func formatFileMissingError(group: FileMissingErrorCaptureGroup) -> String {
        let reason = group.reason
        let filePath = group.filePath
        return _colored ? "\(Symbol.error.rawValue) \(filePath): \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(filePath): \(reason)"
    }

    private func formatWarning(group: GenericWarningCaptureGroup) -> String? {
        let warningMessage = group.wholeWarning
        return _colored ? Symbol.warning.rawValue + " " + warningMessage.f.Yellow : Symbol.asciiWarning.rawValue + " " + warningMessage
    }

    private func formatCompleteWarning() -> String? {
        return _colored ? Symbol.warning.rawValue + " " + self.f.Yellow : Symbol.asciiWarning.rawValue + " " + self
    }

    private func formatCompileWarning(group: CompileWarningCaptureGroup, additionalLines: @escaping () -> (String?)) -> String? {
        let filePath = group.filePath
        let reason = group.reason

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return _colored ?
            """
            \(Symbol.warning.rawValue)  \(filePath): \(reason.f.Yellow)
            \(line)
            \(cursor.f.Green)
            """
            :
            """
            \(Symbol.asciiWarning.rawValue)  \(filePath): \(reason)
            \(line)
            \(cursor)
            """
    }

    private func formatLdWarning(group: LDWarningCaptureGroup) -> String? {
        let prefix = group.ldPrefix
        let message = group.warningMessage
        return _colored ? "\(Symbol.warning.rawValue) \(prefix.f.Yellow)\(message.f.Yellow)" : "\(Symbol.asciiWarning.rawValue) \(prefix)\(message)"
    }

    private func formatProcessInfoPlist(group: ProcessInfoPlistCaptureGroup) -> String? {
        let plist = group.filename

        if let target = group.target {
            // Xcode 10+ output
            return _colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(plist)" : "[\(target)] \("Processing") \(plist)"
        } else {
            // Xcode 9 output
            return _colored ? "Processing".s.Bold + " " + plist : "Processing" + " " + plist
        }
    }

    // TODO: Print symbol and reference location
    private func formatLinkerUndefinedSymbolsError(group: LinkerUndefinedSymbolsCaptureGroup) -> String? {        let reason = group.reason
        return _colored ? "\(Symbol.error.rawValue) \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(reason)"
    }

    // TODO: Print file path
    private func formatLinkerDuplicateSymbolsError(group: LinkerDuplicateSymbolsCaptureGroup) -> String? {
        let reason = group.reason
        return _colored ? "\(Symbol.error.rawValue) \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(reason)"
    }

    private func formatWillNotBeCodesignWarning(group: WillNotBeCodeSignedCaptureGroup) -> String? {
        let warningMessage = group.wholeWarning
        return _colored ? Symbol.warning.rawValue + " " + warningMessage.f.Yellow : Symbol.asciiWarning.rawValue + " " + warningMessage
    }

    private func formatSummary() -> String? {
        return _colored ? self.f.Green.s.Bold : self
    }

    private func coloredTime() -> String {
        guard _colored,
              let time = Double(self)
        else { return self }
        if time < 0.025 { return self }
        if time < 0.100 { return f.Yellow }
        return f.Red
    }

    private func coloredDeviation() -> String {
        guard _colored,
              let deviation = Double(self)
        else { return self }
        if deviation < 1 { return self }
        if deviation < 10 { return f.Yellow }
        return f.Red
    }

    private func formatPackageFetching(group: PackageFetchingCaptureGroup) -> String? {
        let source = group.source
        return "Fetching " + source
    }

    private func formatPackageUpdating(group: PackageUpdatingCaptureGroup) -> String? {
        let source = group.source
        return "Updating " + source
    }

    private func formatPackageCheckingOut(group: PackageCheckingOutCaptureGroup) -> String? {
        let version = group.version
        let package = group.package
        return _colored ? "Checking out " + package.s.Bold + " @ " + version.f.Green : "Checking out \(package) @ \(version)"
    }

    private func formatPackageStart() -> String? {
        return _colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    private func formatPackageEnd() -> String? {
        return _colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
    }

    private func formatPackgeItem(group: PackageGraphResolvedItemCaptureGroup) -> String?  {
        let name = group.packageName
        let url = group.packageURL
        let version = group.packageVersion
        return _colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    private func formatDuplicateLocalizedStringKey(group: DuplicateLocalizedStringKeyCaptureGroup) -> String? {
        let message = group.warningMessage
        return _colored ? Symbol.warning.rawValue + " " + message.f.Yellow : Symbol.asciiWarning.rawValue + " " + message
    }
}
