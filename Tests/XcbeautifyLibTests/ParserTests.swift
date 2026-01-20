//
// ParserTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib
import XcLogParserLib

@Suite struct ParserTests {
    private let parser = Parser()

    @Test func matchCompileAssetCatalog() throws {
        let input = #"CompileAssetCatalog /Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents/Resources /Backyard-Birds/Widgets/Assets.xcassets (in target 'Widgets' from project 'Backyard Birds')"#
        let captureGroup = try #require(parser.parse(line: input) as? CompileAssetCatalogCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents/Resources /Backyard-Birds/Widgets/Assets.xcassets")
        #expect(captureGroup.filename == "Assets.xcassets")
        #expect(captureGroup.target == "Widgets")
        #expect(captureGroup.project == "Backyard Birds")
    }

    @Test func matchCompileXCStrings() throws {
        let input = #"CompileXCStrings /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings (in target 'BackyardBirdsData_BackyardBirdsData' from project 'BackyardBirdsData')"#
        let captureGroup = try #require(parser.parse(line: input) as? CompileXCStringsCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings")
        #expect(captureGroup.filename == "Backyards.xcstrings")
        #expect(captureGroup.target == "BackyardBirdsData_BackyardBirdsData")
        #expect(captureGroup.project == "BackyardBirdsData")
    }

    @Test func matchCopyFilesMatchingSourceAndDestinationFilenames() throws {
        let input = #"Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"#
        let captureGroup = try #require(parser.parse(line: input) as? CopyFilesCaptureGroup)
        #expect(captureGroup.firstFilePath == "/path/to/some/file.swift")
        #expect(captureGroup.firstFilename == "file.swift")
        #expect(captureGroup.secondFilePath == "/path/to/some/other/file.swift")
        #expect(captureGroup.secondFilename == "file.swift")
        #expect(captureGroup.target == "Target")
    }

    @Test func matchCopyFilesDifferentSourceAndDestinationFilenames() throws {
        let input = #"Copy /Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let captureGroup = try #require(parser.parse(line: input) as? CopyFilesCaptureGroup)
        #expect(captureGroup.firstFilePath == "/Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json")
        #expect(captureGroup.firstFilename == "x86_64-apple-macos.abi.json")
        #expect(captureGroup.secondFilePath == #"/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json"#)
        #expect(captureGroup.secondFilename == "Backyard_Birds.abi.json")
        #expect(captureGroup.target == "Backyard Birds")
    }

    @Test func createBuildDirectory() throws {
        let input = "CreateBuildDirectory /Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug"
        let captureGroup = try #require(parser.parse(line: input) as? CreateBuildDirectoryCaptureGroup)
        #expect(captureGroup.directory == "/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug")
    }

    @Test func matchCreateUniversalBinary() throws {
        let input = #"CreateUniversalBinary /Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o normal arm64\ x86_64 (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let captureGroup = try #require(parser.parse(line: input) as? CreateUniversalBinaryCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Build/Products/Debug/BackyardBirdsData.o")
        #expect(captureGroup.filename == "BackyardBirdsData.o")
        #expect(captureGroup.target == "BackyardBirdsDataTarget")
        #expect(captureGroup.project == "BackyardBirdsDataProject")
    }

    @Test func matchDetectedEncoding() throws {
        let input = #"/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings:35:45: note: detected encoding of input file as Unicode (UTF-8) (in target 'BackyardBirdsUI_BackyardBirdsUI' from project 'BackyardBirdsUI')"#
        let captureGroup = try #require(parser.parse(line: input) as? DetectedEncodingCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsUI.build/Debug/BackyardBirdsUI_BackyardBirdsUI.build/ru.lproj/Localizable.strings")
        #expect(captureGroup.filename == "Localizable.strings")
        #expect(captureGroup.lineNumber == 35)
        #expect(captureGroup.columnNumber == 45)
        #expect(captureGroup.encoding == "Unicode (UTF-8)")
        #expect(captureGroup.target == "BackyardBirdsUI_BackyardBirdsUI")
        #expect(captureGroup.project == "BackyardBirdsUI")
    }

