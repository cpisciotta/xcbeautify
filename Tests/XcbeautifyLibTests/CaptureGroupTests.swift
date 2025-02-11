//
//  CaptureGroupTests.swift
//
//
//  Created by Charles Pisciotta on 2/25/24.
//

import XCTest
@testable import XcbeautifyLib

final class CaptureGroupTests: XCTestCase {
    func testSwiftCompiling() {
        let inputs = [
            #"SwiftCompile normal x86_64 Compiling\ BackyardBirdsDataContainer.swift,\ ColorData.swift,\ DataGeneration.swift,\ DataGenerationOptions.swift /Backyard-Birds/BackyardBirdsData/General/BackyardBirdsDataContainer.swift /Backyard-Birds/BackyardBirdsData/General/ColorData.swift /Backyard-Birds/BackyardBirdsData/General/DataGeneration.swift /Backyard-Birds/BackyardBirdsData/General/DataGenerationOptions.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal x86_64 Compiling\ BackyardSnapshot.swift,\ BackyardSupplies.swift,\ BackyardTimeOfDay.swift,\ BackyardTimeOfDayColors.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSnapshot.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSupplies.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDay.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDayColors.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ PlantSpecies.swift,\ PlantSpeciesInfo.swift,\ PassIdentifiers.swift,\ GeneratedAssetSymbols.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpecies.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpeciesInfo.swift /Backyard-Birds/BackyardBirdsData/Store/PassIdentifiers.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ resource_bundle_accessor.swift,\ Account+DataGeneration.swift,\ Account.swift,\ Backyard+DataGeneration.swift,\ Backyard.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/resource_bundle_accessor.swift /Backyard-Birds/BackyardBirdsData/Account/Account+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Account/Account.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
        ]

        for input in inputs {
            XCTAssertNotNil(SwiftCompilingCaptureGroup.regex.captureGroups(for: input))
        }
    }

