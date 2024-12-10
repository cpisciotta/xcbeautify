import Testing
@testable import XcbeautifyLib

@MainActor
@Suite
struct AzureDevOpsPipelinesRendererTests {
    private var parser: Parser!
    private var formatter: XcbeautifyLib.Formatter!

    init() {
        parser = Parser()
        formatter = Formatter(colored: false, renderer: .azureDevOpsPipelines, additionalLines: { nil })
    }

    private func logFormatted(_ string: String) -> String? {
        guard let captureGroup = parser.parse(line: string) else { return nil }
        return formatter.format(captureGroup: captureGroup)
    }

    @Test
    func aggregateTarget() {
        let formatted = logFormatted("=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ===")
        #expect(formatted == "Aggregate target Be Aggro of project AggregateExample with configuration Debug")
    }

    @Test
    func analyze() {
        let formatted = logFormatted("AnalyzeShallow /Users/admin/CocoaLumberjack/Classes/DDTTYLogger.m normal x86_64 (in target: CocoaLumberjack-Static)")
        #expect(formatted == "[CocoaLumberjack-Static] Analyzing DDTTYLogger.m")
    }

    @Test
    func analyzeTarget() {
        let formatted = logFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Analyze target The Spacer of project Pods with configuration Debug")
    }

    @Test
    func buildTarget() {
        let formatted = logFormatted("=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Build target The Spacer of project Pods with configuration Debug")
    }

    @Test
    func checkDependenciesErrors() { }

    @Test
    func checkDependencies() {
        let command = "Check Dependencies"
        let formatted = logFormatted(command)
        #expect(formatted == command)
    }

    @Test
    func clangError() {
        let formatted = logFormatted("clang: error: linker command failed with exit code 1 (use -v to see invocation)")
        #expect(formatted == "###vso[task.logissue type=error]clang: error: linker command failed with exit code 1 (use -v to see invocation)")
    }

    @Test
    func cleanRemove() {
        let formatted = logFormatted("Clean.Remove clean /Users/admin/Library/Developer/Xcode/DerivedData/MyLibrary-abcd/Build/Intermediates/MyLibrary.build/Debug-iphonesimulator/MyLibraryTests.build")
        #expect(formatted == "Cleaning MyLibraryTests.build")
    }

    @Test
    func cleanTarget() {
        let formatted = logFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        #expect(formatted == "Analyze target The Spacer of project Pods with configuration Debug")
    }

    @Test
    func codesignFramework() {
        let formatted = logFormatted("CodeSign build/Release/MyFramework.framework/Versions/A")
        #expect(formatted == "Signing build/Release/MyFramework.framework")
    }

    @Test
    func codesign() {
        let formatted = logFormatted("CodeSign build/Release/MyApp.app")
        #expect(formatted == "Signing MyApp.app")
    }

    @Test
    func multipleCodesigns() {
        let formattedApp = logFormatted("CodeSign build/Release/MyApp.app")
        let formattedFramework = logFormatted("CodeSign build/Release/MyFramework.framework/Versions/A (in target 'X' from project 'Y')")
        #expect(formattedApp == "Signing MyApp.app")
        #expect(formattedFramework == "Signing build/Release/MyFramework.framework")
    }

    @Test
    func compileCommand() { }

    @Test
    func compileError() {
        let inputError = "/path/file.swift:64:69: error: cannot find 'input' in scope"
        let outputError = "###vso[task.logissue type=error;sourcepath=/path/file.swift;linenumber=64;columnnumber=69]cannot find 'input' in scope\n\n"
        #expect(logFormatted(inputError) == outputError)

        let inputFatal = "/path/file.swift:64:69: fatal error: cannot find 'input' in scope"
        let outputFatal = "###vso[task.logissue type=error;sourcepath=/path/file.swift;linenumber=64;columnnumber=69]cannot find 'input' in scope\n\n"
        #expect(logFormatted(inputFatal) == outputFatal)
    }

