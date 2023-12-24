import Foundation

protocol CaptureGroup {
    static var regex: XcbeautifyLib.Regex { get }
}

extension CaptureGroup {
    static var pattern: String { regex.pattern }
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
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    static let regex = Regex(pattern: #"^Analyze(?:Shallow)?\s(.*\/(.*\.(?:m|mm|cc|cpp|c|cxx)))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let filePath: String
    let fileName: String
    let target: String
}

struct BuildTargetCaptureGroup: TargetCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = Regex(pattern: #"^=== BUILD TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    let target: String
    let project: String
    let configuration: String
}

struct AggregateTargetCaptureGroup: TargetCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = Regex(pattern: #"^=== BUILD AGGREGATE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    let target: String
    let project: String
    let configuration: String
}

struct AnalyzeTargetCaptureGroup: TargetCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = Regex(pattern: #"^=== ANALYZE TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH.*CONFIGURATION\s(.*)\s==="#)

    let target: String
    let project: String
    let configuration: String
}

/// Nothing returned here for now
struct CheckDependenciesCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Check dependencies"#)
}

struct ShellCommandCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = command path
    /// $2 = arguments
    static let regex = Regex(pattern: #"^\s{4}(cd|setenv|(?:[\w\/:\s\-.]+?\/)?[\w\-]+)\s(.*)$"#)

    let commandPath: String
    let arguments: String
}

