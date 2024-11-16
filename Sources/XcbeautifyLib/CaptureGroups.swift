import Foundation

package protocol CaptureGroup {
    static var outputType: OutputType { get }
    associatedtype RegexOutput
    static var regex: Regex<RegexOutput> { get }
    init(match: Regex<RegexOutput>.Match)
}

package extension CaptureGroup {
    var outputType: OutputType { Self.outputType }

    static func match(against line: String) -> Self? {
        guard let match = line.prefixMatch(of: regex) else { return nil }
        return Self.init(match: match)
    }
}

protocol ErrorCaptureGroup: CaptureGroup {
    var wholeError: String { get }
}

protocol TargetCaptureGroup: CaptureGroup {
    var target: String { get }
    var project: String { get }
    var configuration: String { get }
}

protocol CompileFileCaptureGroup: CaptureGroup {
    var filename: String { get }
    var target: String { get }
}

protocol CopyCaptureGroup: CaptureGroup {
    var file: String { get }
    var target: String { get }
}

protocol ExecutedCaptureGroup: CaptureGroup {
    var numberOfTests: Int { get }
    var numberOfSkipped: Int { get }
    var numberOfFailures: Int { get }
    var numberOfUnexpectedFailures: Int { get }
    var wallClockTimeInSeconds: Double { get }
}

struct AnalyzeCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    static let regex = /^Analyze(?:Shallow)?\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s.*\((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let filePath: String
    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct BuildTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = /^=== BUILD TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s===/

    let target: String
    let project: String
    let configuration: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
        self.project = String(match.output.2)
        self.configuration = String(match.output.3)
    }
}

struct AggregateTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = /^=== BUILD AGGREGATE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s===/

    let target: String
    let project: String
    let configuration: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
        self.project = String(match.output.2)
        self.configuration = String(match.output.3)
    }
}

struct AnalyzeTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = /^=== ANALYZE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s===/

    let target: String
    let project: String
    let configuration: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
        self.project = String(match.output.2)
        self.configuration = String(match.output.3)
    }
}

/// Nothing returned here for now
struct CheckDependenciesCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^Check Dependencies/

    init(match: Regex<RegexOutput>.Match) { }
}

struct ShellCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = command path
    /// $2 = arguments
    static let regex = /^\s{4}(cd|setenv|(?:[\w\/:\s\-.]+?\/)?[\w\-]+)\s(.*)$/

    let commandPath: String
    let arguments: String

    init(match: Regex<RegexOutput>.Match) {
        self.commandPath = String(match.output.1)
        self.arguments = String(match.output.2)
    }
}

struct CleanRemoveCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Nothing returned here for now
    static let regex = /^Clean.Remove(.*)/

    let directory: String

    init(match: Regex<RegexOutput>.Match) {
        self.directory = String(match.output.1).lastPathComponent
    }
}

struct CleanTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = /^=== CLEAN TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH CONFIGURATION\s(.*)\s===/

    let target: String
    let project: String
    let configuration: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
        self.project = String(match.output.2)
        self.configuration = String(match.output.3)
    }
}

struct CodesignCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    static let regex = /^CodeSign\s(((?!.framework\/Versions\/A)(?:\ |[^ ]))*?)( \(in target '.*' from project '.*' at path '.*'\))?$/

    let file: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1)
    }
}

struct CodesignFrameworkCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    static let regex = /^CodeSign\s((?:\ |[^ ])*.framework)\/Versions\/A/

    let frameworkPath: String

    init(match: Regex<RegexOutput>.Match) {
        self.frameworkPath = String(match.output.1)
    }
}

struct CompileCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    #if os(Linux)
    /// Regular expression captured groups:
    /// $1 = filename (e.g. KWNull.m)
    /// $2 = target
    static let regex = /^\[\d+\/\d+\]\sCompiling\s([^ ]+)\s([^ \.]+\.(?:m|mm|c|cc|cpp|cxx|swift))/
    #else
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. KWNull.m)
    /// $3 = target
    static let regex = /^Compile[\w]+\s.+?\s((?:\.|[^ ])+\/((?:\.|[^ ])+\.(?:m|mm|c|cc|cpp|cxx|swift)))\s.*\((?:in target: (.*)|in target '(.*)' from project '.*')\)/
    #endif

    #if !os(Linux)
    let filePath: String
    #endif
    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        #if os(Linux)
        self.filename = String(match.output.1)
        #warning("FIXME")
        self.target = ""
        #else
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        #warning("FIXME")
        self.target = ""
        #endif
    }
}

