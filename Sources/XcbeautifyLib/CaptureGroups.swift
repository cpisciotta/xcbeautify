import Foundation

protocol CaptureGroup { }

struct EmptyCaptureGroup: CaptureGroup { }

struct AnalyzeCaptureGroup: CaptureGroup {
    let filePath: String
    let fileName: String
    let target: String
}

struct BuildTargetCaptureGroup: CaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

struct AggregateTargetCaptureGroup: CaptureGroup {
    let target: String
    let project: String
    let configuration: String
}

struct AnalyzeTargetCaptureGroup: CaptureGroup {
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

struct CleanTargetCaptureGroup: CaptureGroup {
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

#if os(Linux)
struct CompileCaptureGroup: CaptureGroup {
    let filename: String
    let target: String
}
#else
struct CompileCaptureGroup: CaptureGroup {
    let filePath: String
    let filename: String
    let target: String
}
#endif

struct CompileCommandCaptureGroup: CaptureGroup {
    let compilerCommand: String
    let filePath: String
}

struct CompileXibCaptureGroup: CaptureGroup {
    let filePath: String
    let filename: String
    let target: String
}

struct CompileStoryboardCaptureGroup: CaptureGroup {
    let filePath: String
    let filename: String
    let target: String
}

struct CopyHeaderCaptureGroup: CaptureGroup {
    let sourceFile: String
    let targetFile: String
    let target: String
}

struct CopyPlistCaptureGroup: CaptureGroup {
    let sourceFile: String
    let targetFile: String
}

struct CopyStringsCaptureGroup: CaptureGroup {
    let file: String
}

struct CpresourceCaptureGroup: CaptureGroup {
    let resource: String
}

struct ExecutedCaptureGroup: CaptureGroup {
    let numberOfTests: String
    let numberOfFailures: String
    let numberOfUnexpectedFailures: String
    let wallClockTimeInSeconds: String
}

struct ExecutedWithSkippedCaptureGroup: CaptureGroup {
    let numberOfTests: String
    let numberOfSkipped: String
    let numberOfFailures: String
    let numberOfUnexpectedFailures: String
    let wallClockTimeInSeconds: String
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
    let time: String
}

struct ParallelTestCasePassedCaptureGroup: CaptureGroup {
    let suite: String
    let testCase: String
    let installedAppFileAndID: String
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
    let installedAppFileAndID: String
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

struct PhaseSuccessCaptureGroup: CaptureGroup { }

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

struct PbxcpCaptureGroup: CaptureGroup {
    let sourceFile: String
    let targetFile: String
    let buildTarget: String
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

struct ClangErrorCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct CheckDependenciesErrorsCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct ProvisioningProfileRequiredCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct NoCertificateCaptureGroup: CaptureGroup {
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

struct FatalErrorCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct FileMissingErrorCaptureGroup: CaptureGroup {
    let wholeError: String
    let filePath: String
}

struct LDErrorCaptureGroup: CaptureGroup {
    let wholeError: String
}

struct LinkerDuplicateSymbolsLocationCaptureGroup: CaptureGroup {
    let filePath: String
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

struct PodsErrorCaptureGroup: CaptureGroup {
    let reason: String
}

struct SymbolReferencedFromCaptureGroup: CaptureGroup {
    let reference: String
}

struct ModuleIncludesErrorCaptureGroup: CaptureGroup {
    let errorReason: String
}

struct UndefinedSymbolLocationCaptureGroup: CaptureGroup {
    let target: String
    let filename: String
}

struct PackageFetchingCaptureGroup: CaptureGroup { }

struct PackageUpdatingCaptureGroup: CaptureGroup { }

struct PackageCheckingOutCaptureGroup: CaptureGroup { }

struct PackageGraphResolvingStartCaptureGroup: CaptureGroup { }

struct PackageGraphResolvingEndedCaptureGroup: CaptureGroup { }

struct PackageGraphResolvedItemCaptureGroup: CaptureGroup {
    let packageName: String
    let packageURL: String
    let packageVersion: String
}

struct XcodebuildErrorCaptureGroup: CaptureGroup {
    let wholeError: String
}

