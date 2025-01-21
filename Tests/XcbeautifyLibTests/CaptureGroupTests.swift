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
        XCTAssertEqual(groups.count, 2)
        XCTAssertEqual(groups[0], "SomeTarget")
        XCTAssertEqual(groups[1], "SomeProject")
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
}