struct SwiftCompileCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = target
    /// $3 = project
    static let regex = /^SwiftCompile \w+ \w+ ((?!Compiling\\ ).*) \(in target '(.*)' from project '(.*)'\)$/

    let filePath: String
    let filename: String
    let target: String
    let project: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        filename = String(match.output.1).lastPathComponent
        self.target = String(match.output.2)
        self.project = String(match.output.3)
    }
}

struct SwiftCompilingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^SwiftCompile \w+ \w+ Compiling\\/

    init(match: Regex<RegexOutput>.Match) { }
}

struct CompileCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = compiler command
    /// $2 = file path
    static let regex = /^\s*(.*clang\s.*\s\-c\s(.*\.(?:m|mm|c|cc|cpp|cxx))\s.*\.o)$/

    let compilerCommand: String
    let filePath: String

    init(match: Regex<RegexOutput>.Match) {
        self.compilerCommand = String(match.output.1)
        self.filePath = String(match.output.2)
    }
}

struct CompileXibCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. MainMenu.xib)
    /// $3 = target
    static let regex = /^CompileXIB\s(.*\/(.*\.xib))\s.*\((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let filePath: String
    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct CompileStoryboardCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. Main.storyboard)
    /// $3 = target
    static let regex = /^CompileStoryboard\s(.*\/([^\/].*\.storyboard))\s.*\((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let filePath: String
    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct CopyFilesCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    // ((?:\S|(?:\\ ))+) --> Match any non-whitespace character OR any escaped space (space in filename)
    static let regex = /^Copy ((?:\S|(?:\\ ))+) ((?:\S|(?:\\ ))+) \(in target '(.*)' from project '.*'\)$/

    let firstFilePath: String
    let firstFilename: String
    let secondFilePath: String
    let secondFilename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.firstFilePath = String(match.output.1)
        firstFilename = String(match.output.1).lastPathComponent
        self.secondFilePath = String(match.output.2)
        secondFilename = String(match.output.2).lastPathComponent
        self.target = String(match.output.3)
    }
}

struct CopyHeaderCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = target
    static let regex = /^CpHeader\s(.*\.h)\s(.*\.h) \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let targetFile: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1).lastPathComponent
        self.targetFile = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct CopyPlistCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    static let regex = /^CopyPlistFile\s(.*\.plist)\s(.*\.plist) \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1).lastPathComponent
        #warning("FIXME")
            self.target = ""
    }
}

struct CopyStringsCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    static let regex = /^CopyStringsFile\s(.*\.strings)\s(.*\.strings) \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1).lastPathComponent
        #warning("FIXME")
        self.target = ""
    }
}

struct CpresourceCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = resource
    static let regex = /^CpResource\s(.*)\s\/(.*) \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1).lastPathComponent
        #warning("FIXME")
        self.target = ""
    }
}

struct ExecutedWithoutSkippedCaptureGroup: ExecutedCaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of failures
    /// $3 = number of unexpected failures
    /// $4 = wall clock time in seconds (e.g. 0.295)
    static let regex = /^\s*(Executed\s(\d+)\stest[s]?,\swith\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds.*)$/

    let wholeResult: String
    let numberOfTests: Int
    let numberOfSkipped = 0
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double

    init(match: Regex<RegexOutput>.Match) {
        self.wholeResult = String(match.output.1)
        self.numberOfTests = Int(match.output.2)!
        self.numberOfFailures = Int(match.output.3)!
        self.numberOfUnexpectedFailures = Int(match.output.4)!
        self.wallClockTimeInSeconds = Double(match.output.5)!
    }
}

struct ExecutedWithSkippedCaptureGroup: ExecutedCaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of skipped
    /// $3 = number of failures
    /// $4 = number of unexpected failures
    /// $5 = wall clock time in seconds (e.g. 0.295)
    static let regex = /^\s*(Executed\s(\d+)\stest[s]?,\swith\s(\d+)\stest[s]?\sskipped\sand\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds.*)$/

    let wholeResult: String
    let numberOfTests: Int
    let numberOfSkipped: Int
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double

    init(match: Regex<RegexOutput>.Match) {
        self.wholeResult = String(match.output.1)
        self.numberOfTests = Int(match.output.2)!
        self.numberOfSkipped = Int(match.output.3)!
        self.numberOfFailures = Int(match.output.4)!
        self.numberOfUnexpectedFailures = Int(match.output.5)!
        self.wallClockTimeInSeconds = Double(match.output.6)!
    }
}

