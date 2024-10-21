//
//  ParserTests.swift
//
//
//  Created by Charles Pisciotta on 8/6/24.
//

import XCTest
@testable import XcbeautifyLib

final class ParserTests: XCTestCase {
    private var parser: Parser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        parser = Parser()
    }

    override func tearDownWithError() throws {
        parser = nil
        try super.tearDownWithError()
    }

    func testMatchCopyFilesMatchingSourceAndDestinationFilenames() throws {
        let input = #"Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/path/to/some/file.swift")
        XCTAssertEqual(captureGroup.firstFilename, "file.swift")
        XCTAssertEqual(captureGroup.secondFilePath, "/path/to/some/other/file.swift")
        XCTAssertEqual(captureGroup.secondFilename, "file.swift")
        XCTAssertEqual(captureGroup.target, "Target")
    }

    func testMatchCopyFilesDifferentSourceAndDestinationFilenames() throws {
        let input = #"Copy /Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json")
        XCTAssertEqual(captureGroup.firstFilename, "x86_64-apple-macos.abi.json")
        XCTAssertEqual(captureGroup.secondFilePath, #"/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json"#)
        XCTAssertEqual(captureGroup.secondFilename, "Backyard_Birds.abi.json")
        XCTAssertEqual(captureGroup.target, "Backyard Birds")
    }

    func testMatchSwiftDriverJobDiscoveryCompilingCaptureGroupOneFile() throws {
        let input = #"SwiftDriverJobDiscovery normal arm64 Compiling resource_bundle_accessor.swift (in target 'Some Target' from project 'Some Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        XCTAssertEqual(captureGroup.state, "normal")
        XCTAssertEqual(captureGroup.architecture, "arm64")
        XCTAssertEqual(captureGroup.filenames, ["resource_bundle_accessor.swift"])
        XCTAssertEqual(captureGroup.target, "Some Target")
        XCTAssertEqual(captureGroup.project, "Some Project")
    }

    func testMatchSwiftDriverJobDiscoveryCompilingCaptureGroupMultipleFiles() throws {
        let input = #"SwiftDriverJobDiscovery normal x86_64 Compiling BackyardVisitorEvent+DataGeneration.swift, BackyardVisitors\ &\ Events.swift, Bird+DataGeneration.swift, Bird.swift (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        XCTAssertEqual(captureGroup.state, "normal")
        XCTAssertEqual(captureGroup.architecture, "x86_64")
        XCTAssertEqual(captureGroup.filenames, ["BackyardVisitorEvent+DataGeneration.swift", #"BackyardVisitors\ &\ Events.swift"#, "Bird+DataGeneration.swift", "Bird.swift"])
        XCTAssertEqual(captureGroup.target, "BackyardBirdsDataTarget")
        XCTAssertEqual(captureGroup.project, "BackyardBirdsDataProject")
    }

    func testMatchSwiftCompile() throws {
        let input = #"SwiftCompile normal arm64 /Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftCompileCaptureGroup)
        XCTAssertEqual(captureGroup.filePath, #"/Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift"#)
        XCTAssertEqual(captureGroup.filename, #"BirdFood+DataGeneration.swift"#)
        XCTAssertEqual(captureGroup.target, "BackyardBirdsData")
    }

    func testMatchExplicitDependency() throws {
        let input = #"        ➜ Explicit dependency on target 'BackyardBirdsData_BackyardBirdsData' in project 'Backyard Birds Data'"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? ExplicitDependencyCaptureGroup)
        XCTAssertEqual(captureGroup.target, "BackyardBirdsData_BackyardBirdsData")
        XCTAssertEqual(captureGroup.project, "Backyard Birds Data")
    }

    func testMatchTestingStarted() throws {
        let input = "Testing started"
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? TestingStartedCaptureGroup)
        XCTAssertEqual(captureGroup.wholeMessage, "Testing started")
    }

    func testNotMatchTestingStarted() throws {
        let input = #"2024-08-18 18:17:52.619 xcodebuild[9799:394817] [MT] IDETestOperationsObserverDebug: 21.975 elapsed -- Testing started completed."#
        XCTAssertNil(parser.parse(line: input))
    }

    func testMatchSwiftTestingRunStarted() throws {
        let input = "􀟈 Test run started."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingRunStartedCaptureGroup)
        XCTAssertEqual(captureGroup.message, "Test run started.")
    }

    func testMatchSwiftTestingRunCompletion() throws {
        let input = "􁁛  Test run with 5 tests passed after 3.2 seconds."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingRunCompletionCaptureGroup)
        XCTAssertEqual(captureGroup.numberOfTests, 5)
        XCTAssertEqual(captureGroup.totalTime, "3.2")
    }

    func testMatchSwiftTestingRunFailed() throws {
        let input = "􀢄 Test run with 7 tests failed after 4.8 seconds with 2 issues."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingRunFailedCaptureGroup)
        XCTAssertEqual(captureGroup.numberOfTests, 7)
        XCTAssertEqual(captureGroup.totalTime, "4.8")
        XCTAssertEqual(captureGroup.numberOfIssues, 2)
    }

    func testMatchSwiftTestingSuiteStarted() throws {
        let input = "􀟈  Suite SampleTestSuite started."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingSuiteStartedCaptureGroup)
        XCTAssertEqual(captureGroup.suiteName, "SampleTestSuite")
    }

    func testMatchSwiftTestingTestStarted() throws {
        let input = "􀟈  Test ExampleTest started."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingTestStartedCaptureGroup)
        XCTAssertEqual(captureGroup.testName, "ExampleTest")
    }

    func testMatchSwiftTestingSuitePassed() throws {
        let input = "􁁛 Suite TestSuiteName passed after 5.3 seconds."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingSuitePassedCaptureGroup)
        XCTAssertEqual(captureGroup.suiteName, "TestSuiteName")
        XCTAssertEqual(captureGroup.timeTaken, "5.3")
    }

    func testMatchSwiftTestingSuiteFailed() throws {
        let input = #"􀢄 Suite "AnotherTestSuite" failed after 6.4 seconds with 3 issues."#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingSuiteFailedCaptureGroup)
        XCTAssertEqual(captureGroup.suiteName, "\"AnotherTestSuite\"")
        XCTAssertEqual(captureGroup.timeTaken, "6.4")
        XCTAssertEqual(captureGroup.numberOfIssues, 3)
    }

    func testMatchSwiftTestingTestFailed() throws {
        let input = #"􀢄 Test "SomeTest" failed after 2.5 seconds with 1 issue."#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingTestFailedCaptureGroup)
        XCTAssertEqual(captureGroup.testName, "\"SomeTest\"")
        XCTAssertEqual(captureGroup.timeTaken, "2.5")
        XCTAssertEqual(captureGroup.numberOfIssues, 1)
    }

    func testMatchSwiftTestingTestPassed() throws {
        let input = "􁁛 Test SampleTest passed after 3.0 seconds."
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingTestPassedCaptureGroup)
        XCTAssertEqual(captureGroup.testName, "SampleTest")
        XCTAssertEqual(captureGroup.timeTaken, "3.0")
    }

    func testMatchSwiftTestingTestSkipped() throws {
        let input = #"􀙟 Test "SkippedTest" skipped."#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingTestSkippedCaptureGroup)
        XCTAssertEqual(captureGroup.testName, "\"SkippedTest\"")
    }

    func testMatchSwiftTestingTestSkippedWithReason() throws {
        let input = #"􀙟 Test "SkippedTest" skipped: "Not relevant for this platform.""#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingTestSkippedReasonCaptureGroup)
        XCTAssertEqual(captureGroup.testName, "\"SkippedTest\"")
        XCTAssertEqual(captureGroup.reason, "Not relevant for this platform.")
    }

    func testMatchSwiftTestingIssue() throws {
        let input = #"􀢄  Test "Selected tests by ID" recorded an issue at PlanTests.swift:43:5: Expectation failed"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingIssueCaptureGroup)
        XCTAssertEqual(captureGroup.testDescription, "\"Selected tests by ID\"")
        XCTAssertEqual(captureGroup.issueDetails, "PlanTests.swift:43:5: Expectation failed")
    }

    func testMatchSwiftTestingPassingArgument() throws {
        let input = #"􀟈 Passing 2 arguments input → "argument1, argument2""#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftTestingPassingArgumentCaptureGroup)
        XCTAssertEqual(captureGroup.numberOfArguments, 2)
    }

    func testSwiftDriverTargetCaptureGroup() throws {
        let input = #"SwiftDriver BackyardBirdsData normal arm64 com.apple.xcode.tools.swift.compiler (in target \'BackyardBirdsData\' from project \'BackyardBirdsData\')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverTargetCaptureGroup)
        XCTAssertEqual(captureGroup.target, "BackyardBirdsData")
    }

    func testSwiftDriverCompilationTarget() throws {
        let input = #"SwiftDriver\ Compilation SomeTarget normal x86_64 com.apple.xcode.tools.swift.compiler (in target 'Target' from project 'Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverCompilationTarget)
        XCTAssertEqual(captureGroup.target, "SomeTarget")
    }

    func testSwiftDriverCompilationRequirementsCaptureGroup() throws {
        let input = #"SwiftDriver\ Compilation\ Requirements Backyard\ Birds normal arm64 com.apple.xcode.tools.swift.compiler (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverCompilationRequirementsCaptureGroup)
        XCTAssertEqual(captureGroup.target, #"Backyard\ Birds"#)
    }

    func testParseSwiftTestingParallelTestOutputPassed() throws {
        let resultSuccess = try XCTUnwrap(parser.parse(line: "Test case 'SomeStructThatsNotASuite/someFunctionName()' passed on 'Clone 1 of iPhone 16 Pro - xctest (38347)' (13.060 seconds)") as? ParallelTestCasePassedCaptureGroup)
        XCTAssertEqual(resultSuccess.device, "Clone 1 of iPhone 16 Pro - xctest (38347)")
        XCTAssertEqual(resultSuccess.suite, "SomeStructThatsNotASuite")
        XCTAssertEqual(resultSuccess.time, "13.060")
        XCTAssertEqual(resultSuccess.testCase, "someFunctionName")
    }

    func testParseSwiftTestingParallelTestOutputFailed() throws {
        let resultFailed = try XCTUnwrap(parser.parse(line: "Test case 'SubFolderTestDemoTests/exampleFalse()' failed on 'My Mac - TestDemo (29692)' (0.001 seconds)") as? ParallelTestCaseFailedCaptureGroup)
        XCTAssertEqual(resultFailed.device, "My Mac - TestDemo (29692)")
        XCTAssertEqual(resultFailed.suite, "SubFolderTestDemoTests")
        XCTAssertEqual(resultFailed.time, "0.001")
        XCTAssertEqual(resultFailed.testCase, "exampleFalse")
    }
}
