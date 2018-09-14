import XCTest
@testable import XcbeautifyLib

final class XcbeautifyLibTests: XCTestCase {
    func testAggregateTarget() {
        let original = "=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ==="
        let formatted = Parser().parse(line: original)!
        let expected = "Aggregate target Be Aggro of project AggregateExample with configuration Debug"
        XCTAssertTrue(formatted.contains(expected))
    }

    func testAnalyze() {
        let original = "=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ==="
        let formatted = Parser().parse(line: original)!
        let expected = "Analyze target The Spacer of project Pods with configuration Debug"
        XCTAssertTrue(formatted.contains(expected))
    }

    func testAnalyzeTarget() {
    }

    func testBuildTarget() {
        let original = "=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ==="
        guard let formatted = Parser().parse(line: original) else {
            XCTFail()
            return
        }
        let expected = "Build target The Spacer of project Pods with configuration Debug"
        XCTAssertTrue(formatted.contains(expected))
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
    }

    func testCompileStoryboard() {
    }

    func testCompileSwift() {
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
    }

    func testPhaseScriptExecution() {
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