struct ExplicitDependencyCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^[ \t]*➜ Explicit dependency on target '([^']+)' in project '([^']+)'$/

    let target: String
    let project: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
        self.project = String(match.output.2)
    }
}

struct FailingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = test suite
    /// $3 = test case
    /// $4 = reason
    #if os(Linux)
    static let regex = /^\s*(.+:\d+):\serror:\s(.*)\.(.*)\s:(?:\s'.*'\s\[failed\],)?\s(.*)/
    #else
    static let regex = /^\s*(.+:\d+):\serror:\s[\+\-]\[(.*?)\s(.*)\]\s:(?:\s'.*'\s\[FAILED\],)?\s(.*)/
    #endif

    let file: String
    let testSuite: String
    let testCase: String
    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1)
        self.testSuite = String(match.output.2)
        self.testCase = String(match.output.3)
        self.reason = String(match.output.4)
    }
}

struct UIFailingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = reason
    static let regex = /^\s{4}t = \s+\d+\.\d+s\s+Assertion Failure: (.*:\d+): (.*)$/

    let file: String
    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1)
        self.reason = String(match.output.2)
    }
}

struct RestartingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = test suite + test case
    /// $3 = test suite
    /// $4 = test case
    static let regex = /^(Restarting after unexpected exit, crash, or test timeout in (-\[(\w+)\s(\w+)\]|(\w+)\.(\w+)\(\));.*)/

    let wholeMessage: String
    let testSuiteAndTestCase: String
    let testSuite: String
    let testCase: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeMessage = String(match.output.1)
        self.testSuiteAndTestCase = String(match.output.2)
        #warning("FIXME")
        self.testSuite = "" // String(match.output.3)
        self.testCase = "" // String(match.output.4)
    }
}

struct GenerateCoverageDataCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = coverage report file path
    static let regex = /^generating\s+coverage\s+data\.*/

    init(match: Regex<RegexOutput>.Match) { }
}

struct GeneratedCoverageReportCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^generated\s+coverage\s+report:\s+(.+)/

    let coverageReportFilePath: String

    init(match: Regex<RegexOutput>.Match) {
        self.coverageReportFilePath = String(match.output.1)
    }
}

struct GenerateDSYMCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = dsym
    /// $2 = target
    static let regex = /^GenerateDSYMFile \/.*\/(.*\.dSYM) \/.* \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let dsym: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.dsym = String(match.output.1)
        #warning("FIXME")
        self.target = ""
    }
}

struct LibtoolCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = library
    /// $2 = target
    static let regex = /^Libtool.*\/(.*) .* .* \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filename = String(match.output.1)
        #warning("FIXME")
        self.target = ""
    }
}

struct LinkingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    #if os(Linux)
    /// Regular expression captured groups:
    /// $1 = target
    static let regex = /^\[\d+\/\d+\]\sLinking\s([^ ]+)/
    #else
    /// Regular expression captured groups:
    /// $1 = binary filename
    /// $2 = target
    static let regex = /^Ld \/?.*\/(.*?) normal .* \((?:in target: (.*)|in target '(.*)' from project '.*')\)/
    #endif

    #if !os(Linux)
    let binaryFilename: String
    #endif
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        #if os(Linux)
        self.target = String(match.output.1)
        #else
        binaryFilename = String(match.output.1).lastPathComponent
        #warning("FIXME")
        self.target = ""
        #endif
    }
}

struct TestCaseSkippedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    static let regex = /^\s*Test Case\s'(.*)\.(.*)'\sskipped\s\((\d*\.\d{1,3})\sseconds\)/
    #else
    static let regex = /^\s*Test Case\s'-\[(.*?)\s(.*)\]'\sskipped\s\((\d*\.\d{3})\sseconds\)./
    #endif

    let suite: String
    let testCase: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.time = String(match.output.3)
    }
}

struct TestCasePassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    static let regex = /^\s*Test Case\s'(.*)\.(.*)'\spassed\s\((\d*\.\d{1,3})\sseconds\)/
    #else
    static let regex = /^\s*Test Case\s'-\[(.*?)\s(.*)\]'\spassed\s\((\d*\.\d{3})\sseconds\)./
    #endif

    let suite: String
    let testCase: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.time = String(match.output.3)
    }
}