    @Test func matchExtractAppIntentsMetadata() throws {
        let input = "ExtractAppIntentsMetadata (in target 'Target' from project 'Project')"
        let captureGroup = try #require(parser.parse(line: input) as? ExtractAppIntentsMetadataCaptureGroup)
        #expect(captureGroup.target == "Target")
        #expect(captureGroup.project == "Project")
    }

    @Test func matchFileMissingError() throws {
        let input = #"<unknown>:0: error: no such file or directory: '/path/file.swift'"#
        let captureGroup = try #require(parser.parse(line: input) as? FileMissingErrorCaptureGroup)
        #expect(captureGroup.filePath == "/path/file.swift")
    }

    @Test func generateAssetSymbols() throws {
        let input = #"GenerateAssetSymbols /Backyard-Birds/Widgets/An-Asset_Catalog.xcassets (in target 'Some Target' from project 'A_Project')"#
        let captureGroup = try #require(parser.parse(line: input) as? GenerateAssetSymbolsCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Widgets/An-Asset_Catalog.xcassets")
        #expect(captureGroup.filename == "An-Asset_Catalog.xcassets")
        #expect(captureGroup.target == "Some Target")
        #expect(captureGroup.project == "A_Project")
    }

    #if os(macOS)
    @Test func matchLdCommandObjectWithoutArch() throws {
        let input = #"Ld /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/x86_64/Binary/BackyardBirdsData.o normal (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let captureGroup = try #require(parser.parse(line: input) as? LinkingCaptureGroup)
        #expect(captureGroup.binaryFilename == "BackyardBirdsData.o")
        #expect(captureGroup.target == "BackyardBirdsDataTarget")
    }
    #endif

    @Test func matchLDWarningCaptureGroup() throws {
        let input = #"ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"#
        let captureGroup = try #require(parser.parse(line: input) as? LDWarningCaptureGroup)
        #expect(captureGroup.warningMessage == "embedded dylibs/frameworks only run on iOS 8 or later")
    }

    @Test func matchUnindentedNonPCHClangCommand() throws {
        let input = #"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let captureGroup = try #require(parser.parse(line: input) as? NonPCHClangCommandCaptureGroup)
        #expect(captureGroup.xcodePath == "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    @Test func matchIndentedNonPCHClangCommand() throws {
        let input = #"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        let captureGroup = try #require(parser.parse(line: input) as? NonPCHClangCommandCaptureGroup)
        #expect(captureGroup.xcodePath == "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang")
    }

    @Test func unindentedClangDoesNotMatchShellCommand() throws {
        let input = #"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        #expect(parser.parse(line: input) as? ShellCommandCaptureGroup == nil)
    }

    @Test func indentedClangDoesNotMatchShellCommand() throws {
        let input = #"    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        #expect(parser.parse(line: input) as? ShellCommandCaptureGroup == nil)
    }

