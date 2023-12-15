import Foundation

public protocol CaptureGroup {
    static var outputType: OutputType { get }
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

struct EmptyCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .undefined
}

struct AnalyzeCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
    let fileName: String
    let target: String
}

struct BuildTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    let target: String
    let project: String
    let configuration: String
}

struct AggregateTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    let target: String
    let project: String
    let configuration: String
}

struct AnalyzeTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    let target: String
    let project: String
    let configuration: String
}

/// Nothing returned here for now
struct CheckDependenciesCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
 }

struct ShellCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let commandPath: String
    let arguments: String
}

struct CleanRemoveCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let directory: String
}

struct CleanTargetCaptureGroup: TargetCaptureGroup {
    static let outputType: OutputType = .task

    let target: String
    let project: String
    let configuration: String
}

struct CodesignCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let file: String
}

struct CodesignFrameworkCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let frameworkPath: String
}

struct CompileCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

#if !os(Linux)
    let filePath: String
#endif
    let filename: String
    let target: String
}

struct CompileCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let compilerCommand: String
    let filePath: String
}

struct CompileXibCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
    let filename: String
    let target: String
}

struct CompileStoryboardCaptureGroup: CompileFileCaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
    let filename: String
    let target: String
}

struct CopyHeaderCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let targetFile: String
    let target: String
}

struct CopyPlistCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let target: String
}

struct CopyStringsCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let target: String
}

struct CpresourceCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let target: String
}

struct ExecutedWithoutSkippedCaptureGroup: ExecutedCaptureGroup {
    static let outputType: OutputType = .undefined // FIXME

    let numberOfTests: Int
    let numberOfSkipped = 0
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct ExecutedWithSkippedCaptureGroup: ExecutedCaptureGroup {
    static let outputType: OutputType = .undefined // FIXME

    let numberOfTests: Int
    let numberOfSkipped: Int
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct FailingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let file: String
    let testSuite: String
    let testCase: String
    let reason: String
}

struct UIFailingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let file: String
    let reason: String
}

struct RestartingTestCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let testSuiteAndTestCase: String
    let testSuite: String
    let testCase: String
}

struct GenerateCoverageDataCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
 }

struct GeneratedCoverageReportCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let coverageReportFilePath: String
}

struct GenerateDSYMCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let dsym: String
    let target: String
}

struct LibtoolCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let fileName: String
    let target: String
}

struct LinkingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

#if !os(Linux)
    let binaryFilename: String
#endif
    let target: String
}

struct TestCasePassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
    let time: String
}

struct TestCaseStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
}

struct TestCasePendingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
}

struct TestCaseMeasuredCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
    let name: String
    let unitName: String
    let value: String
    let deviation: String
}

struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestCaseAppKitPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .testCase

    let suite: String
    let testCase: String
    let time: String
}

struct ParallelTestCaseFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestingStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let device: String
}

struct ParallelTestingPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let device: String
}

struct ParallelTestingFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .nonContextualError

    let device: String
}

struct ParallelTestSuiteStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let suite: String
    let device: String
}

struct PhaseSuccessCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result

    let phase: String
}

struct PhaseScriptExecutionCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let phaseName: String
    let target: String
}

struct ProcessPchCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let buildTarget: String
}

struct ProcessPchCommandCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
}

struct PreprocessCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let file: String
}

struct PbxcpCaptureGroup: CopyCaptureGroup {
    static let outputType: OutputType = .task

    let file: String
    let targetFile: String
    let target: String
}

struct ProcessInfoPlistCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
    let filename: String
    let target: String? // Xcode 10+
}

struct TestsRunCompletionCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let suite: String
    let result: String
    let time: String
}

struct TestSuiteStartedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let suite: String
    let time: String
}

struct TestSuiteStartCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .test

    let testSuiteName: String
}

struct TestSuiteAllTestsPassedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result // FIXME

 }

struct TestSuiteAllTestsFailedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .result // FIXME
 }

struct TIFFutilCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filename: String
}

struct TouchCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filename: String
    let target: String
}

struct WriteFileCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let filePath: String
}

struct WriteAuxiliaryFilesCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task
 }

struct CompileWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let filePath: String
    let filename: String
    let reason: String
}

struct LDWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let ldPrefix: String
    let warningMessage: String
}

struct GenericWarningCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let wholeWarning: String
}

struct WillNotBeCodeSignedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let wholeWarning: String
}

struct DuplicateLocalizedStringKeyCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let warningMessage: String
}

struct ClangErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct CheckDependenciesErrorsCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct ProvisioningProfileRequiredCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct NoCertificateCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .warning

    let wholeError: String
}

struct CompileErrorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let filePath: String
    let isFatalError: String
    let reason: String
}

struct CursorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let cursor: String
}

struct FatalErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct FileMissingErrorCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let reason: String
    let filePath: String
}

struct LDErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct LinkerDuplicateSymbolsLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct LinkerDuplicateSymbolsCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let reason: String
}

struct LinkerUndefinedSymbolLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let symbolLocation: String
}

struct LinkerUndefinedSymbolsCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let reason: String
}

struct PodsErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .error

    let reference: String
}

struct ModuleIncludesErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .warning

    let target: String
    let filename: String
}

struct PackageFetchingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let source: String
}

struct PackageUpdatingCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let source: String
}

struct PackageCheckingOutCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let version: String
    let package: String
}

struct PackageGraphResolvingStartCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

 }

struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

 }

struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    static let outputType: OutputType = .task

    let packageName: String
    let packageURL: String
    let packageVersion: String
}

struct XcodebuildErrorCaptureGroup: ErrorCaptureGroup {
    static let outputType: OutputType = .error

    let wholeError: String
}

