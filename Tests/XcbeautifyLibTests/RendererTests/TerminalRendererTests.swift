//
// TerminalRendererTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib
import XcLogParserLib

@Suite struct TerminalRendererTests {
    private let parser = Parser()
    private let formatter = Formatter(colored: false, renderer: .terminal, additionalLines: { nil })

    private func noColoredFormatted(_ string: String) -> String? {
        guard let captureGroup = parser.parse(line: string) else { return nil }
        return formatter.format(captureGroup: captureGroup)
    }

    @Test func aggregateTarget() {
        let formatted = noColoredFormatted("=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ===")
        #expect(formatted == "Aggregate target Be Aggro of project AggregateExample with configuration Debug")
    }

    @Test func analyze() {
        let formatted = noColoredFormatted("AnalyzeShallow /Users/admin/CocoaLumberjack/Classes/DDTTYLogger.m normal x86_64 (in target: CocoaLumberjack-Static)")
        #expect(formatted == "[CocoaLumberjack-Static] Analyzing DDTTYLogger.m")
    }

    @Test func analyzeTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Analyze target The Spacer of project Pods with configuration Debug")
    }

    @Test func buildTarget() {
        let formatted = noColoredFormatted("=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Build target The Spacer of project Pods with configuration Debug")
    }

    @Test func checkDependenciesErrors() { }

    @Test func checkDependencies() {
        let command = "Check dependencies"
        let formatted = noColoredFormatted(command)
        #expect(formatted == command)
    }

    @Test func clangError() {
        let formatted = noColoredFormatted("clang: error: linker command failed with exit code 1 (use -v to see invocation)")
        #expect(formatted == "[x] clang: error: linker command failed with exit code 1 (use -v to see invocation)")
    }

    @Test func cleanRemove() {
        let formatted = noColoredFormatted("Clean.Remove clean /Users/admin/Library/Developer/Xcode/DerivedData/MyLibrary-abcd/Build/Intermediates/MyLibrary.build/Debug-iphonesimulator/MyLibraryTests.build")
        #expect(formatted == "Cleaning MyLibraryTests.build")
    }

    @Test func cleanTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Analyze target The Spacer of project Pods with configuration Debug")
    }

    @Test func codesignFramework() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyFramework.framework/Versions/A")
        #expect(formatted == "Signing build/Release/MyFramework.framework")
    }

    @Test func codesign() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyApp.app")
        #expect(formatted == "Signing MyApp.app")
    }

    @Test func multipleCodesigns() {
        let formattedApp = noColoredFormatted("CodeSign build/Release/MyApp.app (in target 'X' from project 'Y' at path 'Z')")
        let formattedFramework = noColoredFormatted("CodeSign build/Release/MyFramework.framework/Versions/A (in target 'X' from project 'Y')")
        #expect(formattedApp == "Signing MyApp.app")
        #expect(formattedFramework == "Signing build/Release/MyFramework.framework")
    }

    @Test func compileCommand() { }

    @Test func compileError() {
        let inputError = "/path/file.swift:64:69: error: cannot find 'input' in scope"
        let outputError = "[x] /path/file.swift:64:69: cannot find 'input' in scope\n\n"
        #expect(noColoredFormatted(inputError) == outputError)

        let inputFatal = "/path/file.swift:64:69: fatal error: cannot find 'input' in scope"
        let outputFatal = "[x] /path/file.swift:64:69: cannot find 'input' in scope\n\n"
        #expect(noColoredFormatted(inputFatal) == outputFatal)
    }

    @Test func compile() {
        #if os(macOS)
        // Xcode 10 and before
        let input1 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target: xcbeautify)"
        // Xcode 11+'s output
        let input2 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target 'xcbeautify' from project 'xcbeautify')"
        let output = "[xcbeautify] Compiling setup.swift"
        #expect(noColoredFormatted(input1) == output)
        #expect(noColoredFormatted(input2) == output)
        #endif
    }

    @Test func compileAssetCatalog() {
        let formatted = noColoredFormatted(#"CompileAssetCatalog /Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents/Resources /Backyard-Birds/Widgets/AnAssetCatalog.xcassets (in target 'Widgets' from project 'Backyard Birds')"#)
        #expect(formatted == "[Widgets] Compile Asset Catalog AnAssetCatalog.xcassets")
    }

    @Test func createBuildDirectory() {
        let formatted = noColoredFormatted("CreateBuildDirectory /Backyard-Birds/Build/Products/Debug/PackageFrameworks")
        #expect(formatted == nil)
    }

    @Test func createUniversalBinary() {
        let formatted = noColoredFormatted(#"CreateUniversalBinary /Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/Versions/A/LayeredArtworkLibraryFile normal arm64\ x86_64 (in target 'LayeredArtworkLibraryTarget' from project 'LayeredArtworkLibrary')"#)
        #expect(formatted == "[LayeredArtworkLibraryTarget] Create Universal Binary LayeredArtworkLibraryFile")
    }

    @Test func swiftCompile_arm64() {
        let input = "SwiftCompile normal arm64 /path/to/File.swift (in target 'Target' from project 'Project')"
        let output = "[Target] Compiling File.swift"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftCompile_x86_64() {
        let input = "SwiftCompile normal x86_64 /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/resource_bundle_accessor.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"
        let output = "[BackyardBirdsData] Compiling resource_bundle_accessor.swift"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftCompiling() {
        let input = #"SwiftCompile normal x86_64 Compiling\ BackyardBirdsDataContainer.swift,\ ColorData.swift,\ DataGeneration.swift,\ DataGenerationOptions.swift /Backyard-Birds/BackyardBirdsData/General/BackyardBirdsDataContainer.swift /Backyard-Birds/BackyardBirdsData/General/ColorData.swift /Backyard-Birds/BackyardBirdsData/General/DataGeneration.swift /Backyard-Birds/BackyardBirdsData/General/DataGenerationOptions.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func compileStoryboard() {
        let formatted = noColoredFormatted("CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)")
        #expect(formatted == "[MyApp] Compiling Main.storyboard")
    }

    @Test func compileWarning() {
        let input = "/path/file.swift:64:69: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value"
        let output = "[!]  /path/file.swift:64:69: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value\n\n"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func compileXCStrings() {
        let formatted = noColoredFormatted(#"CompileXCStrings /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData_BackyardBirdsData.build/ /Backyard-Birds/BackyardBirdsData/Backyards/Backyards.xcstrings (in target 'BackyardBirdsData_BackyardBirdsData' from project 'BackyardBirdsData')"#)
        #expect(formatted == "[BackyardBirdsData_BackyardBirdsData] Compile XCStrings Backyards.xcstrings")
    }

    @Test func compileXib() {
        let input = "CompileXIB /path/file.xib (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Compiling file.xib"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func copyHeader() {
        let input = "CpHeader /path/to/destination/file.h /path/file.h (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.h"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func copyPlist() {
        let input = "CopyPlistFile /path/to/destination/file.plist /path/file.plist (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.plist"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func copyStrings() {
        let input = "CopyStringsFile /path/to/destination/file.strings /path/file.strings (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.strings"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func cpresource() {
        let input = "CpResource /path/to/destination/file.ttf /path/file.ttf (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.ttf"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func copyMatchingSourceAndDestinationFiles() {
        let input = "Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"
        let output = "[Target] Copy file.swift -> file.swift"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func copyDifferentSourceAndDestinationFiles() {
        let input = #"Copy /Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let output = "[Backyard Birds] Copy x86_64-apple-macos.abi.json -> Backyard_Birds.abi.json"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func cursor() { }

    @Test func detectedEncoding() {
        let input = #"/Backyard-Birds/Build/Intermediates.noindex/Backyard Birds.build/Debug/Widgets.build/ar.lproj/Localizable.strings:1:1: note: detected encoding of input file as Unicode (UTF-8) (in target 'Widgets' from project 'Backyard Birds')"#
        let formatted = noColoredFormatted(input)
        #expect(formatted == nil)
    }

    @Test func executedWithoutSkipped() throws {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted1 = noColoredFormatted(input1)
        #expect(input1 == formatted1)

        let input2 = "Executed 3 tests, with 2 failures (1 unexpected) in 0.112 (0.112) seconds"
        let formatted2 = noColoredFormatted(input2)
        #expect(input2 == formatted2)

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let formatted3 = noColoredFormatted(input3)
        #expect(input3 == formatted3)

        let input4 = "Executed 1 test, with 1 failure (1 unexpected) in 0.200 (0.200) seconds"
        let formatted4 = noColoredFormatted(input4)
        #expect(input4 == formatted4)
    }

    #if os(macOS)
    @Test func executedWithSkipped() {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted1 = noColoredFormatted(input1)
        #expect(input1 == formatted1)

        let input2 = "Executed 56 tests, with 3 test skipped and 2 failures (1 unexpected) in 1.029 (1.029) seconds"
        let formatted2 = noColoredFormatted(input2)
        #expect(input2 == formatted2)

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let formatted3 = noColoredFormatted(input3)
        #expect(input3 == formatted3)

        let input4 = "Executed 1 test, with 1 test skipped and 1 failure (1 unexpected) in 3.000 (3.000) seconds"
        let formatted4 = noColoredFormatted(input4)
        #expect(input4 == formatted4)
    }
    #endif

    @Test func extractAppIntentsMetadata() {
        let formatted = noColoredFormatted("ExtractAppIntentsMetadata (in target 'Target' from project 'Project')")
        #expect(formatted == "[Target] Extract App Intents Metadata")
    }

    @Test func failingTest() { }

    @Test func fatalError() {
        let input = "fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        let output = "[x] fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func fileMissingError() {
        let input = "<unknown>:0: error: no such file or directory: '/path/file.swift'"
        let output = "[x] /path/file.swift: error: no such file or directory"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func generateAssetSymbols() {
        let formatted = noColoredFormatted("GenerateAssetSymbols /Backyard-Birds/BackyardBirdsData/Assets.xcassets (in target 'BackyardBirdsData' from project 'BackyardBirdsData')")
        #expect(formatted == "[BackyardBirdsData] Generate Asset Symbols Assets.xcassets")
    }

    @Test func generateCoverageData() {
        let formatted = noColoredFormatted("Generating coverage data...")
        #expect(formatted == "Generating code coverage data...")
    }

    @Test func generatedCoverageReport() {
        let formatted = noColoredFormatted("Generated coverage report: /path/to/code coverage.xccovreport")
        #expect(formatted == "Generated code coverage report: /path/to/code coverage.xccovreport")
    }

    @Test func generateDsym() {
        let input = "GenerateDSYMFile /path/file.dSYM /path/to/file (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Generating file.dSYM"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func genericWarning() {
        let input = "warning: some warning here 123"
        let output = "[!] some warning here 123"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func ldError() {
        let inputLdLibraryError = "ld: library not found for -lPods-Yammer"
        #expect(noColoredFormatted(inputLdLibraryError) == "[x] ld: library not found for -lPods-Yammer")

        let inputLdSymbolsError = "ld: symbol(s) not found for architecture x86_64"
        #expect(noColoredFormatted(inputLdSymbolsError) == "[x] ld: symbol(s) not found for architecture x86_64")
    }

    @Test func ldWarning() {
        let input = "ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"
        let output = "[!] ld: embedded dylibs/frameworks only run on iOS 8 or later"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func libtool() { }

    @Test func linkerDuplicateSymbolsLocation() { }

    @Test func linkerDuplicateSymbols() { }

    @Test func linkerUndefinedSymbolLocation() { }

    @Test func linkerUndefinedSymbols() { }

    @Test func linking() {
        #if os(macOS)
        let formatted = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/xcbeautify normal x86_64 (in target: xcbeautify)")
        #expect(formatted == "[xcbeautify] Linking xcbeautify")

        let formatted2 = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/MyApp-abcd/Build/Intermediates.noindex/ArchiveIntermediates/MyApp/IntermediateBuildFilesPath/MyApp.build/Release-iphoneos/MyApp.build/Objects-normal/armv7/My\\ App normal armv7 (in target: MyApp)")
        #expect(formatted2 == "[MyApp] Linking My\\ App")

        let formatted3 = noColoredFormatted("Ld /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/x86_64/Binary/BackyardBirdsData.o normal (in target 'BackyardBirdsData' from project 'BackyardBirdsData')")
        #expect(formatted3 == "[BackyardBirdsData] Linking BackyardBirdsData.o")
        #endif
    }

    @Test func moduleIncludesError() { }

    @Test func noCertificate() { }

    #if os(macOS)
    @Test func testCaseWithSpacesPassed() {
        let formatted = noColoredFormatted("Test Case '-[MyProject.MyTestSuite some component, when the disk is full, will display an error]' passed (0.005 seconds).")
        #expect(formatted == "    ✔ some component, when the disk is full, will display an error (0.005 seconds)")
    }
    #endif

    #if os(macOS)
    @Test func testCaseWithSpacesFailed() {
        let formatted = noColoredFormatted("/Users/jsmith/MyProject/Example.swift:12: error: -[MyProject.MyTestSuite one, when added to two, produces three] : expected to equal <3>, got <4>")
        #expect(formatted == "    ✖ one, when added to two, produces three, expected to equal <3>, got <4>")
    }
    #endif

    @Test func parallelTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "    ✖ [XcbeautifyLibTests] testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test func parallelTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "    ✔ [XcbeautifyLibTests] testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test func parallelTestCaseSkipped() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' skipped on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "    ⊘ [XcbeautifyLibTests] testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test func concurrentDestinationTestSuiteStarted() {
        let formatted = noColoredFormatted("Test suite 'XcbeautifyLibTests (iOS).xctest' started on 'iPhone X'")
        #expect(formatted == "Test Suite XcbeautifyLibTests (iOS).xctest started on 'iPhone X'")
    }

    @Test func concurrentDestinationTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'iPhone X' (77.158 seconds)")
        #expect(formatted == "    ✖ [XcbeautifyLibTests] testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    @Test func concurrentDestinationTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'iPhone X' (77.158 seconds)")
        #expect(formatted == "    ✔ [XcbeautifyLibTests] testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    @Test func parallelTestCaseAppKitPassed() {
        let formatted = noColoredFormatted("Test case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed on 'xctest (49438)' (0.131 seconds).")
        #expect(formatted == "    ✔ [XcbeautifyLibTests.XcbeautifyLibTests] testBuildTarget (0.131 seconds)")
    }

    @Test func parallelTestCaseAppKitWithSpacesPassed() {
        let formatted = noColoredFormatted("Test case '-[XcbeautifyLibTests.XcbeautifyLibTests test build target]' passed on 'xctest (49438)' (0.131 seconds).")
        #expect(formatted == "    ✔ [XcbeautifyLibTests.XcbeautifyLibTests] test build target (0.131 seconds)")
    }

    @Test func parallelTestingStarted() {
        let formatted = noColoredFormatted("Testing started on 'iPhone X'")
        #expect(formatted == "Testing started on 'iPhone X'")
    }

    @Test func parallelTestingPassed() {
        let formatted = noColoredFormatted("Testing passed on 'iPhone X'")
        #expect(formatted == "Testing passed on 'iPhone X'")
    }

    @Test func parallelTestingFailed() {
        let formatted = noColoredFormatted("Testing failed on 'iPhone X'")
        #expect(formatted == "Testing failed on 'iPhone X'")
    }

    @Test func pbxcp() {
        let formatted = noColoredFormatted("PBXCp /Users/admin/CocoaLumberjack/Classes/Extensions/DDDispatchQueueLogFormatter.h /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Products/Release/include/CocoaLumberjack/DDDispatchQueueLogFormatter.h (in target: CocoaLumberjack-Static)")
        #expect(formatted == "[CocoaLumberjack-Static] Copying DDDispatchQueueLogFormatter.h")
    }

    @Test func phaseScriptExecution() {
        let input1 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target: App)"
        let input2 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target 'App' from project 'App')"
        #expect(noColoredFormatted(input1) == "[App] Running script [CP] Check Pods Manifest.lock")
        #expect(noColoredFormatted(input2) == "[App] Running script [CP] Check Pods Manifest.lock")
    }

    @Test func phaseSuccess() {
        let formatted = noColoredFormatted("** CLEAN SUCCEEDED ** [0.085 sec]")
        #expect(formatted == "Clean Succeeded")
    }

    @Test func podsError() {
        let input = "error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        let output = "[x] error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        #expect(noColoredFormatted(input) == output)
    }

    @Test func preprocess() {
        let input = "Preprocess /Example/Example/Something.m normal arm64 (in target 'SomeTarget' from project 'SomeProject')"
        let output = "[SomeTarget] Preprocess Something.m"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func processInfoPlist() {
        let formatted = noColoredFormatted("ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist")
        #expect(formatted == "Processing Guaka_Info.plist")
    }

    @Test func processPchCommand() {
        let formatted = noColoredFormatted("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos10.13 -c /path/to/my.pch -o /path/to/output/AcVDiff_Prefix.pch.gch")
        #expect(formatted == "Preprocessing /path/to/my.pch")
    }

    @Test func processPchCommandArbitraryExtension() {
        let formatted = noColoredFormatted(#"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos12.3 -c /path/with\ space/cmake_pch.hxx -o /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch --serialize-diagnostics /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.dia"#)
        #expect(formatted == #"Preprocessing /path/with\ space/cmake_pch.hxx"#)
    }

    @Test func processPch() {
        let formatted = noColoredFormatted("ProcessPCH /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        #expect(formatted == "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    @Test func processPchArbitraryExtension() {
        let formatted = noColoredFormatted(#"ProcessPCH++ /Users/admin/src/Test\ Folder/_builds/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch /Users/admin/src/Test\ Folder/_builds/CMakeFiles/foo.dir/Debug/cmake_pch.hxx normal x86_64 c++ com.apple.compilers.llvm.clang.1_0.compiler (in target 'foo' from project 'foo')"#)
        #expect(formatted == "[foo] Processing cmake_pch.hxx")
    }

    @Test func processPchPlusPlus() {
        let formatted = noColoredFormatted("ProcessPCH++ /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        #expect(formatted == "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    @Test func provisioningProfileRequired() {
        let input = #"MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        let output = #"[x] MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        #expect(noColoredFormatted(input) == output)
    }

    @Test func restartingTests() {
        let formatted = noColoredFormatted("Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
        #expect(formatted == "    ✖ Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
    }

    @Test func shellCommand() {
        let formatted = noColoredFormatted("    cd /foo/bar/baz")
        #expect(formatted == nil)
    }

    @Test func symLink() {
        let formatted = noColoredFormatted("SymLink /Backyard-Birds/Build/Products/Debug/PackageFrameworks/LayeredArtworkLibrary.framework/LayeredArtworkLibrary Versions/Current/LayeredArtworkLibrary (in target 'LayeredArtworkLibrary' from project 'LayeredArtworkLibrary')")
        #expect(formatted == nil)
    }

    @Test func symbolReferencedFrom() {
        let formatted = noColoredFormatted("  \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        #expect(formatted == "[x]   \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
    }

    @Test func undefinedSymbolLocation() {
        let formatted = noColoredFormatted("      MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        #expect(formatted == "[!]       MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
    }

    @Test func testCaseMeasured() {
        #if os(macOS)
        let formatted = noColoredFormatted(#"/Users/cyberbeni/Desktop/framework/TypedNotificationCenter/<compiler-generated>:54: Test Case '-[TypedNotificationCenterPerformanceTests.BridgedNotificationTests test_subscribing_2senders_notificationName]' measured [High Water Mark For Heap Allocations, KB] average: 5407.634, relative standard deviation: 45.772%, values: [9341.718750, 3779.468750, 3779.468750, 9630.344727, 3779.468750, 3779.468750, 3895.093750, 3779.468750, 8532.372070, 3779.468750], performanceMetricID:com.apple.XCTPerformanceMetric_HighWaterMarkForHeapAllocations, baselineName: "", baselineAverage: , polarity: prefers smaller, maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 1.000, maxStandardDeviation: 1.000"#)
        #expect(formatted == #"    ◷ test_subscribing_2senders_notificationName measured (5407.634 KB ±45.772% -- High Water Mark For Heap Allocations)"#)
        #endif
    }

    @Test func testCasePassed() {
        #if os(macOS)
        let formatted = noColoredFormatted("Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds).")
        #expect(formatted == "    ✔ testBuildTarget (0.131 seconds)")
        #endif
    }

    @Test func testCaseSkipped() {
        #if os(macOS)
        let formatted = noColoredFormatted("Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' skipped (0.131 seconds).")
        #expect(formatted == "    ⊘ testBuildTarget (0.131 seconds)")
        #endif
    }

    @Test func testCaseStarted() { }

    @Test func testSuiteStarted() {
        let input = "Test Suite 'swift-testingPackageTests.xctest' started at 2024-10-09 16:48:58.588."
        let formatted = noColoredFormatted(input)
        #expect(formatted == input)
    }

    #if os(macOS)
    @Test func testSuiteAllTestsPassed() {
        let input = "Test Suite 'All tests' passed at 2022-01-15 21:31:49.073."
        let formatted = noColoredFormatted(input)
        #expect(input == formatted)
    }
    #endif

    #if os(macOS)
    @Test func testSuiteAllTestsFailed() {
        let input = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted = noColoredFormatted(input)
        #expect(input == formatted)
    }
    #endif

    @Test func testsRunCompletion() { }

    @Test func tiffutil() {
        let input = "TiffUtil file.tiff"
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func touch() {
        let formatted = noColoredFormatted("Touch /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-dgnqmpfertotpceazwfhtfwtuuwt/Build/Products/Debug/XcbeautifyLib.framework (in target: XcbeautifyLib)")
        #expect(formatted == "[XcbeautifyLib] Touching XcbeautifyLib.framework")
    }

    @Test func uiFailingTest() {
        let formatted = noColoredFormatted("    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>")
        #expect(formatted == "    ✖ <unknown>:0, App crashed in <external symbol>")
    }

    @Test func validate() {
        let formatted = noColoredFormatted(#"Validate /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app (in target 'Backyard Birds Target' from project 'Backyard Birds')"#)
        #expect(formatted == #"[Backyard Birds Target] Validate Backyard\ Birds.app"#)
    }

    @Test func validateEmbeddedBinary() {
        let formatted = noColoredFormatted(#"ValidateEmbeddedBinary /Backyard-Birds/Build/Products/Debug/Backyard\ Birds.app/Contents/PlugIns/Widgets.appex (in target 'Backyard Birds' from project 'Backyard Birds')"#)
        #expect(formatted == "[Backyard Birds] Validate Embedded Binary Widgets.appex")
    }

    @Test func willNotBeCodeSigned() {
        let input = "FrameworkName will not be code signed because its settings don't specify a development team."
        let output = "[!] FrameworkName will not be code signed because its settings don't specify a development team."
        #expect(noColoredFormatted(input) == output)
    }

    @Test func writeAuxiliaryFileGeneric() {
        let input = #"WriteAuxiliaryFile /path/to/some/auxiliary/file.extension (in target 'Target' from project 'Project')"#
        let output = "[Target] Write Auxiliary File file.extension"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func writeAuxiliaryFileBackyardBirds() {
        let input = #"WriteAuxiliaryFile /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.build/empty-LayeredArtworkLibrary_LayeredArtworkLibrary.plist (in target 'LayeredArtworkLibrary_LayeredArtworkLibrary' from project 'LayeredArtworkLibrary')"#
        let output = "[LayeredArtworkLibrary_LayeredArtworkLibrary] Write Auxiliary File empty-LayeredArtworkLibrary_LayeredArtworkLibrary.plist"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func writeFile() {
        let input = "write-file /path/file.SwiftFileList"
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func packageFetching() {
        let input1 = "Fetching from https://github.com/cpisciotta/xcbeautify"
        let output1 = "Fetching https://github.com/cpisciotta/xcbeautify"
        let formatted1 = noColoredFormatted(input1)
        #expect(formatted1 == output1)

        let input2 = "Fetching from https://github.com/cpisciotta/xcbeautify (cached)"
        let output2 = "Fetching https://github.com/cpisciotta/xcbeautify (cached)"
        let formatted2 = noColoredFormatted(input2)
        #expect(formatted2 == output2)

        let input3 = "Fetching from https://github.com/cpisciotta/xcbeautify.git"
        let output3 = "Fetching https://github.com/cpisciotta/xcbeautify.git"
        let formatted3 = noColoredFormatted(input3)
        #expect(formatted3 == output3)
    }

    @Test func packageUpdating() {
        let input1 = "Updating from https://github.com/cpisciotta/xcbeautify"
        let output1 = "Updating https://github.com/cpisciotta/xcbeautify"
        let formatted1 = noColoredFormatted(input1)
        #expect(formatted1 == output1)

        let input2 = "Updating from https://github.com/cpisciotta/xcbeautify (cached)"
        let output2 = "Updating https://github.com/cpisciotta/xcbeautify (cached)"
        let formatted2 = noColoredFormatted(input2)
        #expect(formatted2 == output2)

        let input3 = "Updating from https://github.com/cpisciotta/xcbeautify.git"
        let output3 = "Updating https://github.com/cpisciotta/xcbeautify.git"
        let formatted3 = noColoredFormatted(input3)
        #expect(formatted3 == output3)
    }

    @Test func packageCheckingOut() {
        let input1 = "Cloning local copy of package 'xcbeautify'"
        let formatted1 = noColoredFormatted(input1)
        #expect(formatted1 == nil)

        let input2 = "Checking out x.y.z of package 'xcbeautify'"
        let output2 = "Checking out 'xcbeautify' @ x.y.z"
        let formatted2 = noColoredFormatted(input2)
        #expect(formatted2 == output2)
    }

    @Test func packageGraphResolved() {
        // Start
        let start = noColoredFormatted("Resolve Package Graph")
        #expect(start == "Resolving Package Graph")

        // Ended
        let ended = noColoredFormatted("Resolved source packages:")
        #expect(ended == "Resolved source packages")

        // Package
        let package = noColoredFormatted("  StrasbourgParkAPI: https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
        #expect(package == "StrasbourgParkAPI - https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
    }

    @Test func xcodebuildError() {
        let formatted = noColoredFormatted("xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
        #expect(formatted == "[x] xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
    }

    @Test func xcodeprojError() {
        // Given
        let errorText = #"/path/to/project.xcodeproj: error: No signing certificate "iOS Distribution" found: No "iOS Distribution" signing certificate matching team ID "xxxxx" with a private key was found. (in target 'target' from project 'project')"#
        let expectedFormatted = #"""
        [x] /path/to/project.xcodeproj: No signing certificate "iOS Distribution" found: No "iOS Distribution" signing certificate matching team ID "xxxxx" with a private key was found. (in target 'target' from project 'project')


        """#

        // When
        let actualFormatted = noColoredFormatted(errorText)

        // Then
        #expect(actualFormatted == expectedFormatted)
    }

    @Test func xcodeprojWarning() {
        // Given
        let errorText = #"/Users/xxxxx/Example/Pods/Pods.xcodeproj: warning: The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 9.0, but the range of supported deployment target versions is 11.0 to 16.0.99. (in target 'XXPay' from project 'Pods')"#
        let expectedFormatted = #"""
        [!]  /Users/xxxxx/Example/Pods/Pods.xcodeproj: The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 9.0, but the range of supported deployment target versions is 11.0 to 16.0.99. (in target 'XXPay' from project 'Pods')


        """#

        // When
        let actualFormatted = noColoredFormatted(errorText)

        // Then
        #expect(actualFormatted == expectedFormatted)
    }

    @Test func duplicateLocalizedStringKey() {
        let formatted = noColoredFormatted(#"2022-12-07 16:26:40 --- WARNING: Key "duplicate" used with multiple values. Value "First" kept. Value "Second" ignored."#)
        #expect(formatted == #"[!] Key "duplicate" used with multiple values. Value "First" kept. Value "Second" ignored."#)
    }

    @Test func registerExecutionPolicyException() {
        let formatted = noColoredFormatted(#"RegisterExecutionPolicyException /path/to/output.o (in target 'Target' from project 'Project')"#)
        #expect(formatted == "[Target] RegisterExecutionPolicyException output.o")
    }

    @Test func testingStarted() {
        let formatted = noColoredFormatted(#"Testing started"#)
        #expect(formatted == #"Testing started"#)
    }

    @Test func signingBundle() {
        let formatted = noColoredFormatted(#"Signing Some_Bundle.bundle (in target 'Target' from project 'Project')"#)
        #expect(formatted == #"[Target] Signing Some_Bundle.bundle"#)
    }

    @Test func signingObjectFile() {
        let formatted = noColoredFormatted(#"Signing Some+File.o (in target 'Target' from project 'Project')"#)
        #expect(formatted == #"[Target] Signing Some+File.o"#)
    }

    @Test func swiftMergeGeneratedHeaders() {
        let formatted = noColoredFormatted(#"SwiftMergeGeneratedHeaders /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/DerivedSources/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/arm64/Backyard_Birds-Swift.h /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds-Swift.h (in target 'Backyard Birds' from project 'Backyard Birds')"#)
        #expect(formatted == nil)
    }

    @Test func swiftTestingRunStarted() {
        let input = #"􀟈 Test run started."#
        let output = "Test run started."
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingRunCompletion() {
        let input = #"􁁛 Test run with 5 tests passed after 12.345 seconds."#
        let output = "Test run with 5 tests passed after 12.345 seconds"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingRunFailed() {
        let input = #"􀢄 Test run with 10 tests failed after 15.678 seconds with 3 issues."#
        let output = "Test run with 10 tests failed after 15.678 seconds with 3 issue(s)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingSuiteStarted() {
        let input = #"􀟈 Suite MyTestSuite started."#
        let output = "Suite MyTestSuite started"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingSuitePassed() {
        let input = #"􁁛 Suite MyTestSuite passed after 5.123 seconds."#
        let output = "Suite MyTestSuite passed after 5.123 seconds"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingSuiteFailed() {
        let input = #"􀢄 Suite "My Test Suite" failed after 8.456 seconds with 2 issues."#
        let output = "Suite \"My Test Suite\" failed after 8.456 seconds with 2 issue(s)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingTestPassed() {
        let input = #"􁁛 Test myTest passed after 0.678 seconds."#
        let output = "    ✔ myTest (0.678 seconds)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingTestFailed() {
        let input = #"􀢄 Test "myTest" failed after 1.234 seconds with 1 issue."#
        let output = "    ✖ \"myTest\" (1.234 seconds) 1 issue(s)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingTestSkipped() {
        let input = #"􀙟 Test "myTest" skipped."#
        let output = "    ⊘ \"myTest\" skipped"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingTestSkippedReason() {
        let input = #"􀙟 Test "myTest" skipped: "Reason for skipping""#
        let output = "    ⊘ \"myTest\" skipped (Reason for skipping)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingIssue() {
        let input = #"􀢄 Test "myTest" recorded an issue with 2 arguments."#
        let output = "    [!]  Test \"myTest\" recorded an issue with 2 argument(s)"
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftTestingIssueDetails() {
        let input = #"􀢄  Test "myTest" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        let output = #"    [!]  Test "myTest" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        #expect(noColoredFormatted(input) == output)
    }

    @Test func swiftDriverTarget() throws {
        let input = #"SwiftDriver BackyardBirdsData normal arm64 com.apple.xcode.tools.swift.compiler (in target \'BackyardBirdsData\' from project \'BackyardBirdsData\')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func swiftDriverCompilationTarget() throws {
        let input = #"SwiftDriver\ Compilation SomeTarget normal x86_64 com.apple.xcode.tools.swift.compiler (in target 'Target' from project 'Project')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func swiftDriverCompilationRequirements() throws {
        let input = #"SwiftDriver\ Compilation\ Requirements Backyard\ Birds normal arm64 com.apple.xcode.tools.swift.compiler (in target 'Backyard Birds' from project 'Backyard Birds')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func mkDirCaptureGroup() throws {
        let input = #"MkDir /Backyard-Birds/Build/Products/Debug/Widgets.appex/Contents (in target \'Widgets\' from project \'Backyard Birds\')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func indentedClangCommand() {
        let input = #"    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func nonIndentedClangCommand() {
        let input = #"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -Xlinker -reproducible -target arm64-apple-macos14.0 -dynamiclib -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.2.sdk -O0 -L/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -L/Backyard-Birds/Build/Products/Debug -L/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib -F/Backyard-Birds/Build/Intermediates.noindex/EagerLinkingTBDs/Debug -F/Backyard-Birds/Build/Products/Debug/PackageFrameworks -F/Backyard-Birds/Build/Products/Debug -F/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -iframework /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -filelist /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData.LinkFileList -install_name @rpath/BackyardBirdsData.framework/Versions/A/BackyardBirdsData -Xlinker -rpath -Xlinker /Backyard-Birds/Build/Products/Debug/PackageFrameworks -Xlinker -object_path_lto -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-link-runtime -L/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx -L/usr/lib/swift -Wl,-no_warn_duplicate_libraries -Xlinker -dependency_info -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/BackyardBirdsData_dependency_info.dat -o /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData\ product.build/Objects-normal/arm64/Binary/BackyardBirdsData -Xlinker -add_ast_path -Xlinker /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/Objects-normal/arm64/BackyardBirdsData.swiftmodule"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func swiftEmitModule() {
        let input = #"SwiftEmitModule normal i386 Emitting\ module\ for\ CasePaths (in target 'CasePaths' from project 'swift-case-paths')"#
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func emitSwiftModule() {
        let input = "EmitSwiftModule normal arm64 (in target 'Target' from project 'Project')"
        #expect(noColoredFormatted(input) == nil)
    }

    @Test func note() {
        let formatted = noColoredFormatted("note: Building targets in dependency order")
        #expect(formatted == "note: Building targets in dependency order")
    }

    @Test func dataModelCodegen() {
        let formatted = noColoredFormatted("DataModelCodegen /path/to/data/model/something.xcdatamodeld (in target 'Target' from project 'Project')")
        #expect(formatted == "[Target] DataModelCodegen /path/to/data/model/something.xcdatamodeld")
    }
}
