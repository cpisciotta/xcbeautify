import Foundation
import Swiftline

extension String {
    func beautify(pattern: Pattern) -> String? {
        switch pattern {
        case .analyze:
            return format(command: "Analyzing", pattern: pattern, arguments: "$2")
        case .compile,
             .compileSwift,
             .compileXib,
             .compileStoryboard,
             .compileCommand:
            return format(command: "Compiling", pattern: pattern, arguments: "$2")
        case .buildTarget:
            return formatTargetCommand(command: "Build", pattern: pattern)
        case .analyzeTarget:
            return formatTargetCommand(command: "Analyze", pattern: pattern)
        case .aggregateTarget:
            return formatTargetCommand(command: "Aggregate", pattern: pattern)
        case .cleanTarget:
            return formatTargetCommand(command: "Clean", pattern: pattern)
        case .generateDsym:
            return format(command: "Generating", pattern: pattern)
        case .libtool:
            return format(command: "Building library", pattern: pattern, arguments: "$1")
        case .linking:
            return format(command: "Linking", pattern: pattern, arguments: "$1")
        case .testSuiteStarted,
             .testSuiteStart,
            .parallelTestingStarted:
            return formatTestHeading(pattern: pattern)
        case .failingTest,
             .uiFailingTest,
             .restartingTests,
             .testCasePassed,
             .testCasePending,
             .testCaseMeasured,
             .testsRunCompletion,
             .parallelTestCasePassed,
             .parallelTestCaseFailed:
            return formatTest(pattern: pattern)
        case .codesign,
             .codesignFramework:
            return format(command: "Signing", pattern: pattern)
        case .copyHeader,
             .copyPlist,
             .copyStrings,
             .cpresource,
             .pbxcp:
            return format(command: "Copying", pattern: pattern)
        case .checkDependencies:
            return format(command: "Check Dependencies", pattern: .checkDependencies, arguments: "")
        case .processInfoPlist:
            return formatProcessInfoPlist(pattern: .processInfoPlist)
        case .processPch:
            return format(command: "Processing", pattern: .processPch, arguments: "$1")
        case .touch:
            return format(command: "Touching", pattern: .touch, arguments: "$2")
        case .phaseSuccess:
            let phase = capturedGroups(with: .phaseSuccess)[0].capitalized
            return "\(phase) Succeeded".s.Bold.f.Green
        case .phaseScriptExecution:
            return format(command: "Running script", pattern: .phaseScriptExecution, arguments: "$1")
        case .preprocess,
             .processPchCommand:
            return format(command: "Preprocessing", pattern: pattern, arguments: "$1")
        case .writeFile:
            return nil
        case .writeAuxiliaryFiles:
            return nil
        case .shellCommand:
            return nil
        case .cleanRemove:
            return nil
        case .executed:
            return nil
        case .testCaseStarted:
            return nil
        case .tiffutil:
            return nil
        case .compileWarning:
            return formatCompileWarning(pattern: pattern)
        case .ldWarning:
            return formatLdWarning(pattern: pattern)
        case .genericWarning:
            return formatWarning(pattern: pattern)
        case .willNotBeCodeSigned:
            return formatWillNotBeCodesignWarning(pattern: pattern)
        case .clangError,
             .fatalError,
             .ldError,
             .podsError,
             .moduleIncludesError:
            return formatError(pattern: pattern)
        case .compileError:
            return formatCompileError(pattern: pattern)
        case .fileMissingError:
            return formatFileMissingError(pattern: pattern)
        case .checkDependenciesErrors:
            return formatError(pattern: pattern)
        case .provisioningProfileRequired:
            return formatError(pattern: pattern)
        case .noCertificate:
            return formatError(pattern: pattern)
        case .cursor:
            return nil
        case .linkerDuplicateSymbolsLocation:
            return nil
        case .linkerDuplicateSymbols:
            return formatLinkerDuplicateSymbolsError(pattern: pattern)
        case .linkerUndefinedSymbolLocation:
            return nil
        case .linkerUndefinedSymbols:
            return formatLinkerUndefinedSymbolsError(pattern: pattern)
        case .symbolReferencedFrom:
            return formatError(pattern: pattern)
        }
    }

    // MARK: - Private

    private func formatTargetCommand(command: String, pattern: Pattern) -> String {
        let groups = capturedGroups(with: pattern)
        let target = groups[0]
        let project = groups[1]
        let configuration = groups[2]
        return "\(command) target \(target) of project \(project) with configuration \(configuration)".s.Bold.f.Cyan
    }

