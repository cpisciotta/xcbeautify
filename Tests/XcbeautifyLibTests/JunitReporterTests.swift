import Foundation
import XCTest
import XcbeautifyLib

class JunitReporterTests: XCTestCase {
    private let testLog = """
        Test Suite 'All tests' started at 2021-11-05 01:08:23.237
        Test Suite 'xcbeautifyPackageTests.xctest' started at 2021-11-05 01:08:23.238
        Test Suite 'OutputHandlerTests' started at 2021-11-05 01:08:23.238
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testEarlyReturnIfEmptyString]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testEarlyReturnIfEmptyString]' passed (0.054 seconds).
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintAllOutputTypeByDefault]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintAllOutputTypeByDefault]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintOnlyTasksWithError]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintOnlyTasksWithError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintOnlyTasksWithWarningOrError]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintOnlyTasksWithWarningOrError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintTestResultTooIfIsCIAndQuiet]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintTestResultTooIfIsCIAndQuiet]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintTestResultTooIfIsCIAndQuieter]' started.
        Test Case '-[XcbeautifyLibTests.OutputHandlerTests testPrintTestResultTooIfIsCIAndQuieter]' passed (0.000 seconds).
        Test Suite 'OutputHandlerTests' passed at 2021-11-05 01:08:23.294.
             Executed 6 tests, with 0 failures (0 unexpected) in 0.055 (0.056) seconds
        Test Suite 'XcbeautifyLibTests' started at 2021-11-05 01:08:23.294
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget]' started.
        /Users/andres/Git/xcbeautify/Tests/XcbeautifyLibTests/XcbeautifyLibTests.swift:13: error: -[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget] : XCTAssertEqual failed: ("Optional("Aggregate target Be Aggro of project AggregateExample with configuration Debug")") is not equal to ("Optional("failing Aggregate target Be Aggro of project AggregateExample with configuration Debug")")
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAggregateTarget]' failed (0.119 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAnalyze]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAnalyze]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAnalyzeTarget]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testAnalyzeTarget]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCheckDependencies]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCheckDependencies]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCheckDependenciesErrors]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCheckDependenciesErrors]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testClangError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testClangError]' passed (0.002 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCleanRemove]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCleanRemove]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCleanTarget]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCleanTarget]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCodesign]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCodesign]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCodesignFramework]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCodesignFramework]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompile]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompile]' passed (0.002 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileCommand]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileCommand]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileStoryboard]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileStoryboard]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileWarning]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileWarning]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileXib]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCompileXib]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestCaseFailed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestCaseFailed]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestCasePassed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestCasePassed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestSuiteStarted]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testConcurrentDestinationTestSuiteStarted]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyHeader]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyHeader]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyPlist]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyPlist]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyStrings]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCopyStrings]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCpresource]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCpresource]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCursor]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testCursor]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testExecuted]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testExecuted]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFailingTest]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFailingTest]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFatalError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFatalError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFileMissingError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testFileMissingError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenerateCoverageData]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenerateCoverageData]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGeneratedCoverageReport]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGeneratedCoverageReport]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenerateDsym]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenerateDsym]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenericWarning]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testGenericWarning]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLdError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLdError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLdWarning]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLdWarning]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLibtool]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLibtool]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerDuplicateSymbols]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerDuplicateSymbols]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerDuplicateSymbolsLocation]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerDuplicateSymbolsLocation]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerUndefinedSymbolLocation]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerUndefinedSymbolLocation]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerUndefinedSymbols]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinkerUndefinedSymbols]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinking]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testLinking]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testModuleIncludesError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testModuleIncludesError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testNoCertificate]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testNoCertificate]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPackageGraphResolved]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPackageGraphResolved]' passed (0.003 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCaseAppKitPassed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCaseAppKitPassed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCaseFailed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCaseFailed]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCasePassed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestCasePassed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingFailed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingFailed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingPassed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingPassed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingStarted]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testParallelTestingStarted]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPbxcp]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPbxcp]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPhaseScriptExecution]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPhaseScriptExecution]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPhaseSuccess]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPhaseSuccess]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPodsError]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPodsError]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPreprocess]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testPreprocess]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessInfoPlist]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessInfoPlist]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPch]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPch]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPchCommand]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPchCommand]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPchPlusPlus]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProcessPchPlusPlus]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProvisioningProfileRequired]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testProvisioningProfileRequired]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testRestartingTests]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testRestartingTests]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testShellCommand]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testShellCommand]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testSymbolReferencedFrom]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testSymbolReferencedFrom]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCaseMeasured]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCaseMeasured]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCasePassed]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCasePassed]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCasePending]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCasePending]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCaseStarted]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestCaseStarted]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestsRunCompletion]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestsRunCompletion]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestSuiteStart]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestSuiteStart]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestSuiteStarted]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTestSuiteStarted]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTiffutil]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTiffutil]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTouch]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testTouch]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testUiFailingTest]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testUiFailingTest]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testUndefinedSymbolLocation]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testUndefinedSymbolLocation]' passed (0.001 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWillNotBeCodeSigned]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWillNotBeCodeSigned]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWriteAuxiliaryFiles]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWriteAuxiliaryFiles]' passed (0.000 seconds).
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWriteFile]' started.
        Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testWriteFile]' passed (0.000 seconds).
        Test Suite 'XcbeautifyLibTests' failed at 2021-11-05 01:08:23.443.
             Executed 77 tests, with 1 failure (0 unexpected) in 0.147 (0.149) seconds
        Test Suite 'xcbeautifyPackageTests.xctest' failed at 2021-11-05 01:08:23.443.
             Executed 83 tests, with 1 failure (0 unexpected) in 0.202 (0.205) seconds
        Test Suite 'All tests' failed at 2021-11-05 01:08:23.443.
             Executed 83 tests, with 1 failure (0 unexpected) in 0.202 (0.206) seconds
        """

    private let expectedMacOsXml = """
        <testsuites name="All tests" tests="83" failures="1">
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
                <testcase classname="XcbeautifyLibTests.XcbeautifyLibTests" name="testWriteFile" time="0.000" />
            </testsuite>
        </testsuites>
        """

    private let expectedLinuxXml = """
        <testsuites name="All tests" tests="83" failures="1">
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
                <testcase classname="-[XcbeautifyLibTests" name="XcbeautifyLibTests testWriteFile]" time="0.000" />
            </testsuite>
        </testsuites>
        """

    func testJunitReport() throws {
        let reporter = JunitReporter()
        testLog.components(separatedBy: .newlines).forEach { reporter.add(line: $0) }
        let data = try reporter.generateReport()
        let xml = String(data: data, encoding: .utf8)!
        #if os(Linux)
        let expectedXml = expectedLinuxXml
        #else
        let expectedXml = expectedMacOsXml
        #endif
        XCTAssertEqual(xml, expectedXml)
    }
}
