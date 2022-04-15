import Foundation
import Colorizer

struct Formatter {
    let colored: Bool
    let string: String
    
    func formatTargetCommand(matching: Matching, command: String) -> String {
        let groups = matching.capturedGroups(string: string)
        let target = groups[0]
        let project = groups[1]
        let configuration = groups[2]
        return colored ? "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan : "\(command) target \(target) of project \(project) with configuration \(configuration)"
    }
    
    func formatPhaseSuccess(matcher: Matching) -> String? {
        let phase = matcher.capturedGroups(string: string)[0].capitalized
        return colored ? "\(phase) Succeeded".s.Bold.f.Green : "\(phase) Succeeded"
    }

    func formatPreprocess(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[1].lastPathComponent
        return (colored ? "Preprocessing".s.Bold : "Preprocessing") + " " + filename
    }

    func formatCheckDependencies(matcher: Matching) -> String? {
        return (colored ? "Check Dependencies".s.Bold : "Check Dependencies")
    }

    func formatCodeSigning(matcher: Matching) -> String {
        let groups = matcher.capturedGroups(string: string)
        let sourceFile = groups[0]
        return colored ? "Signing".s.Bold + " " + sourceFile.lastPathComponent : "Signing" + " " + sourceFile.lastPathComponent
    }

    func formatAnalyze(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[1]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Analyzing".s.Bold) \(filename)" : "[\(target)] Analyzing \(filename)"
    }

    func formatNil(matcher: Matching) -> String? {
        return nil
    }

    func formatCleanRemove(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let directory = groups[0].lastPathComponent
        return colored ? "\("Cleaning".s.Bold) \(directory)" : "Cleaning \(directory)"
    }

    func formatCodeSignFramework(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let frameworkPath = groups[0]
        return colored ? "\("Signing".s.Bold) \(frameworkPath)" : "Signing \(frameworkPath)"
    }

    func formatProcessPch(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[0]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(filename)" : "[\(target)] Processing \(filename)"
    }

    func formatProcessPchCommand(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        guard let filePath = groups.last else { return nil }
        return colored ? "\("Preprocessing".s.Bold) \(filePath)" : "Preprocessing \(filePath)"
    }

    func formatCompileCommand(matcher: Matching) -> String? {
        return nil
    }

    func formatCompile(matcher: Matching) -> String? {
        return innerFormatCompile(matcher: matcher, fileIndex: 1, targetIndex: 2)
    }

    func formatCompileLinux(matcher: Matching) -> String? {
        return innerFormatCompile(matcher: matcher, fileIndex: 1, targetIndex: 0)
    }

