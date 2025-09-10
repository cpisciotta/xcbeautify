import XcLogParserLib

extension FailingTestCaptureGroup: JUnitReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: testSuite, name: testCase, time: nil, failure: .init(message: "\(file) - \(reason)"))
        return .failingTest(testCase)
    }
}

extension RestartingTestCaptureGroup: JUnitReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: testSuite, name: testCase, time: nil, failure: .init(message: wholeMessage))
        return .failingTest(testCase)
    }
}

extension TestCaseSkippedCaptureGroup: JUnitReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: suite, name: testCase, time: time, skipped: .init(message: nil))
        return .skippedTest(testCase)
    }
}

extension TestCasePassedCaptureGroup: JUnitReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: suite, name: testCase, time: time)
        return .testCasePassed(testCase)
    }
}

extension ParallelTestCaseSkippedCaptureGroup: JUnitParallelReportable {
    
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: suite, name: testCase, time: time, skipped: .init(message: nil))
        return .testCasePassed(testCase)
    }
}

extension ParallelTestCasePassedCaptureGroup:  JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: suite, name: testCase, time: time)
        return .testCasePassed(testCase)
    }
}

extension ParallelTestCaseFailedCaptureGroup:  JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        // Parallel tests do not provide meaningful failure messages
        let testCase = TestCase(classname: suite, name: testCase, time: nil, failure: .init(message: "Parallel test failed"))
        return .failingTest(testCase)
    }
}

extension TestSuiteStartedCaptureGroup: JUnitReportable {
    func junitComponent() -> JUnitComponent {
        .testSuiteStart(suiteName)
    }
}

extension SwiftTestingSuiteStartedCaptureGroup:  JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        .testSuiteStart(suiteName)
    }
}

extension SwiftTestingTestPassedCaptureGroup: JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: swiftTestingSuiteName, name: testName, time: timeTaken)
        return .testCasePassed(testCase)
    }
}

extension SwiftTestingTestFailedCaptureGroup: JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: swiftTestingSuiteName, name: testName, time: timeTaken, failure: .init(message: "Swift testing test failed"))
        return .failingTest(testCase)
    }
}

extension SwiftTestingTestSkippedCaptureGroup: JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: swiftTestingSuiteName, name: testName, time: nil, skipped: .init(message: nil))
        return .skippedTest(testCase)
    }
}

extension SwiftTestingTestSkippedReasonCaptureGroup:  JUnitParallelReportable {
    func junitComponent() -> JUnitComponent {
        let testCase = TestCase(classname: swiftTestingSuiteName, name: testName, time: nil, skipped: .init(message: reason))
        return .skippedTest(testCase)
    }
}
