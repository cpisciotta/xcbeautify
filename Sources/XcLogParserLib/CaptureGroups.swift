//
// CaptureGroups.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

public let swiftTestingSuiteName = "SwiftTesting"

public protocol CaptureGroup {
    static var outputType: OutputType { get }
    static var regex: XCRegex { get }
    init?(groups: [String])
}

public extension CaptureGroup {
    var outputType: OutputType { Self.outputType }
}

public protocol ErrorCaptureGroup: CaptureGroup {
    var wholeError: String { get }
}

public protocol TargetCaptureGroup: CaptureGroup {
    var target: String { get }
    var project: String { get }
    var configuration: String { get }
}

public protocol CompileFileCaptureGroup: CaptureGroup {
    var filename: String { get }
    var target: String { get }
}

public protocol CopyCaptureGroup: CaptureGroup {
    var file: String { get }
    var target: String { get }
}

public protocol ExecutedCaptureGroup: CaptureGroup {
    var numberOfTests: Int { get }
    var numberOfSkipped: Int { get }
    var numberOfFailures: Int { get }
    var numberOfUnexpectedFailures: Int { get }
    var wallClockTimeInSeconds: Double { get }
}

public struct AnalyzeCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    public static let regex = XCRegex(pattern: #"^Analyze(?:Shallow)?\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let filePath: String
    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
    }
}

public struct BuildTargetCaptureGroup: TargetCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    public static let regex = XCRegex(pattern: #"^=== BUILD TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    public let target: String
    public let project: String
    public let configuration: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let target = groups[safe: 0], let project = groups[safe: 1], let configuration = groups[safe: 2] else { return nil }
        self.target = target
        self.project = project
        self.configuration = configuration
    }
}

public struct AggregateTargetCaptureGroup: TargetCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    public static let regex = XCRegex(pattern: #"^=== BUILD AGGREGATE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    public let target: String
    public let project: String
    public let configuration: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let target = groups[safe: 0], let project = groups[safe: 1], let configuration = groups[safe: 2] else { return nil }
        self.target = target
        self.project = project
        self.configuration = configuration
    }
}

public struct AnalyzeTargetCaptureGroup: TargetCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    public static let regex = XCRegex(pattern: #"^=== ANALYZE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    public let target: String
    public let project: String
    public let configuration: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let target = groups[safe: 0], let project = groups[safe: 1], let configuration = groups[safe: 2] else { return nil }
        self.target = target
        self.project = project
        self.configuration = configuration
    }
}

/// Nothing returned here for now
public struct CheckDependenciesCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Check dependencies"#)

    private init() { }

    public init?(groups: [String]) {
        assert(groups.count >= 0)
        self.init()
    }
}

public struct ShellCommandCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    // TODO: Improve this regex
    // `(?:t =)` avoids collisions with `UIFailingTestCaptureGroup`
    //
    /// Regular expression captured groups:
    /// $1 = command path
    /// $2 = arguments
    public static let regex = XCRegex(pattern: #"^\s{4}(?!(?:t =))(cd|setenv|(?:[\w\/:\-.]+?\/)?[\w\-]+(?<!clang))\s(.*)$"#)

    public let commandPath: String
    public let arguments: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let commandPath = groups[safe: 0], let arguments = groups[safe: 1] else { return nil }
        self.commandPath = commandPath
        self.arguments = arguments
    }
}

// FIXME: Refactor this type.
// Added to temporarily capture unwanted clang output.
// This type's regex conflicts with ShellCommandCaptureGroup and ProcessPchCommandCaptureGroup.
public struct NonPCHClangCommandCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^\s{0,4}(.*\/usr\/bin\/clang) (?:(?!(?:pch)).)*$"#)

    public let xcodePath: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let xcodePath = groups[safe: 0] else { return nil }
        self.xcodePath = xcodePath
    }
}

public struct CleanRemoveCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Nothing returned here for now
    public static let regex = XCRegex(pattern: #"^Clean.Remove(.*)"#)

    public let directory: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let directory = groups[safe: 0] else { return nil }
        self.directory = directory.lastPathComponent
    }
}

public struct CleanTargetCaptureGroup: TargetCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    public static let regex = XCRegex(pattern: #"^=== CLEAN TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH CONFIGURATION\s(.*)\s==="#)

    public let target: String
    public let project: String
    public let configuration: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let target = groups[safe: 0], let project = groups[safe: 1], let configuration = groups[safe: 2] else { return nil }
        self.target = target
        self.project = project
        self.configuration = configuration
    }
}

public struct CodesignCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    public static let regex = XCRegex(pattern: #"^CodeSign\s(((?!.framework/Versions/A)(?:\ |[^ ]))*?)( \(in target '.*' from project '.*' at path '.*'\))?$"#)

    public let file: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let file = groups[safe: 0] else { return nil }
        self.file = file
    }
}

public struct CodesignFrameworkCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    public static let regex = XCRegex(pattern: #"^CodeSign\s((?:\ |[^ ])*.framework)\/Versions/A"#)

    public let frameworkPath: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let frameworkPath = groups[safe: 0] else { return nil }
        self.frameworkPath = frameworkPath
    }
}

public struct CompileCaptureGroup: CompileFileCaptureGroup {
    public static let outputType: OutputType = .task

    #if os(Linux)
    /// Regular expression captured groups:
    /// $1 = filename (e.g. KWNull.m)
    /// $2 = target
    public static let regex = XCRegex(pattern: #"^\[\d+\/\d+\]\sCompiling\s([^ ]+)\s([^ \.]+\.(?:m|mm|c|cc|cpp|cxx|swift))"#)
    #else
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. KWNull.m)
    /// $3 = target
    public static let regex = XCRegex(pattern: #"^Compile[\w]+\s.+?\s((?:\.|[^ ])+\/((?:\.|[^ ])+\.(?:m|mm|c|cc|cpp|cxx|swift)))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)
    #endif

    #if !os(Linux)
    public let filePath: String
    #endif
    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        #if os(Linux)
        assert(groups.count >= 2)
        guard let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filename = filename
        self.target = target
        #else
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
        #endif
    }
}

public struct SwiftCompileCaptureGroup: CompileFileCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = target
    /// $3 = project
    public static let regex = XCRegex(pattern: #"^SwiftCompile \w+ \w+ ((?:\S|(?<=\\) )+) \(in target '(.*)' from project '(.*)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct SwiftCompilingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftCompile \w+ \w+ Compiling\\"#)

    public init?(groups: [String]) { }
}

