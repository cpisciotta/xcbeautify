import XCTest
@testable import XcbeautifyLib

final class XcbeautifyLibTests: XCTestCase {
    func testPhaseSucceeded() {
        let original = "** CLEAN SUCCEEDED ** [0.085 sec"
        let formatted = "Clean Succeeded"
        XCTAssertTrue(Parser().parse(line: original)!.contains(formatted))
    }

    func testBuildTarget() {
        let original = "=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ==="
        let formatted = "Build target The Spacer of project Pods with configuration Debug"
        XCTAssertTrue(Parser().parse(line: original)!.contains(formatted))
    }

    func testTestCasePassed() {
        let original = "Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds)."
        XCTAssertTrue(Parser().parse(line: original)!.contains(TestStatus.pass.rawValue))
        XCTAssertTrue(Parser().parse(line: original)!.contains("testBuildTarget"))
        XCTAssertTrue(Parser().parse(line: original)!.contains("0.131"))
    }
}