struct TestCaseStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    #if os(Linux)
    static let regex = /^Test Case '(.*)\.(.*)' started at/
    #else
    static let regex = /^Test Case '-\[(.*?) (.*)\]' started.$/
    #endif

    let suite: String
    let testCase: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
    }
}

struct TestCasePendingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    static let regex = /^Test Case\s'-\[(.*?)\s(.*)PENDING\]'\spassed/

    let suite: String
    let testCase: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
    }
}

struct TestCaseMeasuredCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    static let regex = /^[^:]*:[^:]*:\sTest Case\s'(.*?)\.(.*)'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})/
    #else
    static let regex = /^[^:]*:[^:]*:\sTest Case\s'-\[(.*?)\s(.*)\]'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})/
    #endif

    let suite: String
    let testCase: String
    let name: String
    let unitName: String
    let value: String
    let deviation: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.name = String(match.output.3)
        self.unitName = String(match.output.4)
        self.value = String(match.output.5)
        self.deviation = String(match.output.6)
    }
}

struct ParallelTestCaseSkippedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    static let regex = /^Test\s+case\s+'(.*)\.(.*)\(\)'\s+skipped\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)/

    let suite: String
    let testCase: String
    let device: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.device = String(match.output.3)
        self.time = String(match.output.4)
    }
}

struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    static let regex = /^Test\s+case\s+'(.*)[\.\/](.*)\(\)'\s+passed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)/

    let suite: String
    let testCase: String
    let device: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.device = String(match.output.3)
        self.time = String(match.output.4)
    }
}

struct ParallelTestCaseAppKitPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    static let regex = /^\s*Test case\s'-\[(.*?)\s(.*)\]'\spassed\son\s'.*'\s\((\d*\.\d{3})\sseconds\)/

    let suite: String
    let testCase: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.time = String(match.output.3)
    }
}

struct ParallelTestCaseFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    static let regex = /^Test\s+case\s+'(.*)[\.\/](.*)\(\)'\s+failed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)/

    let suite: String
    let testCase: String
    let device: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.testCase = String(match.output.2)
        self.device = String(match.output.3)
        self.time = String(match.output.4)
    }
}

struct ParallelTestingStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = device
    static let regex = /^(Testing\s+started\s+on\s+'(.*)'.*)$/

    let wholeMessage: String
    let device: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeMessage = String(match.output.1)
        self.device = String(match.output.2)
    }
}

struct ParallelTestingPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    /// $2 = device
    static let regex = /^(Testing\s+passed\s+on\s+'(.*)'.*)$/

    let wholeMessage: String
    let device: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeMessage = String(match.output.1)
        self.device = String(match.output.2)
    }
}

struct ParallelTestingFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .nonContextualError

    /// Regular expression captured groups:
    /// $1 = whole error
    /// $2 = device
    static let regex = /^(Testing\s+failed\s+on\s+'(.*)'.*)$/

    let wholeError: String
    let device: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
        self.device = String(match.output.2)
    }
}

struct ParallelTestSuiteStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = device
    static let regex = /^\s*Test\s+Suite\s+'(.*)'\s+started\s+on\s+'(.*)'/

    let suite: String
    let device: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.device = String(match.output.2)
    }
}

struct PhaseSuccessCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result
    static let regex = /^\*\*\s(.*)\sSUCCEEDED\s\*\*/

    let phase: String

    init(match: Regex<RegexOutput>.Match) {
        self.phase = String(match.output.1)
    }
}

struct PhaseScriptExecutionCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = phase name
    /// $2 = target
    static let regex = /^PhaseScriptExecution\s(.*)\s\/.*\.sh\s\((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let phaseName: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.phaseName = String(match.output.1)
        #warning("FIXME")
        self.target = ""
    }
}

struct ProcessPchCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = build target
    static let regex = /^ProcessPCH(?:\+\+)?\s.*\s\/.*\/(.*) normal .* .* .* \((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let buildTarget: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1)
        self.buildTarget = ""
        #warning("FIXME")
    }
}

struct ProcessPchCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 file path
    static let regex = /^\s*.*\/usr\/bin\/clang\s.*\s\-c\s(.*)\s\-o\s.*\.gch/

    let filePath: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
    }
}

struct PreprocessCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = file
    /// $3 = target
    /// $4 = project
    static let regex = /^Preprocess\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s.*\(in target '(.*)' from project '(.*)'\)/

    let filePath: String
    let file: String
    let target: String
    let project: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.file = String(match.output.2)
        self.target = String(match.output.3)
        self.project = String(match.output.4)
    }
}