    @Test
    func compile() {
        #if os(macOS)
        // Xcode 10 and before
        let input1 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target: xcbeautify)"
        // Xcode 11+'s output
        let input2 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target 'xcbeautify' from project 'xcbeautify')"
        let output = "[xcbeautify] Compiling setup.swift"
        #expect(logFormatted(input1) == output)
        #expect(logFormatted(input2) == output)
        #endif
    }

    @Test
    func swiftCompile_arm64() {
        let input = "SwiftCompile normal arm64 /path/to/File.swift (in target 'Target' from project 'Project')"
        let output = "[Target] Compiling File.swift"
        #expect(logFormatted(input) == output)
    }

    @Test
    func swiftCompile_x86_64() {
        let input = "SwiftCompile normal x86_64 /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/resource_bundle_accessor.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"
        let output = "[BackyardBirdsData] Compiling resource_bundle_accessor.swift"
        #expect(logFormatted(input) == output)
    }

    @Test
    func swiftCompiling() {
        let input = #"SwiftCompile normal x86_64 Compiling\ BackyardBirdsDataContainer.swift,\ ColorData.swift,\ DataGeneration.swift,\ DataGenerationOptions.swift /Backyard-Birds/BackyardBirdsData/General/BackyardBirdsDataContainer.swift /Backyard-Birds/BackyardBirdsData/General/ColorData.swift /Backyard-Birds/BackyardBirdsData/General/DataGeneration.swift /Backyard-Birds/BackyardBirdsData/General/DataGenerationOptions.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#
        #expect(logFormatted(input) == nil)
    }

    @Test
    func compileStoryboard() {
        let formatted = logFormatted("CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)")
        #expect(formatted == "[MyApp] Compiling Main.storyboard")
    }

    @Test
    func compileWarning() {
        let input = "/path/file.swift:64:69: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value"
        let output = "###vso[task.logissue type=warning;sourcepath=/path/file.swift;linenumber=64;columnnumber=69]'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value\n\n"
        #expect(logFormatted(input) == output)
    }

    @Test
    func compileXib() {
        let input = "CompileXIB /path/file.xib (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Compiling file.xib"
        #expect(logFormatted(input) == output)
    }

    @Test
    func copyHeader() {
        let input = "CpHeader /path/to/destination/file.h /path/file.h (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.h"
        #expect(logFormatted(input) == output)
    }

    @Test
    func copyPlist() {
        let input = "CopyPlistFile /path/to/destination/file.plist /path/file.plist (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.plist"
        #expect(logFormatted(input) == output)
    }

    @Test
    func copyStrings() {
        let input = "CopyStringsFile /path/to/destination/file.strings /path/file.strings (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.strings"
        #expect(logFormatted(input) == output)
    }

    @Test
    func cpResource() {
        let input = "CpResource /path/to/destination/file.ttf /path/file.ttf (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.ttf"
        #expect(logFormatted(input) == output)
    }

    @Test
    func copyMatchingSourceAndDestinationFiles() {
        let input = "Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"
        let output = "[Target] Copy file.swift -> file.swift"
        #expect(logFormatted(input) == output)
    }

    @Test
    func copyDifferentSourceAndDestinationFiles() {
        let input = #"Copy /Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let output = "[Backyard Birds] Copy x86_64-apple-macos.abi.json -> Backyard_Birds.abi.json"
        #expect(logFormatted(input) == output)
    }

    @Test
    func cursor() { }

    @Test
    func executed() throws {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted1 = logFormatted(input1)
        #expect(input1 == formatted1)

        let input2 = "Executed 3 tests, with 2 failures (1 unexpected) in 0.112 (0.112) seconds"
        let formatted2 = logFormatted(input2)
        #expect(input2 == formatted2)

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let formatted3 = logFormatted(input3)
        #expect(input3 == formatted3)

        let input4 = "Executed 1 test, with 1 failure (1 unexpected) in 0.200 (0.200) seconds"
        let formatted4 = logFormatted(input4)
        #expect(input4 == formatted4)
    }

    #if os(macOS)
    @Test
    func executedWithSkipped() {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted1 = logFormatted(input1)
        #expect(input1 == formatted1)

        let input2 = "Executed 56 tests, with 3 test skipped and 2 failures (1 unexpected) in 1.029 (1.029) seconds"
        let formatted2 = logFormatted(input2)
        #expect(input2 == formatted2)

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let formatted3 = logFormatted(input3)
        #expect(input3 == formatted3)

        let input4 = "Executed 1 test, with 1 test skipped and 1 failure (1 unexpected) in 3.000 (3.000) seconds"
        let formatted4 = logFormatted(input4)
        #expect(input4 == formatted4)
    }
    #endif

    @Test
    func failingTest() { }

    @Test
    func fatalError() {
        let input = "fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        let output = "###vso[task.logissue type=error]fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        #expect(logFormatted(input) == output)
    }

    @Test
    func fileMissingError() {
        let input = "<unknown>:0: error: no such file or directory: '/path/file.swift'"
        let output = "###vso[task.logissue type=error;sourcepath=/path/file.swift]error: no such file or directory:"
        #expect(logFormatted(input) == output)
    }

    @Test
    func generateCoverageData() {
        let formatted = logFormatted("Generating coverage data...")
        #expect(formatted == "Generating code coverage data...")
    }

    @Test
    func generatedCoverageReport() {
        let formatted = logFormatted("Generated coverage report: /path/to/code coverage.xccovreport")
        #expect(formatted == "Generated code coverage report: /path/to/code coverage.xccovreport")
    }

    @Test
    func generateDsym() {
        let input = "GenerateDSYMFile /path/file.dSYM /path/to/file (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Generating file.dSYM"
        #expect(logFormatted(input) == output)
    }

    @Test
    func genericWarning() {
        let input = "warning: some warning here 123"
        let output = "###vso[task.logissue type=warning]some warning here 123"
        #expect(logFormatted(input) == output)
    }

    @Test
    func ldError() {
        let inputLdLibraryError = "ld: library not found for -lPods-Yammer"
        #expect(logFormatted(inputLdLibraryError) == "###vso[task.logissue type=error]ld: library not found for -lPods-Yammer")

        let inputLdSymbolsError = "ld: symbol(s) not found for architecture x86_64"
        #expect(logFormatted(inputLdSymbolsError) == "###vso[task.logissue type=error]ld: symbol(s) not found for architecture x86_64")
    }

    @Test
    func ldWarning() {
        let input = "ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"
        let output = "###vso[task.logissue type=warning]ld: embedded dylibs/frameworks only run on iOS 8 or later"
        #expect(logFormatted(input) == output)
    }

    @Test
    func libtool() { }

    @Test
    func linkerDuplicateSymbolsLocation() { }

    @Test
    func linkerDuplicateSymbols() { }

    @Test
    func linkerUndefinedSymbolLocation() { }

    @Test
    func linkerUndefinedSymbols() { }

    @Test
    func linking() {
        #if os(macOS)
        let formatted = logFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/xcbeautify normal x86_64 (in target: xcbeautify)")
        #expect(formatted == "[xcbeautify] Linking xcbeautify")

        let formatted2 = logFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/MyApp-abcd/Build/Intermediates.noindex/ArchiveIntermediates/MyApp/IntermediateBuildFilesPath/MyApp.build/Release-iphoneos/MyApp.build/Objects-normal/armv7/My\\ App normal armv7 (in target: MyApp)")
        #expect(formatted2 == "[MyApp] Linking My\\ App")
        #endif
    }

    @Test
    func moduleIncludesError() { }

    @Test
    func noCertificate() { }

    @Test
    func parallelTestCaseFailed() {
        let formatted = logFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "###vso[task.logissue type=error]    testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test
    func parallelTestCasePassed() {
        let formatted = logFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "    ✔ [XcbeautifyLibTests] testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test
    func parallelTestCaseSkipped() {
        let formatted = logFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' skipped on 'xctest (49438)' (0.131 seconds)")
        #expect(formatted == "    ⊘ [XcbeautifyLibTests] testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    @Test
    func concurrentDestinationTestSuiteStarted() {
        let formatted = logFormatted("Test suite 'XcbeautifyLibTests (iOS).xctest' started on 'iPhone X'")
        #expect(formatted == "Test Suite XcbeautifyLibTests (iOS).xctest started on 'iPhone X'")
    }

    @Test
    func concurrentDestinationTestCaseFailed() {
        let formatted = logFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'iPhone X' (77.158 seconds)")
        #expect(formatted == "###vso[task.logissue type=error]    testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    @Test
    func concurrentDestinationTestCasePassed() {
        let formatted = logFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'iPhone X' (77.158 seconds)")
        #expect(formatted == "    ✔ [XcbeautifyLibTests] testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    @Test
    func parallelTestCaseAppKitPassed() {
        let formatted = logFormatted("Test case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed on 'xctest (49438)' (0.131 seconds).")
        #expect(formatted == "    ✔ [XcbeautifyLibTests.XcbeautifyLibTests] testBuildTarget (0.131 seconds)")
    }

    @Test
    func parallelTestingStarted() {
        let formatted = logFormatted("Testing started on 'iPhone X'")
        #expect(formatted == "Testing started on 'iPhone X'")
    }

    @Test
    func parallelTestingPassed() {
        let formatted = logFormatted("Testing passed on 'iPhone X'")
        #expect(formatted == "Testing passed on 'iPhone X'")
    }

    @Test
    func parallelTestingFailed() {
        let formatted = logFormatted("Testing failed on 'iPhone X'")
        #expect(formatted == "###vso[task.logissue type=error]Testing failed on 'iPhone X'")
    }

    @Test
    func pbxCp() {
        let formatted = logFormatted("PBXCp /Users/admin/CocoaLumberjack/Classes/Extensions/DDDispatchQueueLogFormatter.h /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Products/Release/include/CocoaLumberjack/DDDispatchQueueLogFormatter.h (in target: CocoaLumberjack-Static)")
        #expect(formatted == "[CocoaLumberjack-Static] Copying DDDispatchQueueLogFormatter.h")
    }

    @Test
    func phaseScriptExecution() {
        let input1 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target: App)"
        let input2 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target 'App' from project 'App')"
        #expect(logFormatted(input1) == "[App] Running script [CP] Check Pods Manifest.lock")
        #expect(logFormatted(input2) == "[App] Running script [CP] Check Pods Manifest.lock")
    }

    @Test
    func phaseSuccess() {
        let formatted = logFormatted("** CLEAN SUCCEEDED ** [0.085 sec]")
        #expect(formatted == "Clean Succeeded")
    }

    @Test
    func podsError() {
        let input = "error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        let output = "###vso[task.logissue type=error]error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        #expect(logFormatted(input) == output)
    }

    @Test
    func preprocess() {
        let input = "Preprocess /Example/Example/Something.m normal arm64 (in target 'SomeTarget' from project 'SomeProject')"
        let output = "[SomeTarget] Preprocess Something.m"
        #expect(logFormatted(input) == output)
    }

    @Test
    func processInfoPlist() {
        let formatted = logFormatted("ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist")
        #expect(formatted == "Processing Guaka_Info.plist")
    }

    @Test
    func processPchCommand() {
        let formatted = logFormatted("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos10.13 -c /path/to/my.pch -o /path/to/output/AcVDiff_Prefix.pch.gch")
        #expect(formatted == "Preprocessing /path/to/my.pch")
    }

    @Test
    func processPchCommandArbitraryExtension() {
        let formatted = logFormatted(#"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos12.3 -c /path/with\ space/cmake_pch.hxx -o /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch --serialize-diagnostics /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.dia"#)
        #expect(formatted == #"Preprocessing /path/with\ space/cmake_pch.hxx"#)
    }

    @Test
    func processPch() {
        let formatted = logFormatted("ProcessPCH /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        #expect(formatted == "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    @Test
    func processPchArbitraryExtension() {
        let formatted = logFormatted(#"ProcessPCH++ /Users/admin/src/Test\ Folder/_builds/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch /Users/admin/src/Test\ Folder/_builds/CMakeFiles/foo.dir/Debug/cmake_pch.hxx normal x86_64 c++ com.apple.compilers.llvm.clang.1_0.compiler (in target 'foo' from project 'foo')"#)
        #expect(formatted == "[foo] Processing cmake_pch.hxx")
    }

    @Test
    func processPchPlusPlus() {
        let formatted = logFormatted("ProcessPCH++ /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        #expect(formatted == "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    @Test
    func provisioningProfileRequired() {
        let input = #"MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        let output = #"###vso[task.logissue type=error]MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        #expect(logFormatted(input) == output)
    }

    @Test
    func restartingTests() {
        let formatted = logFormatted("Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
        #expect(formatted == "###vso[task.logissue type=error]    Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
    }

    @Test
    func shellCommand() {
        let formatted = logFormatted("    cd /foo/bar/baz")
        #expect(formatted == nil)
    }

    @Test
    func symbolReferencedFrom() {
        let formatted = logFormatted("  \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        #expect(formatted == "###vso[task.logissue type=error]  \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
    }

    @Test
    func undefinedSymbolLocation() {
        let formatted = logFormatted("      MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        #expect(formatted == "###vso[task.logissue type=warning]      MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
    }

    @Test
    func testCaseMeasured() {
        #if os(macOS)
        let formatted = logFormatted(#"/Users/cyberbeni/Desktop/framework/TypedNotificationCenter/<compiler-generated>:54: Test Case '-[TypedNotificationCenterPerformanceTests.BridgedNotificationTests test_subscribing_2senders_notificationName]' measured [High Water Mark For Heap Allocations, KB] average: 5407.634, relative standard deviation: 45.772%, values: [9341.718750, 3779.468750, 3779.468750, 9630.344727, 3779.468750, 3779.468750, 3895.093750, 3779.468750, 8532.372070, 3779.468750], performanceMetricID:com.apple.XCTPerformanceMetric_HighWaterMarkForHeapAllocations, baselineName: "", baselineAverage: , polarity: prefers smaller, maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 1.000, maxStandardDeviation: 1.000"#)
        #expect(formatted == #"    ◷ test_subscribing_2senders_notificationName measured (5407.634 KB ±45.772% -- High Water Mark For Heap Allocations)"#)
        #endif
    }

    @Test
    func testCasePassed() {
        #if os(macOS)
        let formatted = logFormatted("Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds).")
        #expect(formatted == "    ✔ testBuildTarget (0.131 seconds)")
        #endif
    }

    @Test
    func testCaseSkipped() {
        #if os(macOS)
        let formatted = logFormatted("Test Case '-[SomeTests testName]' skipped (0.004 seconds).")
        #expect(formatted == "    ⊘ testName (0.004 seconds)")
        #endif
    }

    @Test
    func testCasePending() { }

    @Test
    func testCaseStarted() { }

    @Test
    func testSuiteStart() { }

    @Test
    func testSuiteStarted() { }

    #if os(macOS)
    @Test
    func testSuiteAllTestsPassed() {
        let input = "Test Suite 'All tests' passed at 2022-01-15 21:31:49.073."
        let formatted = logFormatted(input)
        #expect(input == formatted)
    }
    #endif

    #if os(macOS)
    @Test
    func testSuiteAllTestsFailed() {
        let input = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let formatted = logFormatted(input)
        #expect(input == formatted)
    }
    #endif

    @Test
    func testsRunCompletion() { }

    @Test
    func tiffutil() {
        let input = "TiffUtil file.tiff"
        #expect(logFormatted(input) == nil)
    }

    @Test
    func touch() {
        let formatted = logFormatted("Touch /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-dgnqmpfertotpceazwfhtfwtuuwt/Build/Products/Debug/XcbeautifyLib.framework (in target: XcbeautifyLib)")
        #expect(formatted == "[XcbeautifyLib] Touching XcbeautifyLib.framework")
    }

    @Test
    func uiFailingTest() {
        let formatted = logFormatted("    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>")
        #expect(formatted == "###vso[task.logissue type=error;sourcepath=<unknown>;linenumber=0]    App crashed in <external symbol>")
    }

    @Test
    func willNotBeCodeSigned() {
        let input = "FrameworkName will not be code signed because its settings don't specify a development team."
        let output = "###vso[task.logissue type=warning]FrameworkName will not be code signed because its settings don't specify a development team."
        #expect(logFormatted(input) == output)
    }

    @Test
    func writeAuxiliaryFileGeneric() {
        let input = #"WriteAuxiliaryFile /path/to/some/auxiliary/file.extension (in target 'Target' from project 'Project')"#
        let output = "[Target] Write Auxiliary File file.extension"
        #expect(logFormatted(input) == output)
    }

    @Test
    func writeAuxiliaryFileBackyardBirds() {
        let input = #"WriteAuxiliaryFile /Backyard-Birds/Build/Intermediates.noindex/LayeredArtworkLibrary.build/Debug/LayeredArtworkLibrary_LayeredArtworkLibrary.build/empty-LayeredArtworkLibrary_LayeredArtworkLibrary.plist (in target 'LayeredArtworkLibrary_LayeredArtworkLibrary' from project 'LayeredArtworkLibrary')"#
        let output = "[LayeredArtworkLibrary_LayeredArtworkLibrary] Write Auxiliary File empty-LayeredArtworkLibrary_LayeredArtworkLibrary.plist"
        #expect(logFormatted(input) == output)
    }

    @Test
    func writeFile() {
        let input = "write-file /path/file.SwiftFileList"
        #expect(logFormatted(input) == nil)
    }

    @Test
    func packageFetching() {
        let input1 = "Fetching from https://github.com/cpisciotta/xcbeautify"
        let output1 = "Fetching https://github.com/cpisciotta/xcbeautify"
        let formatted1 = logFormatted(input1)
        #expect(formatted1 == output1)

        let input2 = "Fetching from https://github.com/cpisciotta/xcbeautify (cached)"
        let output2 = "Fetching https://github.com/cpisciotta/xcbeautify (cached)"
        let formatted2 = logFormatted(input2)
        #expect(formatted2 == output2)

        let input3 = "Fetching from https://github.com/cpisciotta/xcbeautify.git"
        let output3 = "Fetching https://github.com/cpisciotta/xcbeautify.git"
        let formatted3 = logFormatted(input3)
        #expect(formatted3 == output3)
    }

    @Test
    func packageUpdating() {
        let input1 = "Updating from https://github.com/cpisciotta/xcbeautify"
        let output1 = "Updating https://github.com/cpisciotta/xcbeautify"
        let formatted1 = logFormatted(input1)
        #expect(formatted1 == output1)

        let input2 = "Updating from https://github.com/cpisciotta/xcbeautify (cached)"
        let output2 = "Updating https://github.com/cpisciotta/xcbeautify (cached)"
        let formatted2 = logFormatted(input2)
        #expect(formatted2 == output2)

        let input3 = "Updating from https://github.com/cpisciotta/xcbeautify.git"
        let output3 = "Updating https://github.com/cpisciotta/xcbeautify.git"
        let formatted3 = logFormatted(input3)
        #expect(formatted3 == output3)
    }

    @Test
    func packageCheckingOut() {
        let input1 = "Cloning local copy of package 'xcbeautify'"
        let formatted1 = logFormatted(input1)
        #expect(formatted1 == nil)

        let input2 = "Checking out x.y.z of package 'xcbeautify'"
        let output2 = "Checking out 'xcbeautify' @ x.y.z"
        let formatted2 = logFormatted(input2)
        #expect(formatted2 == output2)
    }

    @Test
    func packageGraphResolved() {
        // Start
        let start = logFormatted("Resolve Package Graph")
        #expect(start == "Resolving Package Graph")

        // Ended
        let ended = logFormatted("Resolved source packages:")
        #expect(ended == "Resolved source packages")

        // Package
        let package = logFormatted("  StrasbourgParkAPI: https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
        #expect(package == "StrasbourgParkAPI - https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
    }

    @Test
    func xcodebuildError() {
        let formatted = logFormatted("xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
        #expect(formatted == "###vso[task.logissue type=error]xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
    }

    @Test
    func xcodeprojError() {
        // Given
        let errorText = #"/path/to/project.xcodeproj: error: No signing certificate "iOS Distribution" found: No "iOS Distribution" signing certificate matching team ID "xxxxx" with a private key was found. (in target 'target' from project 'project')"#
        let expectedFormatted = "###vso[task.logissue type=error;sourcepath=/path/to/project.xcodeproj]No signing certificate \"iOS Distribution\" found: No \"iOS Distribution\" signing certificate matching team ID \"xxxxx\" with a private key was found. (in target 'target' from project 'project')\n\n"

        // When
        let actualFormatted = logFormatted(errorText)

        // Then
        #expect(actualFormatted == expectedFormatted)
    }

    @Test
    func xcodeprojWarning() {
        // Given
        let errorText = "/Users/xxxxx/Example/Pods/Pods.xcodeproj: warning: The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 9.0, but the range of supported deployment target versions is 11.0 to 16.0.99. (in target 'XXPay' from project 'Pods')"
        let expectedFormatted = "###vso[task.logissue type=warning;sourcepath=/Users/xxxxx/Example/Pods/Pods.xcodeproj]The iOS deployment target 'IPHONEOS_DEPLOYMENT_TARGET' is set to 9.0, but the range of supported deployment target versions is 11.0 to 16.0.99. (in target 'XXPay' from project 'Pods')\n\n"

        // When
        let actualFormatted = logFormatted(errorText)

        // Then
        #expect(actualFormatted == expectedFormatted)
    }

    @Test
    func duplicateLocalizedStringKey() {
        let formatted = logFormatted(#"2022-12-07 16:26:40 --- WARNING: Key "duplicate" used with multiple values. Value "First" kept. Value "Second" ignored."#)
        #expect(formatted == #"###vso[task.logissue type=warning]Key "duplicate" used with multiple values. Value "First" kept. Value "Second" ignored."#)
    }

    @Test
    func testingStarted() {
        let formatted = logFormatted(#"Testing started"#)
        #expect(formatted == #"Testing started"#)
    }

    @Test
    func swiftTestingRunCompletion() {
        let input = #"􁁛 Test run with 5 tests passed after 12.345 seconds."#
        let formatted = logFormatted(input)
        let expectedOutput = "Test run with 5 tests passed after 12.345 seconds"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingRunFailed() {
        let input = #"􀢄 Test run with 10 tests failed after 15.678 seconds with 3 issues."#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]Test run with 10 tests failed after 15.678 seconds with 3 issue(s)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingSuiteFailed() {
        let input = #"􀢄 Suite "MyTestSuite" failed after 8.456 seconds with 2 issues."#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]Suite \"MyTestSuite\" failed after 8.456 seconds with 2 issue(s)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingTestFailed() {
        let input = #"􀢄 Test "myTest" failed after 1.234 seconds with 1 issue."#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]\"myTest\" (1.234 seconds) 1 issue(s)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingTestSkipped() {
        let input = #"􀙟 Test myTest() skipped."#
        let formatted = logFormatted(input)
        let expectedOutput = "    ⊘ myTest() skipped"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingTestSkippedReason() {
        let input = #"􀙟 Test myTest() skipped: "Reason for skipping""#
        let formatted = logFormatted(input)
        let expectedOutput = "    ⊘ myTest() skipped (Reason for skipping)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingIssue() {
        let input = #"􀢄  Test "myTest" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]Recorded an issue (PlanTests.swift:43:5: Expectation failed)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingIssueArguments() {
        let input = #"􀢄 Test "myTest" recorded an issue with 2 arguments."#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]Recorded an issue (2) argument(s)"
        #expect(formatted == expectedOutput)
    }

    @Test
    func swiftTestingIssueDetails() {
        let input = #"􀢄  Test "myTest" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        let formatted = logFormatted(input)
        let expectedOutput = "###vso[task.logissue type=error]Recorded an issue (PlanTests.swift:43:5: Expectation failed)"
        #expect(formatted == expectedOutput)
    }
}
