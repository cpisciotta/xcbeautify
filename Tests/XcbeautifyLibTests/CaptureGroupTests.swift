//
// CaptureGroupTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib
import XcLogParserLib

@Suite struct CaptureGroupTests {
    @Test func swiftCompiling() {
        let inputs = [
            #"SwiftCompile normal x86_64 Compiling\ BackyardBirdsDataContainer.swift,\ ColorData.swift,\ DataGeneration.swift,\ DataGenerationOptions.swift /Backyard-Birds/BackyardBirdsData/General/BackyardBirdsDataContainer.swift /Backyard-Birds/BackyardBirdsData/General/ColorData.swift /Backyard-Birds/BackyardBirdsData/General/DataGeneration.swift /Backyard-Birds/BackyardBirdsData/General/DataGenerationOptions.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal x86_64 Compiling\ BackyardSnapshot.swift,\ BackyardSupplies.swift,\ BackyardTimeOfDay.swift,\ BackyardTimeOfDayColors.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSnapshot.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSupplies.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDay.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDayColors.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ PlantSpecies.swift,\ PlantSpeciesInfo.swift,\ PassIdentifiers.swift,\ GeneratedAssetSymbols.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpecies.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpeciesInfo.swift /Backyard-Birds/BackyardBirdsData/Store/PassIdentifiers.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ resource_bundle_accessor.swift,\ Account+DataGeneration.swift,\ Account.swift,\ Backyard+DataGeneration.swift,\ Backyard.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/resource_bundle_accessor.swift /Backyard-Birds/BackyardBirdsData/Account/Account+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Account/Account.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
        ]

        for input in inputs {
            #expect(SwiftCompilingCaptureGroup.regex.captureGroups(for: input) != nil)
        }
    }

    @Test func matchCompilationResults() {
        let input = #"/* com.apple.actool.compilation-results */"#
        #expect(CompilationResultCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchAssetCatalog() throws {
        let input = #"CompileAssetCatalog /Backyard-Birds/Build/Products/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.bundle/Contents/Resources /Backyard-Birds/LayeredArtworkLibrary/Assets.xcassets (in target 'LayeredArtworkLibrary_LayeredArtworkLibrary' from project 'LayeredArtworkLibrary')"#
        let groups = try #require(CompileAssetCatalogCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/Backyard-Birds/Build/Products/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.bundle/Contents/Resources /Backyard-Birds/LayeredArtworkLibrary/Assets.xcassets")
        #expect(groups[1] == "LayeredArtworkLibrary_LayeredArtworkLibrary")
        #expect(groups[2] == "LayeredArtworkLibrary")
    }

    @Test func matchCompileXCStrings() throws {
        let input = #"CompileXCStrings /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings (in target 'BackyardBirdsData_BackyardBirdsData' from project 'BackyardBirdsData')"#
        let groups = try #require(CompileXCStringsCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings")
        #expect(groups[1] == "BackyardBirdsData_BackyardBirdsData")
        #expect(groups[2] == "BackyardBirdsData")
    }

    @Test func matchCreateBuildDirectory() throws {
        let input = "CreateBuildDirectory /Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug"
        let groups = try #require(CreateBuildDirectoryCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug")
    }

    @Test func matchCreateUniversalBinary() throws {
        let input = #"CreateUniversalBinary /Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o normal arm64\ x86_64 (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let groups = try #require(CreateUniversalBinaryCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o")
        #expect(groups[1] == "BackyardBirdsDataTarget")
        #expect(groups[2] == "BackyardBirdsDataProject")
    }

    @Test func matchDetectedEncoding() throws {
        let input = #"/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings:35:45: note: detected encoding of input file as Unicode (UTF-8) (in target 'BackyardBirdsUI_BackyardBirdsUI' from project 'BackyardBirdsUI')"#
        let groups = try #require(DetectedEncodingCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 6)
        #expect(groups[0] == "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings")
        #expect(groups[1] == "35")
        #expect(groups[2] == "45")
        #expect(groups[3] == "Unicode (UTF-8)")
        #expect(groups[4] == "BackyardBirdsUI_BackyardBirdsUI")
        #expect(groups[5] == "BackyardBirdsUI")
    }

    @Test func matchExtractAppIntentsMetadata() throws {
        let input = "ExtractAppIntentsMetadata (in target 'Target' from project 'Project')"
        let groups = try #require(ExtractAppIntentsMetadataCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 2)
        #expect(groups[0] == "Target")
        #expect(groups[1] == "Project")
    }

    @Test func matchFileMissingError() throws {
        let input = #"<unknown>:0: error: no such file or directory: '/path/file.swift'"#
        let groups = try #require(FileMissingErrorCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "/path/file.swift")
    }

    @Test func matchGenerateAssetSymbols() throws {
        let input = #"GenerateAssetSymbols /Backyard-Birds/Widgets/Assets.xcassets (in target 'Widgets' from project 'Backyard Birds')"#
        let groups = try #require(GenerateAssetSymbolsCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/Backyard-Birds/Widgets/Assets.xcassets")
        #expect(groups[1] == "Widgets")
        #expect(groups[2] == "Backyard Birds")
    }