    func testMatchCompilationResults() {
        let input = #"/* com.apple.actool.compilation-results */"#
        XCTAssertNotNil(CompilationResultCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchCompileXCStrings() throws {
        let input = #"CompileXCStrings /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings (in target 'BackyardBirdsData_BackyardBirdsData' from project 'BackyardBirdsData')"#
        let groups = try XCTUnwrap(CompileXCStringsCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings")
        XCTAssertEqual(groups[1], "BackyardBirdsData_BackyardBirdsData")
        XCTAssertEqual(groups[2], "BackyardBirdsData")
    }

    func testMatchCreateUniversalBinary() throws {
        let input = #"CreateUniversalBinary /Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o normal arm64\ x86_64 (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let groups = try XCTUnwrap(CreateUniversalBinaryCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o")
        XCTAssertEqual(groups[1], "BackyardBirdsDataTarget")
        XCTAssertEqual(groups[2], "BackyardBirdsDataProject")
    }

    func testMatchDetectedEncoding() throws {
        let input = #"/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings:35:45: note: detected encoding of input file as Unicode (UTF-8) (in target 'BackyardBirdsUI_BackyardBirdsUI' from project 'BackyardBirdsUI')"#
        let groups = try XCTUnwrap(DetectedEncodingCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 6)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings")
        XCTAssertEqual(groups[1], "35")
        XCTAssertEqual(groups[2], "45")
        XCTAssertEqual(groups[3], "Unicode (UTF-8)")
        XCTAssertEqual(groups[4], "BackyardBirdsUI_BackyardBirdsUI")
        XCTAssertEqual(groups[5], "BackyardBirdsUI")
    }

    #if os(macOS)
    func testMatchLdCaptureGroup() throws {
        let input = #"Ld /path/to/output/DerivedData/Build/Products/Debug-iphonesimulator/output.o normal (in target 'Target' from project 'Project')"#
        let groups = try XCTUnwrap(LinkingCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 2)
        XCTAssertEqual(groups[0], "output.o")
        XCTAssertEqual(groups[1], "Target")
    }
    #endif

    func testMatchSwiftDriverJobDiscoveryEmittingModule() {
        let input = #"SwiftDriverJobDiscovery normal arm64 Emitting module for Widgets (in target 'Widgets' from project 'Backyard Birds')"#
        XCTAssertNotNil(SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.regex.captureGroups(for: input))
    }

    func testMkDirCaptureGroup() throws {
        let input = "MkDir /Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents (in target \'Widgets\' from project \'Backyard Birds\')"
        XCTAssertNotNil(MkDirCaptureGroup.regex.captureGroups(for: input))
    }

    func testPrecompileModule() throws {
        let input = "PrecompileModule /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan"
        let groups = try XCTUnwrap(PrecompileModuleCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan")
    }

    func testScanDependencies() throws {
        let input = #"ScanDependencies /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-ABC123.o /Users/Some/Other-Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-DEF456.m normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SomeTarget' from project 'SomeProject')"#
        let groups = try XCTUnwrap(ScanDependenciesCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "x86_64")
        XCTAssertEqual(groups[1], "SomeTarget")
        XCTAssertEqual(groups[2], "SomeProject")
    }

    func testSigning() throws {
        let input = "Signing Some+File.bundle (in target 'Target' from project 'Project')"
        let groups = try XCTUnwrap(SigningCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "Some+File.bundle")
        XCTAssertEqual(groups[1], "Target")
        XCTAssertEqual(groups[2], "Project")
    }

    func testSwiftMergeGeneratedHeadersCaptureGroupCaptureGroup() throws {
        let input = #"SwiftMergeGeneratedHeaders /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/DerivedSources/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/arm64/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds-Swift.h (in target 'Backyard Birds Target' from project 'Backyard Birds Project')"#
        let groups = try XCTUnwrap(SwiftMergeGeneratedHeadersCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], #"/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/DerivedSources/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/arm64/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds-Swift.h"#)
        XCTAssertEqual(groups[1], "Backyard Birds Target")
        XCTAssertEqual(groups[2], "Backyard Birds Project")
    }

    func testUnindentedShellCommand() throws {
        let input = #"/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let groups = try XCTUnwrap(NonPCHClangCommandCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    func testIndentedShellCommand() throws {
        let input = #"    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let groups = try XCTUnwrap(NonPCHClangCommandCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    func testRegisterExecutionPolicyException() throws {
        let input = #"RegisterExecutionPolicyException /path/to/output.o (in target 'Target' from project 'Project')"#
        let groups = try XCTUnwrap(RegisterExecutionPolicyExceptionCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 4)
        XCTAssertEqual(groups[0], "/path/to/output.o")
        XCTAssertEqual(groups[1], "output.o")
        XCTAssertEqual(groups[2], "Target")
        XCTAssertEqual(groups[3], "Project")
    }

    func testSwiftEmitModule() throws {
        let input = #"SwiftEmitModule normal i386 Emitting\ module\ for\ CasePaths (in target 'CasePathsTarget' from project 'swift-case-paths')"#
        let groups = try XCTUnwrap(SwiftEmitModuleCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 4)
        XCTAssertEqual(groups[0], "i386")
        XCTAssertEqual(groups[1], "CasePaths")
        XCTAssertEqual(groups[2], "CasePathsTarget")
        XCTAssertEqual(groups[3], "swift-case-paths")
    }

    func testEmitSwiftModule() throws {
        let input = #"EmitSwiftModule normal arm64 (in target 'Target' from project 'Project')"#
        let groups = try XCTUnwrap(EmitSwiftModuleCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "arm64")
        XCTAssertEqual(groups[1], "Target")
        XCTAssertEqual(groups[2], "Project")
    }

    func testMatchTestFailure() {
        let input = #"/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13: error: -[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget] : XCTAssertEqual failed: ("Optional("Aggregate target Be Aggro of project AggregateExample with configuration Debug")") is not equal to ("Optional("failing Aggregate target Be Aggro of project AggregateExample with configuration Debug")")"#
        XCTAssertNotNil(FailingTestCaptureGroup.regex.captureGroups(for: input))
    }

    func testNegativeMatchTestFailureAsCompileError() {
        let input = #"/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13: error: -[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget] : XCTAssertEqual failed: ("Optional("Aggregate target Be Aggro of project AggregateExample with configuration Debug")") is not equal to ("Optional("failing Aggregate target Be Aggro of project AggregateExample with configuration Debug")")"#
        XCTAssertNil(CompileErrorCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingTestRunStarted() {
        let input = "􀟈  Test run started."
        XCTAssertNil(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingTestStarted() {
        let input = #"􀟈  Test "One Identifiable parameter" started."#
        XCTAssertNotNil(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNil(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchTestCaseWithRunInName() {
        let input = "􀟈  Test runnerStateScopedEventHandler() started."
        XCTAssertNotNil(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNil(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwitchTestingIssueCaptureGroup() {
        let input = #"􀢄  Test "Selected tests by ID" recorded an issue at PlanTests.swift:43:5: Expectation failed: !((plan.steps → [Testing.Runner.Plan.Step(test: Testing.Test(name: "SendableTests", displayName: nil, traits: [Testing.HiddenTrait()], sourceLocation: TestingTests/MiscellaneousTests.swift:62:2, containingTypeInfo: Optional(TestingTests.SendableTests), xcTestCompatibleSelector: nil, testCasesState: nil, parameters: nil, isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true))), Testing.Runner.Plan.Step(test: Testing.Test(name: "NestedSendableTests", displayName: nil, traits: [Testing.HiddenTrait(), Testing.HiddenTrait(), .namedConstant], sourceLocation: TestingTests/MiscellaneousTests.swift:81:4, containingTypeInfo: Optional(TestingTests.SendableTests.NestedSendableTests), xcTestCompatibleSelector: nil, testCasesState: nil, parameters: nil, isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true))), Testing.Runner.Plan.Step(test: Testing.Test(name: "succeeds()", displayName: nil, traits: [Testing.HiddenTrait(), Testing.HiddenTrait(), .namedConstant, Testing.HiddenTrait(), .anotherConstant], sourceLocation: TestingTests/MiscellaneousTests.swift:83:6, containingTypeInfo: Optional(TestingTests.SendableTests.NestedSendableTests), xcTestCompatibleSelector: nil, testCasesState: Optional(Testing.Test.(unknown context at $104958b84).TestCasesState.evaluated(Swift.AnySequence<Testing.Test.Case>(_box: Swift._SequenceBox<Testing.Test.Case.Generator<Swift.CollectionOfOne<()>>>))), parameters: Optional([]), isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true)))]).contains(where: { $0.test == outerTestType }) → true)"#
        XCTAssertNotNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument1() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "@Test(arguments: []) func f(f: () -> String) {}", expectedTypeName → "(() -> String).self", otherCode → nil at TestDeclarationMacroTests.swift:363:7: Expectation failed: !((output → "func f(f: () -> String) {}"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument2() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument3() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument4() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "final class C_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument5() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }
}