struct PbxcpCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = build target
    static let regex = /^PBXCp\s(.*)\s\/(.*)\s\((?:in target: (.*)|in target '(.*)' from project '.*')\)/

    let file: String
    let targetFile: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.file = String(match.output.1).lastPathComponent
        self.targetFile = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct ProcessInfoPlistCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $4 = target
    static let regex = /^ProcessInfoPlistFile\s.*\.plist\s(.*\/+(.*\.plist))( \((?:in target: (.*)|in target '(.*)' from project '.*')\))?/

    let filePath: String
    let filename: String
    let target: String? // Xcode 10+

    init(match: Regex<RegexOutput>.Match) {
        // Xcode 10+ includes target output
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
#warning("FIXME")
        self.target = ""
    }
}

struct TestsRunCompletionCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = result
    /// $3 = time
    #if os(Linux)
    static let regex = /^\s*(Test Suite '(.*)' (finished|passed|failed) at (.*).*)/
    #else
    static let regex = /^\s*(Test Suite '(?:.*\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*).*)/
    #endif

    let wholeResult: String
    let suite: String
    let result: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeResult = String(match.output.1)
        self.suite = String(match.output.2)
        self.result = String(match.output.3)
        self.time = String(match.output.4)
    }
}

struct TestSuiteStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = time
    #if os(Linux)
    static let regex = /^\s*Test Suite '(.*)' started at(.*)/
    #else
    static let regex = /^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' started at(.*)/
    #endif

    let suite: String
    let time: String

    init(match: Regex<RegexOutput>.Match) {
        self.suite = String(match.output.1)
        self.time = String(match.output.2)
    }
}

struct TestSuiteStartCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = test suite name
    static let regex = /^\s*Test Suite '(.*)' started at/

    let testSuiteName: String

    init(match: Regex<RegexOutput>.Match) {
        self.testSuiteName = String(match.output.1)
    }
}

struct TestSuiteAllTestsPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result
    static let regex = /^\s*(Test Suite 'All tests' passed at.*)/

    let wholeResult: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeResult = String(match.output.1)
    }
}

struct TestSuiteAllTestsFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result
    static let regex = /^\s*(Test Suite 'All tests' failed at.*)/

    let wholeResult: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeResult = String(match.output.1)
    }
}

struct TIFFutilCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = filename
    static let regex = /^TiffUtil\s(.*)/

    let filename: String

    init(match: Regex<RegexOutput>.Match) {
        self.filename = String(match.output.1)
    }
}

struct TouchCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = filename
    /// $3 = target
    static let regex = /^Touch\s(.*\/(.+))( \((?:in target: (.*)|in target '(.*)' from project '.*')\))/

    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filename = String(match.output.2)
        #warning("FIXME")
        self.target = ""
    }
}

struct WriteFileCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captured groups:
    /// $1 = file path
    static let regex = /^write-file\s(.*)/

    let filePath: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
    }
}

struct WriteAuxiliaryFileCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^WriteAuxiliaryFile (.*\/(.*\..*)) \(in target '(.*)' from project '.*'\)$/

    let filePath: String
    let filename: String
    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        self.target = String(match.output.3)
    }
}

struct CompileWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $3 = reason
    static let regex = /^(([^:]*):*\d*:*\d*):\swarning:\s(.*)$/

    let filePath: String
    let filename: String
    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.filename = String(match.output.2)
        self.reason = String(match.output.3)
    }
}

struct LDWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = ld prefix
    /// $2 = warning message
    static let regex = /^(ld: )warning: (.*)/

    let ldPrefix: String
    let warningMessage: String

    init(match: Regex<RegexOutput>.Match) {
        self.ldPrefix = String(match.output.1)
        self.warningMessage = String(match.output.2)
    }
}

struct GenericWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole warning
    static let regex = /^warning:\s(.*)$/

    let wholeWarning: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeWarning = String(match.output.1)
    }
}

struct WillNotBeCodeSignedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole warning
    static let regex = /^(.* will not be code signed because .*)$/

    let wholeWarning: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeWarning = String(match.output.1)
    }
}

struct DuplicateLocalizedStringKeyCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expresion captured groups:
    /// $1 = warning message.
    static let regex = /^[\d -:]+ --- WARNING: (Key ".*" used with multiple values. Value ".*" kept. Value ".*" ignored.)$/

    let warningMessage: String

    init(match: Regex<RegexOutput>.Match) {
        warningMessage = String(match.output.1)
    }
}