public struct CompileAssetCatalogCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static var regex = XCRegex(pattern: #"^CompileAssetCatalog (.+) \(in target '(.*)' from project '(.*)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct CompileCommandCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = compiler command
    /// $2 = file path
    public static let regex = XCRegex(pattern: #"^\s*(.*clang\s.*\s\-c\s(.*\.(?:m|mm|c|cc|cpp|cxx))\s.*\.o)$"#)

    public let compilerCommand: String
    public let filePath: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let compilerCommand = groups[safe: 0], let filePath = groups[safe: 1] else { return nil }
        self.compilerCommand = compilerCommand
        self.filePath = filePath
    }
}

public struct CompileXCStringsCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^CompileXCStrings (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct CompileXibCaptureGroup: CompileFileCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. MainMenu.xib)
    /// $3 = target
    public static let regex = XCRegex(pattern: #"^CompileXIB\s(.*\/(.*\.xib))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let filePath: String
    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
    }
}

public struct CompileStoryboardCaptureGroup: CompileFileCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. Main.storyboard)
    /// $3 = target
    public static let regex = XCRegex(pattern: #"^CompileStoryboard\s(.*\/([^\/].*\.storyboard))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let filePath: String
    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
    }
}

public struct CopyFilesCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    // ((?:\S|(?<=\\) )+) --> Match any non-whitespace character OR any escaped space (space in filename)
    public static let regex = XCRegex(pattern: #"^Copy ((?:\S|(?<=\\) )+) ((?:\S|(?<=\\) )+) \(in target '(.*)' from project '.*'\)$"#)

    public let firstFilePath: String
    public let firstFilename: String
    public let secondFilePath: String
    public let secondFilename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let firstFilePath = groups[safe: 0], let secondFilePath = groups[safe: 1], let target = groups[safe: 2] else { return nil }
        self.firstFilePath = firstFilePath
        firstFilename = firstFilePath.lastPathComponent
        self.secondFilePath = secondFilePath
        secondFilename = secondFilePath.lastPathComponent
        self.target = target
    }
}

public struct CopyHeaderCaptureGroup: CopyCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = target
    public static let regex = XCRegex(pattern: #"^CpHeader\s(.*\.h)\s(.*\.h) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let targetFile: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let file = groups[safe: 0], let targetFile = groups[safe: 1], let target = groups.last else { return nil }
        self.file = file.lastPathComponent
        self.targetFile = targetFile
        self.target = target
    }
}

public struct CopyPlistCaptureGroup: CopyCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    public static let regex = XCRegex(pattern: #"^CopyPlistFile\s(.*\.plist)\s(.*\.plist) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let file = groups[safe: 0], let target = groups.last else { return nil }
        self.file = file.lastPathComponent
        self.target = target
    }
}

public struct CopyStringsCaptureGroup: CopyCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    public static let regex = XCRegex(pattern: #"^CopyStringsFile\s(.*\.strings)\s(.*\.strings) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let file = groups[safe: 0], let target = groups.last else { return nil }
        self.file = file.lastPathComponent
        self.target = target
    }
}

public struct CpresourceCaptureGroup: CopyCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = resource
    public static let regex = XCRegex(pattern: #"^CpResource\s(.*)\s\/(.*) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let file = groups[safe: 0], let target = groups.last else { return nil }
        self.file = file.lastPathComponent
        self.target = target
    }
}

public struct CreateBuildDirectoryCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: "^CreateBuildDirectory (.+)$")

    public let directory: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let directory = groups[safe: 0] else { return nil }
        self.directory = directory
    }
}

public struct CreateUniversalBinaryCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^CreateUniversalBinary (.+) normal (?:.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct DetectedEncodingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^(\/.+):(\d+):(\d+): note: detected encoding of input file as (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let filePath: String
    public let filename: String
    public let lineNumber: Int
    public let columnNumber: Int
    public let encoding: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 6)
        guard let filePath = groups[safe: 0], let _lineNumber = groups[safe: 1], let lineNumber = Int(_lineNumber), let _columnNumber = groups[safe: 2], let columnNumber = Int(_columnNumber), let encoding = groups[safe: 3], let target = groups[safe: 4], let project = groups[safe: 5] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.lineNumber = lineNumber
        self.columnNumber = columnNumber
        self.encoding = encoding
        self.target = target
        self.project = project
    }
}

public struct ExecutedWithoutSkippedCaptureGroup: ExecutedCaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of failures
    /// $3 = number of unexpected failures
    /// $4 = wall clock time in seconds (e.g. 0.295)
    public static let regex = XCRegex(pattern: #"^\s*(Executed\s(\d+)\stest[s]?,\swith\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds.*)$"#)

    public let wholeResult: String
    public let numberOfTests: Int
    public let numberOfSkipped = 0
    public let numberOfFailures: Int
    public let numberOfUnexpectedFailures: Int
    public let wallClockTimeInSeconds: Double

    public init?(groups: [String]) {
        assert(groups.count == 5)
        guard let wholeResult = groups[safe: 0], let _numberOfTests = groups[safe: 1], let _numberOfFailures = groups[safe: 2], let _numberOfUnexpectedFailures = groups[safe: 3], let _wallClockTimeInSeconds = groups[safe: 4] else { return nil }
        guard let numberOfTests = Int(_numberOfTests), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
        self.wholeResult = wholeResult
        self.numberOfTests = numberOfTests
        self.numberOfFailures = numberOfFailures
        self.numberOfUnexpectedFailures = numberOfUnexpectedFailures
        self.wallClockTimeInSeconds = wallClockTimeInSeconds
    }
}

public struct ExecutedWithSkippedCaptureGroup: ExecutedCaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of skipped
    /// $3 = number of failures
    /// $4 = number of unexpected failures
    /// $5 = wall clock time in seconds (e.g. 0.295)
    public static let regex = XCRegex(pattern: #"^\s*(Executed\s(\d+)\stest[s]?,\swith\s(\d+)\stest[s]?\sskipped\sand\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds.*)$"#)

    public let wholeResult: String
    public let numberOfTests: Int
    public let numberOfSkipped: Int
    public let numberOfFailures: Int
    public let numberOfUnexpectedFailures: Int
    public let wallClockTimeInSeconds: Double

    public init?(groups: [String]) {
        assert(groups.count == 6)
        guard let wholeResult = groups[safe: 0], let _numberOfTests = groups[safe: 1], let _numberOfSkipped = groups[safe: 2], let _numberOfFailures = groups[safe: 3], let _numberOfUnexpectedFailures = groups[safe: 4], let _wallClockTimeInSeconds = groups[safe: 5] else { return nil }
        guard let numberOfTests = Int(_numberOfTests), let numberOfSkipped = Int(_numberOfSkipped), let numberOfFailures = Int(_numberOfFailures), let numberOfUnexpectedFailures = Int(_numberOfUnexpectedFailures), let wallClockTimeInSeconds = Double(_wallClockTimeInSeconds) else { return nil }
        self.wholeResult = wholeResult
        self.numberOfTests = numberOfTests
        self.numberOfSkipped = numberOfSkipped
        self.numberOfFailures = numberOfFailures
        self.numberOfUnexpectedFailures = numberOfUnexpectedFailures
        self.wallClockTimeInSeconds = wallClockTimeInSeconds
    }
}

