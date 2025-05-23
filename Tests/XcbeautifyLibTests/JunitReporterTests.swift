//
// JunitReporterTests.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import XcbeautifyLib
import XCTest

class JunitReporterTests: XCTestCase {
    private let expectedMacOsXml = """
    <testsuites name="All tests" tests="85" failures="3">
        <testsuite name="XcbeautifyLibTests.OutputHandlerTests" tests="6" failures="0">
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testEarlyReturnIfEmptyString" time="0.054" />
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testPrintAllOutputTypeByDefault" time="0.000" />
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testPrintOnlyTasksWithError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testPrintOnlyTasksWithWarningOrError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testPrintTestResultTooIfIsCIAndQuiet" time="0.000" />
            <testcase classname="XcbeautifyLibTests.OutputHandlerTests" name="testPrintTestResultTooIfIsCIAndQuieter" time="0.000" />
        </testsuite>
        <testsuite name="XcbeautifyLibTests.XcbeautifyLibTests" tests="77" failures="1">
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testAggregateTarget">
                <failure message="/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13 - XCTAssertEqual failed: (&quot;Optional(&quot;Aggregate target Be Aggro of project AggregateExample with configuration Debug&quot;)&quot;) is not equal to (&quot;Optional(&quot;failing Aggregate target Be Aggro of project AggregateExample with configuration Debug&quot;)&quot;)" />
            </testcase>
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testAnalyze" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testAnalyzeTarget" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testBuildTarget" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCheckDependencies" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCheckDependenciesErrors" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testClangError" time="0.002" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCleanRemove" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCleanTarget" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCodesign" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCodesignFramework" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompile" time="0.002" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompileCommand" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompileError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompileStoryboard" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompileWarning" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCompileXib" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testConcurrentDestinationTestCaseFailed" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testConcurrentDestinationTestCasePassed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testConcurrentDestinationTestSuiteStarted" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCopyHeader" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCopyPlist" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCopyStrings" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCpresource" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testCursor" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testExecuted" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testFailingTest" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testFatalError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testFileMissingError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testGenerateCoverageData" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testGeneratedCoverageReport" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testGenerateDsym" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testGenericWarning" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLdError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLdWarning" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLibtool" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLinkerDuplicateSymbols" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLinkerDuplicateSymbolsLocation" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLinkerUndefinedSymbolLocation" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLinkerUndefinedSymbols" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testLinking" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testModuleIncludesError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testNoCertificate" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPackageGraphResolved" time="0.003" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestCaseAppKitPassed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestCaseFailed" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestCasePassed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestingFailed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestingPassed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testParallelTestingStarted" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPbxcp" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPhaseScriptExecution" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPhaseSuccess" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPodsError" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testPreprocess" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testProcessInfoPlist" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testProcessPch" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testProcessPchCommand" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testProcessPchPlusPlus" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testProvisioningProfileRequired" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testRestartingTests" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testShellCommand" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testSymbolReferencedFrom" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestCaseMeasured" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestCasePassed" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestCasePending" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestCaseStarted" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestsRunCompletion" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestSuiteStart" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTestSuiteStarted" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTiffutil" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testTouch" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testUiFailingTest" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testUndefinedSymbolLocation" time="0.001" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testWillNotBeCodeSigned" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testWriteAuxiliaryFiles" time="0.000" />
            <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testWriteFile" time="0.000">
                <skipped />
            </testcase>
        </testsuite>
        <testsuite name="SwiftTests" tests="1" failures="1">
            <testcase classname="SwiftTests" name="testExample">
                <failure message="Restarting after unexpected exit, crash, or test timeout in SwiftTests.testExample(); summary will include totals from previous launches." />
            </testcase>
        </testsuite>
        <testsuite name="ObjCTests" tests="1" failures="1">
            <testcase classname="ObjCTests" name="testExample">
                <failure message="Restarting after unexpected exit, crash, or test timeout in -[ObjCTests testExample]; summary will include totals from previous launches." />
            </testcase>
        </testsuite>
    </testsuites>
    """

