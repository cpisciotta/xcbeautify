import XCTest
@testable import XcbeautifyLib

final class XcbeautifyLibTests: XCTestCase {
    let parser = Parser()

    private func noColoredFormatted(_ string: String) -> String? {
        return parser.parse(line: string, colored: false, additionalLines: { nil })
    }

    func testAggregateTarget() {
        let formatted = noColoredFormatted("=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Aggregate target Be Aggro of project AggregateExample with configuration Debug")
    }

    func testAnalyze() {
        let formatted = noColoredFormatted("AnalyzeShallow /Users/admin/CocoaLumberjack/Classes/DDTTYLogger.m normal x86_64 (in target: CocoaLumberjack-Static)")
        XCTAssertEqual(formatted, "[CocoaLumberjack-Static] Analyzing DDTTYLogger.m")
    }

    func testAnalyzeTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Analyze target The Spacer of project Pods with configuration Debug")
    }

    func testBuildTarget() {
        let formatted = noColoredFormatted("=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Build target The Spacer of project Pods with configuration Debug")
    }

    func testCheckDependenciesErrors() {
    }

    func testCheckDependencies() {
    }

    func testClangError() {
        let formatted = noColoredFormatted("clang: error: linker command failed with exit code 1 (use -v to see invocation)")
        XCTAssertEqual(formatted, "[x] clang: error: linker command failed with exit code 1 (use -v to see invocation)")
    }

    func testCleanRemove() {
        let formatted = noColoredFormatted("Clean.Remove clean /Users/admin/Library/Developer/Xcode/DerivedData/MyLibrary-abcd/Build/Intermediates/MyLibrary.build/Debug-iphonesimulator/MyLibraryTests.build")
        XCTAssertEqual(formatted, "Cleaning MyLibraryTests.build")
    }

    func testCleanTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Analyze target The Spacer of project Pods with configuration Debug")
    }

    func testCodesignFramework() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyFramework.framework/Versions/A")
        XCTAssertEqual(formatted, "Signing build/Release/MyFramework.framework")
    }

    func testCodesign() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyApp.app")
        XCTAssertEqual(formatted, "Signing MyApp.app")
    }

    func testCompileCommand() {
    }

    func testCompileError() {
    }

    func testCompile() {
#if os(macOS)
        // Xcode 10 and before
        let input1 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target: xcbeautify)"
        // Xcode 11+'s output
        let input2 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target 'xcbeautify' from project 'xcbeautify')"
        let output = "[xcbeautify] Compiling setup.swift"
        XCTAssertEqual(noColoredFormatted(input1), output)
        XCTAssertEqual(noColoredFormatted(input2), output)
