//
// CaptureGroupTests.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
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

    func testMatchAssetCatalog() throws {
        let input = #"CompileAssetCatalog /Backyard-Birds/Build/Products/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.bundle/Contents/Resources /Backyard-Birds/LayeredArtworkLibrary/Assets.xcassets (in target 'LayeredArtworkLibrary_LayeredArtworkLibrary' from project 'LayeredArtworkLibrary')"#
        let groups = try XCTUnwrap(CompileAssetCatalogCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Products/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.bundle/Contents/Resources /Backyard-Birds/LayeredArtworkLibrary/Assets.xcassets")
        XCTAssertEqual(groups[1], "LayeredArtworkLibrary_LayeredArtworkLibrary")
        XCTAssertEqual(groups[2], "LayeredArtworkLibrary")
    }

    func testMatchCompileXCStrings() throws {
        let input = #"CompileXCStrings /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings (in target 'BackyardBirdsData_BackyardBirdsData' from project 'BackyardBirdsData')"#
        let groups = try XCTUnwrap(CompileXCStringsCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings")
        XCTAssertEqual(groups[1], "BackyardBirdsData_BackyardBirdsData")
        XCTAssertEqual(groups[2], "BackyardBirdsData")
    }

    func testMatchCreateBuildDirectory() throws {
        let input = "CreateBuildDirectory /Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug"
        let groups = try XCTUnwrap(CreateBuildDirectoryCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug")
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

    func testMatchExtractAppIntentsMetadata() throws {
        let input = "ExtractAppIntentsMetadata (in target 'Target' from project 'Project')"
        let groups = try XCTUnwrap(ExtractAppIntentsMetadataCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 2)
        XCTAssertEqual(groups[0], "Target")
        XCTAssertEqual(groups[1], "Project")
    }

    func testMatchFileMissingError() throws {
        let input = #"<unknown>:0: error: no such file or directory: '/path/file.swift'"#
        let groups = try XCTUnwrap(FileMissingErrorCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/path/file.swift")
    }

    func testMatchGenerateAssetSymbols() throws {
        let input = #"GenerateAssetSymbols /Backyard-Birds/Widgets/Assets.xcassets (in target 'Widgets' from project 'Backyard Birds')"#
        let groups = try XCTUnwrap(GenerateAssetSymbolsCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Widgets/Assets.xcassets")
        XCTAssertEqual(groups[1], "Widgets")
        XCTAssertEqual(groups[2], "Backyard Birds")
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

    func testMatchLDWarningCaptureGroup() throws {
        let input = #"ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"#
        let groups = try XCTUnwrap(LDWarningCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "embedded dylibs/frameworks only run on iOS 8 or later")
    }

    func testMatchSwiftDriverJobDiscoveryEmittingModule() {
        let input = #"SwiftDriverJobDiscovery normal arm64 Emitting module for Widgets (in target 'Widgets' from project 'Backyard Birds')"#
        XCTAssertNotNil(SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSymLink() throws {
        let input = "SymLink /Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Resources Versions/Current/Resources (in target 'Some Target_Value' from project 'LayeredArtworkLibrary')"
        let groups = try XCTUnwrap(SymLinkCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Resources Versions/Current/Resources")
        XCTAssertEqual(groups[1], "Some Target_Value")
        XCTAssertEqual(groups[2], "LayeredArtworkLibrary")
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

    func testUIFailingTestCaptureGroup() throws {
        let input = "    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>"
        let groups = try XCTUnwrap(UIFailingTestCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 2)
        XCTAssertEqual(groups[0], "<unknown>:0")
        XCTAssertEqual(groups[1], "App crashed in <external symbol>")
    }

    func testUnindentedShellCommand() throws {
        let input = #"/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let groups = try XCTUnwrap(NonPCHClangCommandCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], "/Applications/Xcode-16.0.1.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    func testValidate() throws {
        let input = "Validate /path/to/DerivedData/Build/Products/Debug-iphonesimulator/some.app (in target 'Target' from project 'Project')"
        let groups = try XCTUnwrap(ValidateCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], "/path/to/DerivedData/Build/Products/Debug-iphonesimulator/some.app")
        XCTAssertEqual(groups[1], "Target")
        XCTAssertEqual(groups[2], "Project")
    }

    func testValidateEmbeddedBinary() throws {
        let input = #"ValidateEmbeddedBinary /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex (in target 'Backyard Birds Target' from project 'Backyard Birds Project')"#
        let groups = try XCTUnwrap(ValidateEmbeddedBinaryCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 3)
        XCTAssertEqual(groups[0], #"/Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex"#)
        XCTAssertEqual(groups[1], "Backyard Birds Target")
        XCTAssertEqual(groups[2], "Backyard Birds Project")
    }

    func testXcodebuildError() throws {
        let input = #"xcodebuild: error: Existing file at -resultBundlePath "/output/file.xcresult""#
        let groups = try XCTUnwrap(XcodebuildErrorCaptureGroup.regex.captureGroups(for: input))
        XCTAssertEqual(groups.count, 1)
        XCTAssertEqual(groups[0], input)
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

    func testMatchSwiftCompileFailed() {
        let input = #"Command SwiftCompile failed with a nonzero exit code"#
        XCTAssertNotNil(SwiftCompileFailedCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftCompileStackDumpHeader() {
        let input = #"Stack dump:"#
        XCTAssertNotNil(SwiftCompileStackDumpHeaderCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftCompileStackDump() {
        let input = """
        0.	Program arguments: /Applications/Xcode-16.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Users/agp1/Developer/Rugby/Example/LocalPods/LocalPod/Sources/Bundle+Resources.swift /Users/agp1/Developer/Rugby/Example/LocalPods/LocalPod/Sources/DummySource.swift /Users/agp1/Developer/Rugby/Example/LocalPods/LocalPod/Sources/TheView.swift -supplementary-output-file-map /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/supplementaryOutputs-5 -target arm64-apple-ios16.0-simulator -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator18.4.sdk -I /Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/LocalPod-framework -F /Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/LocalPod-framework -F /Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/Alamofire-framework -F /Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/LocalLibraryPod-framework -F /Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/Moya-framework -no-color-diagnostics -enable-testing -g -debug-info-format=dwarf -dwarf-version=4 -import-underlying-module -warnings-as-errors -warnings-as-errors -swift-version 5 -enforce-exclusivity=checked -Onone -D DEBUG -D COCOAPODS -serialize-debugging-options -const-gather-protocols-file /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/LocalPod-framework_const_extract_protocols.json -enable-experimental-feature DebugDescriptionMacro -enable-bare-slash-regex -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /var/folders/8n/h4qvsvq569n0npb_y9fpxblh0000gn/C/org.llvm.clang/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Users/agp1/Developer/Rugby/Example/Pods -resource-dir /Applications/Xcode-16.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -enable-anonymous-context-mangled-names -file-compilation-dir /Users/agp1/Developer/Rugby/Example/Pods -Xcc -ivfsstatcache -Xcc /var/folders/8n/h4qvsvq569n0npb_y9fpxblh0000gn/C/com.apple.DeveloperTools/16.3-16E140/Xcode/SDKStatCaches.noindex/iphonesimulator18.4-22E235-43e5fd89280df366c77438703b8fa853.sdkstatcache -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/swift-overrides.hmap -Xcc -iquote -Xcc /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/LocalPod-generated-files.hmap -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/LocalPod-own-target-headers.hmap -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/LocalPod-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/Pods-bfdfe7dc352907fc980b868725387e98-VFS-iphonesimulator/all-product-headers.yaml -Xcc -iquote -Xcc /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/LocalPod-project-headers.hmap -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/LocalPod-framework/include -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/DerivedSources-normal/arm64 -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/DerivedSources/arm64 -Xcc -I/Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/DerivedSources -Xcc -DPOD_CONFIGURATION_DEBUG=1 -Xcc -DDEBUG=1 -Xcc -DCOCOAPODS=1 -Xcc -ivfsoverlay -Xcc /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/unextended-module-overlay.yaml -module-name LocalPod -frontend-parseable-output -disable-clang-spi -target-sdk-version 18.4 -target-sdk-name iphonesimulator18.4 -external-plugin-path /Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/lib/swift/host/plugins#/Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/local/lib/swift/host/plugins#/Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/swift-plugin-server -in-process-plugin-server-path /Applications/Xcode-16.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/libSwiftInProcPluginServer.dylib -plugin-path /Applications/Xcode-16.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins -plugin-path /Applications/Xcode-16.3.0.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/local/lib/swift/host/plugins -num-threads 14 -o /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/Bundle+Resources.o -o /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/DummySource.o -o /Users/agp1/Developer/Rugby/Example/.rugby/build/Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/TheView.o -index-unit-output-path /Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/Bundle+Resources.o -index-unit-output-path /Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/DummySource.o -index-unit-output-path /Pods.build/Debug-iphonesimulator/LocalPod-framework.build/Objects-normal/arm64/TheView.o
        1.	Apple Swift version 6.1 (swiftlang-6.1.0.110.21 clang-1700.0.13.3)
        2.	Compiling with effective version 5.10
        3.	While evaluating request TypeCheckSourceFileRequest(source_file "/Users/agp1/Developer/Rugby/Example/LocalPods/LocalPod/Sources/TheView.swift")
        4.	While evaluating request TypeCheckFunctionBodyRequest(LocalPod.(file).SomeSizeReaderView._@/Users/agp1/Developer/Rugby/Example/LocalPods/LocalPod/Sources/TheView.swift:8:32)
        5.	While evaluating request QualifiedLookupRequest(0x118ac5f18 AbstractFunctionDecl name=_ : (SomeSizeReaderView) -> () -> some View, {SwiftUICore.(file).HStack}, 'sizeReader', { NL_ProtocolMembers, NL_IgnoreMissingImports })
        6.	While evaluating request DirectLookupRequest(directly looking up 'sizeReader' on SwiftUICore.(file).View with options {  })
        7.	While loading members for extension of View (in module 'LocalLibraryPod')
        8.	While deserializing 'sizeReader' (FuncDecl @ 168090) in 'LocalLibraryPod'
        9.	    ...decl is named 'sizeReader(to:)'
        10.	While deserializing '_' (OpaqueTypeDecl @ 166555) in 'LocalLibraryPod'
        11.	While cross-referencing conformance for 'CGSize' (at /Applications/Xcode-16.3.0.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator18.4.sdk/System/Library/Frameworks/CoreFoundation.framework/Headers/CFCGTypes.h:58:8)
        12.	While ... to 'Sendable' (in module 'Swift')
        13.	If you're seeing a crash here, check that your SDK and dependencies are at least as new as the versions used to build module 'LocalLibraryPod', builder version '6.1(5.10)/Apple Swift version 6.1 (swiftlang-6.1.0.110.21 clang-1700.0.13.3)', built from source against SDK 22E235, non-resilient, loaded from '/Users/agp1/Developer/Rugby/Example/.rugby/build/Debug-iphonesimulator/LocalLibraryPod-framework/LocalLibraryPod.framework/Modules/LocalLibraryPod.swiftmodule/arm64-apple-ios-simulator.swiftmodule'
        """
        let lines = input.components(separatedBy: "\n")
        lines.forEach { line in
            XCTAssertNotNil(SwiftCompileStackDumpCaptureGroup.regex.captureGroups(for: line))
        }
    }
}
