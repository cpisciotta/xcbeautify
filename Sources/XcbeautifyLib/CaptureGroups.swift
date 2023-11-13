import Foundation

protocol CaptureGroup { }

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

struct EmptyCaptureGroup: CaptureGroup { }

struct AnalyzeCaptureGroup: CaptureGroup {
    let filePath: String
    let fileName: String
    let target: String
}

struct BuildTargetCaptureGroup: TargetCaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

struct AggregateTargetCaptureGroup: TargetCaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

struct AnalyzeTargetCaptureGroup: TargetCaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

/// Nothing returned here for now
struct CheckDependenciesCaptureGroup: CaptureGroup { }

struct ShellCommandCaptureGroup: CaptureGroup {
    let commandPath: String
    let arguments: String
}

struct CleanRemoveCaptureGroup: CaptureGroup {
    let directory: String
}

struct CleanTargetCaptureGroup: TargetCaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

struct CodesignCaptureGroup: CaptureGroup {
    let file: String
}

struct CodesignFrameworkCaptureGroup: CaptureGroup {
    let frameworkPath: String
}

struct CompileCaptureGroup: CompileFileCaptureGroup {
#if !os(Linux)
    let filePath: String
#endif
    let filename: String
    let target: String
}

struct CompileCommandCaptureGroup: CaptureGroup {
    let compilerCommand: String
    let filePath: String
}

struct CompileXibCaptureGroup: CompileFileCaptureGroup {
    let filePath: String
    let filename: String
    let target: String
}

struct CompileStoryboardCaptureGroup: CompileFileCaptureGroup {
    let filePath: String
    let filename: String
    let target: String
}

struct CopyHeaderCaptureGroup: CopyCaptureGroup {
    let file: String
    let targetFile: String
    let target: String
}

struct CopyPlistCaptureGroup: CopyCaptureGroup {
    let file: String
    let target: String
}

struct CopyStringsCaptureGroup: CopyCaptureGroup {
    let file: String
    let target: String
}

struct CpresourceCaptureGroup: CopyCaptureGroup {
    let file: String
    let target: String
}

struct ExecutedWithoutSkippedCaptureGroup: ExecutedCaptureGroup {
    let numberOfTests: Int
    let numberOfSkipped = 0
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct ExecutedWithSkippedCaptureGroup: ExecutedCaptureGroup {
    let numberOfTests: Int
    let numberOfSkipped: Int
    let numberOfFailures: Int
    let numberOfUnexpectedFailures: Int
    let wallClockTimeInSeconds: Double
}

struct FailingTestCaptureGroup: CaptureGroup {
    let file: String
    let testSuite: String
    let testCase: String
    let reason: String
}

struct UIFailingTestCaptureGroup: CaptureGroup {
    let file: String
    let reason: String
}

struct RestartingTestCaptureGroup: CaptureGroup {
    let testSuiteAndTestCase: String
    let testSuite: String
    let testCase: String
}

struct GenerateCoverageDataCaptureGroup: CaptureGroup { }

struct GeneratedCoverageReportCaptureGroup: CaptureGroup {
    let coverageReportFilePath: String
}

struct GenerateDSYMCaptureGroup: CaptureGroup {
    let dsym: String
    let target: String
}

struct LibtoolCaptureGroup: CaptureGroup {
    let fileName: String
    let target: String
}

struct LinkingCaptureGroup: CaptureGroup {
#if !os(Linux)
    let binaryFilename: String
#endif
    let target: String
}

struct TestCasePassedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let time: String
}

struct TestCaseStartedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
}

struct TestCasePendingCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
}

struct TestCaseMeasuredCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let name: String
    let unitName: String
    let value: String
    let deviation: String
}

struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestCaseAppKitPassedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let time: String
}

struct ParallelTestCaseFailedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let device: String
    let time: String
}

struct ParallelTestingStartedCaptureGroup: CaptureGroup {
    let device: String
}

struct ParallelTestingPassedCaptureGroup: CaptureGroup {
    let device: String
}