public struct ExplicitDependencyCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^[ \t]*➜ Explicit dependency on target '([^']+)' in project '([^']+)'$"#)

    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 2)
        guard let target = groups[safe: 0], let project = groups[safe: 1] else { return nil }
        self.target = target
        self.project = project
    }
}

public struct ExtractAppIntentsMetadataCaptureGroup: CaptureGroup {
    public static var outputType: OutputType = .task

    public static var regex = XCRegex(pattern: #"^ExtractAppIntentsMetadata \(in target '(.+)' from project '(.+)'\)$"#)

    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 2)
        guard let target = groups[safe: 0], let project = groups[safe: 1] else { return nil }
        self.target = target
        self.project = project
    }
}

public struct FailingTestCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = test suite
    /// $3 = test case
    /// $4 = reason
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^\s*(.+:\d+):\serror:\s(.*)\.(.*)\s:(?:\s'.*'\s\[failed\],)?\s(.*)"#)
    #else
    public static let regex = XCRegex(pattern: #"^\s*(.+:\d+):\serror:\s[\+\-]\[(.*?)\s(.*)\]\s:(?:\s'.*'\s\[FAILED\],)?\s(.*)"#)
    #endif

    public let file: String
    public let testSuite: String
    public let testCase: String
    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let file = groups[safe: 0], let testSuite = groups[safe: 1], let testCase = groups[safe: 2], let reason = groups[safe: 3] else { return nil }
        self.file = file
        self.testSuite = testSuite
        self.testCase = testCase
        self.reason = reason
    }
}

public struct UIFailingTestCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    // // TODO: Is this actually a regex for a UI failing test error?
    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = reason
    public static let regex = XCRegex(pattern: #"^\s{4}t = \s+\d+\.\d+s\s+Assertion Failure: (.*:\d+): (.*)$"#)

    public let file: String
    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let file = groups[safe: 0], let reason = groups[safe: 1] else { return nil }
        self.file = file
        self.reason = reason
    }
}

public struct RestartingTestCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = test suite + test case
    /// $3 = test suite
    /// $4 = test case
    public static let regex = XCRegex(pattern: #"^(Restarting after unexpected exit, crash, or test timeout in (-\[(\w+)\s(\w+)\]|(\w+)\.(\w+)\(\));.*)"#)

    public let wholeMessage: String
    public let testSuiteAndTestCase: String
    public let testSuite: String
    public let testCase: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let wholeMessage = groups[safe: 0], let testSuiteAndTestCase = groups[safe: 1], let testSuite = groups[safe: 2], let testCase = groups[safe: 3] else { return nil }
        self.wholeMessage = wholeMessage
        self.testSuiteAndTestCase = testSuiteAndTestCase
        self.testSuite = testSuite
        self.testCase = testCase
    }
}

public struct GenerateAssetSymbolsCaptureGroup: CaptureGroup {
    public static var outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^GenerateAssetSymbols (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct GenerateCoverageDataCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = coverage report file path
    public static let regex = XCRegex(pattern: #"^Generating\s+coverage\s+data\.*$"#)

    private init() { }

    public init?(groups: [String]) {
        assert(groups.count >= 0)
        self.init()
    }
}

public struct GeneratedCoverageReportCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Generated\s+coverage\s+report:\s+(.+)"#)

    public let coverageReportFilePath: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let coverageReportFilePath = groups[safe: 0] else { return nil }
        self.coverageReportFilePath = coverageReportFilePath
    }
}

public struct GenerateDSYMCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = dsym
    /// $2 = target
    public static let regex = XCRegex(pattern: #"^GenerateDSYMFile \/.*\/(.*\.dSYM) \/.* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let dsym: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let dsym = groups[safe: 0], let target = groups.last else { return nil }
        self.dsym = dsym
        self.target = target
    }
}

public struct LibtoolCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = library
    /// $2 = target
    public static let regex = XCRegex(pattern: #"^Libtool.*\/(.*) .* .* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let filename = groups[safe: 0], let target = groups.last else { return nil }
        self.filename = filename
        self.target = target
    }
}

public struct LinkingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    #if os(Linux)
    /// Regular expression captured groups:
    /// $1 = target
    public static let regex = XCRegex(pattern: #"^\[\d+\/\d+\]\sLinking\s([^ ]+)"#)
    #else
    /// Regular expression captured groups:
    /// $1 = binary filename
    /// $2 = target
    public static let regex = XCRegex(pattern: #"^Ld \/?.*\/(.*?) normal (?:.* )?\((?:in target: (.*)|in target '(.*)' from project '.*')\)"#)
    #endif

    #if !os(Linux)
    public let binaryFilename: String
    #endif
    public let target: String

    public init?(groups: [String]) {
        #if os(Linux)
        assert(groups.count == 1)
        guard let target = groups[safe: 0] else { return nil }
        self.target = target
        #else
        assert(groups.count == 2)
        guard let binaryFileName = groups[safe: 0], let target = groups.last else { return nil }
        binaryFilename = binaryFileName.lastPathComponent
        self.target = target
        #endif
    }
}

public struct TestCaseSkippedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^\s*Test Case\s'(.*)\.(.*)'\sskipped\s\((\d*\.\d{1,3})\sseconds\)"#)
    #else
    public static let regex = XCRegex(pattern: #"^\s*Test Case\s'-\[(.*?)\s(.*)\]'\sskipped\s\((\d*\.\d{3})\sseconds\)."#)
    #endif

    public let suite: String
    public let testCase: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let time = groups[safe: 2] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.time = time
    }
}

