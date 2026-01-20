//
// Parser.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

/// Maps raw `xcodebuild` output to a `CaptureGroup`.
public final class Parser {
    private lazy var captureGroupTypes: [any CaptureGroup.Type] = [
        // START SORT
        AggregateTargetCaptureGroup.self,
        AnalyzeCaptureGroup.self,
        AnalyzeTargetCaptureGroup.self,
        BuildTargetCaptureGroup.self,
        CheckDependenciesCaptureGroup.self,
        CheckDependenciesErrorsCaptureGroup.self,
        ClangErrorCaptureGroup.self,
        CleanRemoveCaptureGroup.self,
        CleanTargetCaptureGroup.self,
        CodesignCaptureGroup.self,
        CodesignFrameworkCaptureGroup.self,
        CompilationResultCaptureGroup.self,
        CompileAssetCatalogCaptureGroup.self,
        CompileCaptureGroup.self,
        CompileCommandCaptureGroup.self,
        CompileErrorCaptureGroup.self,
        CompileStoryboardCaptureGroup.self,
        CompileWarningCaptureGroup.self,
        CompileXCStringsCaptureGroup.self,
        CompileXibCaptureGroup.self,
        CopyFilesCaptureGroup.self,
        CopyHeaderCaptureGroup.self,
        CopyPlistCaptureGroup.self,
        CopyStringsCaptureGroup.self,
        CpresourceCaptureGroup.self,
        CreateBuildDirectoryCaptureGroup.self,
        CreateUniversalBinaryCaptureGroup.self,
        CursorCaptureGroup.self,
        DataModelCodegenCaptureGroup.self,
        DetectedEncodingCaptureGroup.self,
        DuplicateLocalizedStringKeyCaptureGroup.self,
        EmitSwiftModuleCaptureGroup.self,
        ExecutedWithoutSkippedCaptureGroup.self,
        ExecutedWithSkippedCaptureGroup.self,
        ExplicitDependencyCaptureGroup.self,
        ExtractAppIntentsMetadataCaptureGroup.self,
        FailingTestCaptureGroup.self,
        FatalErrorCaptureGroup.self,
        FileMissingErrorCaptureGroup.self,
        GenerateAssetSymbolsCaptureGroup.self,
        GenerateCoverageDataCaptureGroup.self,
        GeneratedCoverageReportCaptureGroup.self,
        GenerateDSYMCaptureGroup.self,
        GenericWarningCaptureGroup.self,
        LDErrorCaptureGroup.self,
        LDWarningCaptureGroup.self,
        LibtoolCaptureGroup.self,
        LinkerDuplicateSymbolsCaptureGroup.self,
        LinkerUndefinedSymbolLocationCaptureGroup.self,
        LinkerUndefinedSymbolsCaptureGroup.self,
        LinkingCaptureGroup.self,
        MkDirCaptureGroup.self,
        ModuleIncludesErrorCaptureGroup.self,
        NoCertificateCaptureGroup.self,
        NonPCHClangCommandCaptureGroup.self,
        NoteCaptureGroup.self,
        PackageCheckingOutCaptureGroup.self,
        PackageFetchingCaptureGroup.self,
        PackageGraphResolvedItemCaptureGroup.self,
        PackageGraphResolvingEndedCaptureGroup.self,
        PackageGraphResolvingStartCaptureGroup.self,
        PackageUpdatingCaptureGroup.self,
        ParallelTestCaseAppKitPassedCaptureGroup.self,
        ParallelTestCaseFailedCaptureGroup.self,
        ParallelTestCasePassedCaptureGroup.self,
        ParallelTestCaseSkippedCaptureGroup.self,
        ParallelTestingFailedCaptureGroup.self,
        ParallelTestingPassedCaptureGroup.self,
        ParallelTestingStartedCaptureGroup.self,
        ParallelTestSuiteStartedCaptureGroup.self,
        PbxcpCaptureGroup.self,
        PhaseScriptExecutionCaptureGroup.self,
        PhaseSuccessCaptureGroup.self,
        PodsErrorCaptureGroup.self,
        PrecompileModuleCaptureGroup.self,
        PreprocessCaptureGroup.self,
        ProcessInfoPlistCaptureGroup.self,
        ProcessPchCaptureGroup.self,
        ProcessPchCommandCaptureGroup.self,
        ProvisioningProfileRequiredCaptureGroup.self,
        RegisterExecutionPolicyExceptionCaptureGroup.self,
        RestartingTestCaptureGroup.self,
        ScanDependenciesCaptureGroup.self,
        ShellCommandCaptureGroup.self,
        SigningCaptureGroup.self,
        SwiftCompileCaptureGroup.self,
        SwiftCompilingCaptureGroup.self,
        SwiftDriverCompilationRequirementsCaptureGroup.self,
        SwiftDriverCompilationTarget.self,
        SwiftDriverJobDiscoveryCompilingCaptureGroup.self,
        SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.self,
        SwiftDriverTargetCaptureGroup.self,
        SwiftEmitModuleCaptureGroup.self,
        SwiftMergeGeneratedHeadersCaptureGroup.self,
        SwiftTestingIssueArgumentCaptureGroup.self,
        SwiftTestingIssueCaptureGroup.self,
        SwiftTestingPassingArgumentCaptureGroup.self,
        SwiftTestingRunCompletionCaptureGroup.self,
        SwiftTestingRunFailedCaptureGroup.self,
        SwiftTestingRunStartedCaptureGroup.self,
        SwiftTestingSuiteFailedCaptureGroup.self,
        SwiftTestingSuitePassedCaptureGroup.self,
        SwiftTestingSuiteStartedCaptureGroup.self,
        SwiftTestingTestFailedCaptureGroup.self,
        SwiftTestingTestPassedCaptureGroup.self,
        SwiftTestingTestSkippedCaptureGroup.self,
        SwiftTestingTestSkippedReasonCaptureGroup.self,
        SwiftTestingTestStartedCaptureGroup.self,
        SymbolReferencedFromCaptureGroup.self,
        SymLinkCaptureGroup.self,
        TestCaseMeasuredCaptureGroup.self,
        TestCasePassedCaptureGroup.self,
        TestCaseSkippedCaptureGroup.self,
        TestCaseStartedCaptureGroup.self,
        TestingStartedCaptureGroup.self,
        TestsRunCompletionCaptureGroup.self,
        TestSuiteAllTestsFailedCaptureGroup.self,
        TestSuiteAllTestsPassedCaptureGroup.self,
        TestSuiteStartedCaptureGroup.self,
        TIFFutilCaptureGroup.self,
        TouchCaptureGroup.self,
        UIFailingTestCaptureGroup.self,
        UndefinedSymbolLocationCaptureGroup.self,
        ValidateCaptureGroup.self,
        ValidateEmbeddedBinaryCaptureGroup.self,
        WillNotBeCodeSignedCaptureGroup.self,
        WriteAuxiliaryFileCaptureGroup.self,
        WriteFileCaptureGroup.self,
        XcodebuildErrorCaptureGroup.self,
        // END SORT
    ]

    #if DEBUG
    public func __for_test__captureGroupTypes() -> [any CaptureGroup.Type] {
        captureGroupTypes
    }
    #endif

    // MARK: - Init

    public init() { }

    /// Maps raw `xcodebuild` output to a `CaptureGroup`.
    /// - Parameter line: The raw `xcodebuild` output.
    /// - Returns: The `CaptureGroup` if `line` is recognized. Otherwise, `nil`.
    public func parse(line: String) -> (any CaptureGroup)? {
        if line.isEmpty {
            return nil
        }

        for (index, captureGroupType) in captureGroupTypes.enumerated() {
            guard let groups = captureGroupType.regex.captureGroups(for: line) else { continue }

            guard let captureGroup = captureGroupType.init(groups: groups) else {
                assertionFailure()
                return nil
            }

            // Move found parser to the top, so next time it will be checked first
            captureGroupTypes.insert(captureGroupTypes.remove(at: index), at: 0)

            return captureGroup
        }

        return nil
    }
}