    #if os(macOS)
    @Test func matchLdCaptureGroup() throws {
        let input = #"Ld /path/to/output/DerivedData/Build/Products/Debug-iphonesimulator/output.o normal (in target 'Target' from project 'Project')"#
        let groups = try #require(LinkingCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 2)
        #expect(groups[0] == "output.o")
        #expect(groups[1] == "Target")
    }
    #endif

    @Test func matchLDWarningCaptureGroup() throws {
        let input = #"ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"#
        let groups = try #require(LDWarningCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "embedded dylibs/frameworks only run on iOS 8 or later")
    }

    @Test func matchSwiftDriverJobDiscoveryEmittingModule() {
        let input = #"SwiftDriverJobDiscovery normal arm64 Emitting module for Widgets (in target 'Widgets' from project 'Backyard Birds')"#
        #expect(SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSymLink() throws {
        let input = "SymLink /Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Resources Versions/Current/Resources (in target 'Some Target_Value' from project 'LayeredArtworkLibrary')"
        let groups = try #require(SymLinkCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Resources Versions/Current/Resources")
        #expect(groups[1] == "Some Target_Value")
        #expect(groups[2] == "LayeredArtworkLibrary")
    }

    @Test func mkDirCaptureGroup() throws {
        let input = "MkDir /Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents (in target \'Widgets\' from project \'Backyard Birds\')"
        #expect(MkDirCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func precompileModule() throws {
        let input = "PrecompileModule /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan"
        let groups = try #require(PrecompileModuleCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "/Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan")
    }

    @Test func scanDependencies() throws {
        let input = #"ScanDependencies /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-ABC123.o /Users/Some/Other-Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-DEF456.m normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SomeTarget' from project 'SomeProject')"#
        let groups = try #require(ScanDependenciesCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "x86_64")
        #expect(groups[1] == "SomeTarget")
        #expect(groups[2] == "SomeProject")
    }

    @Test func signing() throws {
        let input = "Signing Some+File.bundle (in target 'Target' from project 'Project')"
        let groups = try #require(SigningCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "Some+File.bundle")
        #expect(groups[1] == "Target")
        #expect(groups[2] == "Project")
    }

    @Test func swiftMergeGeneratedHeadersCaptureGroupCaptureGroup() throws {
        let input = #"SwiftMergeGeneratedHeaders /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/DerivedSources/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/arm64/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds-Swift.h (in target 'Backyard Birds Target' from project 'Backyard Birds Project')"#
        let groups = try #require(SwiftMergeGeneratedHeadersCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == #"/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/DerivedSources/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/arm64/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds-Swift.h"#)
        #expect(groups[1] == "Backyard Birds Target")
        #expect(groups[2] == "Backyard Birds Project")
    }

    @Test func uIFailingTestCaptureGroup() throws {
        let input = "    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>"
        let groups = try #require(UIFailingTestCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 2)
        #expect(groups[0] == "<unknown>:0")
        #expect(groups[1] == "App crashed in <external symbol>")
    }

    @Test func unindentedShellCommand() throws {
        let input = #"/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let groups = try #require(NonPCHClangCommandCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    @Test func validate() throws {
        let input = "Validate /path/to/DerivedData/Build/Products/Debug-iphonesimulator/some.app (in target 'Target' from project 'Project')"
        let groups = try #require(ValidateCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "/path/to/DerivedData/Build/Products/Debug-iphonesimulator/some.app")
        #expect(groups[1] == "Target")
        #expect(groups[2] == "Project")
    }

    @Test func validateEmbeddedBinary() throws {
        let input = #"ValidateEmbeddedBinary /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex (in target 'Backyard Birds Target' from project 'Backyard Birds Project')"#
        let groups = try #require(ValidateEmbeddedBinaryCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == #"/Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex"#)
        #expect(groups[1] == "Backyard Birds Target")
        #expect(groups[2] == "Backyard Birds Project")
    }

    @Test func xcodebuildError() throws {
        let input = #"xcodebuild: error: Existing file at -resultBundlePath "/output/file.xcresult""#
        let groups = try #require(XcodebuildErrorCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == input)
    }

    @Test func indentedShellCommand() throws {
        let input = #"    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let groups = try #require(NonPCHClangCommandCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 1)
        #expect(groups[0] == "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    @Test func registerExecutionPolicyException() throws {
        let input = #"RegisterExecutionPolicyException /path/to/output.o (in target 'Target' from project 'Project')"#
        let groups = try #require(RegisterExecutionPolicyExceptionCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 4)
        #expect(groups[0] == "/path/to/output.o")
        #expect(groups[1] == "output.o")
        #expect(groups[2] == "Target")
        #expect(groups[3] == "Project")
    }