public struct TestCasePassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^\s*Test Case\s'(.*)\.(.*)'\spassed\s\((\d*\.\d{1,3})\sseconds\)"#)
    #else
    public static let regex = XCRegex(pattern: #"^\s*Test Case\s'-\[(.*?)\s(.*)\]'\spassed\s\((\d*\.\d{3})\sseconds\)."#)
    #endif

    public let suite: String
    public let testCase: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let time = groups[safe: 2] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.time = time
    }

}

public struct TestCaseStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^Test Case '(.*)\.(.*)' started at"#)
    #else
    public static let regex = XCRegex(pattern: #"^Test Case '-\[(.*?) (.*)\]' started.$"#)
    #endif

    public let suite: String
    public let testCase: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1] else { return nil }
        self.suite = suite
        self.testCase = testCase
    }
}

public struct TestCaseMeasuredCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^[^:]*:[^:]*:\sTest Case\s'(.*?)\.(.*)'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})"#)
    #else
    public static let regex = XCRegex(pattern: #"^[^:]*:[^:]*:\sTest Case\s'-\[(.*?)\s(.*)\]'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})"#)
    #endif

    public let suite: String
    public let testCase: String
    public let name: String
    public let unitName: String
    public let value: String
    public let deviation: String

    public init?(groups: [String]) {
        assert(groups.count >= 6)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let name = groups[safe: 2], let unitName = groups[safe: 3], let value = groups[safe: 4], let deviation = groups[safe: 5] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.name = name
        self.unitName = unitName
        self.value = value
        self.deviation = deviation
    }
}

public struct ParallelTestCaseSkippedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    public static let regex = XCRegex(pattern: #"^Test\s+case\s+'(.*)\.(.*)\(\)'\s+skipped\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)"#)

    public let suite: String
    public let testCase: String
    public let device: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let device = groups[safe: 2], let time = groups[safe: 3] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.device = device
        self.time = time
    }
}

public struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    public static let regex = XCRegex(pattern: #"^Test\s+case\s+'(.*)[\.\/](.*)\(\)'\s+passed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)"#)

    public let suite: String
    public let testCase: String
    public let device: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let device = groups[safe: 2], let time = groups[safe: 3] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.device = device
        self.time = time
    }
}

public struct ParallelTestCaseAppKitPassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    public static let regex = XCRegex(pattern: #"^\s*Test case\s'-\[(.*?)\s(.*)\]'\spassed\son\s'.*'\s\((\d*\.\d{3})\sseconds\)"#)

    public let suite: String
    public let testCase: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let time = groups[safe: 2] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.time = time
    }
}

public struct ParallelTestCaseFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    public static let regex = XCRegex(pattern: #"^Test\s+case\s+'(.*)[\./](.*)\(\)'\s+failed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)"#)

    public let suite: String
    public let testCase: String
    public let device: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let suite = groups[safe: 0], let testCase = groups[safe: 1], let device = groups[safe: 2], let time = groups[safe: 3] else { return nil }
        self.suite = suite
        self.testCase = testCase
        self.device = device
        self.time = time
    }
}

public struct ParallelTestingStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = device
    public static let regex = XCRegex(pattern: #"^(Testing\s+started\s+on\s+'(.*)'.*)$"#)

    public let wholeMessage: String
    public let device: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let wholeMessage = groups[safe: 0], let device = groups[safe: 1] else { return nil }
        self.wholeMessage = wholeMessage
        self.device = device
    }
}

public struct ParallelTestingPassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = device
    public static let regex = XCRegex(pattern: #"^(Testing\s+passed\s+on\s+'(.*)'.*)$"#)

    public let wholeMessage: String
    public let device: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let wholeMessage = groups[safe: 0], let device = groups[safe: 1] else { return nil }
        self.wholeMessage = wholeMessage
        self.device = device
    }
}

public struct ParallelTestingFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .nonContextualError

    /// Regular expression captured groups:
    /// $1 = whole error
    /// $2 = device
    public static let regex = XCRegex(pattern: #"^(Testing\s+failed\s+on\s+'(.*)'.*)$"#)

    public let wholeError: String
    public let device: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let wholeError = groups[safe: 0], let device = groups[safe: 1] else { return nil }
        self.wholeError = wholeError
        self.device = device
    }
}

public struct ParallelTestSuiteStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = device
    public static let regex = XCRegex(pattern: #"^\s*Test\s+suite\s+'(.*)'\s+started\s+on\s+'(.*)'"#)

    public let suite: String
    public let device: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let suite = groups[safe: 0], let device = groups[safe: 1] else { return nil }
        self.suite = suite
        self.device = device
    }
}

public struct PhaseSuccessCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result
    public static let regex = XCRegex(pattern: #"^\*\*\s(.*)\sSUCCEEDED\s\*\*"#)

    public let phase: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let phase = groups[safe: 0] else { return nil }
        self.phase = phase
    }
}

public struct PhaseScriptExecutionCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = phase name
    /// $2 = target
    public static let regex = XCRegex(pattern: #"^PhaseScriptExecution\s(.*)\s\/.*\.sh\s\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let phaseName: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let phaseName = groups[safe: 0], let target = groups.last else { return nil }
        self.phaseName = phaseName
        self.target = target
    }
}

public struct PrecompileModuleCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^PrecompileModule (.*\.scan)$"#)

    public let path: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let path = groups[safe: 0] else { return nil }
        self.path = path
    }
}

public struct ProcessPchCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = build target
    public static let regex = XCRegex(pattern: #"^ProcessPCH(?:\+\+)?\s.*\s\/.*\/(.*) normal .* .* .* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let buildTarget: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let file = groups[safe: 0], let buildTarget = groups.last else { return nil }
        self.file = file
        self.buildTarget = buildTarget
    }
}

public struct ProcessPchCommandCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 file path
    public static let regex = XCRegex(pattern: #"^\s*.*\/usr\/bin\/clang\s.*\s\-c\s(.*?)(?<!\\)\s.*\-o\s.*\.gch"#)

    public let filePath: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let filePath = groups.last else { return nil }
        self.filePath = filePath
    }
}

public struct PreprocessCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = file
    /// $3 = target
    /// $4 = project
    public static let regex = XCRegex(pattern: #"^Preprocess\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s.*\(in target '(.*)' from project '(.*)'\)"#)

    public let filePath: String
    public let file: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let filePath = groups[safe: 0], let file = groups[safe: 1], let target = groups[safe: 2], let project = groups[safe: 3] else { return nil }
        self.filePath = filePath
        self.file = file
        self.target = target
        self.project = project
    }
}

