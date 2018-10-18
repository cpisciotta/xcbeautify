import XCTest
@testable import XcbeautifyLib

final class XcbeautifyLibTests: XCTestCase {
    private func formatted(of original: String, shouldContain expected: String) {
        let formatted = Parser().parse(line: original)!
        XCTAssertTrue(formatted.contains(expected))
    }

    func testAggregateTarget() {
        formatted(of: "=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ===", shouldContain: "Aggregate target Be Aggro of project AggregateExample with configuration Debug")
    }

    func testAnalyze() {
    }

    func testAnalyzeTarget() {
        formatted(of: "=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===", shouldContain: "Analyze target The Spacer of project Pods with configuration Debug")
    }

    func testBuildTarget() {
        formatted(of: "=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===", shouldContain: "Build target The Spacer of project Pods with configuration Debug")
    }

    func testCheckDependenciesErrors() {
    }

    func testCheckDependencies() {
    }

    func testClangError() {
    }

    func testCleanRemove() {
    }

    func testCleanTarget() {
        let original = "=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ==="
        let formatted = Parser().parse(line: original)!
        let expected = "Analyze target The Spacer of project Pods with configuration Debug"
        XCTAssertTrue(formatted.contains(expected))
    }

    func testCodesignFramework() {
    }

    func testCodesign() {
    }

    func testCompileCommand() {
    }

    func testCompileError() {
    }

    func testCompile() {
        let sample = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target: xcbeautify)"
        formatted(of: sample, shouldContain: "[")
        formatted(of: sample, shouldContain: "xcbeautify")
        formatted(of: sample, shouldContain: "setup.swift")
    }

    func testCompileStoryboard() {
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
        let sample = "Ld /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/xcbeautify normal x86_64 (in target: xcbeautify)"
        formatted(of: sample, shouldContain: "[")
        formatted(of: sample, shouldContain: "xcbeautify")
        formatted(of: sample, shouldContain: "Linking")

        let sample2 = "Ld /Users/admin/Library/Developer/Xcode/DerivedData/MyApp-abcd/Build/Intermediates.noindex/ArchiveIntermediates/MyApp/IntermediateBuildFilesPath/MyApp.build/Release-iphoneos/MyApp.build/Objects-normal/armv7/My\\ App normal armv7 (in target: MyApp)"
        formatted(of: sample2, shouldContain: "My\\ App")
    }

    func testModuleIncludesError() {
    }

    func testNoCertificate() {
    }

    func testParallelTestCaseFailed() {
    }

    func testParallelTestCasePassed() {
        let original = "Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds)."
        guard let formatted = Parser().parse(line: original) else {
            XCTFail()
            return
        }
        XCTAssertTrue(formatted.contains(TestStatus.pass.rawValue))
        XCTAssertTrue(formatted.contains("testBuildTarget"))
        XCTAssertTrue(formatted.contains("0.131"))
    }

    func testParallelTestingStarted() {
    }

    func testPbxcp() {
        let original = "PBXCp /Users/admin/CocoaLumberjack/Classes/Extensions/DDDispatchQueueLogFormatter.h /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Products/Release/include/CocoaLumberjack/DDDispatchQueueLogFormatter.h (in target: CocoaLumberjack-Static)"
        formatted(of: original, shouldContain: "CocoaLumberjack-Static")
        formatted(of: original, shouldContain: "Copying")
        formatted(of: original, shouldContain: "DDDispatchQueueLogFormatter.h")
    }

    func testPhaseScriptExecution() {
        let original = """
        PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target: App)
        """
        formatted(of: original, shouldContain: "Running script")
        formatted(of: original, shouldContain: "[CP]\\ Check\\ Pods\\ Manifest.lock")
    }

    func testPhaseSuccess() {
        let original = "** CLEAN SUCCEEDED ** [0.085 sec]"
        guard let formatted = Parser().parse(line: original) else {
            XCTFail()
            return
        }
        XCTAssertTrue(formatted.contains("Clean Succeeded"))
    }

    func testPodsError() {
    }

    func testPreprocess() {
    }

    func testProcessInfoPlist() {
        formatted(
            of: "ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist",
            shouldContain: "Processing")
        formatted(
            of: "ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist",
            shouldContain: " Guaka_Info.plist")
        formatted(
            of: "ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist (in target: Guaka)",
            shouldContain: "Processing")
        formatted(
            of: "ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist (in target: Guaka)",
            shouldContain: "Guaka")
        formatted(
            of: "ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist (in target: Guaka)",
            shouldContain: " Guaka_Info.plist")
    }

    func testProcessPchCommand() {
    }

    func testProcessPch() {
    }

    func testProvisioningProfileRequired() {
    }

    func testRestartingTests() {
    }

    func testShellCommand() {
    }

    func testSymbolReferencedFrom() {
    }

    func testTestCaseMeasured() {
    }

    func testTestCasePassed() {
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
        let sample = "Touch /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-dgnqmpfertotpceazwfhtfwtuuwt/Build/Products/Debug/XcbeautifyLib.framework (in target: XcbeautifyLib)"
        formatted(of: sample, shouldContain: "[")
        formatted(of: sample, shouldContain: "Touching")
        formatted(of: sample, shouldContain: "XcbeautifyLib")
    }

    func testUiFailingTest() {
    }

    func testWillNotBeCodeSigned() {
    }

    func testWriteAuxiliaryFiles() {
    }

    func testWriteFile() {
    }
}
