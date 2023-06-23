import Foundation
import Colorizer

private var _colored = true

extension String {
    func beautify(pattern: Pattern, colored: Bool, additionalLines: @escaping () -> (String?)) -> String? {
        _colored = colored

        let group: CaptureGroup = self.capturedGroups(with: pattern)

        switch (pattern, group) {
        case (.analyze, let group as AnalyzeCaptureGroup):
            return formatAnalyze(group: group)
        #if os(Linux)
        case (.compile, let group as CompileCaptureGroup):
            return formatCompileLinux(pattern: pattern)
        #else
        case (.compile, let group as CompileCaptureGroup):
            return formatCompile(pattern: .compile)
        #endif
        case (.compileXib, let group as CompileXibCaptureGroup):
            return formatCompile(pattern: pattern)
        case (.compileStoryboard, let group as CompileStoryboardCaptureGroup):
            return formatCompile(pattern: pattern)
        case (.compileCommand, let group as CompileCommandCaptureGroup):
            return formatCompileCommand(pattern: pattern)
        case (.buildTarget, let group as BuildTargetCaptureGroup):
            return formatTargetCommand(command: "Build", pattern: pattern)
        case (.analyzeTarget, let group as AnalyzeTargetCaptureGroup):
            return formatTargetCommand(command: "Analyze", pattern: pattern)
        case (.aggregateTarget, let group as AggregateTargetCaptureGroup):
            return formatTargetCommand(command: "Aggregate", pattern: pattern)
        case (.cleanTarget, let group as CleanTargetCaptureGroup):
            return formatTargetCommand(command: "Clean", pattern: pattern)
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
            return formatTestHeading(pattern: pattern)
        case (.testSuiteStart, let group as TestSuiteStartCaptureGroup):
            return formatTestHeading(pattern: pattern)
        case (.parallelTestingStarted, let group as ParallelTestingStartedCaptureGroup):
            return formatTestHeading(pattern: pattern)
        case (.parallelTestingPassed, let group as ParallelTestingPassedCaptureGroup):
            return formatTestHeading(pattern: pattern)
        case (.parallelTestingFailed, let group as ParallelTestingFailedCaptureGroup):
            return formatTestHeading(pattern: pattern)
        case (.parallelTestSuiteStarted, let group as ParallelTestSuiteStartedCaptureGroup):
            return formatTestHeading(pattern: pattern)
        case (.testSuiteAllTestsPassed, let group as TestSuiteAllTestsPassedCaptureGroup):
            return nil
        case (.testSuiteAllTestsFailed, let group as TestSuiteAllTestsFailedCaptureGroup):
            return nil
        case (.failingTest, let group as FailingTestCaptureGroup):
            return formatTest(pattern: pattern)
        case (.uiFailingTest, let group as UIFailingTestCaptureGroup):
            return formatTest(pattern: pattern)
        case (.restartingTest, let group as RestartingTestCaptureGroup):
            return formatTest(pattern: pattern)
        case (.testCasePassed, let group as TestCasePassedCaptureGroup):
            return formatTest(pattern: pattern)
        case (.testCasePending, let group as TestCasePendingCaptureGroup):
            return formatTest(pattern: pattern)
        case (.testCaseMeasured, let group as TestCaseMeasuredCaptureGroup):
            return formatTest(pattern: pattern)
        case (.testsRunCompletion, let group as TestsRunCompletionCaptureGroup):
            return formatTest(pattern: pattern)
        case (.parallelTestCasePassed, let group as ParallelTestCasePassedCaptureGroup):
            return formatTest(pattern: pattern)
        case (.parallelTestCaseAppKitPassed, let group as ParallelTestCaseAppKitPassedCaptureGroup):
            return formatTest(pattern: pattern)
        case (.parallelTestCaseFailed, let group as ParallelTestCaseFailedCaptureGroup):
            return formatTest(pattern: pattern)
        case (.codesign, let group as CodesignCaptureGroup):
            return format(command: "Signing", pattern: pattern)
        case (.codesignFramework, let group as CodesignFrameworkCaptureGroup):
            return formatCodeSignFramework(group: group)
        case (.copyHeader, let group as CopyHeaderCaptureGroup):
            return formatCopy(pattern: pattern)
        case (.copyPlist, let group as CopyPlistCaptureGroup):
            return formatCopy(pattern: pattern)
        case (.copyStrings, let group as CopyStringsCaptureGroup):
            return formatCopy(pattern: pattern)
        case (.cpresource, let group as CpresourceCaptureGroup):
            return formatCopy(pattern: pattern)
        case (.pbxcp, let group as PbxcpCaptureGroup):
            return formatCopy(pattern: pattern)
        case (.checkDependencies, let group as CheckDependenciesCaptureGroup):
            return format(command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case (.processInfoPlist, let group as ProcessInfoPlistCaptureGroup):
            return formatProcessInfoPlist(group: group)
        case (.processPch, let group as ProcessPchCaptureGroup):
            return formatProcessPch(pattern: pattern)
        case (.touch, let group as TouchCaptureGroup):
            return formatTouch(group: group)
        case (.phaseSuccess, let group as PhaseSuccessCaptureGroup):
            let phase = capturedGroups(with: .phaseSuccess)[0].capitalized
            return _colored ? "\(phase) Succeeded".s.Bold.f.Green : "\(phase) Succeeded"
        case (.phaseScriptExecution, let group as PhaseScriptExecutionCaptureGroup):
            return formatPhaseScriptExecution(group: group)
        case (.preprocess, let group as PreprocessCaptureGroup):
            return format(command: "Preprocessing", pattern: pattern, arguments: "$1")
        case (.processPchCommand, let group as ProcessPchCommandCaptureGroup):
            return formatProcessPchCommand(pattern: pattern)
        case (.writeFile, let group as WriteFileCaptureGroup):
            return nil
        case (.writeAuxiliaryFiles, let group as WriteAuxiliaryFilesCaptureGroup):
            return nil
        case (.shellCommand, let group as ShellCommandCaptureGroup):
            return nil
        case (.cleanRemove, let group as CleanRemoveCaptureGroup):
            return formatCleanRemove(group: group)
        case (.executed, let group as ExecutedCaptureGroup):
            return nil
        case (.executedWithSkipped, let group as ExecutedWithSkippedCaptureGroup):
            return nil
        case (.testCaseStarted, let group as TestCaseStartedCaptureGroup):
            return nil
        case (.tiffutil, let group as TIFFutilCaptureGroup):
            return nil
        case (.compileWarning, let group as CompileWarningCaptureGroup):
            return formatCompileWarning(group: group, additionalLines: additionalLines)
        case (.ldWarning, let group as LDWarningCaptureGroup):
            return formatLdWarning(group: group)
        case (.genericWarning, let group as GenericWarningCaptureGroup):
            return formatWarning(pattern: pattern)
        case (.willNotBeCodeSigned, let group as WillNotBeCodeSignedCaptureGroup):
            return formatWillNotBeCodesignWarning(group: group)
        case (.clangError, let group as ClangErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.fatalError, let group as FatalErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.ldError, let group as LDErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.podsError, let group as PodsErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.moduleIncludesError, let group as ModuleIncludesErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.xcodebuildError, let group as XcodebuildErrorCaptureGroup):
            return formatError(pattern: pattern)
        case (.compileError, let group as CompileErrorCaptureGroup):
            return formatCompileError(group: group, additionalLines: additionalLines)
        case (.fileMissingError, let group as FileMissingErrorCaptureGroup):
            return formatFileMissingError(group: group)
        case (.checkDependenciesErrors, let group as CheckDependenciesCaptureGroup):
            return formatError(pattern: pattern)
        case (.provisioningProfileRequired, let group as ProvisioningProfileRequiredCaptureGroup):
            return formatError(pattern: pattern)
        case (.noCertificate, let group as NoCertificateCaptureGroup):
            return formatError(pattern: pattern)
        case (.cursor, let group as CursorCaptureGroup):
            return nil
        case (.linkerDuplicateSymbolsLocation, let group as LinkerDuplicateSymbolsLocationCaptureGroup):
            return nil
        case (.linkerDuplicateSymbols, let group as LinkerDuplicateSymbolsCaptureGroup):
            return formatLinkerDuplicateSymbolsError(group: group)
        case (.linkerUndefinedSymbolLocation, let group as LinkerUndefinedSymbolLocationCaptureGroup):
            return nil
        case (.linkerUndefinedSymbols, let group as LinkerUndefinedSymbolsCaptureGroup):
            return formatLinkerUndefinedSymbolsError(group: group)
        case (.symbolReferencedFrom, let group as SymbolReferencedFromCaptureGroup):
            return formatCompleteError()
        case (.undefinedSymbolLocation, let group as UndefinedSymbolLocationCaptureGroup):
            return formatCompleteWarning()
        case (.packageFetching, let group as PackageFetchingCaptureGroup):
            return formatPackageFetching(pattern: pattern)
        case (.packageUpdating, let group as PackageUpdatingCaptureGroup):
            return formatPackageUpdating(pattern: pattern)
        case (.packageCheckingOut, let group as PackageCheckingOutCaptureGroup):
            return formatPackageCheckingOut(pattern: pattern)
        case (.packageGraphResolvingStart, let group as PackageGraphResolvingStartCaptureGroup):
            return formatPackageStart()
        case (.packageGraphResolvingEnded, let group as PackageGraphResolvingEndedCaptureGroup):
            return formatPackageEnd()
        case (.packageGraphResolvedItem, let group as PackageGraphResolvedItemCaptureGroup):
            return formatPackgeItem(pattern: pattern)
        case (.duplicateLocalizedStringKey, let group as DuplicateLocalizedStringKeyCaptureGroup):
            return formatDuplicateLocalizedStringKey(pattern: pattern)
        case (_, _):
            assertionFailure()
            return nil
        }
    }

    // MARK: - Private

    private func formatTargetCommand(command: String, pattern: Pattern) -> String {
        let groups: [String] = capturedGroups(with: pattern)
        let target = groups[0]
        let project = groups[1]
        let configuration = groups[2]
        return _colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan : "\(command) target \(target) of project \(project) with configuration \(configuration)"
    }

    private func format(command: String, pattern: Pattern) -> String {
        let groups: [String] = capturedGroups(with: pattern)
        let sourceFile = groups[0]
        return _colored ? command.s.Bold + " " + sourceFile.lastPathComponent : command + " " + sourceFile.lastPathComponent
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

    private func formatCodeSignFramework(group: CodesignFrameworkCaptureGroup) -> String? {
        let frameworkPath = group.frameworkPath
        return _colored ? "\("Signing".s.Bold) \(frameworkPath)" : "Signing \(frameworkPath)"
    }

    private func formatProcessPch(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let filename = groups[0]
        guard let target = groups.last else { return nil }
        return _colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(filename)" : "[\(target)] Processing \(filename)"
    }

    private func formatProcessPchCommand(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        guard let filePath = groups.last else { return nil }
        return _colored ? "\("Preprocessing".s.Bold) \(filePath)" : "Preprocessing \(filePath)"
    }

    private func formatCompileCommand(pattern: Pattern) -> String? {
        return nil
    }
    private func formatCompile(pattern: Pattern) -> String? {
        return innerFormatCompile(pattern: pattern, fileIndex: 1, targetIndex: 2)
    }
    
    private func formatCompileLinux(pattern: Pattern) -> String? {
        return innerFormatCompile(pattern: pattern, fileIndex: 1, targetIndex: 0)
    }
    
    private func innerFormatCompile(pattern: Pattern, fileIndex: Int, targetIndex: Int) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let filename = groups[fileIndex]
        guard let target = groups.last else { return nil }
        return _colored ? "[\(target.f.Cyan)] \("Compiling".s.Bold) \(filename)" : "[\(target)] Compiling \(filename)"
    }

    private func formatCopy(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let filename = groups[0].lastPathComponent
        guard let target = groups.last else { return nil }
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

    private func formatTestHeading(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let testSuite = groups[0]

        switch pattern {
        case .testSuiteStart:
            return _colored ? testSuite.s.Bold : testSuite
        case .testSuiteStarted,
             .parallelTestSuiteStarted:
            let deviceDescription = pattern == .parallelTestSuiteStarted ? " on '\(groups[1])'" : ""
            let heading = "Test Suite \(testSuite) started\(deviceDescription)"
            return _colored ? heading.s.Bold.f.Cyan : heading
        case .parallelTestingStarted:
            return _colored ? s.Bold.f.Cyan : self
        case .parallelTestingPassed:
            return _colored ? s.Bold.f.Green : self
        case .parallelTestingFailed:
            return _colored ? s.Bold.f.Red : self
        default:
            return nil
        }
    }

    private func formatTest(pattern: Pattern) -> String? {
        let indent = "    "
        let groups: [String] = capturedGroups(with: pattern)

        switch pattern {
        case .testCasePassed:
            let testCase = groups[1]
            let time = groups[2]
            return _colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " (\(time) seconds)"
        case .failingTest:
            let testCase = groups[2]
            let failingReason = groups[3]
            return _colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + testCase + ", " + failingReason : indent + TestStatus.fail.rawValue + " "  + testCase + ", " + failingReason
        case .uiFailingTest:
            let file = groups[0]
            let failingReason = groups[1]
            return _colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + file + ", " + failingReason : indent + TestStatus.fail.rawValue + " "  + file + ", " + failingReason
        case .restartingTest:
            return _colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + self : indent + TestStatus.fail.rawValue + " "  + self
        case .testCasePending:
            let testCase = groups[1]
            return _colored ? indent + TestStatus.pending.rawValue.foreground.Yellow + " "  + testCase + " [PENDING]" : indent + TestStatus.pending.rawValue + " "  + testCase + " [PENDING]"
        case .testsRunCompletion:
            return nil
        case .testCaseMeasured:
            let testCase = groups[1]
            let name = groups[2]
            let unitName = groups[3]
            let value = groups[4]
            let deviation = groups[5].coloredDeviation()

            let formattedValue: String
            if unitName == "seconds" {
                formattedValue = value.coloredTime()
            } else {
                formattedValue = value
            }
            return indent + (_colored ? TestStatus.measure.rawValue.foreground.Yellow : TestStatus.measure.rawValue) + " "  + testCase + " measured (\(formattedValue) \(unitName) ±\(deviation)% -- \(name))"
        case .parallelTestCasePassed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[3]
            return _colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " on '\(device)' (\(time.coloredTime()) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " on '\(device)' (\(time) seconds)"
        case .parallelTestCaseAppKitPassed:
            let testCase = groups[1]
            let time = groups[2]
            return _colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " (\(time)) seconds)"
        case .parallelTestCaseFailed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[3]
            return _colored ? "    \(TestStatus.fail.rawValue.f.Red) \(testCase) on '\(device)' (\(time.coloredTime()) seconds)" : "    \(TestStatus.fail.rawValue) \(testCase) on '\(device)' (\(time) seconds)"
        default:
            return nil
        }
    }

    private func formatError(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        guard let errorMessage = groups.first else { return nil }
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

    private func formatWarning(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        guard let warningMessage = groups.first else { return nil }
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

    private func formatPackageFetching(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let source = groups[0]
        return "Fetching " + source
    }

    private func formatPackageUpdating(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let source = groups[0]
        return "Updating " + source
    }

    private func formatPackageCheckingOut(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let version = groups[0]
        let package = groups[1]
        return _colored ? "Checking out " + package.s.Bold + " @ " + version.f.Green : "Checking out \(package) @ \(version)"
    }

    private func formatPackageStart() -> String? {
        return _colored ? "Resolving Package Graph".s.Bold.f.Cyan : "Resolving Package Graph"
    }

    private func formatPackageEnd() -> String? {
        return _colored ? "Resolved source packages".s.Bold.f.Green : "Resolved source packages"
    }

    private func formatPackgeItem(pattern: Pattern) -> String?  {
        let groups: [String] = capturedGroups(with: pattern)
        let name = groups[0]
        let url = groups[1]
        let version = groups[2]
        return _colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    private func formatDuplicateLocalizedStringKey(pattern: Pattern) -> String? {
        let groups: [String] = capturedGroups(with: pattern)
        let message = groups[0]
        return _colored ? Symbol.warning.rawValue + " " + message.f.Yellow : Symbol.asciiWarning.rawValue + " " + message
    }
}