    @Test func swiftTaskExecutionDoesMatchesShellCommand() throws {
        let input = #"    builtin-swiftTaskExecution -- /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift-frontend -frontend -c /Backyard-Birds/Widgets/Backyard/BackyardWidgetIntent.swift /Backyard-Birds/Widgets/Backyard/BackyardWidget.swift -primary-file /Backyard-Birds/Widgets/Backyard/ResupplyBackyardIntent.swift /Backyard-Birds/Widgets/WidgetsBundle.swift /Backyard-Birds/Widgets/Backyard/BackyardSnapshotTimelineProvider.swift /Backyard-Birds/Widgets/Backyard/BackyardWidgetView.swift /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/DerivedSources/GeneratedAssetSymbols.swift -emit-dependencies-path /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.d -emit-const-values-path /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.swiftconstvalues -emit-reference-dependencies-path /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.swiftdeps -serialize-diagnostics-path /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.dia -emit-localized-strings -emit-localized-strings-path /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64 -target arm64-apple-macos14.2 -Xllvm -aarch64-use-tbi -enable-objc-interop -stack-check -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -I /Backyard-Birds/Build/Products/Debug -F /Backyard-Birds/Build/Products/Debug/PackageFrameworks -F /Backyard-Birds/Build/Products/Debug/PackageFrameworks -F /Backyard-Birds/Build/Products/Debug/PackageFrameworks -F /Backyard-Birds/Build/Products/Debug -no-color-diagnostics -application-extension -enable-testing -g -module-cache-path /Backyard-Birds/ModuleCache.noindex -swift-version 5 -enforce-exclusivity\=checked -Onone -D DEBUG -serialize-debugging-options -const-gather-protocols-file /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/Widgets_const_extract_protocols.json -enable-bare-slash-regex -empty-abi-descriptor -validate-clang-modules-once -clang-build-session-file /Backyard-Birds/ModuleCache.noindex/Session.modulevalidation -Xcc -working-directory -Xcc /Backyard-Birds -resource-dir /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift -enable-anonymous-context-mangled-names -Xcc -ivfsstatcache -Xcc /Backyard-Birds/SDKStatCaches.noindex/macosx14.2-23C53-df0db8920d7ae99241a1bc0f08d2dced.sdkstatcache -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/swift-overrides.hmap -Xcc -iquote -Xcc /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Widgets-generated-files.hmap -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Widgets-own-target-headers.hmap -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Widgets-all-non-framework-target-headers.hmap -Xcc -ivfsoverlay -Xcc /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/all-product-headers.yaml -Xcc -iquote -Xcc /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Widgets-project-headers.hmap -Xcc -I/Backyard-Birds/Build/Products/Debug/include -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/DerivedSources-normal/arm64 -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/DerivedSources/arm64 -Xcc -I/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/DerivedSources -Xcc -DDEBUG\=1 -module-name Widgets -frontend-parseable-output -disable-clang-spi -target-sdk-version 14.2 -target-sdk-name macosx14.2 -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/lib/swift/host/plugins\#\/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/local/lib/swift/host/plugins\#\/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins\#\/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins\#\/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/host/plugins -plugin-path /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/local/lib/swift/host/plugins -o /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.o -index-unit-output-path /Backyard\ Birds.build/Debug/Widgets.build/Objects-normal/arm64/ResupplyBackyardIntent.o -index-store-path /Backyard-Birds/Index.noindex/DataStore -index-system-modules"#
        #expect(parser.parse(line: input) as? ShellCommandCaptureGroup != nil)
    }

    @Test func matchSwiftDriverJobDiscoveryCompilingCaptureGroupOneFile() throws {
        let input = #"SwiftDriverJobDiscovery normal arm64 Compiling resource_bundle_accessor.swift (in target 'Some Target' from project 'Some Project')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        #expect(captureGroup.state == "normal")
        #expect(captureGroup.architecture == .arm64)
        #expect(captureGroup.filenames == ["resource_bundle_accessor.swift"])
        #expect(captureGroup.target == "Some Target")
        #expect(captureGroup.project == "Some Project")
    }

    @Test func matchSwiftDriverJobDiscoveryCompilingCaptureGroupMultipleFiles() throws {
        let input = #"SwiftDriverJobDiscovery normal x86_64 Compiling BackyardVisitorEvent+DataGeneration.swift, BackyardVisitors\ &\ Events.swift, Bird+DataGeneration.swift, Bird.swift (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        #expect(captureGroup.state == "normal")
        #expect(captureGroup.architecture == .x86_64)
        #expect(captureGroup.filenames == ["BackyardVisitorEvent+DataGeneration.swift", #"BackyardVisitors\ &\ Events.swift"#, "Bird+DataGeneration.swift", "Bird.swift"])
        #expect(captureGroup.target == "BackyardBirdsDataTarget")
        #expect(captureGroup.project == "BackyardBirdsDataProject")
    }

    @Test func matchSwiftCompile() throws {
        let input = #"SwiftCompile normal arm64 /Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftCompileCaptureGroup)
        #expect(captureGroup.filePath == #"/Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift"#)
        #expect(captureGroup.filename == #"BirdFood+DataGeneration.swift"#)
        #expect(captureGroup.target == "BackyardBirdsData")
    }