struct ClangErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(clang: error:.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct CheckDependenciesErrorsCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(Code\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct ProvisioningProfileRequiredCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(.*requires a provisioning profile.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct NoCertificateCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(No certificate matching.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct CompileErrorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = is fatal error
    /// $3 = reason
    static let regex = /^(([^:]*):*\d*:*\d*):\s(?:fatal\s)?error:\s(.*)$/

    let filePath: String
    let isFatalError: String
    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.filePath = String(match.output.1)
        self.isFatalError = String(match.output.2)
        self.reason = String(match.output.3)
    }
}

struct CursorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression captured groups:
    /// $1 = cursor (with whitespaces and tildes)
    static let regex = /^([\s~]*\^[\s~]*)$/

    let cursor: String

    init(match: Regex<RegexOutput>.Match) {
        self.cursor = String(match.output.1)
    }
}

struct FatalErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error.
    /// it varies a lot, not sure if it makes sense to catch everything separately
    static let regex = /^(fatal error:.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct FileMissingErrorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error.
    /// $2 = file path
    static let regex = /^<unknown>:0:\s(error:\s.*)\s'(\/.+\/.*\..*)'$/

    let reason: String
    let filePath: String

    init(match: Regex<RegexOutput>.Match) {
        self.reason = String(match.output.1)
        self.filePath = String(match.output.2)
    }
}

struct LDErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(ld:.*)/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct LinkerDuplicateSymbolsLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = file path
    static let regex = /^\s+(\/.*\.o[\)]?)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct LinkerDuplicateSymbolsCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = /^(duplicate symbol .*):$/

    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.reason = String(match.output.1)
    }
}

struct LinkerUndefinedSymbolLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = symbol location
    static let regex = /^(.* in .*\.o)$/

    let symbolLocation: String

    init(match: Regex<RegexOutput>.Match) {
        self.symbolLocation = String(match.output.1)
    }
}

struct LinkerUndefinedSymbolsCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = /^(Undefined symbols for architecture .*):$/

    let reason: String

    init(match: Regex<RegexOutput>.Match) {
        self.reason = String(match.output.1)
    }
}

struct PodsErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = /^(error:\s.*)/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = wholeError
    /// $2 = reference
    static let regex = /(\s+\"(.*)\", referenced from:)$/

    let wholeError: String
    let reference: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
        self.reference = String(match.output.2)
    }
}

struct ModuleIncludesErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = error reason
    static let regex = /^\<module-includes\>:.*?:.*?:\s(?:fatal\s)?(error:\s.*)$\//

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning
    /// Regular expression captured groups:
    /// $1 = whole warning
    /// $2 = target
    /// $3 = filename
    static let regex = /(.+ in (.+)\((.+)\.o\))$/

    let wholeWarning: String
    let target: String
    let filename: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeWarning = String(match.output.1)
        self.target = String(match.output.2)
        self.filename = String(match.output.3)
    }
}

struct PackageFetchingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^Fetching from (.*?)$/

    let source: String

    init(match: Regex<RegexOutput>.Match) {
        self.source = String(match.output.1)
    }
}

struct PackageUpdatingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^Updating from (.*?)$/

    let source: String

    init(match: Regex<RegexOutput>.Match) {
        self.source = String(match.output.1)
    }
}

struct PackageCheckingOutCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^Checking out (.*?) of package (.*?)$/

    let version: String
    let package: String

    init(match: Regex<RegexOutput>.Match) {
        self.version = String(match.output.1)
        self.package = String(match.output.2)
    }
}

struct PackageGraphResolvingStartCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^\s*Resolve Package Graph\s*$/

    init(match: Regex<RegexOutput>.Match) { }
}

struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
    static let regex = /^Resolved source packages:$/

    init(match: Regex<RegexOutput>.Match) { }
}

struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    /// Regular expression captures groups:
    /// $1 = package name
    /// $2 = package url
    /// $3 = package version
    static let regex = /^\s*([^\s:]+):\s([^ ]+)\s@\s(\d+\.\d+\.\d+)/

    let packageName: String
    let packageURL: String
    let packageVersion: String

    init(match: Regex<RegexOutput>.Match) {
        self.packageName = String(match.output.1)
        self.packageURL = String(match.output.2)
        self.packageVersion = String(match.output.3)
    }
}