    @Test func swiftEmitModule() throws {
        let input = #"SwiftEmitModule normal i386 Emitting\ module\ for\ CasePaths (in target 'CasePathsTarget' from project 'swift-case-paths')"#
        let groups = try #require(SwiftEmitModuleCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 4)
        #expect(groups[0] == "i386")
        #expect(groups[1] == "CasePaths")
        #expect(groups[2] == "CasePathsTarget")
        #expect(groups[3] == "swift-case-paths")
    }

    @Test func emitSwiftModule() throws {
        let input = #"EmitSwiftModule normal arm64 (in target 'Target' from project 'Project')"#
        let groups = try #require(EmitSwiftModuleCaptureGroup.regex.captureGroups(for: input))
        #expect(groups.count == 3)
        #expect(groups[0] == "arm64")
        #expect(groups[1] == "Target")
        #expect(groups[2] == "Project")
    }

    @Test func matchTestFailure() {
        let input = #"/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13: error: -[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget] : XCTAssertEqual failed: ("Optional("Aggregate target Be Aggro of project AggregateExample with configuration Debug")") is not equal to ("Optional("failing Aggregate target Be Aggro of project AggregateExample with configuration Debug")")"#
        #expect(FailingTestCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func negativeMatchTestFailureAsCompileError() {
        let input = #"/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13: error: -[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget] : XCTAssertEqual failed: ("Optional("Aggregate target Be Aggro of project AggregateExample with configuration Debug")") is not equal to ("Optional("failing Aggregate target Be Aggro of project AggregateExample with configuration Debug")")"#
        #expect(CompileErrorCaptureGroup.regex.captureGroups(for: input) == nil)
    }

    @Test func matchSwiftTestingTestRunStarted() {
        let input = "􀟈  Test run started."
        #expect(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSwiftTestingTestStarted() {
        let input = #"􀟈  Test "One Identifiable parameter" started."#
        #expect(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input) != nil)
        #expect(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input) == nil)
    }

    @Test func matchTestCaseWithRunInName() {
        let input = "􀟈  Test runnerStateScopedEventHandler() started."
        #expect(SwiftTestingTestStartedCaptureGroup.regex.captureGroups(for: input) != nil)
        #expect(SwiftTestingRunStartedCaptureGroup.regex.captureGroups(for: input) == nil)
    }

    @Test func matchSwitchTestingIssueCaptureGroup() {
        let input = #"􀢄  Test "Selected tests by ID" recorded an issue at PlanTests.swift:43:5: Expectation failed: !((plan.steps → [Testing.Runner.Plan.Step(test: Testing.Test(name: "SendableTests", displayName: nil, traits: [Testing.HiddenTrait()], sourceLocation: TestingTests/MiscellaneousTests.swift:62:2, containingTypeInfo: Optional(TestingTests.SendableTests), xcTestCompatibleSelector: nil, testCasesState: nil, parameters: nil, isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true))), Testing.Runner.Plan.Step(test: Testing.Test(name: "NestedSendableTests", displayName: nil, traits: [Testing.HiddenTrait(), Testing.HiddenTrait(), .namedConstant], sourceLocation: TestingTests/MiscellaneousTests.swift:81:4, containingTypeInfo: Optional(TestingTests.SendableTests.NestedSendableTests), xcTestCompatibleSelector: nil, testCasesState: nil, parameters: nil, isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true))), Testing.Runner.Plan.Step(test: Testing.Test(name: "succeeds()", displayName: nil, traits: [Testing.HiddenTrait(), Testing.HiddenTrait(), .namedConstant, Testing.HiddenTrait(), .anotherConstant], sourceLocation: TestingTests/MiscellaneousTests.swift:83:6, containingTypeInfo: Optional(TestingTests.SendableTests.NestedSendableTests), xcTestCompatibleSelector: nil, testCasesState: Optional(Testing.Test.(unknown context at $104958b84).TestCasesState.evaluated(Swift.AnySequence<Testing.Test.Case>(_box: Swift._SequenceBox<Testing.Test.Case.Generator<Swift.CollectionOfOne<()>>>))), parameters: Optional([]), isSynthesized: false), action: Testing.Runner.Plan.Action.run(options: Testing.Runner.Plan.Action.RunOptions(isParallelizationEnabled: true)))]).contains(where: { $0.test == outerTestType }) → true)"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) != nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) == nil)
    }

    @Test func matchSwiftTestingIssueArgument1() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "@Test(arguments: []) func f(f: () -> String) {}", expectedTypeName → "(() -> String).self", otherCode → nil at TestDeclarationMacroTests.swift:363:7: Expectation failed: !((output → "func f(f: () -> String) {}"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSwiftTestingIssueArgument2() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSwiftTestingIssueArgument3() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSwiftTestingIssueArgument4() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "final class C_NAME {"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) != nil)
    }

    @Test func matchSwiftTestingIssueArgument5() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        #expect(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input) == nil)
        #expect(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input) != nil)
    }
}