struct CleanRemoveCaptureGroup: CaptureGroup {
    /// Nothing returned here for now
    static let regex = Regex(pattern: #"^Clean.Remove(.*)"#)

    let directory: String
}

struct CleanTargetCaptureGroup: TargetCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = project
    /// $3 = configuration
    static let regex = Regex(pattern: #"^=== CLEAN TARGET\s(.*)\sOF PROJECT\s(.*)\sWITH CONFIGURATION\s(.*)\s==="#)

    let target: String
    let project: String
    let configuration: String
}

struct CodesignCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    static let regex = Regex(pattern: #"^CodeSign\s(((?!.framework/Versions/A)(?:\ |[^ ]))*?)( \(in target '.*' from project '.*' at path '.*'\))?$"#)

    let file: String
}

struct CodesignFrameworkCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    static let regex = Regex(pattern: #"^CodeSign\s((?:\ |[^ ])*.framework)\/Versions/A"#)

    let frameworkPath: String
}

struct CompileCaptureGroup: CompileFileCaptureGroup {
#if os(Linux)
/// Regular expression captured groups:
/// $1 = filename (e.g. KWNull.m)
/// $2 = target
    static let regex = Regex(pattern: #"^\[\d+\/\d+\]\sCompiling\s([^ ]+)\s([^ \.]+\.(?:m|mm|c|cc|cpp|cxx|swift))"#)
#else
/// Regular expression captured groups:
/// $1 = file path
/// $2 = filename (e.g. KWNull.m)
/// $3 = target
    static let regex = Regex(pattern: #"^Compile[\w]+\s.+?\s((?:\.|[^ ])+\/((?:\.|[^ ])+\.(?:m|mm|c|cc|cpp|cxx|swift)))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)
#endif
    
#if !os(Linux)
    let filePath: String
#endif
    let filename: String
    let target: String
}

struct CompileCommandCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = compiler command
    /// $2 = file path
    static let regex = Regex(pattern: #"^\s*(.*clang\s.*\s\-c\s(.*\.(?:m|mm|c|cc|cpp|cxx))\s.*\.o)$"#)

    let compilerCommand: String
    let filePath: String
}

struct CompileXibCaptureGroup: CompileFileCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. MainMenu.xib)
    /// $3 = target
    static let regex = Regex(pattern: #"^CompileXIB\s(.*\/(.*\.xib))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let filePath: String
    let filename: String
    let target: String
}

struct CompileStoryboardCaptureGroup: CompileFileCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename (e.g. Main.storyboard)
    /// $3 = target
    static let regex = Regex(pattern: #"^CompileStoryboard\s(.*\/([^\/].*\.storyboard))\s.*\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let filePath: String
    let filename: String
    let target: String
}

struct CopyHeaderCaptureGroup: CopyCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = target
    static let regex = Regex(pattern: #"^CpHeader\s(.*\.h)\s(.*\.h) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let targetFile: String
    let target: String
}

struct CopyPlistCaptureGroup: CopyCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    static let regex = Regex(pattern: #"^CopyPlistFile\s(.*\.plist)\s(.*\.plist) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let target: String
}

struct CopyStringsCaptureGroup: CopyCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    static let regex = Regex(pattern: #"^CopyStringsFile\s(.*\.strings)\s(.*\.strings) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let target: String
}

struct CpresourceCaptureGroup: CopyCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = resource
    static let regex = Regex(pattern: #"^CpResource\s(.*)\s\/(.*) \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let target: String
}

struct ExecutedWithoutSkippedCaptureGroup: ExecutedCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of failures
    /// $3 = number of unexpected failures
    /// $4 = wall clock time in seconds (e.g. 0.295)
    static let regex = Regex(pattern: #"^\s*Executed\s(\d+)\stest[s]?,\swith\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds"#)

    let numberOfTests: Int
    let numberOfSkipped = 0
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct ExecutedWithSkippedCaptureGroup: ExecutedCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = number of tests
    /// $2 = number of skipped
    /// $3 = number of failures
    /// $4 = number of unexpected failures
    /// $5 = wall clock time in seconds (e.g. 0.295)
    static let regex = Regex(pattern: #"^\s*Executed\s(\d+)\stest[s]?,\swith\s(\d+)\stest[s]?\sskipped\sand\s(\d+)\sfailure[s]?\s\((\d+)\sunexpected\)\sin\s\d+\.\d{3}\s\((\d+\.\d{3})\)\sseconds"#)

    let numberOfTests: Int
    let numberOfSkipped: Int
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct FailingTestCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = test suite
    /// $3 = test case
    /// $4 = reason
    #if os(Linux)
    static let regex = Regex(pattern: #"^\s*(.+:\d+):\serror:\s(.*)\.(.*)\s:(?:\s'.*'\s\[failed\],)?\s(.*)"#)
    #else
    static let regex = Regex(pattern: #"^\s*(.+:\d+):\serror:\s[\+\-]\[(.*?)\s(.*)\]\s:(?:\s'.*'\s\[FAILED\],)?\s(.*)"#)
    #endif

    let file: String
    let testSuite: String
    let testCase: String
    let reason: String
}

struct UIFailingTestCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = reason
    static let regex = Regex(pattern: #"^\s{4}t = \s+\d+\.\d+s\s+Assertion Failure: (.*:\d+): (.*)$"#)

    let file: String
    let reason: String
}

struct RestartingTestCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = test suite + test case
    /// $2 = test suite
    /// $3 = test case
    static let regex = Regex(pattern: #"^Restarting after unexpected exit, crash, or test timeout in (-\[(\w+)\s(\w+)\]|(\w+)\.(\w+)\(\));"#)

    let testSuiteAndTestCase: String
    let testSuite: String
    let testCase: String
}

struct GenerateCoverageDataCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = coverage report file path
    static let regex = Regex(pattern: #"^generating\s+coverage\s+data\.*"#)
}

struct GeneratedCoverageReportCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^generated\s+coverage\s+report:\s+(.+)"#)

    let coverageReportFilePath: String
}

struct GenerateDSYMCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = dsym
    /// $2 = target
    static let regex = Regex(pattern: #"^GenerateDSYMFile \/.*\/(.*\.dSYM) \/.* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let dsym: String
    let target: String
}

struct LibtoolCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = library
    /// $2 = target
    static let regex = Regex(pattern: #"^Libtool.*\/(.*) .* .* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let fileName: String
    let target: String
}

struct LinkingCaptureGroup: CaptureGroup {
#if os(Linux)
    /// Regular expression captured groups:
    /// $1 = target
    static let regex = Regex(pattern: #"^\[\d+\/\d+\]\sLinking\s([^ ]+)"#)
#else
    /// Regular expression captured groups:
    /// $1 = binary filename
    /// $2 = target
    static let regex = Regex(pattern: #"^Ld \/?.*\/(.*?) normal .* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)
#endif

#if !os(Linux)
    let binaryFilename: String
#endif
    let target: String
}

struct TestCasePassedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    static let regex = Regex(pattern: #"^\s*Test Case\s'(.*)\.(.*)'\spassed\s\((\d*\.\d{1,3})\sseconds\)"#)
    #else
     static let regex = Regex(pattern: #"^\s*Test Case\s'-\[(.*?)\s(.*)\]'\spassed\s\((\d*\.\d{3})\sseconds\)."#)
    #endif

    let suite: String
    let testCase: String
    let time: String
}

struct TestCaseStartedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    #if os(Linux)
    static let regex = Regex(pattern: #"^Test Case '(.*)\.(.*)' started at"#)
    #else
    static let regex = Regex(pattern: #"^Test Case '-\[(.*?) (.*)\]' started.$"#)
    #endif

    let suite: String
    let testCase: String
}

struct TestCasePendingCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    static let regex = Regex(pattern: #"^Test Case\s'-\[(.*?)\s(.*)PENDING\]'\spassed"#)

    let suite: String
    let testCase: String
}

struct TestCaseMeasuredCaptureGroup: CaptureGroup {
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    #if os(Linux)
    static let regex = Regex(pattern: #"^[^:]*:[^:]*:\sTest Case\s'(.*?)\.(.*)'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})"#)
    #else
    static let regex = Regex(pattern: #"^[^:]*:[^:]*:\sTest Case\s'-\[(.*?)\s(.*)\]'\smeasured\s\[([^,]*),\s([^\]]*)\]\saverage:\s(\d*\.\d{3}), relative standard deviation: (\d*\.\d{3})"#)
    #endif

    let suite: String
    let testCase: String
    let name: String
    let unitName: String
    let value: String
    let deviation: String
}

struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    static let regex = Regex(pattern: #"^Test\s+case\s+'(.*)\.(.*)\(\)'\s+passed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)"#)

    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestCaseAppKitPassedCaptureGroup: CaptureGroup {

    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = time
    static let regex = Regex(pattern: #"^\s*Test case\s'-\[(.*?)\s(.*)\]'\spassed\son\s'.*'\s\((\d*\.\d{3})\sseconds\)"#)

    let suite: String
    let testCase: String
    let time: String
}

struct ParallelTestCaseFailedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = test case
    /// $3 = installed app file and ID (e.g. "MyApp.app (12345)"), process (e.g. "xctest (12345)"), or device (e.g. "iPhone X")
    /// $4 = time
    static let regex = Regex(pattern: #"^Test\s+case\s+'(.*)\.(.*)\(\)'\s+failed\s+on\s+'(.*)'\s+\((\d*\.(.*){3})\s+seconds\)"#)

    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestingStartedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = device
    static let regex = Regex(pattern: #"^Testing\s+started\s+on\s+'(.*)'"#)

    let device: String
}

struct ParallelTestingPassedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = device
    static let regex = Regex(pattern: #"^Testing\s+passed\s+on\s+'(.*)'"#)

    let device: String
}

struct ParallelTestingFailedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = device
    static let regex = Regex(pattern: #"^Testing\s+failed\s+on\s+'(.*)'"#)

    let device: String
}

struct ParallelTestSuiteStartedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = device
    static let regex = Regex(pattern: #"^\s*Test\s+Suite\s+'(.*)'\s+started\s+on\s+'(.*)'"#)

    let suite: String
    let device: String
}

struct PhaseSuccessCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^\*\*\s(.*)\sSUCCEEDED\s\*\*"#)

    let phase: String
}

struct PhaseScriptExecutionCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = phase name
    /// $2 = target
    static let regex = Regex(pattern: #"^PhaseScriptExecution\s(.*)\s\/.*\.sh\s\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let phaseName: String
    let target: String
}

struct ProcessPchCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    /// $2 = build target
    static let regex = Regex(pattern: #"^ProcessPCH(?:\+\+)?\s.*\s\/.*\/(.*) normal .* .* .* \((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let buildTarget: String
}

struct ProcessPchCommandCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 file path
    static let regex = Regex(pattern: #"^\s*.*\/usr\/bin\/clang\s.*\s\-c\s(.*?)(?<!\\)\s.*\-o\s.*\.gch"#)

    let filePath: String
}

struct PreprocessCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file
    static let regex = Regex(pattern: #"^Preprocess\s(?:(?:\ |[^ ])*)\s((?:\ |[^ ])*)$"#)

    let file: String
}

struct PbxcpCaptureGroup: CopyCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = source file
    /// $2 = target file
    /// $3 = build target
    static let regex = Regex(pattern: #"^PBXCp\s(.*)\s\/(.*)\s\((in target: (.*)|in target '(.*)' from project '.*')\)"#)

    let file: String
    let targetFile: String
    let target: String
}

struct ProcessInfoPlistCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $4 = target
    static let regex = Regex(pattern: #"^ProcessInfoPlistFile\s.*\.plist\s(.*\/+(.*\.plist))( \((in target: (.*)|in target '(.*)' from project '.*')\))?"#)

    let filePath: String
    let filename: String
    let target: String? // Xcode 10+
}

struct TestsRunCompletionCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = result
    /// $3 = time
    #if os(Linux)
    static let regex = Regex(pattern: #"^\s*Test Suite '(.*)' (finished|passed|failed) at (.*)"#)
    #else
    static let regex = Regex(pattern: #"^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' (finished|passed|failed) at (.*)"#)
    #endif

    let suite: String
    let result: String
    let time: String
}

struct TestSuiteStartedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = suite
    /// $2 = time
    #if os(Linux)
    static let regex = Regex(pattern: #"^\s*Test Suite '(.*)' started at(.*)"#)
    #else
    static let regex = Regex(pattern: #"^\s*Test Suite '(?:.*\/)?(.*[ox]ctest.*)' started at(.*)"#)
    #endif

    let suite: String
    let time: String
}

struct TestSuiteStartCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = test suite name
    static let regex = Regex(pattern: #"^\s*Test Suite '(.*)' started at"#)

    let testSuiteName: String
}

struct TestSuiteAllTestsPassedCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^\s*Test Suite 'All tests' passed at"#)
}

struct TestSuiteAllTestsFailedCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^\s*Test Suite 'All tests' failed at"#)
}

struct TIFFutilCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = filename
    static let regex = Regex(pattern: #"^TiffUtil\s(.*)"#)

    let filename: String
}

struct TouchCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = filename
    /// $3 = target
    static let regex = Regex(pattern: #"^Touch\s(.*\/(.+))( \((in target: (.*)|in target '(.*)' from project '.*')\))"#)

    let filename: String
    let target: String
}

struct WriteFileCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    static let regex = Regex(pattern: #"^write-file\s(.*)"#)

    let filePath: String
}

struct WriteAuxiliaryFilesCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Write auxiliary files"#)
}

struct CompileWarningCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    /// $2 = filename
    /// $3 = reason
    static let regex = Regex(pattern: #"^(([^:]*):*\d*:*\d*):\swarning:\s(.*)$"#)

    let filePath: String
    let filename: String
    let reason: String
}

struct LDWarningCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = ld prefix
    /// $2 = warning message
    static let regex = Regex(pattern: #"^(ld: )warning: (.*)"#)

    let ldPrefix: String
    let warningMessage: String
}

struct GenericWarningCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole warning
    static let regex = Regex(pattern: #"^warning:\s(.*)$"#)

    let wholeWarning: String
}

struct WillNotBeCodeSignedCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole warning
    static let regex = Regex(pattern: #"^(.* will not be code signed because .*)$"#)

    let wholeWarning: String
}

struct DuplicateLocalizedStringKeyCaptureGroup: CaptureGroup {
    /// Regular expresion captured groups:
    /// $1 = warning message.
    static let regex = Regex(pattern: #"^[\d\s-:]+ --- WARNING: (Key ".*" used with multiple values. Value ".*" kept. Value ".*" ignored.)$"#)

    let warningMessage: String
}

struct ClangErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(clang: error:.*)$"#)

    let wholeError: String
}

struct CheckDependenciesErrorsCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(Code\s?Sign error:.*|Code signing is required for product type .* in SDK .*|No profile matching .* found:.*|Provisioning profile .* doesn't .*|Swift is unavailable on .*|.?Use Legacy Swift Language Version.*)$"#)

    let wholeError: String
}

struct ProvisioningProfileRequiredCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(.*requires a provisioning profile.*)$"#)

    let wholeError: String
}

struct NoCertificateCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(No certificate matching.*)$"#)

    let wholeError: String
}

struct CompileErrorCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path (could be a relative path if you build with Bazel)
    /// $2 = is fatal error
    /// $3 = reason
    static let regex = Regex(pattern: #"^(([^:]*):*\d*:*\d*):\s(?:fatal\s)?error:\s(.*)$"#)

    let filePath: String
    let isFatalError: String
    let reason: String
}

struct CursorCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = cursor (with whitespaces and tildes)
    static let regex = Regex(pattern: #"^([\s~]*\^[\s~]*)$"#)

    let cursor: String
}

struct FatalErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error.
    /// it varies a lot, not sure if it makes sense to catch everything separately
    static let regex = Regex(pattern: #"^(fatal error:.*)$"#)

    let wholeError: String
}

struct FileMissingErrorCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error.
    /// $2 = file path
    static let regex = Regex(pattern: #"^<unknown>:0:\s(error:\s.*)\s'(\/.+\/.*\..*)'$"#)

    let reason: String
    let filePath: String
}

struct LDErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(ld:.*)"#)

    let wholeError: String
}

struct LinkerDuplicateSymbolsLocationCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = file path
    static let regex = Regex(pattern: #"^\s+(\/.*\.o[\)]?)$"#)

    let wholeError: String
}

struct LinkerDuplicateSymbolsCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = Regex(pattern: #"^(duplicate symbol .*):$"#)

    let reason: String
}

struct LinkerUndefinedSymbolLocationCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = symbol location
    static let regex = Regex(pattern: #"^(.* in .*\.o)$"#)

    let symbolLocation: String
}

struct LinkerUndefinedSymbolsCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = Regex(pattern: #"^(Undefined symbols for architecture .*):$"#)

    let reason: String
}

struct PodsErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = reason
    static let regex = Regex(pattern: #"^(error:\s.*)"#)

    let wholeError: String
}

struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = reference
    static let regex = Regex(pattern: #"\s+\"(.*)\", referenced from:$"#)

    let reference: String
}

struct ModuleIncludesErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = error reason
    static let regex = Regex(pattern: #"^\<module-includes\>:.*?:.*?:\s(?:fatal\s)?(error:\s.*)$/"#)

    let wholeError: String
}

struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    /// Regular expression captured groups:
    /// $1 = target
    /// $2 = filename
    static let regex = Regex(pattern: #".+ in (.+)\((.+)\.o\)$"#)

    let target: String
    let filename: String
}

struct PackageFetchingCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Fetching from (.*?)$"#)

    let source: String
}

struct PackageUpdatingCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Updating from (.*?)$"#)

    let source: String
}

struct PackageCheckingOutCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Checking out (.*?) of package (.*?)$"#)

    let version: String
    let package: String
}

struct PackageGraphResolvingStartCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^\s*Resolve Package Graph\s*$"#)
}

struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup {
    static let regex = Regex(pattern: #"^Resolved source packages:$"#)
}

struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    /// Regular expression captures groups:
    /// $1 = package name
    /// $2 = package url
    /// $3 = package version
    static let regex = Regex(pattern: #"^\s*([^\s:]+):\s([^ ]+)\s@\s(\d+\.\d+\.\d+)"#)

    let packageName: String
    let packageURL: String
    let packageVersion: String
}

struct XcodebuildErrorCaptureGroup: ErrorCaptureGroup {
    /// Regular expression captured groups:
    /// $1 = whole error
    static let regex = Regex(pattern: #"^(xcodebuild: error:.*)$"#)

    let wholeError: String
}