struct ParallelTestingFailedCaptureGroup: CaptureGroup {
    let device: String
}

struct ParallelTestSuiteStartedCaptureGroup: CaptureGroup {
    let suite: String
    let device: String
}

struct PhaseSuccessCaptureGroup: CaptureGroup {
    let phase: String
}

struct PhaseScriptExecutionCaptureGroup: CaptureGroup {
    let phaseName: String
    let target: String
}

struct ProcessPchCaptureGroup: CaptureGroup {
    let file: String
    let buildTarget: String
}

struct ProcessPchCommandCaptureGroup: CaptureGroup {
    let filePath: String
}

struct PreprocessCaptureGroup: CaptureGroup {
    let file: String
}

struct PbxcpCaptureGroup: CopyCaptureGroup {
    let file: String
    let targetFile: String
    let target: String
}

struct ProcessInfoPlistCaptureGroup: CaptureGroup {
    let filePath: String
    let filename: String
    let target: String? // Xcode 10+
}

struct TestsRunCompletionCaptureGroup: CaptureGroup {
    let suite: String
    let result: String
    let time: String
}

struct TestSuiteStartedCaptureGroup: CaptureGroup {
    let suite: String
    let time: String
}

struct TestSuiteStartCaptureGroup: CaptureGroup {
    let testSuiteName: String
}

struct TestSuiteAllTestsPassedCaptureGroup: CaptureGroup { }

struct TestSuiteAllTestsFailedCaptureGroup: CaptureGroup { }

struct TIFFutilCaptureGroup: CaptureGroup {
    let filename: String
}

struct TouchCaptureGroup: CaptureGroup {
    let filename: String
    let target: String
}

struct WriteFileCaptureGroup: CaptureGroup {
    let filePath: String
}

struct WriteAuxiliaryFilesCaptureGroup: CaptureGroup { }

struct CompileWarningCaptureGroup: CaptureGroup {
    let filePath: String
    let filename: String
    let reason: String
}

struct LDWarningCaptureGroup: CaptureGroup {
    let ldPrefix: String
    let warningMessage: String
}

struct GenericWarningCaptureGroup: CaptureGroup {
    let wholeWarning: String
}

struct WillNotBeCodeSignedCaptureGroup: CaptureGroup {
    let wholeWarning: String
}

struct DuplicateLocalizedStringKeyCaptureGroup: CaptureGroup {
    let warningMessage: String
}

struct ClangErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct CheckDependenciesErrorsCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct ProvisioningProfileRequiredCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct NoCertificateCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct CompileErrorCaptureGroup: CaptureGroup {
    let filePath: String
    let isFatalError: String
    let reason: String
}

struct CursorCaptureGroup: CaptureGroup {
    let cursor: String
}

struct FatalErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct FileMissingErrorCaptureGroup: CaptureGroup {
    let reason: String
    let filePath: String
}

struct LDErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct LinkerDuplicateSymbolsLocationCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct LinkerDuplicateSymbolsCaptureGroup: CaptureGroup {
    let reason: String
}

struct LinkerUndefinedSymbolLocationCaptureGroup: CaptureGroup {
    let symbolLocation: String
}

struct LinkerUndefinedSymbolsCaptureGroup: CaptureGroup {
    let reason: String
}

struct PodsErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    let reference: String
}

struct ModuleIncludesErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    let target: String
    let filename: String
}

struct PackageFetchingCaptureGroup: CaptureGroup {
    let source: String
}

struct PackageUpdatingCaptureGroup: CaptureGroup {
    let source: String
}

struct PackageCheckingOutCaptureGroup: CaptureGroup {
    let version: String
    let package: String
}

struct PackageGraphResolvingStartCaptureGroup: CaptureGroup { }

struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup { }

struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    let packageName: String
    let packageURL: String
    let packageVersion: String
}

struct XcodebuildErrorCaptureGroup: ErrorCaptureGroup {
    let wholeError: String
}