    func innerFormatCompile(matcher: Matching, fileIndex: Int, targetIndex: Int) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[fileIndex]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Compiling".s.Bold) \(filename)" : "[\(target)] Compiling \(filename)"
    }

    func formatCopy(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[0].lastPathComponent
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Copying".s.Bold) \(filename)" : "[\(target)] Copying \(filename)"
    }

    func formatGenerateDsym(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let dsym = groups[0]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Generating".s.Bold) \(dsym)" : "[\(target)] Generating \(dsym)"
    }

    func formatCodeCoverage(matcher: Matching, pattern: Pattern) -> String? {
        switch pattern {
        case .generateCoverageData:
            return colored ? "\("Generating".s.Bold) code coverage data..." : "Generating code coverage data..."
        case .generatedCoverageReport:
            let groups = matcher.capturedGroups(string: string)
            let filePath = groups[0]
            return colored
            ? "\("Generated".s.Bold) code coverage report: \(filePath.s.Italic)"
            : "Generated code coverage report: \(filePath)"
        default:
            return nil
        }
    }

    func formatLibtool(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[0]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Building library".s.Bold) \(filename)" : "[\(target)] Building library \(filename)"
    }

    func formatTouch(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[1]
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Touching".s.Bold) \(filename)" : "[\(target)] Touching \(filename)"
    }

    func formatLinking(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filename = groups[0].lastPathComponent
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Linking".s.Bold) \(filename)" : "[\(target)] Linking \(filename)"
    }
    
    func formatLinkingLinux(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let target = groups[0]
        return colored ? "[\(target.f.Cyan)] \("Linking".s.Bold)" : "[\(target)] Linking"
    }

    func formatPhaseScriptExecution(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let phaseName = groups[0]
        // Strip backslashed added by xcodebuild before spaces in the build phase name
        let strippedPhaseName = phaseName.replacingOccurrences(of: "\\ ", with: " ")
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Running script".s.Bold) \(strippedPhaseName)" : "[\(target)] Running script \(strippedPhaseName)"
    }

    func formatTestHeading(matcher: Matching, pattern: Pattern) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let testSuite = groups[0]
        
        switch pattern {
        case .testSuiteStart:
            return colored ? testSuite.s.Bold : testSuite
        case .testSuiteStarted,
             .parallelTestSuiteStarted:
            let deviceDescription = pattern == .parallelTestSuiteStarted ? " on '\(groups[1])'" : ""
            let heading = "Test Suite \(testSuite) started\(deviceDescription)"
            return colored ? heading.s.Bold.f.Cyan : heading
        case .parallelTestingStarted:
            return colored ? string.s.Bold.f.Cyan : string
        case .parallelTestingPassed:
            return colored ? string.s.Bold.f.Green : string
        case .parallelTestingFailed:
            return colored ? string.s.Bold.f.Red : string
        default:
            return nil
        }
    }

    func formatTest(matcher: Matching, pattern: Pattern) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let indent = "    "
        
        switch pattern {
        case .testCasePassed:
            let testCase = groups[1]
            let time = groups[2]
            return colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " (\(coloredTime(timedString: time)) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " (\(time) seconds)"
        case .failingTest:
            let testCase = groups[2]
            let failingReason = groups[3]
            return colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + testCase + ", " + failingReason : indent + TestStatus.fail.rawValue + " "  + testCase + ", " + failingReason
        case .uiFailingTest:
            let file = groups[0]
            let failingReason = groups[1]
            return colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + file + ", " + failingReason : indent + TestStatus.fail.rawValue + " "  + file + ", " + failingReason
        case .restartingTests:
            return colored ? indent + TestStatus.fail.rawValue.foreground.Red + " "  + string : indent + TestStatus.fail.rawValue + " "  + string
        case .testCasePending:
            let testCase = groups[1]
            return colored ? indent + TestStatus.pending.rawValue.foreground.Yellow + " "  + testCase + " [PENDING]" : indent + TestStatus.pending.rawValue + " "  + testCase + " [PENDING]"
        case .testsRunCompletion:
            return nil
        case .testCaseMeasured:
            let testCase = groups[1]
            let time = groups[2]
            return colored ? indent + TestStatus.measure.rawValue.foreground.Yellow + " "  + testCase + " measured (\(coloredTime(timedString: time)) seconds)" : indent + TestStatus.measure.rawValue + " "  + testCase + " measured (\(time) seconds)"
        case .parallelTestCasePassed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[3]
            return colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " on '\(device)' (\(coloredTime(timedString: time)) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " on '\(device)' (\(time) seconds)"
        case .parallelTestCaseAppKitPassed:
            let testCase = groups[1]
            let time = groups[2]
            return colored ? indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " (\(coloredTime(timedString: time)) seconds)" : indent + TestStatus.pass.rawValue + " " + testCase + " (\(time)) seconds)"
        case .parallelTestCaseFailed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[3]
            return colored ? "    \(TestStatus.fail.rawValue.f.Red) \(testCase) on '\(device)' (\(coloredTime(timedString: time)) seconds)" : "    \(TestStatus.fail.rawValue) \(testCase) on '\(device)' (\(time) seconds)"
        default:
            return nil
        }
    }

    func formatError(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        guard let errorMessage = groups.first else { return nil }
        return colored ? Symbol.error.rawValue + " " + errorMessage.f.Red : Symbol.asciiError.rawValue + " " + errorMessage
    }

    func formatCompleteError(matcher: Matching) -> String? {
        return colored ? Symbol.error.rawValue + " " + string.f.Red : Symbol.asciiError.rawValue + " " + string
    }

    func formatCompileError(matcher: Matching, additionalLines: @escaping () -> (String?)) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filePath = groups[0]
        let reason = groups[2]
        
        // Read 2 additional lines to get the error line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
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

    func formatFileMissingError(matcher: Matching) -> String {
        let groups = matcher.capturedGroups(string: string)
        let reason = groups[0]
        let filePath = groups[1]
        return colored ? "\(Symbol.error.rawValue) \(filePath): \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(filePath): \(reason)"
    }

    func formatWarning(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        guard let warningMessage = groups.first else { return nil }
        return colored ? Symbol.warning.rawValue + " " + warningMessage.f.Yellow : Symbol.asciiWarning.rawValue + " " + warningMessage
    }
    
    func formatCompleteWarning(matcher: Matching) -> String? {
        return colored ? Symbol.warning.rawValue + " " + string.f.Yellow : Symbol.asciiWarning.rawValue + " " + string
    }

    func formatCompileWarning(matcher: Matching, additionalLines: @escaping () -> (String?)) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let filePath = groups[0]
        let reason = groups[2]
        
        // Read 2 additional lines to get the warning line and cursor position
        let line: String = additionalLines() ?? ""
        let cursor: String = additionalLines() ?? ""
        return colored ?
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

    func formatLdWarning(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let prefix = groups[0]
        let message = groups[1]
        return colored ? "\(Symbol.warning.rawValue) \(prefix.f.Yellow)\(message.f.Yellow)" : "\(Symbol.asciiWarning.rawValue) \(prefix)\(message)"
    }

    func formatProcessInfoPlist(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let plist = groups[1]
        
        // Xcode 9 output
        if groups.count == 2 {
            return colored ? "Processing".s.Bold + " " + plist : "Processing" + " " + plist
        }
        
        // Xcode 10+ output
        guard let target = groups.last else { return nil }
        return colored ? "[\(target.f.Cyan)] \("Processing".s.Bold) \(plist)" : "[\(target)] \("Processing") \(plist)"
    }

    // TODO: Print symbol and reference location
    func formatLinkerUndefinedSymbolsError(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let reason = groups[0]
        return colored ? "\(Symbol.error.rawValue) \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(reason)"
    }

    // TODO: Print file path
    func formatLinkerDuplicateSymbolsError(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let reason = groups[0]
        return colored ? "\(Symbol.error.rawValue) \(reason.f.Red)" : "\(Symbol.asciiError.rawValue) \(reason)"
    }

    func formatWillNotBeCodesignWarning(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        guard let warningMessage = groups.first else { return nil }
        return colored ? Symbol.warning.rawValue + " " + warningMessage.f.Yellow : Symbol.asciiWarning.rawValue + " " + warningMessage
    }

    func formatSummary() -> String? {
        return colored ? string.f.Green.s.Bold : string
    }

    func coloredTime(timedString: String) -> String {
        guard let time = Double(timedString) else { return timedString }
        if time < 0.025 { return timedString }
        if time < 0.100 { return colored ? timedString.f.Yellow : timedString }
        return colored ? timedString.f.Red : timedString
    }

    func formatPackageStart(matcher: Matching) -> String? {
        return colored ? string.s.Bold.f.Cyan : string
    }

    func formatPackageEnd(matcher: Matching) -> String? {
        let groups = matcher.capturedGroups(string: string)
        let ended = groups[0]
        return colored ? ended.s.Bold.f.Green : ended
    }

    func formatPackgeItem(matcher: Matching) -> String?  {
        let groups = matcher.capturedGroups(string: string)
        let name = groups[0]
        let url = groups[1]
        let version = groups[2]
        return colored ? name.s.Bold.f.Cyan + " - " + url.s.Bold + " @ " + version.f.Green : "\(name) - \(url) @ \(version)"
    }

    func formatBuildTargetCommand(matching: Matching) -> String {
        formatTargetCommand(matching: matching, command: "Build")
    }
    
    func formatAggregateTargetCommand(matching: Matching) -> String {
        formatTargetCommand(matching: matching, command: "Aggregate")
    }
    
    func formatAnalyzeTargetCommand(matching: Matching) -> String {
        formatTargetCommand(matching: matching, command: "Analyze")
    }
    
    func formatCleanTargetCommand(matching: Matching) -> String {
        formatTargetCommand(matching: matching, command: "Clean")
    }
    
    static func formatTestHeading(pattern: Pattern) -> (Formatter) -> (Matching) -> String? {
        format(pattern: pattern, formatter: Formatter.formatTestHeading)
    }
    
    static func formatTest(pattern: Pattern) -> (Formatter) -> (Matching) -> String? {
        format(pattern: pattern, formatter: Formatter.formatTest)
    }
    
    static func formatCodeCoverage(pattern: Pattern) -> (Formatter) -> (Matching) -> String? {
        format(pattern: pattern, formatter: Formatter.formatCodeCoverage)
    }
    
    static func format(
        pattern: Pattern,
        formatter: @escaping (Formatter) -> (Matching, Pattern) -> String?
    ) -> (Formatter) -> (Matching) -> String? {
        { string in
            { matcher in
                return formatter(string)(matcher, pattern)
            }
        }
    }

}