struct XcodebuildErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = /^(xcodebuild: error:.*)$/

    let wholeError: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeError = String(match.output.1)
    }
}

struct CompilationResultCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^\/\* com.apple.actool.compilation-results \*\/$/

    init(match: Regex<RegexOutput>.Match) { }
}

struct SwiftDriverJobDiscoveryEmittingModuleCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /SwiftDriverJobDiscovery \w+ \w+ Emitting module for .* \(in target '.*' from project '.*'\)/

    init(match: Regex<RegexOutput>.Match) { }
}

/// This output is printed when running
/// `xcodebuild test -scheme xcbeautify-Package -destination 'platform=macOS,arch=arm64'`.
struct TestingStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression captured groups:
    /// $1 = whole message
    static let regex = /^(Testing started.*)$/

    let wholeMessage: String

    init(match: Regex<RegexOutput>.Match) {
        self.wholeMessage = String(match.output.1)
    }
}

struct SwiftDriverJobDiscoveryCompilingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

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
    static let regex = /^SwiftDriverJobDiscovery (\S+) (\S+) Compiling (.*) \(in target '(.*)' from project '(.*)'\)/

    let state: String // Currently, the only expected/known value is `normal`
    let architecture: String
    let filenames: [String]
    let target: String
    let project: String

    init(match: Regex<RegexOutput>.Match) {
        self.state = String(match.output.1)
        self.architecture = String(match.output.2)
        filenames = String(match.output.3).components(separatedBy: ", ")
        self.target = String(match.output.4)
        self.project = String(match.output.5)
    }
}

struct SwiftTestingRunStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression to capture the start of a test run.
    /// $1 = message
    static let regex = /^.\s+(Test run started\.)$/

    let message: String

    init(match: Regex<RegexOutput>.Match) {
        self.message = String(match.output.1)
    }
}

struct SwiftTestingRunCompletionCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression to capture the number of tests and total time.
    /// $1 = number of tests
    /// $2 = total time in seconds
    static let regex = /^.\s+Test run with (\d+) test(?:s)? passed after ([\d.]+) seconds\.$/

    let numberOfTests: Int
    let totalTime: String

    init(match: Regex<RegexOutput>.Match) {
        #warning("GET RID OF THIS FORCE UNWRAP")
        self.numberOfTests = Int(match.output.1)!
        self.totalTime = String(match.output.2)
    }
}

struct SwiftTestingRunFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression to capture the number of tests, total time, and the number of issues.
    /// $1 = number of tests
    /// $2 = total time in seconds
    /// $3 = number of issues
    static let regex = /^.\s+Test run with (\d+) test(?:s)? failed after ([\d.]+) seconds with (\d+) issue[s]?\.$/

    let numberOfTests: Int
    let totalTime: String
    let numberOfIssues: Int

    init(match: Regex<RegexOutput>.Match) {
        #warning("GET RID OF THIS FORCE UNWRAP")
        self.numberOfTests = Int(match.output.1)!
        self.totalTime = String(match.output.2)
        self.numberOfIssues = Int(match.output.3)!
    }
}

struct SwiftTestingSuiteStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    /// Regular expression to capture the start of a test suite.
    /// $1 = suite name
    static let regex = /^.\s+Suite (.*) started\.$/

    let suiteName: String

    init(match: Regex<RegexOutput>.Match) {
        self.suiteName = String(match.output.1)
    }
}

struct SwiftTestingTestStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the start of a test case.
    /// $1 = test name
    static let regex = /^.\s+Test\s+(.*) started\.$/

    let testName: String
    let wholeMessage: String

    init(match: Regex<RegexOutput>.Match) {
        self.testName = String(match.output.1)
        wholeMessage = "Test \(testName) started."
    }
}

struct SwiftTestingSuitePassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    /// Regular expression to capture the successful completion of a test suite.
    /// $1 = suite name
    /// $2 = total time taken in seconds
    static let regex = /^.\s+Suite (.*) passed after ([\d.]+) seconds\.$/

    let suiteName: String
    let timeTaken: String

    init(match: Regex<RegexOutput>.Match) {
        self.suiteName = String(match.output.1)
        self.timeTaken = String(match.output.2)
    }
}