public struct PbxcpCaptureGroup: CopyCaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = build target
    public static let regex = XCRegex(pattern: #"^PBXCp\s(.*)\s\/(.*)\s\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    public let file: String
    public let targetFile: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let file = groups[safe: 0], let targetFile = groups[safe: 1], let target = groups.last else { return nil }
        self.file = file.lastPathComponent
        self.targetFile = targetFile
        self.target = target
    }
}

public struct ProcessInfoPlistCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $4 = target
    public static let regex = XCRegex(pattern: #"^ProcessInfoPlistFile\s.*\.plist\s(.*\/+(.*\.plist))( \((in target: (.*)|in target '(.*)' from project '.*')\))?"#)

    public let filePath: String
    public let filename: String
    public let target: String? // Xcode 10+

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1] else { return nil }

        // TODO: Test with target included
        if groups.count == 2 {
            // Xcode 9 excludes target output
            self.filePath = filePath
            self.filename = filename
            target = nil
        } else {
            // Xcode 10+ includes target output
            self.filePath = filePath
            self.filename = filename
            target = groups.last
        }
    }
}

public struct RegisterExecutionPolicyExceptionCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^RegisterExecutionPolicyException (.+\/(.+\..+)) \(in target '(.+)' from project '(.+)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 4)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups[safe: 2], let project = groups[safe: 3] else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
        self.project = project
    }
}

public struct ScanDependenciesCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^ScanDependencies .* normal (arm64|arm64_32|armv7k|i386|x86_64) .* \(in target '(.*)' from project '(.*)'\)$"#)

    public let arch: Architecture
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let _arch = groups[safe: 0], let arch = Architecture(rawValue: _arch), let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.arch = arch
        self.target = target
        self.project = project
    }
}

public struct SymLinkCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SymLink (.+) \(in target '(.*)' from project '(.*)'\)$"#)

    public let filePath: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        self.target = target
        self.project = project
    }
}

public struct TestsRunCompletionCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = result
    /// $3 = time
    #if os(Linux)
    public static let regex = XCRegex(pattern: #"^\s*(Test Suite '(.*)' (finished|passed|failed) at (.*).*)"#)
    #else
    public static let regex = XCRegex(pattern: #"^\s*(Test Suite '(?:.*\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*).*)"#)
    #endif

    public let wholeResult: String
    public let suite: String
    public let result: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count >= 4)
        guard let wholeResult = groups[safe: 0], let suite = groups[safe: 1], let result = groups[safe: 2], let time = groups[safe: 3] else { return nil }
        self.wholeResult = wholeResult
        self.suite = suite
        self.result = result
        self.time = time
    }
}

public struct TestSuiteStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite name
    /// $2 = time
    public static let regex = XCRegex(pattern: #"^\s*Test Suite '(.*)' started at (.*)$"#)

    public let suiteName: String
    public let time: String

    public init?(groups: [String]) {
        assert(groups.count == 2)
        guard let suiteName = groups[safe: 0], let time = groups[safe: 1] else { return nil }
        self.suiteName = suiteName
        self.time = time
    }
}

public struct TestSuiteAllTestsPassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result
    public static let regex = XCRegex(pattern: #"^\s*(Test Suite 'All tests' passed at.*)"#)

    public let wholeResult: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let wholeResult = groups[safe: 0] else { return nil }
        self.wholeResult = wholeResult
    }
}

public struct TestSuiteAllTestsFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result
    public static let regex = XCRegex(pattern: #"^\s*(Test Suite 'All tests' failed at.*)"#)

    public let wholeResult: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let wholeResult = groups[safe: 0] else { return nil }
        self.wholeResult = wholeResult
    }
}

public struct TIFFutilCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = filename
    public static let regex = XCRegex(pattern: #"^TiffUtil\s(.*)"#)

    public let filename: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let filename = groups[safe: 0] else { return nil }
        self.filename = filename
    }
}

public struct TouchCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = filename
    /// $3 = target
    public static let regex = XCRegex(pattern: #"^Touch\s(.*\/(.+))( \((in target: (.*)|in target '(.*)' from project '.*')\))"#)

    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filename = groups[safe: 1], let target = groups.last else { return nil }
        self.filename = filename
        self.target = target
    }
}

public struct ValidateCaptureGroup: CaptureGroup {
    public static var outputType: OutputType = .task

    public static var regex = XCRegex(pattern: #"^Validate (.+) \(in target '(.*)' from project '(.*)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct ValidateEmbeddedBinaryCaptureGroup: CaptureGroup {
    public static var outputType: OutputType = .task

    public static var regex = XCRegex(pattern: #"^ValidateEmbeddedBinary (.+) \(in target '(.*)' from project '(.*)'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let filePath = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.filePath = filePath
        filename = filePath.lastPathComponent
        self.target = target
        self.project = project
    }
}

public struct WriteFileCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    public static let regex = XCRegex(pattern: #"^write-file\s(.*)"#)

    public let filePath: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let filePath = groups[safe: 0] else { return nil }
        self.filePath = filePath
    }
}

public struct WriteAuxiliaryFileCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^WriteAuxiliaryFile (.*\/(.*\..*)) \(in target '(.*)' from project '.*'\)$"#)

    public let filePath: String
    public let filename: String
    public let target: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let target = groups[safe: 2] else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.target = target
    }
}

public struct CompileWarningCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $3 = reason
    public static let regex = XCRegex(pattern: #"^(?!(?:ld))(([^:]*):*\d*:*\d*):\swarning:\s(.*)$"#)

    public let filePath: String
    public let filename: String
    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let filename = groups[safe: 1], let reason = groups[safe: 2] else { return nil }
        self.filePath = filePath
        self.filename = filename
        self.reason = reason
    }
}

public struct LDWarningCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = warning message
    public static let regex = XCRegex(pattern: #"^ld: warning: (.*)"#)

    public let ldPrefix = "ld: "
    public let warningMessage: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let warningMessage = groups[safe: 0] else { return nil }
        self.warningMessage = warningMessage
    }
}

public struct GenericWarningCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole warning
    public static let regex = XCRegex(pattern: #"^warning:\s(.*)$"#)

    public let wholeWarning: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeWarning = groups[safe: 0] else { return nil }
        self.wholeWarning = wholeWarning
    }
}

public struct WillNotBeCodeSignedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole warning
    public static let regex = XCRegex(pattern: #"^(.* will not be code signed because .*)$"#)

    public let wholeWarning: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeWarning = groups[safe: 0] else { return nil }
        self.wholeWarning = wholeWarning
    }
}

public struct DuplicateLocalizedStringKeyCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expresion captured groups:
    /// $1 = warning message.
    public static let regex = XCRegex(pattern: #"^[\d\s-:]+ --- WARNING: (Key ".*" used with multiple values. Value ".*" kept. Value ".*" ignored.)$"#)

    public let warningMessage: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeMessage = groups[safe: 0] else { return nil }
        warningMessage = wholeMessage
    }
}

public struct ClangErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(clang: error:.*)$"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct CheckDependenciesErrorsCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(Code\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups.first else { return nil }
        self.wholeError = wholeError
    }
}

public struct ProvisioningProfileRequiredCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(.*requires a provisioning profile.*)$"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct NoCertificateCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(No certificate matching.*)$"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct CompileErrorCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    // TODO: Improve this group's matching
    // `(?:no such file or directory)` avoids collisions with `FileMissingErrorCaptureGroup`
    //
    // Includes `(?!\-)` to prevent capturing XCTest failure messages.
    // Example: /Users/.../Tests.swift:13: error: -[Tests.Tests someTest] : XCTAssertEqual failed: ("Optional("...")") is not equal to ("Optional("....")")
    //
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = is fatal error
    /// $3 = reason
    public static let regex = XCRegex(pattern: #"^(?!(?:xcodebuild))(([^:]*):*\d*:*\d*):\s(?:fatal\s)?error:\s(?!(?:\-)|(?:no such file or directory))(.*)$"#)

    public let filePath: String
    public let isFatalError: String
    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let filePath = groups[safe: 0], let isFatalError = groups[safe: 1], let reason = groups[safe: 2] else { return nil }
        self.filePath = filePath
        self.isFatalError = isFatalError
        self.reason = reason
    }
}

public struct CursorCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = cursor (with whitespaces and tildes)
    public static let regex = XCRegex(pattern: #"^([\s~]*\^[\s~]*)$"#)

    public let cursor: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let cursor = groups[safe: 0] else { return nil }
        self.cursor = cursor
    }
}

public struct FatalErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error.
    /// it varies a lot, not sure if it makes sense to catch everything separately
    public static let regex = XCRegex(pattern: #"^(fatal error:.*)$"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct FileMissingErrorCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file path
    public static let regex = XCRegex(pattern: #"^<unknown>:0: error: no such file or directory: '(.+)'$"#)

    public let reason = "error: no such file or directory"
    public let filePath: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let filePath = groups[safe: 0] else { return nil }
        self.filePath = filePath
    }
}

public struct LDErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(ld: (?!(?:warning)).*)"#)

    // TODO: Capture error itself instead of entire line.
    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct LinkerDuplicateSymbolsCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    public static let regex = XCRegex(pattern: #"^(duplicate symbol .*):$"#)

    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let reason = groups[safe: 0] else { return nil }
        self.reason = reason
    }
}

public struct LinkerUndefinedSymbolLocationCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = symbol location
    public static let regex = XCRegex(pattern: #"^(.* in .*\.o)$"#)

    public let symbolLocation: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let symbolLocation = groups[safe: 0] else { return nil }
        self.symbolLocation = symbolLocation
    }
}

public struct LinkerUndefinedSymbolsCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    public static let regex = XCRegex(pattern: #"^(Undefined symbols for architecture .*):$"#)

    public let reason: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let reason = groups[safe: 0] else { return nil }
        self.reason = reason
    }
}

public struct PodsErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    public static let regex = XCRegex(pattern: #"^(error:\s.*)"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = wholeError
    /// $2 = reference
    public static let regex = XCRegex(pattern: #"^(\s+\"(.*)\", referenced from:)$"#)

    public let wholeError: String
    public let reference: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let wholeError = groups[safe: 0], let reference = groups[safe: 1] else { return nil }
        self.wholeError = wholeError
        self.reference = reference
    }
}

public struct ModuleIncludesErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = error reason
    public static let regex = XCRegex(pattern: #"^\<module-includes\>:.*?:.*?:\s(?:fatal\s)?(error:\s.*)$/"#)

    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning
    /// Regular expression captured groups:
    /// $1 = whole warning
    /// $2 = target
    /// $3 = filename
    public static let regex = XCRegex(pattern: #"^(.+ in (.+)\((.+)\.o\))$"#)

    public let wholeWarning: String
    public let target: String
    public let filename: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let wholeWarning = groups[safe: 0], let target = groups[safe: 1], let filename = groups[safe: 2] else { return nil }
        self.wholeWarning = wholeWarning
        self.target = target
        self.filename = filename
    }
}

public struct PackageFetchingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Fetching from (.*?)$"#)

    public let source: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let source = groups[safe: 0] else { return nil }
        self.source = source
    }
}

public struct PackageUpdatingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Updating from (.*?)$"#)

    public let source: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let source = groups[safe: 0] else { return nil }
        self.source = source
    }
}

public struct PackageCheckingOutCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Checking out (.*?) of package (.*?)$"#)

    public let version: String
    public let package: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let version = groups[safe: 0], let package = groups[safe: 1] else { return nil }
        self.version = version
        self.package = package
    }
}

public struct PackageGraphResolvingStartCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^\s*Resolve Package Graph\s*$"#)

    private init() { }

    public init?(groups: [String]) {
        assert(groups.count >= 0)
        self.init()
    }
}

public struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task
    public static let regex = XCRegex(pattern: #"^Resolved source packages:$"#)

    private init() { }

    public init?(groups: [String]) {
        assert(groups.count >= 0)
        self.init()
    }
}

public struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captures groups:
    /// $1 = package name
    /// $2 = package url
    /// $3 = package version
    public static let regex = XCRegex(pattern: #"^\s*([^\s:]+):\s([^ ]+)\s@\s(\d+\.\d+\.\d+)"#)

    public let packageName: String
    public let packageURL: String
    public let packageVersion: String

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let packageName = groups[safe: 0], let packageURL = groups[safe: 1], let packageVersion = groups[safe: 2] else { return nil }
        self.packageName = packageName
        self.packageURL = packageURL
        self.packageVersion = packageVersion
    }
}

public struct XcodebuildErrorCaptureGroup: ErrorCaptureGroup {
    public static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    public static let regex = XCRegex(pattern: #"^(xcodebuild: error:.*)$"#)

    // TODO: Capture error itself instead of entire line.
    public let wholeError: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeError = groups[safe: 0] else { return nil }
        self.wholeError = wholeError
    }
}