    private func format(command: String, pattern: Pattern) -> String {
        let groups = capturedGroups(with: pattern)
        let sourceFile = groups[0]
        return command.s.Bold + " " + sourceFile.lastPathComponent
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

    private func formatTestHeading(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let testSuite = groups[0]

        if pattern == .testSuiteStart {
            return testSuite.s.Bold
        } else if pattern == .testSuiteStarted {
            return "Test Suite \(testSuite) started".s.Bold.f.Cyan
        } else if pattern == .parallelTestingStarted {
            return s.Bold.f.Cyan
        }

        return nil
    }

    private func formatTest(pattern: Pattern) -> String? {
        let indent = "    "
        let groups = capturedGroups(with: pattern)

        switch pattern {
        case .testCasePassed:
            let testCase = groups[1]
            let time = groups[2]
            return indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " (\(time.coloredTime()) seconds)"
        case .failingTest:
            let testCase = groups[2]
            let failingReason = groups[3]
            return indent + TestStatus.fail.rawValue.foreground.Red + " "  + testCase + ", " + failingReason
        case .uiFailingTest:
            let file = groups[0]
            let failingReason = groups[1]
            return indent + TestStatus.fail.rawValue.foreground.Red + " "  + file + ", " + failingReason
        case .restartingTests:
            return self
        case .testCasePending:
            let testCase = groups[1]
            return indent + TestStatus.pending.rawValue.foreground.Yellow + " "  + testCase + " [PENDING]"
        case .testsRunCompletion:
            return nil
        case .testCaseMeasured:
            let testCase = groups[1]
            let time = groups[2]
            return indent + TestStatus.measure.rawValue.foreground.Yellow + " "  + testCase + " measured (\(time.coloredTime()) seconds)"
        case .parallelTestCasePassed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[4]
            return indent + TestStatus.pass.rawValue.foreground.Green + " " + testCase + " on '\(device)' (\(time.coloredTime()) seconds)"
        case .parallelTestCaseFailed:
            let testCase = groups[1]
            let device = groups[2]
            let time = groups[4]
            return "    \(TestStatus.fail.rawValue.f.Red) \(testCase) on '\(device)' (\(time.coloredTime()) seconds)"
        default:
            return nil
        }
    }

    func formatError(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        guard let errorMessage = groups.first else { return nil }
        return Symbol.error.rawValue + " " + errorMessage.f.Red
    }

    func formatCompileError(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let filePath = groups[0]
        let reason = groups[2]

        // Read 2 additional lines to get the error line and cursor position
        let line: String = readLine() ?? ""
        let cursor: String = readLine() ?? ""
        return """
        \(Symbol.error.rawValue) \(filePath): \(reason.f.Red)
        \(line)
        \(cursor.f.Cyan)
        """
    }

    func formatFileMissingError(pattern: Pattern) -> String {
        let groups = capturedGroups(with: pattern)
        let reason = groups[0]
        let filePath = groups[1]
        return "\(Symbol.error.rawValue) \(filePath): \(reason.f.Red)"
    }

    func formatWarning(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        guard let warningMessage = groups.first else { return nil }
        return Symbol.warning.rawValue + " " + warningMessage.f.Yellow
    }

    func formatCompileWarning(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let filePath = groups[0]
        let reason = groups[2]

        // Read 2 additional lines to get the warning line and cursor position
        let line: String = readLine() ?? ""
        let cursor: String = readLine() ?? ""
        return """
        \(Symbol.warning.rawValue)  \(filePath): \(reason.f.Yellow)
        \(line)
        \(cursor.f.Green)
        """
    }

    func formatLdWarning(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let prefix = groups[0]
        let message = groups[1]
        return "\(Symbol.warning.rawValue) \(prefix.f.Yellow)\(message.f.Yellow)"
    }

    func formatProcessInfoPlist(pattern: Pattern) -> String {
        let groups = capturedGroups(with: pattern)
        let plist = groups[1]

        // Xcode 9 output
        if groups.count == 2 {
            return "Processing".s.Bold + " " + plist
        }

        // Xcode 10+ output
        let target = groups[3]
        return "[\(target.f.Cyan)] \("Processing".s.Bold) \(plist)"
    }

    // TODO: Print symbol and reference location
    func formatLinkerUndefinedSymbolsError(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let reason = groups[0]
        return "\(Symbol.error.rawValue) \(reason.f.Red)"
    }

    // TODO: Print file path
    func formatLinkerDuplicateSymbolsError(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        let reason = groups[0]
        return "\(Symbol.error.rawValue) \(reason.f.Red)"
    }

    func formatWillNotBeCodesignWarning(pattern: Pattern) -> String? {
        let groups = capturedGroups(with: pattern)
        guard let warningMessage = groups.first else { return nil }
        return Symbol.warning.rawValue + " " + warningMessage.f.Yellow
    }

    func formatSummary() -> String? {
        return self.f.Green.s.Bold
    }

    private func coloredTime() -> String {
        guard let time = Double(self) else { return self }
        if time < 0.025 { return self }
        if time < 0.100 { return f.Yellow }
        return f.Red
    }
}
