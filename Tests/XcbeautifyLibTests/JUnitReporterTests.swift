//
// JUnitReporterTests.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import XcbeautifyLib
import XCTest

final class JUnitReporterTests: XCTestCase {
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

    func testJUnitReport() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "TestLog", withExtension: "txt"))
        let parser = Parser()
        let reporter = JUnitReporter()

        for line in try String(contentsOf: url).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) as? any JUnitReportable {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let xml = try XCTUnwrap(String(data: data, encoding: .utf8))
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

    func testParallelJUnitReport() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "ParallelTestLog", withExtension: "txt"))
        let parser = Parser()
        let reporter = JUnitReporter()

        for line in try String(contentsOf: url).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) as? any JUnitReportable {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let xml = try XCTUnwrap(String(data: data, encoding: .utf8))
        let expectedXml = expectedParallelXml
        XCTAssertEqual(xml, expectedXml)
    }

    #if os(macOS)
    private let expectedSwiftTestingXML_macOS = """
    <testsuites name="All tests" tests="464" failures="2">
        <testsuite name="TestingTests.IssueTests" tests="54" failures="0">
            <testcase classname="TestingTests.IssueTests" name="testCastAsAnyProtocol" time="0.004" />
            <testcase classname="TestingTests.IssueTests" name="testCEnumDescription" time="0.002" />
            <testcase classname="TestingTests.IssueTests" name="testCollectionDifferenceSkippedForRanges" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testCollectionDifferenceSkippedForStrings" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testCollectionDifference" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testCustomTestStringConvertible" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testDescriptionProperties" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testEnumDescription" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testEnumWithCustomDescription" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpect_mismatchedErrorDescription_nonVoid" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpect_mismatchedErrorDescription" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpect_Mismatching" time="0.003" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpect_ThrowingFromErrorMatcher" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpectAsync_mismatchedErrorDescription_nonVoid" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpectAsync_mismatchedErrorDescription" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpectAsync_Mismatching" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpectAsync_ThrowingFromErrorMatcher" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpectAsync" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithExpect" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithRequire_ThrowingFromErrorMatcher" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorCheckingWithRequireAsync_ThrowingFromErrorMatcher" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorPropertyNilForOtherIssueKinds" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorPropertyValidForThrownErrors" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testErrorThrownFromExpect" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testExpectationValueLazyStringification" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testExpect" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testExpressionLiterals" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testExpressionRuntimeValueCapture" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testExpressionRuntimeValueChildren" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testFailBecauseOfError" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testFail" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testFailWithoutCurrentTest" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testGetSourceLocationProperty" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testIsAndAsComparisons" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testLazyExpectDoesNotEvaluateRightHandValue" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testLazyExpectEvaluatesRightHandValueWhenNeeded" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testMemberFunctionCall" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testMemberFunctionCallWithFunctionArgument" time="0.001" />
            <testcase classname="TestingTests.IssueTests" name="testMemberFunctionCallWithInoutArgument" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testMemberFunctionCallWithLabel" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testNegatedExpressionsExpandToCaptureNegatedExpression" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testNegatedExpressionsHaveCorrectCapturedExpressions" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testNegatedExpressions" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testNilOptionalCallResult" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testNilOptionalOperand" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testOptionalOperand" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testOptionalUnwrappingMemberFunctionCall" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testOptionalUnwrappingWithCoalescing_Failure" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testOptionalUnwrappingWithCoalescing" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testOptionalUnwrapping" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testRequireOptionalMemberAccessEvaluatesToNil" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testRequire" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testSetSourceLocationProperty" time="0.000" />
            <testcase classname="TestingTests.IssueTests" name="testThrowingMemberFunctionCall" time="0.000" />
        </testsuite>
        <testsuite name="TestingTests.KnownIssueTests" tests="13" failures="0">
            <testcase classname="TestingTests.KnownIssueTests" name="testAsyncKnownIssueThatDoesNotAlwaysOccur" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testAsyncKnownIssueWithExpectCallAndCondition" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testAsyncKnownIssueWithExpectCall" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testAsyncKnownIssueWithFalsePrecondition" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testIssueIsKnownPropertyIsSetCorrectly" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testIssueIsKnownPropertyIsSetCorrectlyWithCustomIssueMatcher" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueOnDetachedTask" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueThatDoesNotAlwaysOccur" time="0.001" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueWithComment" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueWithExpectCallAndCondition" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueWithExpectCall" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testKnownIssueWithFalsePrecondition" time="0.000" />
            <testcase classname="TestingTests.KnownIssueTests" name="testUnexpectedErrorRecordsTwoIssues" time="0.001" />
        </testsuite>
        <testsuite name="TestingTests.ObjCClassTests" tests="10" failures="0">
            <testcase classname="TestingTests.ObjCClassTests" name="testAsynchronousThrowing" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testAsynchronous" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testExplicitName" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testExplicitNameAsyncThrows" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testExplicitNameThrowsFunError:" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testExplicitNameWithBackticks" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testExplicitName" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testImplicitName" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testImplicitNameWithBackticks" time="0.000" />
            <testcase classname="TestingTests.ObjCClassTests" name="testThrowing" time="0.000" />
        </testsuite>
        <testsuite name="TestingTests.RunnerTests" tests="36" failures="0">
            <testcase classname="TestingTests.RunnerTests" name="testAvailableWithDefinedAvailability" time="0.068" />
            <testcase classname="TestingTests.RunnerTests" name="testAvailableWithSwiftVersion" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testConditionTraitIsConstant" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testConditionTraitsAreEvaluatedOutermostToInnermost" time="0.010" />
            <testcase classname="TestingTests.RunnerTests" name="testDefaultInit" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testDeprecated" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testErrorThrownFromTest" time="0.001" />
            <testcase classname="TestingTests.RunnerTests" name="testErrorThrownWhileEvaluatingArguments" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testExpectationCheckedEventHandlingWhenDisabled" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testExpectationCheckedEventHandlingWhenEnabled" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testFreeFunction" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testGeneratedPlan" time="0.038" />
            <testcase classname="TestingTests.RunnerTests" name="testHardCodedPlan" time="0.013" />
            <testcase classname="TestingTests.RunnerTests" name="testInitialTaskLocalState" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testNoasyncTestsAreCallable" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testObsoletedTestFunctions" time="0.038" />
            <testcase classname="TestingTests.RunnerTests" name="testParameterizedTestWithNoCasesIsSkipped" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testPlanExcludesHiddenTests" time="0.078" />
            <testcase classname="TestingTests.RunnerTests" name="testPoundIfFalseElseIfTestFunctionRuns" time="0.042" />
            <testcase classname="TestingTests.RunnerTests" name="testPoundIfFalseElseTestFunctionRuns" time="0.044" />
            <testcase classname="TestingTests.RunnerTests" name="testPoundIfFalseTestFunctionDoesNotRun" time="0.047" />
            <testcase classname="TestingTests.RunnerTests" name="testPoundIfTrueTestFunctionRuns" time="0.045" />
            <testcase classname="TestingTests.RunnerTests" name="testSerializedSortOrder" time="0.044" />
            <testcase classname="TestingTests.RunnerTests" name="testSynchronousTestFunctionRunsInDefaultIsolationContext" time="0.087" />
            <testcase classname="TestingTests.RunnerTests" name="testSynchronousTestFunctionRunsOnMainActorWhenEnforced" time="0.087" />
            <testcase classname="TestingTests.RunnerTests" name="testTestActionIsRecordIssueDueToErrorThrownByConditionTrait" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testTestIsNotSkippedWithPassingConditionTraits" time="0.001" />
            <testcase classname="TestingTests.RunnerTests" name="testTestIsSkippedWhenDisabledWithComment" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testTestIsSkippedWhenDisabled" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testTestIsSkippedWithBlockingEnabledIfTrait" time="0.001" />
            <testcase classname="TestingTests.RunnerTests" name="testTestsProperty" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testUnavailableTestMessageIsCaptured" time="0.038" />
            <testcase classname="TestingTests.RunnerTests" name="testUnavailableTestsAreSkipped" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testYieldingError" time="0.000" />
            <testcase classname="TestingTests.RunnerTests" name="testYieldsIssueWhenErrorThrownFromParallelizedTest" time="0.043" />
            <testcase classname="TestingTests.RunnerTests" name="testYieldsIssueWhenErrorThrownFromTestCase" time="0.044" />
        </testsuite>
        <testsuite name="SwiftTesting" tests="351" failures="2">
            <testcase classname="SwiftTesting" name="&quot;Repeated calls to #expect() run in reasonable time&quot;">
                <skipped message="time-sensitive" />
            </testcase>
            <testcase classname="SwiftTesting" name="&quot;Dumping a Runner.Plan&quot;">
                <skipped />
            </testcase>
            <testcase classname="SwiftTesting" name="variadicCStringArguments()" time="1.285" />
            <testcase classname="SwiftTesting" name="&quot;Test function does not conflict with local type names&quot;" time="1.285" />
            <testcase classname="SwiftTesting" name="&quot;Backtrace.current() is populated&quot;" time="1.285" />
            <testcase classname="SwiftTesting" name="&quot;Test function does not conflict with local type names&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="parameterizedTestWithTrailingComment(value:)" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;One Identifiable parameter&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;An unthrown error has no backtrace&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Codable&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Nil display name&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Invalid tag expressions are detected&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Invalid bug URLs are detected&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;comments property&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;tags property&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;associatedBugs property&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Error diagnostics emitted on API misuse&quot;" time="1.286" />
            <testcase classname="SwiftTesting" name="&quot;Error diagnostics which include fix-its emitted on API misuse&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Encoding/decoding&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;One Codable parameter&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Different kinds of functions are handled correctly&quot;" time="1.288">
                <failure message="Swift testing test failed" />
            </testcase>
            <testcase classname="SwiftTesting" name="&quot;Warning diagnostics emitted on API misuse&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Valid bug identifiers are allowed&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;One RawRepresentable parameter&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Self. in @Test attribute is removed&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Thrown NSError has a different backtrace than we generated&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;One CustomTestArgumentEncodable parameter&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Error diagnostics emitted on API misuse&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Availability attributes are captured&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="mutateMe()" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Display name is preserved&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;@Tag macro&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Thunk identifiers do not contain backticks&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Valid tag expressions are allowed&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;CError.description property&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Effects influence generated identifiers&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Thunk identifiers do not contain arbitrary Unicode&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Argument types influence generated identifiers&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="consumeMe()" time="1.288" />
            <testcase classname="SwiftTesting" name="staticMe()" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Symbolication&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="mangledTypeName()" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;Body does not influence generated identifiers&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="borrowMe()" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;#require(as Bool?) suppresses its diagnostic&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation comparisons&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;#expect(false) and #require(false) warn they always fail&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.line and .column properties&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;as! warns when used with #require()&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;as! warning is suppressed for explicit Bool and Optional casts&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="testNotAnXCTestCaseMethod()" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.moduleName property&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;Bool(false) suppresses the warning about always failing&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;#require(Bool?) produces a diagnostic&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.fileID property ignores middle components&quot;" time="1.287" />
            <testcase classname="SwiftTesting" name="&quot;#require() macro&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;#expect() macro&quot;" time="1.288" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation._filePath property&quot;" time="1.290" />
            <testcase classname="SwiftTesting" name="&quot;Unicode characters influence generated identifiers&quot;" time="1.292" />
            <testcase classname="SwiftTesting" name="typeComparison()" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.description property&quot;" time="1.292" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.fileID property&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;Explicitly nil comment&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;Test.associatedBugs property&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;.bug() with String&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;.bug() with UnsignedInteger&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;Bug hashing&quot;" time="1.291" />
            <testcase classname="SwiftTesting" name="&quot;comment property&quot;" time="1.292" />
            <testcase classname="SwiftTesting" name="&quot;.bug() with SignedInteger&quot;" time="1.292" />
            <testcase classname="SwiftTesting" name="&quot;#require(throws: Never.self) produces a diagnostic&quot;" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;Methods on non-XCTestCase subclasses are supported&quot;" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;sourceLocation property&quot;" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;.bug() with URL string&quot;" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;removeValue(at:keepingChildren:) function (removing root, sparse)&quot;" time="1.293" />
            <testcase classname="SwiftTesting" name="&quot;#expect(true) and #require(true) note they always pass&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;Encoding/decoding&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;updateValue(_:at:) function (no existing value)&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;.comment() factory method&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;insertValue(_:at:) function (no existing value)&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;init() (sparse)&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;updateValue(_:at:) function&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;compactMap(_:) function&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.fileName property&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;subscript([K]) operator&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;insertValue(_:at:) function&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;flatMap(_:) function (async)&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;forEach(_:) function&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;removeValue(at:keepingChildren:) function (no value at key path)&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;.bug() is not recursively applied&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;insertValue(_:at:) function (no existing value, sparse)&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;mapValues(_:) function (async, recursively applied)&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;mapValues(_:) function (recursively applied)&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;mapValues(_:) function&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;compactMapValues(_:) function (async, recursively applied)&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;flatMap(_:) function&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;compactMapValues(_:) function&quot;" time="1.295" />
            <testcase classname="SwiftTesting" name="&quot;Cartesian product with empty first input is empty&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;subscript([K]) operator (sparse, mutating)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;First element is correct&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;init(value:)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;compactMapValues(_:) function (async)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;CartesianProduct.underestimatedCount is clamped at .max&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;Comparing Bug instances&quot;" time="1.298" />
            <testcase classname="SwiftTesting" name="&quot;Cartesian product with empty second input is empty&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;mapValues(_:) function (async)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;underestimatedCount and count properties&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="sourceLocationPropertyGetter()" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;removeValue(at:keepingChildren:) function (removing children)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;takeValues(at:) function&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;removeValue(at:keepingChildren:) function (removing root, should have no effect)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="errorSnapshot()" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;subscript([K]) operator (sparse)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;#require(non-optional value) produces a diagnostic&quot;" time="1.299" />
            <testcase classname="SwiftTesting" name="&quot;Codable&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;Clock.minimumResolution property&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;Codable&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;Clock.Instant.nanoseconds(until:) method&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;Custom descriptions are the same&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;Casting Test.Clock.Instant to Date&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;init(value:children:)&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;.hidden trait&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;Capturing comments above #expect()/#require()&quot;" time="1.300" />
            <testcase classname="SwiftTesting" name="&quot;Event&apos;s and Event.Kinds&apos;s Codable Conformances&quot;" time="1.296" />
            <testcase classname="SwiftTesting" name="&quot;subgraph(at:)&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="&quot;map(_:) function&quot;" time="1.297" />
            <testcase classname="SwiftTesting" name="sourceLocationPropertySetter()" time="1.298" />
            <testcase classname="SwiftTesting" name="&quot;removeValue(at:keepingChildren:) function&quot;" time="1.299" />
            <testcase classname="SwiftTesting" name="&quot;--symbolicate-backtraces argument&quot;" time="1.300" />
            <testcase classname="SwiftTesting" name="&quot;forEach(_:) function (async)&quot;" time="1.300" />
            <testcase classname="SwiftTesting" name="&quot;--xunit-output argument (bad path)&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--xunit-output argument (missing path)&quot;" time="1.300" />
            <testcase classname="SwiftTesting" name="&quot;--verbosity argument&quot;" time="1.300" />
            <testcase classname="SwiftTesting" name="&quot;EXIT_NO_TESTS_FOUND is unique&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--parallel/--no-parallel argument&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;Clock.Instant.advanced(by:) and .duration(to:) methods&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;All elements of two ranges are equal&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--verbose, --very-verbose, and --quiet arguments&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;Event.Contexts&apos;s Codable Conformances&quot;" time="1.302" />
            <testcase classname="SwiftTesting" name="&quot;--repeat-until pass argument (alone)&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--repetitions and --repeat-until arguments&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;Unwrapping #require() macro&quot;" time="1.305" />
            <testcase classname="SwiftTesting" name="&quot;Multiple --filter arguments&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--xunit-output argument (writes to file)&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--configuration-path argument&quot;" time="1.302" />
            <testcase classname="SwiftTesting" name="&quot;--filter/--skip arguments and .hidden trait&quot;" time="1.304" />
            <testcase classname="SwiftTesting" name="&quot;Test.ID.parent property&quot;" time="1.304" />
            <testcase classname="SwiftTesting" name="&quot;--repeat-until fail argument (alone)&quot;" time="1.305" />
            <testcase classname="SwiftTesting" name="&quot;--filter or --skip argument with bad regex&quot;" time="1.305" />
            <testcase classname="SwiftTesting" name="&quot;--repeat-until argument with garbage value (alone)&quot;" time="1.306" />
            <testcase classname="SwiftTesting" name="&quot;Test.id property&quot;" time="1.301" />
            <testcase classname="SwiftTesting" name="&quot;--repetitions argument (alone)&quot;" time="1.306" />
            <testcase classname="SwiftTesting" name="&quot;Properties related to parameterization&quot;" time="1.307" />
            <testcase classname="SwiftTesting" name="&quot;failureBreakpoint() call&quot;" time="1.308" />
            <testcase classname="SwiftTesting" name="&quot;Test.ID.init() with no arguments&quot;" time="1.308" />
            <testcase classname="SwiftTesting" name="&quot;Test.sourceLocation.column is used when sorting&quot;" time="1.308" />
            <testcase classname="SwiftTesting" name="&quot;No --filter or --skip argument&quot;" time="1.302" />
            <testcase classname="SwiftTesting" name="&quot;Command line arguments are available&quot;" time="1.312" />
            <testcase classname="SwiftTesting" name="&quot;--filter argument&quot;" time="1.315" />
            <testcase classname="SwiftTesting" name="&quot;--skip argument&quot;" time="1.314" />
            <testcase classname="SwiftTesting" name="&quot;Test.all deduping&quot;" time="1.318" />
            <testcase classname="SwiftTesting" name="&quot;Issue.Kind.timeLimitExceeded.description property&quot;" time="1.318" />
            <testcase classname="SwiftTesting" name="&quot;Configuration.maximumTestTimeLimit property&quot;" time="1.318" />
            <testcase classname="SwiftTesting" name="&quot;Value reflecting an object with a reference to another object which has a cyclic back-reference the first&quot;" time="1.318" />
            <testcase classname="SwiftTesting" name="&quot;Value reflecting an object with multiple cyclic references&quot;" time="1.318" />
            <testcase classname="SwiftTesting" name="&quot;TimeoutError.description property&quot;" time="1.319" />
            <testcase classname="SwiftTesting" name="&quot;Configuration.defaultTestTimeLimit property set higher than maximum&quot;" time="1.319" />
            <testcase classname="SwiftTesting" name="&quot;Configuration.defaultTestTimeLimit property&quot;" time="1.321" />
            <testcase classname="SwiftTesting" name="&quot;Value reflecting a simple struct with one property&quot;" time="1.321" />
            <testcase classname="SwiftTesting" name="&quot;adjustedTimeLimit(configuration:) function&quot;" time="1.325" />
            <testcase classname="SwiftTesting" name="&quot;Summing values is consistent&quot;" time="1.329" />
            <testcase classname="SwiftTesting" name="&quot;Value reflecting an object with multiple non-cyclic references&quot;" time="1.326" />
            <testcase classname="SwiftTesting" name="isImportedFromC()" time="1.326" />
            <testcase classname="SwiftTesting" name="&quot;--event-stream-output-path argument (writes to a stream and can be read back)&quot;" time="1.329" />
            <testcase classname="SwiftTesting" name="&quot;Value reflecting an object with a cyclic reference to itself&quot;" time="1.327" />
            <testcase classname="SwiftTesting" name="initWithType(type:expectedTypeInfo:)" time="1.328" />
            <testcase classname="SwiftTesting" name="isSwiftEnumeration()" time="1.330" />
            <testcase classname="SwiftTesting" name="&quot;Count of cartesian product&quot;" time="1.340" />
            <testcase classname="SwiftTesting" name="typeNameOfFunctionIsMungedCorrectly()" time="1.337" />
            <testcase classname="SwiftTesting" name="&quot;.hidden trait&quot;" time="1.337" />
            <testcase classname="SwiftTesting" name="eventPostingInTaskGroup()" time="1.337" />
            <testcase classname="SwiftTesting" name="&quot;.timeLimit() factory method&quot;" time="1.337" />
            <testcase classname="SwiftTesting" name="typeNameInExtensionIsMungedCorrectly()" time="1.338" />
            <testcase classname="SwiftTesting" name="mangledTypeName()" time="1.338" />
            <testcase classname="SwiftTesting" name="&quot;One-element key path before two-element key path&quot;" time="1.337" />
            <testcase classname="SwiftTesting" name="&quot;Single-element key path&quot;" time="1.337" />
            <testcase classname="SwiftTesting" name="&quot;Long key path, then short key path, then medium key path&quot;" time="1.338" />
            <testcase classname="SwiftTesting" name="&quot;Short key path before long key path&quot;" time="1.338" />
            <testcase classname="SwiftTesting" name="&quot;Two-element key path before one-element key path&quot;" time="1.338" />
            <testcase classname="SwiftTesting" name="&quot;Inverted lookup&quot;" time="1.338" />
            <testcase classname="SwiftTesting" name="&quot;Long key path before short key path&quot;" time="1.339" />
            <testcase classname="SwiftTesting" name="&quot;Two peer key paths&quot;" time="1.338" />
            <testcase classname="SwiftTesting" name="strings()" time="0.473" />
            <testcase classname="SwiftTesting" name="types()" time="0.474" />
            <testcase classname="SwiftTesting" name="&quot;Cartesian products compare equal&quot;" time="1.343" />
            <testcase classname="SwiftTesting" name="&quot;Exit condition matching operators (==, !=, ===, !==)&quot;" time="0.468" />
            <testcase classname="SwiftTesting" name="optionals()" time="0.473" />
            <testcase classname="SwiftTesting" name="&quot;Mutating a value within withLock(_:)&quot;" time="0.437" />
            <testcase classname="SwiftTesting" name="otherProtocols()" time="0.474" />
            <testcase classname="SwiftTesting" name="ranges()" time="0.473" />
            <testcase classname="SwiftTesting" name="&quot;Can recognize opened pipe&quot;" time="0.152" />
            <testcase classname="SwiftTesting" name="enumerations()" time="0.474" />
            <testcase classname="SwiftTesting" name="&quot;Can get stdout&quot;" time="0.150" />
            <testcase classname="SwiftTesting" name="&quot;Can get stderr&quot;" time="0.153" />
            <testcase classname="SwiftTesting" name="&quot;Cannot write string to a read-only file&quot;" time="0.150" />
            <testcase classname="SwiftTesting" name="&quot;close() function&quot;" time="0.149" />
            <testcase classname="SwiftTesting" name="&quot;Cannot write bytes to a read-only file&quot;" time="0.150" />
            <testcase classname="SwiftTesting" name="&quot;Can recognize opened TTY&quot;" time="0.152" />
            <testcase classname="SwiftTesting" name="&quot;Can write to a file&quot;" time="0.148" />
            <testcase classname="SwiftTesting" name="&quot;/dev/null is not a TTY or pipe&quot;" time="0.148" />
            <testcase classname="SwiftTesting" name="&quot;fmemopen()&apos;ed file is not a TTY or pipe&quot;" time="0.148" />
            <testcase classname="SwiftTesting" name="&quot;Init from invalid file descriptor&quot;" time="0.149" />
            <testcase classname="SwiftTesting" name="&quot;Can get file descriptor&quot;" time="0.152" />
            <testcase classname="SwiftTesting" name="&quot;Can close ends of a pipe&quot;" time="0.151" />
            <testcase classname="SwiftTesting" name="&quot;Get whole environment block&quot;" time="0.126" />
            <testcase classname="SwiftTesting" name="&quot;JUnitXMLRecorder counts issues without associated tests&quot;" time="0.126" />
            <testcase classname="SwiftTesting" name="&quot;JUnit XML omits time for skipped tests&quot;" time="0.127" />
            <testcase classname="SwiftTesting" name="&quot;HumanReadableOutputRecorder counts issues without associated tests&quot;" time="0.127" />
            <testcase classname="SwiftTesting" name="&quot;Can read from a file&quot;" time="0.155" />
            <testcase classname="SwiftTesting" name="&quot;Macro expansion is performed within a test function&quot;" time="1.371" />
            <testcase classname="SwiftTesting" name="&quot;Main actor isolation&quot;" time="1.679" />
            <testcase classname="SwiftTesting" name="decodeEmptyConfiguration()" time="0.436" />
            <testcase classname="SwiftTesting" name="&quot;Invalid tag color decoding&quot;" time="0.483" />
            <testcase classname="SwiftTesting" name="&quot;Tags as codable dictionary keys&quot;" time="0.484" />
            <testcase classname="SwiftTesting" name="&quot;Colors are read from disk&quot;" time="0.485" />
            <testcase classname="SwiftTesting" name="&quot;Tag.description property&quot;" time="0.485" />
            <testcase classname="SwiftTesting" name="&quot;Tag.List.description property&quot;" time="0.485" />
            <testcase classname="SwiftTesting" name="&quot;Tags can be parsed from user-provided strings&quot;" time="0.486" />
            <testcase classname="SwiftTesting" name="&quot;Encoding/decoding tags&quot;" time="0.486" />
            <testcase classname="SwiftTesting" name="&quot;No colors are read from a bad path&quot;" time="0.486" />
            <testcase classname="SwiftTesting" name="&quot;.tags() factory method with one tag&quot;" time="0.486" />
            <testcase classname="SwiftTesting" name="&quot;Tag color sorting&quot;" time="0.487" />
            <testcase classname="SwiftTesting" name="&quot;.tags() factory method with two tags&quot;" time="0.487" />
            <testcase classname="SwiftTesting" name="&quot;Test.tags property&quot;" time="0.487" />
            <testcase classname="SwiftTesting" name="&quot;Tag.List comparisons&quot;" time="0.487" />
            <testcase classname="SwiftTesting" name="&quot;Tag colors are converted to 16-color correctly&quot;" time="0.487" />
            <testcase classname="SwiftTesting" name="&quot;.tags() factory method with colors&quot;" time="0.488" />
            <testcase classname="SwiftTesting" name="&quot;Free function&apos;s name&quot;" time="2.336" />
            <testcase classname="SwiftTesting" name="&quot;Test suite type&apos;s name&quot;" time="2.337" />
            <testcase classname="SwiftTesting" name="&quot;list subcommand&quot;" time="2.338" />
            <testcase classname="SwiftTesting" name="&quot;list --verbose subcommand&quot;" time="2.337" />
            <testcase classname="SwiftTesting" name="&quot;Concurrent access (summing ten times) is consistent&quot;" time="2.340" />
            <testcase classname="SwiftTesting" name="&quot;Free function has custom display name&quot;" time="2.338" />
            <testcase classname="SwiftTesting" name="&quot;Cancelled tests can exit early (cancellation checking works)&quot;" time="2.338" />
            <testcase classname="SwiftTesting" name="&quot;Member function has custom display name&quot;" time="2.343" />
            <testcase classname="SwiftTesting" name="&quot;.serialized trait is recursively applied&quot;" time="2.362" />
            <testcase classname="SwiftTesting" name="&quot;Test.comments property&quot;" time="2.447" />
            <testcase classname="SwiftTesting" name="&quot;Static functions are nested at the same level as instance functions&quot;" time="2.456" />
            <testcase classname="SwiftTesting" name="&quot;Objective-C selectors are discovered&quot;" time="2.456" />
            <testcase classname="SwiftTesting" name="&quot;Unfiltered tests&quot;" time="2.456" />
            <testcase classname="SwiftTesting" name="&quot;Clock.Instant.durationSince1970 property&quot;" time="2.464" />
            <testcase classname="SwiftTesting" name="&quot;Clock.Instant basics&quot;" time="2.464" />
            <testcase classname="SwiftTesting" name="&quot;Creating a SuspendingClock.Instant from Test.Clock.Instant&quot;" time="2.465" />
            <testcase classname="SwiftTesting" name="&quot;Clock.Instant.timeComponentsSince1970 property&quot;" time="2.472" />
            <testcase classname="SwiftTesting" name="&quot;Clock.now property&quot;" time="2.474" />
            <testcase classname="SwiftTesting" name="&quot;Clock.sleep(until:tolerance:) method&quot;" time="2.473" />
            <testcase classname="SwiftTesting" name="&quot;timeLimit property&quot;" time="2.523" />
            <testcase classname="SwiftTesting" name="&quot;Exit test reports &gt; 8 bits of the exit code&quot;" time="1.645" />
            <testcase classname="SwiftTesting" name="&quot;Writing requires contiguous storage&quot;" time="1.328" />
            <testcase classname="SwiftTesting" name="&quot;isParameterized property&quot;" time="2.537" />
            <testcase classname="SwiftTesting" name="&quot;isSuite property&quot;" time="2.543" />
            <testcase classname="SwiftTesting" name="&quot;v0 entry point listing tests only&quot;" time="1.275" />
            <testcase classname="SwiftTesting" name="&quot;Recursive trait application&quot;" time="2.551" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.fileID property must be well-formed&quot;" time="2.557" />
            <testcase classname="SwiftTesting" name="&quot;Exit test can be main-actor-isolated&quot;" time="1.730" />
            <testcase classname="SwiftTesting" name="&quot;SourceLocation.line and column properties must be positive&quot;" time="2.608" />
            <testcase classname="SwiftTesting" name="&quot;Iteration count must be positive&quot;" time="1.365" />
            <testcase classname="SwiftTesting" name="&quot;Confirmation requires positive count&quot;" time="2.636" />
            <testcase classname="SwiftTesting" name="&quot;Read environment variable&quot;" time="0.105" />
            <testcase classname="SwiftTesting" name="&quot;Tags are recursively applied&quot;" time="1.459" />
            <testcase classname="SwiftTesting" name="&quot;Custom execution trait throws an error&quot;" time="2.765" />
            <testcase classname="SwiftTesting" name="&quot;Test.parameters property&quot;" time="2.772" />
            <testcase classname="SwiftTesting" name="&quot;Codable&quot;" time="2.772" />
            <testcase classname="SwiftTesting" name="&quot;Relative order of recursively applied traits&quot;" time="2.777" />
            <testcase classname="SwiftTesting" name="&quot;Combining test filter by ID with .unfiltered (rhs)&quot;" time="2.778" />
            <testcase classname="SwiftTesting" name="&quot;Excluded tests by ID&quot;" time="2.779" />
            <testcase classname="SwiftTesting" name="&quot;Multiple selected tests by ID&quot;" time="2.798" />
            <testcase classname="SwiftTesting" name="&quot;Combining test filter by ID with by tag&quot;" time="2.798" />
            <testcase classname="SwiftTesting" name="&quot;Combining test filter by ID with .unfiltered (lhs)&quot;" time="2.798" />
            <testcase classname="SwiftTesting" name="&quot;Typed thrown error captures backtrace&quot;" time="2.808" />
            <testcase classname="SwiftTesting" name="&quot;Thrown error captures backtrace&quot;" time="2.809" />
            <testcase classname="SwiftTesting" name="&quot;Thrown NSError captures backtrace&quot;" time="2.808" />
            <testcase classname="SwiftTesting" name="&quot;Custom source location argument to #expect()&quot;" time="2.808" />
            <testcase classname="SwiftTesting" name="&quot;Selected tests by ID&quot;" time="2.802">
                <failure message="Swift testing test failed" />
            </testcase>
            <testcase classname="SwiftTesting" name="&quot;Multiple arguments conforming to CustomTestArgumentEncodable, passed to one parameter, selecting one case&quot;" time="2.815" />
            <testcase classname="SwiftTesting" name="&quot;Multiple arguments passed to one parameter, selecting one case&quot;" time="2.815" />
            <testcase classname="SwiftTesting" name="&quot;Multiple arguments conforming to RawRepresentable, passed to one parameter, selecting one case&quot;" time="2.816" />
            <testcase classname="SwiftTesting" name="&quot;Two collections, each with multiple arguments, passed to two parameters, selecting one case&quot;" time="2.815" />
            <testcase classname="SwiftTesting" name="&quot;Zipped collections are not combinatoric&quot;" time="2.815" />
            <testcase classname="SwiftTesting" name="&quot;Multiple arguments conforming to Identifiable, passed to one parameter, selecting one case&quot;" time="2.816" />
            <testcase classname="SwiftTesting" name="&quot;Multiple arguments passed to one parameter, selecting a subset of cases&quot;" time="2.816" />
            <testcase classname="SwiftTesting" name="&quot;Parameterizing over a collection with a poor underestimatedCount property&quot;" time="2.815" />
            <testcase classname="SwiftTesting" name="&quot;Parameterized cases are all executed (1 argument)&quot;" time="2.818" />
            <testcase classname="SwiftTesting" name="&quot;Execute code before and after a non-parameterized test.&quot;" time="2.819" />
            <testcase classname="SwiftTesting" name="&quot;Execute code before and after a parameterized test.&quot;" time="2.820" />
            <testcase classname="SwiftTesting" name="runnerStateScopedEventHandler()" time="2.820" />
            <testcase classname="SwiftTesting" name="&quot;Exit test without configured exit test handler&quot;" time="1.946" />
            <testcase classname="SwiftTesting" name="&quot;Issue counts are omitted on a successful test&quot;" time="1.605" />
            <testcase classname="SwiftTesting" name="&quot;withKnownIssue {} with main actor isolation&quot;" time="2.834" />
            <testcase classname="SwiftTesting" name="&quot;Selected tests by any tag&quot;" time="2.825" />
            <testcase classname="SwiftTesting" name="&quot;One iteration (default behavior)&quot;" time="1.560" />
            <testcase classname="SwiftTesting" name="&quot;Mixed included and excluded tests by ID&quot;" time="2.830" />
            <testcase classname="SwiftTesting" name="&quot;Excluded tests by any tag&quot;" time="2.832" />
            <testcase classname="SwiftTesting" name="&quot;Excluded tests by all tags&quot;" time="2.834" />
            <testcase classname="SwiftTesting" name="&quot;Selected tests by all tags&quot;" time="2.834" />
            <testcase classname="SwiftTesting" name="&quot;Combining test filters with .or&quot;" time="2.835" />
            <testcase classname="SwiftTesting" name="&quot;Exit test forwards issues&quot;" time="1.972" />
            <testcase classname="SwiftTesting" name="&quot;Time limit exceeded event includes its associated Test&quot;" time="2.846" />
            <testcase classname="SwiftTesting" name="&quot;Test times out when overrunning .timeLimit() trait&quot;" time="2.846" />
            <testcase classname="SwiftTesting" name="&quot;Test times out when overrunning maximum time limit&quot;" time="2.846" />
            <testcase classname="SwiftTesting" name="&quot;Test times out when overrunning default time limit&quot;" time="2.846" />
            <testcase classname="SwiftTesting" name="&quot;Test does not block until end of time limit&quot;" time="2.847" />
            <testcase classname="SwiftTesting" name="&quot;Test suite types are runnable&quot;" time="2.849" />
            <testcase classname="SwiftTesting" name="&quot;One Dictionary element tuple (key, value) parameter&quot;" time="2.854" />
            <testcase classname="SwiftTesting" name="&quot;One parameter&quot;" time="2.853" />
            <testcase classname="SwiftTesting" name="&quot;One 2-tuple parameter&quot;" time="2.854" />
            <testcase classname="SwiftTesting" name="&quot;One 1-tuple parameter&quot;" time="2.855" />
            <testcase classname="SwiftTesting" name="&quot;Two parameters&quot;" time="2.856" />
            <testcase classname="SwiftTesting" name="&quot;--filter with no matches&quot;" time="2.852" />
            <testcase classname="SwiftTesting" name="&quot;Teardown occurs after child tests run&quot;" time="2.850" />
            <testcase classname="SwiftTesting" name="&quot;Successful confirmations&quot;" time="2.850" />
            <testcase classname="SwiftTesting" name="&quot;Two Dictionary element (key, value) parameters&quot;" time="2.856" />
            <testcase classname="SwiftTesting" name="&quot;Test cases of a disabled test are not evaluated&quot;" time="2.851" />
            <testcase classname="SwiftTesting" name="&quot;Unsuccessful confirmations&quot;" time="2.852" />
            <testcase classname="SwiftTesting" name="&quot;Verbose output&quot;" time="1.635" />
            <testcase classname="SwiftTesting" name="&quot;JUnitXMLRecorder outputs valid XML&quot;" time="1.636" />
            <testcase classname="SwiftTesting" name="&quot;XCTest test methods are currently unsupported&quot;" time="2.853" />
            <testcase classname="SwiftTesting" name="&quot;Titles of messages (&apos;Test&apos; vs. &apos;Suite&apos;) are determined correctly&quot;" time="1.637" />
            <testcase classname="SwiftTesting" name="&quot;Issue counts are summed correctly on run end&quot;" time="1.636" />
            <testcase classname="SwiftTesting" name="&quot;Test times out when overrunning .timeLimit() trait (inherited)&quot;" time="2.855" />
            <testcase classname="SwiftTesting" name="v0()" time="1.585" />
            <testcase classname="SwiftTesting" name="v0_experimental()" time="1.586" />
            <testcase classname="SwiftTesting" name="&quot;Quiet output&quot;" time="1.641" />
            <testcase classname="SwiftTesting" name="&quot;Issue counts are summed correctly on test end&quot;" time="1.642" />
            <testcase classname="SwiftTesting" name="&quot;Writing events&quot;" time="1.641" />
            <testcase classname="SwiftTesting" name="&quot;Free functions are runnable&quot;" time="2.862" />
            <testcase classname="SwiftTesting" name="&quot;Parameterized free functions are runnable&quot;" time="2.862" />
            <testcase classname="SwiftTesting" name="&quot;Read true environment flags&quot;" time="0.040" />
            <testcase classname="SwiftTesting" name="&quot;Iteration while issue recorded&quot;" time="1.593" />
            <testcase classname="SwiftTesting" name="&quot;Iteration until issue recorded&quot;" time="1.593" />
            <testcase classname="SwiftTesting" name="&quot;Parameterized cases are all executed (2 arguments)&quot;" time="2.863" />
            <testcase classname="SwiftTesting" name="&quot;Mock exit test handlers (failing)&quot;" time="1.990" />
            <testcase classname="SwiftTesting" name="&quot;Unconditional iteration&quot;" time="1.593" />
            <testcase classname="SwiftTesting" name="&quot;Mock exit test handlers (passing)&quot;" time="1.991" />
            <testcase classname="SwiftTesting" name="&quot;Read false environment flags&quot;" time="0.002" />
            <testcase classname="SwiftTesting" name="&quot;Instance methods are runnable&quot;" time="2.944" />
            <testcase classname="SwiftTesting" name="&quot;Exit tests (passing)&quot;" time="2.071" />
            <testcase classname="SwiftTesting" name="&quot;Parameterized member functions are runnable&quot;" time="3.098" />
            <testcase classname="SwiftTesting" name="&quot;Exit tests (failing)&quot;" time="2.287" />
            <testcase classname="SwiftTesting" name="&quot;.serialized trait serializes parameterized test&quot;" time="3.434" />
            <testcase classname="SwiftTesting" name="&quot;v0 experimental entry point with a large number of filter arguments&quot;" time="2.497" />
            <testcase classname="SwiftTesting" name="&quot;v0 entry point with a large number of filter arguments&quot;" time="2.505" />
        </testsuite>
    </testsuites>
    """
    #endif

    #if os(macOS)
    func testSwiftTestingJUnitReport() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "swift_test_log_macOS", withExtension: "txt"))
        let parser = Parser()
        let reporter = JUnitReporter()

        for line in try String(contentsOf: url).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) as? any JUnitReportable {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let xml = try XCTUnwrap(String(data: data, encoding: .utf8))
        let expectedXml = expectedSwiftTestingXML_macOS
        XCTAssertEqual(xml, expectedXml)
    }
    #endif

    func testMixedXCTestAndSwiftTestingJUnitReport() throws {
        #if os(Linux)
        throw XCTSkip("[TODO] Re-enable this test.")
        let inputURL = try XCTUnwrap(Bundle.module.url(forResource: "MixedTestLog_6_0_Linux", withExtension: "txt"))
        let outputURL = try XCTUnwrap(Bundle.module.url(forResource: "MixedTestLog_6_0_Expected_XML_Linux", withExtension: "txt"))
        #else
        let inputURL = try XCTUnwrap(Bundle.module.url(forResource: "MixedTestLog_6_0_macOS", withExtension: "txt"))
        let outputURL = try XCTUnwrap(Bundle.module.url(forResource: "MixedTestLog_6_0_Expected_XML_macOS", withExtension: "txt"))
        #endif
        let parser = Parser()
        let reporter = JUnitReporter()

        for line in try String(contentsOf: inputURL).components(separatedBy: .newlines) {
            if let captureGroup = parser.parse(line: line) as? any JUnitReportable {
                reporter.add(captureGroup: captureGroup)
            }
        }
        let data = try reporter.generateReport()
        let actualXML = String(decoding: data, as: UTF8.self)
        let expectedXML = try String(contentsOf: outputURL)
        XCTAssertEqual(actualXML, expectedXML)
    }
}