public struct CompilationResultCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^\/\* com.apple.actool.compilation-results \*\/$"#)

    public init?(groups: [String]) { }
}

public struct SwiftDriverJobDiscoveryEmittingModuleCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftDriverJobDiscovery \w+ \w+ Emitting module for .* \(in target '.*' from project '.*'\)"#)

    public init?(groups: [String]) { }
}

/// This output is printed when running
/// `xcodebuild test -scheme xcbeautify-Package -destination 'platform=macOS,arch=arm64'`.
public struct TestingStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    public static let regex = XCRegex(pattern: "^(Testing started.*)$")

    public let wholeMessage: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let wholeMessage = groups[safe: 0] else { return nil }
        self.wholeMessage = wholeMessage
    }
}

public struct SigningCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^Signing (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let file: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let file = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.file = file
        self.target = target
        self.project = project
    }
}

public struct SwiftDriverJobDiscoveryCompilingCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    // Examples:
    //  - SwiftDriverJobDiscovery normal arm64 Compiling BackyardBirdsPassOfferCard.swift (in target 'BackyardBirdsUI' from project 'BackyardBirdsUI')
    //  - SwiftDriverJobDiscovery normal arm64 Compiling BackyardSkyView.swift, BackyardSupplyGauge.swift (in target 'BackyardBirdsUI' from project 'BackyardBirdsUI')
    //  - SwiftDriverJobDiscovery normal x86_64 Compiling resource_bundle_accessor.swift, Account+DataGeneration.swift, Backyard.swift (in target 'SomeTarget' from project 'SomeProject')
    //
    // Regular expression captured groups:
    // $1 = state
    // $2 = architecture
    // $3 = filenames
    // $4 = target
    // $5 = project
    public static let regex = XCRegex(pattern: #"^SwiftDriverJobDiscovery (\S+) (arm64|arm64_32|armv7k|i386|x86_64) Compiling ((?:\S|(?>, )|(?<=\\) )+) \(in target '(.*)' from project '(.*)'\)"#)

    public let state: String // Currently, the only expected/known value is `normal`
    public let architecture: Architecture
    public let filenames: [String]
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 5)
        guard let state = groups[safe: 0], let _architecture = groups[safe: 1], let architecture = Architecture(rawValue: _architecture), let filenamesGroup = groups[safe: 2], let target = groups[safe: 3], let project = groups[safe: 4] else { return nil }
        self.state = state
        self.architecture = architecture
        filenames = filenamesGroup.components(separatedBy: ", ")
        self.target = target
        self.project = project
    }
}

public struct SwiftMergeGeneratedHeadersCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftMergeGeneratedHeaders (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    // TODO: Split this into String array after requiring macOS 13+
    // Requires: https://github.com/cpisciotta/xcbeautify/issues/358
    public let headerFilePaths: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let headerFilePaths = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        // TODO: Split headerFilePaths by non-escaped whitespace
        // Requires: https://github.com/cpisciotta/xcbeautify/issues/358
        // assert(headerFilePaths.allSatisfy { $0.hasSuffix(".h") })
        self.headerFilePaths = headerFilePaths
        self.target = target
        self.project = project
    }
}

public struct SwiftTestingRunStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression to capture the start of a test run.
    /// $1 = message
    public static let regex = XCRegex(pattern: #"^[^ ] +(Test run started\.)$"#)

    public let message: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let message = groups[safe: 0] else { return nil }
        self.message = message
    }
}

public struct SwiftTestingRunCompletionCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression to capture the number of tests and total time.
    /// $1 = number of tests
    /// $2 = total time in seconds
    public static let regex = XCRegex(pattern: #"^[^ ] +Test run with (\d+) test(?:s)? passed after ([\d.]+) seconds\.$"#)

    public let numberOfTests: Int
    public let totalTime: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let numberOfTests = groups[safe: 0].flatMap(Int.init),
              let totalTime = groups[safe: 1] else { return nil }
        self.numberOfTests = numberOfTests
        self.totalTime = totalTime
    }
}

public struct SwiftTestingRunFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression to capture the number of tests, total time, and the number of issues.
    /// $1 = number of tests
    /// $2 = total time in seconds
    /// $3 = number of issues
    public static let regex = XCRegex(pattern: #"^[^ ] +Test run with (\d+) test(?:s)? failed after ([\d.]+) seconds with (\d+) issue[s]?\.$"#)

    public let numberOfTests: Int
    public let totalTime: String
    public let numberOfIssues: Int

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let numberOfTests = groups[safe: 0].flatMap(Int.init),
            let totalTime = groups[safe: 1],
            let numberOfIssues = groups[safe: 2].flatMap(Int.init) else { return nil }
        self.numberOfTests = numberOfTests
        self.totalTime = totalTime
        self.numberOfIssues = numberOfIssues
    }
}

public struct SwiftTestingSuiteStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .test

    /// Regular expression to capture the start of a test suite.
    /// $1 = suite name
    public static let regex = XCRegex(pattern: #"^[^ ] +Suite (.*) started\.$"#)

    public let suiteName: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let suiteName = groups[safe: 0] else { return nil }
        self.suiteName = suiteName
    }
}

public struct SwiftTestingTestStartedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the start of a test case.
    /// $1 = test name
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (?!run )(.*) started\.$"#)

    public let testName: String
    public let wholeMessage: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let testName = groups[safe: 0] else { return nil }
        self.testName = testName
        wholeMessage = "Test \(testName) started."
    }
}

public struct SwiftTestingSuitePassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .warning

    /// Regular expression to capture the successful completion of a test suite.
    /// $1 = suite name
    /// $2 = total time taken in seconds
    public static let regex = XCRegex(pattern: #"^[^ ] +Suite (.*) passed after ([\d.]+) seconds\.$"#)

    public let suiteName: String
    public let timeTaken: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let suiteName = groups[safe: 0],
              let timeTaken = groups[safe: 1] else { return nil }
        self.suiteName = suiteName
        self.timeTaken = timeTaken
    }
}

public struct SwiftTestingSuiteFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .result

    /// Regular expression to capture the failure of a test suite.
    /// $1 = suite name
    /// $2 = total time taken in seconds
    /// $3 = number of issues
    public static let regex = XCRegex(pattern: #"^[^ ] +Suite (.*) failed after ([\d.]+) seconds with (\d+) issue[s]?\.$"#)

    public let suiteName: String
    public let timeTaken: String
    public let numberOfIssues: Int

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let suiteName = groups[safe: 0],
              let timeTaken = groups[safe: 1],
              let numberOfIssues = groups[safe: 2].flatMap(Int.init) else { return nil }
        self.suiteName = suiteName
        self.timeTaken = timeTaken
        self.numberOfIssues = numberOfIssues
    }
}