    private let expectedLinuxXml = """
    <testsuites name="All tests" tests="85" failures="3">
        <testsuite name="-[XcbeautifyLibTests" tests="83" failures="1">
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testEarlyReturnIfEmptyString]" time="0.054" />
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testPrintAllOutputTypeByDefault]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testPrintOnlyTasksWithError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testPrintOnlyTasksWithWarningOrError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testPrintTestResultTooIfIsCIAndQuiet]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="OutputHandlerTests testPrintTestResultTooIfIsCIAndQuieter]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testAggregateTarget]">
                <failure message="/Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13 - XCTAssertEqual failed: (&quot;Optional(&quot;Aggregate target Be Aggro of project AggregateExample with configuration Debug&quot;)&quot;) is not equal to (&quot;Optional(&quot;failing Aggregate target Be Aggro of project AggregateExample with configuration Debug&quot;)&quot;)" />
            </testcase>
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testAnalyze]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testAnalyzeTarget]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testBuildTarget]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCheckDependencies]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCheckDependenciesErrors]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testClangError]" time="0.002" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCleanRemove]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCleanTarget]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCodesign]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCodesignFramework]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompile]" time="0.002" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompileCommand]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompileError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompileStoryboard]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompileWarning]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCompileXib]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testConcurrentDestinationTestCaseFailed]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testConcurrentDestinationTestCasePassed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testConcurrentDestinationTestSuiteStarted]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCopyHeader]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCopyPlist]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCopyStrings]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCpresource]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testCursor]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testExecuted]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testFailingTest]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testFatalError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testFileMissingError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testGenerateCoverageData]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testGeneratedCoverageReport]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testGenerateDsym]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testGenericWarning]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLdError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLdWarning]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLibtool]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLinkerDuplicateSymbols]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLinkerDuplicateSymbolsLocation]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLinkerUndefinedSymbolLocation]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLinkerUndefinedSymbols]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testLinking]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testModuleIncludesError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testNoCertificate]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPackageGraphResolved]" time="0.003" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestCaseAppKitPassed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestCaseFailed]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestCasePassed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestingFailed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestingPassed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testParallelTestingStarted]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPbxcp]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPhaseScriptExecution]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPhaseSuccess]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPodsError]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testPreprocess]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testProcessInfoPlist]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testProcessPch]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testProcessPchCommand]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testProcessPchPlusPlus]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testProvisioningProfileRequired]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testRestartingTests]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testShellCommand]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testSymbolReferencedFrom]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestCaseMeasured]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestCasePassed]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestCasePending]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestCaseStarted]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestsRunCompletion]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestSuiteStart]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTestSuiteStarted]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTiffutil]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testTouch]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testUiFailingTest]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testUndefinedSymbolLocation]" time="0.001" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testWillNotBeCodeSigned]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testWriteAuxiliaryFiles]" time="0.000" />
            <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testWriteFile]" time="0.000">
                <skipped />
            </testcase>
        </testsuite>
        <testsuite name="SwiftTests" tests="1" failures="1">
            <testcase classname="SwiftTests" name="testExample">
                <failure message="Restarting after unexpected exit, crash, or test timeout in SwiftTests.testExample(); summary will include totals from previous launches." />
            </testcase>
        </testsuite>
        <testsuite name="ObjCTests" tests="1" failures="1">
            <testcase classname="ObjCTests" name="testExample">
                <failure message="Restarting after unexpected exit, crash, or test timeout in -[ObjCTests testExample]; summary will include totals from previous launches." />
            </testcase>
        </testsuite>
    </testsuites>
    """

