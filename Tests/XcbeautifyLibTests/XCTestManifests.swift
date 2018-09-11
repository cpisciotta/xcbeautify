import XCTest

extension XcbeautifyLibTests {
    static let __allTests = [
        ("testBuildTarget", testBuildTarget),
        ("testPhaseSucceeded", testPhaseSucceeded),
        ("testTestCasePassed", testTestCasePassed),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(XcbeautifyLibTests.__allTests),
    ]
}
#endif