#endif
    }

    func testCompileStoryboard() {
        let formatted = noColoredFormatted("CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)")
        XCTAssertEqual(formatted, "[MyApp] Compiling Main.storyboard")
    }

    func testCompileWarning() {
    }

    func testCompileXib() {
    }

    func testCopyHeader() {
    }

    func testCopyPlist() {
    }

    func testCopyStrings() {
    }

    func testCpresource() {
    }

    func testCursor() {
    }

    func testExecuted() {
    }

    func testFailingTest() {
    }

    func testFatalError() {
    }

    func testFileMissingError() {
    }

    func testGenerateCoverageData() {
        let formatted = noColoredFormatted("Generating coverage data...")
        XCTAssertEqual(formatted, "Generating code coverage data...")
    }

    func testGeneratedCoverageReport() {
        let formatted = noColoredFormatted("Generated coverage report: /path/to/code coverage.xccovreport")
        XCTAssertEqual(formatted, "Generated code coverage report: /path/to/code coverage.xccovreport")
    }

    func testGenerateDsym() {
    }

    func testGenericWarning() {
    }

    func testLdError() {
    }

    func testLdWarning() {
    }

    func testLibtool() {
    }

    func testLinkerDuplicateSymbolsLocation() {
    }

    func testLinkerDuplicateSymbols() {
    }

    func testLinkerUndefinedSymbolLocation() {
    }

    func testLinkerUndefinedSymbols() {
    }

    func testLinking() {
#if os(macOS)
        let formatted = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/xcbeautify normal x86_64 (in target: xcbeautify)")
        XCTAssertEqual(formatted, "[xcbeautify] Linking xcbeautify")

        let formatted2 = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/MyApp-abcd/Build/Intermediates.noindex/ArchiveIntermediates/MyApp/IntermediateBuildFilesPath/MyApp.build/Release-iphoneos/MyApp.build/Objects-normal/armv7/My\\ App normal armv7 (in target: MyApp)")
        XCTAssertEqual(formatted2, "[MyApp] Linking My\\ App")
#endif
    }

    func testModuleIncludesError() {
    }

    func testNoCertificate() {
    }

    func testParallelTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'xctest (49438)' (0.131 seconds)")
        XCTAssertEqual(formatted, "    ✖ testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    func testParallelTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'xctest (49438)' (0.131 seconds)")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    func testConcurrentDestinationTestSuiteStarted() {
        let formatted = noColoredFormatted("Test suite 'XcbeautifyLibTests (iOS).xctest' started on 'iPhone X'")
        XCTAssertEqual(formatted, "Test Suite XcbeautifyLibTests (iOS).xctest started on 'iPhone X'")
    }

    func testConcurrentDestinationTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'iPhone X' (77.158 seconds)")
        XCTAssertEqual(formatted, "    ✖ testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    func testConcurrentDestinationTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'iPhone X' (77.158 seconds)")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    func testParallelTestCaseAppKitPassed() {
        let formatted = noColoredFormatted("Test case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed on 'xctest (49438)' (0.131 seconds).")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget (0.131) seconds)")
    }

    func testParallelTestingStarted() {
        let formatted = noColoredFormatted("Testing started on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing started on 'iPhone X'")
    }

    func testParallelTestingPassed() {
        let formatted = noColoredFormatted("Testing passed on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing passed on 'iPhone X'")
    }

    func testParallelTestingFailed() {
        let formatted = noColoredFormatted("Testing failed on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing failed on 'iPhone X'")
    }

    func testPbxcp() {
        let formatted = noColoredFormatted("PBXCp /Users/admin/CocoaLumberjack/Classes/Extensions/DDDispatchQueueLogFormatter.h /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Products/Release/include/CocoaLumberjack/DDDispatchQueueLogFormatter.h (in target: CocoaLumberjack-Static)")
        XCTAssertEqual(formatted, "[CocoaLumberjack-Static] Copying DDDispatchQueueLogFormatter.h")
    }

    func testPhaseScriptExecution() {
        let input1 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target: App)"
        let input2 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target 'App' from project 'App')"
        XCTAssertEqual(noColoredFormatted(input1), "[App] Running script [CP] Check Pods Manifest.lock")
        XCTAssertEqual(noColoredFormatted(input2), "[App] Running script [CP] Check Pods Manifest.lock")
    }

    func testPhaseSuccess() {
        let formatted = noColoredFormatted("** CLEAN SUCCEEDED ** [0.085 sec]")
        XCTAssertEqual(formatted, "Clean Succeeded")
    }

    func testPodsError() {
    }

    func testPreprocess() {
    }

    func testProcessInfoPlist() {
        let formatted = noColoredFormatted("ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist")
        XCTAssertEqual(formatted, "Processing Guaka_Info.plist")
    }

    func testProcessPchCommand() {
        let formatted = noColoredFormatted("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos10.13 -c /path/to/my.pch -o /path/to/output/AcVDiff_Prefix.pch.gch")
        XCTAssertEqual(formatted, "Preprocessing /path/to/my.pch")
    }

    func testProcessPch() {
        let formatted = noColoredFormatted("ProcessPCH /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        XCTAssertEqual(formatted, "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    func testProcessPchPlusPlus() {
        let formatted = noColoredFormatted("ProcessPCH++ /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        XCTAssertEqual(formatted, "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    func testProvisioningProfileRequired() {
    }

    func testRestartingTests() {
        let formatted = noColoredFormatted( "Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
        XCTAssertEqual(formatted, "    ✖ Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
    }

    func testShellCommand() {
        let formatted = noColoredFormatted("    cd /foo/bar/baz")
        XCTAssertNil(formatted)
        XCTAssertEqual(parser.outputType, .task)
    }

    func testSymbolReferencedFrom() {
        let formatted = noColoredFormatted( "  \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        XCTAssertEqual(formatted, "[x]   \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        XCTAssertEqual(parser.outputType, .warning)
    }

    func testUndefinedSymbolLocation() {
        let formatted = noColoredFormatted( "      MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        XCTAssertEqual(formatted, "[!]       MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        XCTAssertEqual(parser.outputType, .warning)
    }

    func testTestCaseMeasured() {
    }

    func testTestCasePassed() {
#if os(macOS)
        let formatted = noColoredFormatted("Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds).")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget (0.131 seconds)")
#endif
    }

    func testTestCasePending() {
    }

    func testTestCaseStarted() {
    }

    func testTestSuiteStart() {
    }

    func testTestSuiteStarted() {
    }

    func testTestsRunCompletion() {
    }

    func testTiffutil() {
    }

    func testTouch() {
        let formatted = noColoredFormatted("Touch /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-dgnqmpfertotpceazwfhtfwtuuwt/Build/Products/Debug/XcbeautifyLib.framework (in target: XcbeautifyLib)")
        XCTAssertEqual(formatted, "[XcbeautifyLib] Touching XcbeautifyLib.framework")
    }

    func testUiFailingTest() {
        let formatted = noColoredFormatted("    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>")
        XCTAssertEqual(formatted, "    ✖ <unknown>:0, App crashed in <external symbol>")
    }

    func testWillNotBeCodeSigned() {
    }

    func testWriteAuxiliaryFiles() {
    }

    func testWriteFile() {
    }

    func testPackageGraphResolved() {

        // Start
        let start = noColoredFormatted("Resolve Package Graph")
        XCTAssertEqual(start, "Resolve Package Graph")

        // Ended
        let ended = noColoredFormatted("Resolved source packages:")
        XCTAssertEqual(ended, "Resolved source packages")

        // Package
        let package = noColoredFormatted("  StrasbourgParkAPI: https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
        XCTAssertEqual(package, "StrasbourgParkAPI - https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
    }
    
    func testXcodebuildError() {
        let formatted = noColoredFormatted("xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
        XCTAssertEqual(formatted, "[x] xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
    }
}