    func testJunitReport() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "TestLog", withExtension: "txt"))
        let parser = Parser()
        let reporter = JunitReporter()

        for line in try String(contentsOf: url).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let xml = String(data: data, encoding: .utf8)!
        #if os(Linux)
        let expectedXml = expectedLinuxXml
        #else
        let expectedXml = expectedMacOsXml
        #endif
        XCTAssertEqual(xml, expectedXml)
    }

    private let expectedParallelXml = """
    <testsuites name="PARALLEL_TESTS" tests="21" failures="1">
        <testsuite name="URL_OutgoingEmailTests" tests="2" failures="0">
            <testcase classname="URL_OutgoingEmailTests" name="test_outgoingEmailLinkName_urlContainsQueryItem_valueIsReturned" time="0.002" />
            <testcase classname="URL_OutgoingEmailTests" name="test_outgoingEmailToken_urlContainsQueryItem_valueIsReturned" time="0.003" />
        </testsuite>
        <testsuite name="MobileWebURLRouteTest" tests="2" failures="0">
            <testcase classname="MobileWebURLRouteTest" name="testReportingDescriptionContainsUrl" time="0.003" />
            <testcase classname="MobileWebURLRouteTest" name="testRouteContainsUrl" time="0.002" />
        </testsuite>
        <testsuite name="URLRoutingComponentsTests" tests="1" failures="0">
            <testcase classname="URLRoutingComponentsTests" name="test_init_urlWithQueryItems_queryItemsReturnsCorrectly" time="0.004" />
        </testsuite>
        <testsuite name="BuildFlagTests" tests="3" failures="1">
            <testcase classname="BuildFlagTests" name="test_logClicksToConsole_isFalse" time="0.003" />
            <testcase classname="BuildFlagTests" name="test_logEventsToConsole_isFalse" time="0.002" />
            <testcase classname="BuildFlagTests" name="test_failIntentionally">
                <failure message="Parallel test failed" />
            </testcase>
        </testsuite>
        <testsuite name="GeneratedTestingFlagTests" tests="1" failures="0">
            <testcase classname="GeneratedTestingFlagTests" name="test_generatedTesting_expectedValue" time="0.001" />
        </testsuite>
        <testsuite name="Event_EmailTests" tests="1" failures="0">
            <testcase classname="Event_EmailTests" name="test_path_isCorrectValue" time="0.001" />
        </testsuite>
        <testsuite name="UserCoordinatorTests" tests="11" failures="0">
            <testcase classname="UserCoordinatorTests" name="test_loginWithEmailPasswordAndSSO_callsAuthenticationService_thenCallsCompletion" time="0.015" />
            <testcase classname="UserCoordinatorTests" name="test_refreshLoginToken_failure_completionIsCalled" time="0.012" />
            <testcase classname="UserCoordinatorTests" name="test_refreshLoginToken_failure_recordsError" time="0.014" />
            <testcase classname="UserCoordinatorTests" name="test_refreshLoginToken_success_completionIsCalled" time="0.008" />
            <testcase classname="UserCoordinatorTests" name="test_refreshLoginToken_success_storesLoginToken" time="0.006" />
            <testcase classname="UserCoordinatorTests" name="test_refreshUser_failure_completionIsCalled" time="0.005" />
            <testcase classname="UserCoordinatorTests" name="test_refreshUser_failure_logsError" time="0.005" />
            <testcase classname="UserCoordinatorTests" name="test_refreshUser_success_completionIsCalled" time="0.005" />
            <testcase classname="UserCoordinatorTests" name="test_refreshUser_success_userIsStoredInUserDefaults" time="0.006" />
            <testcase classname="UserCoordinatorTests" name="test_refreshUser_success_userPropertyIsUpdated" time="0.032" />
            <testcase classname="UserCoordinatorTests" name="test_resetPassword_requestSucceeds_completionCalledWithSuccess" time="0.005">
                <skipped />
            </testcase>
        </testsuite>
    </testsuites>
    """

    func testParallelJunitReport() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "ParallelTestLog", withExtension: "txt"))
        let parser = Parser()
        let reporter = JunitReporter()

        for line in try String(contentsOf: url).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let xml = String(data: data, encoding: .utf8)!
        let expectedXml = expectedParallelXml
        XCTAssertEqual(xml, expectedXml)
    }
}