struct SwiftTestingSuiteFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result

    /// Regular expression to capture the failure of a test suite.
    /// $1 = suite name
    /// $2 = total time taken in seconds
    /// $3 = number of issues
    static let regex = /^.\s+Suite (.*) failed after ([\d.]+) seconds with (\d+) issue[s]?\.$/

    let suiteName: String
    let timeTaken: String
    let numberOfIssues: Int

    init(match: Regex<RegexOutput>.Match) {
        #warning("GET RID OF THIS FORCE UNWRAP")
        self.suiteName = String(match.output.1)
        self.timeTaken = String(match.output.2)
        self.numberOfIssues = Int(match.output.3)!
    }
}

struct SwiftTestingTestFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the failure of a test case.
    /// $1 = test name
    /// $2 = time taken in seconds
    /// $3 = number of issues
    static let regex = /^.\s+Test (?!run\s)(.*) failed after ([\d.]+) seconds with (\d+) issue[s]?\.$/

    let testName: String
    let timeTaken: String
    let numberOfIssues: Int

    init(match: Regex<RegexOutput>.Match) {
        #warning("GET RID OF THIS FORCE UNWRAP")
        self.testName = String(match.output.1)
        self.timeTaken = String(match.output.2)
        self.numberOfIssues = Int(match.output.3)!
    }
}

struct SwiftTestingTestPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the successful completion of a test case.
    /// $1 = test name
    /// $2 = time taken in seconds
    static let regex = /^.*Test (?!run\s)(.*) passed after ([\d.]+) seconds\.$/

    let testName: String
    let timeTaken: String

    init(match: Regex<RegexOutput>.Match) {
        self.testName = String(match.output.1)
        self.timeTaken = String(match.output.2)
    }
}

struct SwiftTestingTestSkippedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture a skipped test case.
    /// $1 = test name
    static let regex = /^.\s+Test (.*) skipped\.$/

    let testName: String

    init(match: Regex<RegexOutput>.Match) {
        self.testName = String(match.output.1)
    }
}

struct SwiftTestingTestSkippedReasonCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture a skipped test case with a reason.
    /// $1 = test name
    /// $2 = optional reason
    static let regex = /^.\s+Test (.*) skipped(?:\s*:\s*"(.*)")?$/

    let testName: String
    let reason: String?

    init(match: Regex<RegexOutput>.Match) {
        self.testName = String(match.output.1)
        reason = match.output.2 != nil ? String(match.output.2!) : nil
    }
}

struct SwiftTestingIssueCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol, test description, and issue details.
    /// $1 = test description
    /// $2 = issue details
    static let regex = /^.\s+Test (.*?) recorded an issue(?: at (.*))?$/

    let testDescription: String
    let issueDetails: String?

    init(match: Regex<RegexOutput>.Match) {
        self.testDescription = String(match.output.1)
        issueDetails = match.output.2 != nil ? String(match.output.2!) : nil
    }
}

struct SwiftTestingIssueArgumentCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol, test description, and optional number of arguments.
    /// $1 = test description
    /// $2 = number of arguments (optional)
    static let regex = /^.\s+Test (.*?) recorded an issue(?: with (\d+) arguments?)?/

    let testDescription: String
    let numberOfArguments: Int?

    init(match: Regex<RegexOutput>.Match) {
        self.testDescription = String(match.output.1)
        numberOfArguments = match.output.2 != nil ? Int(match.output.2!) : nil
    }
}

struct SwiftTestingPassingArgumentCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    /// Regular expression to capture the symbol and number of arguments.
    /// $1 = number of arguments
    static let regex = /^.\s+Passing (\d+) argument[s]?.*$/

    let numberOfArguments: Int

    init(match: Regex<RegexOutput>.Match) {
        #warning("GET RID OF THIS FORCE UNWRAP")
        self.numberOfArguments = Int(match.output.1)!
    }
}

struct SwiftDriverTargetCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^SwiftDriver (.*) normal (?:arm64|x86_64) com\.apple\.xcode\.tools\.swift\.compiler/

    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
    }
}

struct SwiftDriverCompilationTarget: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^SwiftDriver\\ Compilation (.*) normal (?:arm64|x86_64) com\.apple\.xcode\.tools\.swift\.compiler/

    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
    }
}

struct SwiftDriverCompilationRequirementsCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^SwiftDriver\\ Compilation\\ Requirements (.*) normal (?:arm64|x86_64) com\.apple\.xcode\.tools\.swift\.compiler/

    let target: String

    init(match: Regex<RegexOutput>.Match) {
        self.target = String(match.output.1)
    }
}

struct MkDirCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    static let regex = /^MkDir.*/

    init(match: Regex<RegexOutput>.Match) { }
}