    @Test func matchSwiftDriverJobDiscoveryCompilingCaptureGroup() throws {
        let input = #"SwiftMergeGeneratedHeaders /Backyard-Birds/Build/Intermediates.noindex/GeneratedModuleMaps/LayeredArtworkLibrary-Swift.h /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary.build/Objects-normal/arm64/LayeredArtworkLibrary-Swift.h /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary.build/Objects-normal/x86_64/LayeredArtworkLibrary-Swift.h (in target 'LayeredArtworkLibraryTarget' from project 'LayeredArtworkLibraryProject')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftMergeGeneratedHeadersCaptureGroup)
        #expect(captureGroup.headerFilePaths == "/Backyard-Birds/Build/Intermediates.noindex/GeneratedModuleMaps/LayeredArtworkLibrary-Swift.h /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary.build/Objects-normal/arm64/LayeredArtworkLibrary-Swift.h /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary.build/Objects-normal/x86_64/LayeredArtworkLibrary-Swift.h")
        #expect(captureGroup.target == "LayeredArtworkLibraryTarget")
        #expect(captureGroup.project == "LayeredArtworkLibraryProject")
    }

    @Test func matchSymLink() throws {
        let input = "SymLink /Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Versions/Current A (in target 'LayeredArtworkLibrary_Target' from project 'LayeredArtworkLibrary_Project')"
        let captureGroup = try #require(parser.parse(line: input) as? SymLinkCaptureGroup)
        #expect(captureGroup.filePath == "/Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Versions/Current A")
        #expect(captureGroup.target == "LayeredArtworkLibrary_Target")
        #expect(captureGroup.project == "LayeredArtworkLibrary_Project")
    }

    @Test func matchExplicitDependency() throws {
        let input = #"        ➜ Explicit dependency on target 'BackyardBirdsData_BackyardBirdsData' in project 'Backyard Birds Data'"#
        let captureGroup = try #require(parser.parse(line: input) as? ExplicitDependencyCaptureGroup)
        #expect(captureGroup.target == "BackyardBirdsData_BackyardBirdsData")
        #expect(captureGroup.project == "Backyard Birds Data")
    }

    @Test func matchTestingStarted() throws {
        let input = "Testing started"
        let captureGroup = try #require(parser.parse(line: input) as? TestingStartedCaptureGroup)
        #expect(captureGroup.wholeMessage == "Testing started")
    }

    @Test func notMatchTestingStarted() throws {
        let input = #"2024-08-18 18:17:52.619 xcodebuild[9799:394817] [MT] IDETestOperationsObserverDebug: 21.975 elapsed -- Testing started completed."#
        #expect(parser.parse(line: input) == nil)
    }

    @Test func matchSigning() throws {
        let input = "Signing Some+File.bundle (in target 'Target' from project 'Project')"
        let captureGroup = try #require(parser.parse(line: input) as? SigningCaptureGroup)
        #expect(captureGroup.file == "Some+File.bundle")
        #expect(captureGroup.target == "Target")
        #expect(captureGroup.project == "Project")
    }