public struct SwiftTestingTestFailedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the failure of a test case.
    /// $1 = test name
    /// $2 = time taken in seconds
    /// $3 = number of issues
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (?!run\s)(.*) failed after ([\d.]+) seconds with (\d+) issue[s]?\.$"#)

    public let testName: String
    public let timeTaken: String
    public let numberOfIssues: Int

    public init?(groups: [String]) {
        assert(groups.count >= 3)
        guard let testName = groups[safe: 0],
              let timeTaken = groups[safe: 1],
              let numberOfIssues = groups[safe: 2].flatMap(Int.init) else { return nil }
        self.testName = testName
        self.timeTaken = timeTaken
        self.numberOfIssues = numberOfIssues
    }
}

public struct SwiftTestingTestPassedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the successful completion of a test case.
    /// $1 = test name
    /// $2 = time taken in seconds
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (?!run\s)(.*) passed after ([\d.]+) seconds\.$"#)

    public let testName: String
    public let timeTaken: String

    public init?(groups: [String]) {
        assert(groups.count >= 2)
        guard let testName = groups[safe: 0],
              let timeTaken = groups[safe: 1] else { return nil }
        self.testName = testName
        self.timeTaken = timeTaken
    }
}

public struct SwiftTestingTestSkippedCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture a skipped test case.
    /// $1 = test name
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (.*) skipped\.$"#)

    public let testName: String

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let testName = groups[safe: 0] else { return nil }
        self.testName = testName
    }
}

public struct SwiftTestingTestSkippedReasonCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture a skipped test case with a reason.
    /// $1 = test name
    /// $2 = optional reason
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (.*) skipped(?:\s*:\s*"(.*)")?$"#)

    public let testName: String
    public let reason: String?

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let testName = groups[safe: 0] else { return nil }
        self.testName = testName
        reason = groups[safe: 1]
    }
}

public struct SwiftTestingIssueCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol, test description, and issue details.
    /// $1 = test description
    /// $2 = issue details
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (.*?) recorded an issue at (.*)$"#)

    public let testDescription: String
    public let issueDetails: String?

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let testDescription = groups[safe: 0] else { return nil }

        self.testDescription = testDescription
        issueDetails = groups[safe: 1]
    }
}

public struct SwiftTestingIssueArgumentCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol, test description, and optional number of arguments.
    /// $1 = test description
    /// $2 = number of arguments (optional)
    public static let regex = XCRegex(pattern: #"^[^ ] +Test (.*?) recorded an issue with (\d+) arguments?"#)

    public let testDescription: String
    public let numberOfArguments: Int?

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let testDescription = groups[safe: 0] else { return nil }

        self.testDescription = testDescription
        numberOfArguments = groups[safe: 1].flatMap(Int.init)
    }
}

public struct SwiftTestingPassingArgumentCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol and number of arguments.
    /// $1 = number of arguments
    public static let regex = XCRegex(pattern: #"^[^ ] +Passing (\d+) argument[s]?.*$"#)

    public let numberOfArguments: Int

    public init?(groups: [String]) {
        assert(groups.count >= 1)
        guard let numberOfArguments = groups[safe: 0].flatMap(Int.init) else { return nil }

        self.numberOfArguments = numberOfArguments
    }
}

public struct SwiftDriverTargetCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftDriver (.*) normal (?:arm64|arm64_32|armv7k|i386|x86_64) com\.apple\.xcode\.tools\.swift\.compiler"#)

    public let target: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let target = groups[safe: 0] else { return nil }
        self.target = target
    }
}

public struct SwiftDriverCompilationTarget: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftDriver\\ Compilation (.*) normal (?:arm64|arm64_32|armv7k|i386|x86_64) com\.apple\.xcode\.tools\.swift\.compiler"#)

    public let target: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let target = groups[safe: 0] else { return nil }
        self.target = target
    }
}

public struct SwiftDriverCompilationRequirementsCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftDriver\\ Compilation\\ Requirements (.*) normal (?:arm64|arm64_32|armv7k|i386|x86_64) com\.apple\.xcode\.tools\.swift\.compiler"#)

    public let target: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let target = groups[safe: 0] else { return nil }
        self.target = target
    }
}

public struct MkDirCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: "^MkDir.*")

    public init?(groups: [String]) { }
}

public struct SwiftEmitModuleCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^SwiftEmitModule normal (arm64|arm64_32|armv7k|i386|x86_64) Emitting\\ module\\ for\\ (.+) \(in target '(.+)' from project '(.+)'\)$"#)

    public let arch: Architecture
    public let module: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 4)
        guard let _arch = groups[safe: 0], let arch = Architecture(rawValue: _arch), let module = groups[safe: 1], let target = groups[safe: 2], let project = groups[safe: 3] else { return nil }
        self.arch = arch
        self.module = module
        self.target = target
        self.project = project
    }
}

public struct EmitSwiftModuleCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    public static let regex = XCRegex(pattern: #"^EmitSwiftModule normal (arm64|arm64_32|armv7k|i386|x86_64) \(in target '(.+)' from project '(.+)'\)$"#)

    public let arch: Architecture
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let _arch = groups[safe: 0], let arch = Architecture(rawValue: _arch), let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.arch = arch
        self.target = target
        self.project = project
    }
}

/// This output is printed when running
/// `xcodebuild test -scheme xcbeautify-Package -destination 'platform=macOS,arch=arm64'`.
public struct NoteCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = note
    public static let regex = XCRegex(pattern: "^note: (.*)$")

    public let note: String

    public init?(groups: [String]) {
        assert(groups.count == 1)
        guard let note = groups[safe: 0] else { return nil }
        self.note = note
    }
}

public struct DataModelCodegenCaptureGroup: CaptureGroup {
    public static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = path
    /// $2 = target
    /// $3 = project
    public static let regex = XCRegex(pattern: #"^DataModelCodegen (.*\.xcdatamodeld) \(in target '(.*)' from project '(.*)'\)$"#)

    public let path: String
    public let target: String
    public let project: String

    public init?(groups: [String]) {
        assert(groups.count == 3)
        guard let path = groups[safe: 0], let target = groups[safe: 1], let project = groups[safe: 2] else { return nil }
        self.path = path
        self.target = target
        self.project = project
    }
}