    @Test func matchSwiftTestingRunStarted() throws {
        let input = "􀟈 Test run started."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingRunStartedCaptureGroup)
        #expect(captureGroup.message == "Test run started.")
    }

    @Test func matchSwiftTestingRunCompletion() throws {
        let input = "􁁛  Test run with 5 tests passed after 3.2 seconds."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingRunCompletionCaptureGroup)
        #expect(captureGroup.numberOfTests == 5)
        #expect(captureGroup.totalTime == "3.2")
    }

    @Test func matchSwiftTestingRunFailed() throws {
        let input = "􀢄 Test run with 7 tests failed after 4.8 seconds with 2 issues."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingRunFailedCaptureGroup)
        #expect(captureGroup.numberOfTests == 7)
        #expect(captureGroup.totalTime == "4.8")
        #expect(captureGroup.numberOfIssues == 2)
    }

    @Test func matchSwiftTestingSuiteStarted() throws {
        let input = "􀟈  Suite SampleTestSuite started."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingSuiteStartedCaptureGroup)
        #expect(captureGroup.suiteName == "SampleTestSuite")
    }

    @Test func matchSwiftTestingTestStarted() throws {
        let input = "􀟈  Test ExampleTest started."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingTestStartedCaptureGroup)
        #expect(captureGroup.testName == "ExampleTest")
    }

    @Test func matchSwiftTestingSuitePassed() throws {
        let input = "􁁛 Suite TestSuiteName passed after 5.3 seconds."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingSuitePassedCaptureGroup)
        #expect(captureGroup.suiteName == "TestSuiteName")
        #expect(captureGroup.timeTaken == "5.3")
    }

    @Test func matchSwiftTestingSuiteFailed() throws {
        let input = #"􀢄 Suite "AnotherTestSuite" failed after 6.4 seconds with 3 issues."#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingSuiteFailedCaptureGroup)
        #expect(captureGroup.suiteName == "\"AnotherTestSuite\"")
        #expect(captureGroup.timeTaken == "6.4")
        #expect(captureGroup.numberOfIssues == 3)
    }

    @Test func matchSwiftTestingTestFailed() throws {
        let input = #"􀢄 Test "SomeTest" failed after 2.5 seconds with 1 issue."#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingTestFailedCaptureGroup)
        #expect(captureGroup.testName == "\"SomeTest\"")
        #expect(captureGroup.timeTaken == "2.5")
        #expect(captureGroup.numberOfIssues == 1)
    }

    @Test func matchSwiftTestingTestPassed() throws {
        let input = "􁁛 Test SampleTest passed after 3.0 seconds."
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingTestPassedCaptureGroup)
        #expect(captureGroup.testName == "SampleTest")
        #expect(captureGroup.timeTaken == "3.0")
    }

    @Test func matchSwiftTestingTestSkipped() throws {
        let input = #"􀙟 Test "SkippedTest" skipped."#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingTestSkippedCaptureGroup)
        #expect(captureGroup.testName == "\"SkippedTest\"")
    }

    @Test func matchSwiftTestingTestSkippedWithReason() throws {
        let input = #"􀙟 Test "SkippedTest" skipped: "Not relevant for this platform.""#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingTestSkippedReasonCaptureGroup)
        #expect(captureGroup.testName == "\"SkippedTest\"")
        #expect(captureGroup.reason == "Not relevant for this platform.")
    }

    @Test func matchSwiftTestingIssue() throws {
        let input = #"􀢄  Test "Selected tests by ID" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingIssueCaptureGroup)
        #expect(captureGroup.testDescription == "\"Selected tests by ID\"")
        #expect(captureGroup.issueDetails == "PlanTests.swift:43:5: Expectation failed")
    }

    @Test func matchSwiftTestingPassingArgument() throws {
        let input = #"􀟈 Passing 2 arguments input → "argument1, argument2""#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftTestingPassingArgumentCaptureGroup)
        #expect(captureGroup.numberOfArguments == 2)
    }

    @Test func matchScanDependencies() throws {
        let input = #"ScanDependencies /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-ABC123.o /Users/Some/Other-Random-Path/_To/A/Build/Intermediates.noindex/Some/Other.build/x86_64/file-DEF456.m normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.compiler (in target 'SomeTarget' from project 'SomeProject')"#
        let captureGroup = try #require(parser.parse(line: input) as? ScanDependenciesCaptureGroup)
        #expect(captureGroup.target == "SomeTarget")
        #expect(captureGroup.project == "SomeProject")
    }

    @Test func swiftDriverTargetCaptureGroup() throws {
        let input = #"SwiftDriver BackyardBirdsData normal arm64 com.apple.xcode.tools.swift.compiler (in target \'BackyardBirdsData\' from project \'BackyardBirdsData\')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftDriverTargetCaptureGroup)
        #expect(captureGroup.target == "BackyardBirdsData")
    }

    @Test func swiftDriverCompilationTarget() throws {
        let input = #"SwiftDriver\ Compilation SomeTarget normal x86_64 com.apple.xcode.tools.swift.compiler (in target 'Target' from project 'Project')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftDriverCompilationTarget)
        #expect(captureGroup.target == "SomeTarget")
    }

    @Test func swiftDriverCompilationRequirementsCaptureGroup() throws {
        let input = #"SwiftDriver\ Compilation\ Requirements Backyard\ Birds normal arm64 com.apple.xcode.tools.swift.compiler (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let captureGroup = try #require(parser.parse(line: input) as? SwiftDriverCompilationRequirementsCaptureGroup)
        #expect(captureGroup.target == #"Backyard\ Birds"#)
    }

    @Test func parseSwiftTestingParallelTestOutputPassed() throws {
        let resultSuccess = try #require(parser.parse(line: "Test case 'SomeStructThatsNotASuite/someFunctionName()' passed on 'Clone 1 of iPhone 16 Pro - xctest (38347)' (13.060 seconds)") as? ParallelTestCasePassedCaptureGroup)
        #expect(resultSuccess.device == "Clone 1 of iPhone 16 Pro - xctest (38347)")
        #expect(resultSuccess.suite == "SomeStructThatsNotASuite")
        #expect(resultSuccess.time == "13.060")
        #expect(resultSuccess.testCase == "someFunctionName")
    }

    @Test func parseSwiftTestingParallelTestOutputFailed() throws {
        let resultFailed = try #require(parser.parse(line: "Test case 'SubFolderTestDemoTests/exampleFalse()' failed on 'My Mac - TestDemo (29692)' (0.001 seconds)") as? ParallelTestCaseFailedCaptureGroup)
        #expect(resultFailed.device == "My Mac - TestDemo (29692)")
        #expect(resultFailed.suite == "SubFolderTestDemoTests")
        #expect(resultFailed.time == "0.001")
        #expect(resultFailed.testCase == "exampleFalse")
    }

    func tesPrecompileModule() throws {
        let input = try #require(parser.parse(line: "PrecompileModule /Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan") as? PrecompileModuleCaptureGroup)
        #expect(input.path == "/Users/Some/Random-Path/_To/A/Build/Intermediates.noindex/ExplicitPrecompileModules/file-ABC123.scan")
    }

    @Test func registerExecutionPolicyException() throws {
        let captureGroup = try #require(parser.parse(line: "RegisterExecutionPolicyException /path/to/output.o (in target 'Target' from project 'Project')") as? RegisterExecutionPolicyExceptionCaptureGroup)
        #expect(captureGroup.filePath == "/path/to/output.o")
        #expect(captureGroup.filename == "output.o")
        #expect(captureGroup.target == "Target")
        #expect(captureGroup.project == "Project")
    }

    @Test func swiftEmitModule() throws {
        let captureGroup = try #require(parser.parse(line: #"SwiftEmitModule normal i386 Emitting\ module\ for\ CasePaths (in target 'CasePathsTarget' from project 'swift-case-paths')"#) as? SwiftEmitModuleCaptureGroup)
        #expect(captureGroup.arch == .i386)
        #expect(captureGroup.module == "CasePaths")
        #expect(captureGroup.target == "CasePathsTarget")
        #expect(captureGroup.project == "swift-case-paths")
    }

    @Test func emitSwiftModule() throws {
        let captureGroup = try #require(parser.parse(line: #"EmitSwiftModule normal arm64 (in target 'Target' from project 'Project')"#) as? EmitSwiftModuleCaptureGroup)
        #expect(captureGroup.arch == .arm64)
        #expect(captureGroup.target == "Target")
        #expect(captureGroup.project == "Project")
    }

    @Test func matchNote() throws {
        let inputs = [
            ("note:", "Building targets in dependency order"),
            ("note:", "Metadata extraction skipped. No AppIntents.framework dependency found. (in target 'Target' from project 'Project')"),
            ("note:", #"Run script build phase 'SomeRunScriptBuildPhase' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Target' from project 'Project')"#),
            ("note:", "Target dependency graph (12 targets)"),
        ]

        for (keyword, note) in inputs {
            let input = "\(keyword) \(note)"
            let captureGroup = try #require(parser.parse(line: input) as? NoteCaptureGroup)
            #expect(captureGroup.note == note)
        }
    }

    // Note Output expects a lowercase n.
    @Test func negativeMatchNote() {
        let inputs = [
            #"Note: Building targets in dependency order"#,
            #"Note: Metadata extraction skipped. No AppIntents.framework dependency found. (in target 'Target' from project 'Project')"#,
            #"Note: Run script build phase 'SomeRunScriptBuildPhase' will be run during every build because the option to run the script phase "Based on dependency analysis" is unchecked. (in target 'Target' from project 'Project')"#,
            #"Note: Target dependency graph (12 targets)"#,
        ]

        #expect(
            inputs.allSatisfy { input in
                parser.parse(line: input) == nil
            }
        )
    }

    @Test func notMatchNote() throws {
        let inputs = [
            "in the note middle",
            "in the note: middle",
            "note Building targets in dependency order",
            "Note Metadata extraction skipped.",
            "Target dependency graph (12 targets) note",
            "Target dependency graph (12 targets) note:",
            "Target dependency graph (12 targets): note:",
        ]

        for input in inputs {
            #expect(parser.parse(line: input) == nil)
        }
    }

    @Test func uIFailingTestCaptureGroup() throws {
        let input = "    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>"
        let captureGroup = try #require(parser.parse(line: input) as? UIFailingTestCaptureGroup)
        #expect(captureGroup.file == "<unknown>:0")
        #expect(captureGroup.reason == "App crashed in <external symbol>")
    }

    @Test func validate() throws {
        let input = #"Validate /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app (in target 'Backyard Birds Target' from project 'Backyard Birds')"#
        let captureGroup = try #require(parser.parse(line: input) as? ValidateCaptureGroup)
        #expect(captureGroup.filePath == #"/Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app"#)
        #expect(captureGroup.filename == #"Backyard\ Birds.app"#)
        #expect(captureGroup.target == "Backyard Birds Target")
        #expect(captureGroup.project == "Backyard Birds")
    }

    @Test func validateEmbeddedBinary() throws {
        let input = #"ValidateEmbeddedBinary /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex (in target 'Backyard Birds Target' from project 'Backyard Birds Project')"#
        let captureGroup = try #require(parser.parse(line: input) as? ValidateEmbeddedBinaryCaptureGroup)
        #expect(captureGroup.filePath == #"/Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex"#)
        #expect(captureGroup.filename == "Widgets.appex")
        #expect(captureGroup.target == "Backyard Birds Target")
        #expect(captureGroup.project == "Backyard Birds Project")
    }

    @Test func xcodebuildError() throws {
        let input = #"xcodebuild: error: Existing file at -resultBundlePath "/output/file.xcresult""#
        let captureGroup = try #require(parser.parse(line: input) as? XcodebuildErrorCaptureGroup)
        #expect(captureGroup.wholeError == input)
    }

    @Test func matchDataModelCodegen() throws {
        let inputs = [
            ("/path/to/data/model/something", "target", "Project"),
            ("", "", ""),
            ("", "iOS", "app"),
            ("", "visionOS", ""),
            ("", "", "123"),
            ("/", "", ""),
            ("path", "macOS", ""),
            (".", "", "!"),
            ("()", "[]", "(.*)"),
        ]

        for (path, target, project) in inputs {
            let input = "DataModelCodegen \(path).xcdatamodeld (in target '\(target)' from project '\(project)')"
            let captureGroup = try #require(parser.parse(line: input) as? DataModelCodegenCaptureGroup)
            #expect(captureGroup.path == "\(path).xcdatamodeld")
            #expect(captureGroup.target == target)
            #expect(captureGroup.project == project)
        }
    }

    @Test func notDataModelCodegen() throws {
        let inputs = [
            "DataModelCodegen /pathxcdatamodeld (in target 'target' from project 'project')",
            "datamodelcodegen /path.xcdatamodeld (in target 'target' from project 'project')",
            "DataModelCodegen path.xcdatamodeld (in target from project 'project')",
            "DataModelCodegen path.xcdatamodeld (in target 'target' from project)",
            "DataModelCodegen path.xcdatamodeld (in target target from project project)",
        ]

        for input in inputs {
            #expect(parser.parse(line: input) == nil)
        }
    }
}
