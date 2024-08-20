// Information about the JUNIT Schema/specification used in this file can be found here:
// * https://stackoverflow.com/a/9410271
// * https://github.com/bazelbuild/bazel/blob/45092bb122b840e3410845522df9fe89c59db465/src/java_tools/junitrunner/java/com/google/testing/junit/runner/model/AntXmlResultWriter.java#L29
// * http://windyroad.com.au/dl/Open%20Source/JUnit.xsd

import Foundation
import XMLCoder

package final class JunitReporter {
    private var components: [JunitComponent] = []
    // Parallel output does not guarantee order - so it is _very_ hard
    // to match to the parent suite. We can still capture test success/failure
    // and output a generic result file.
    private var parallelComponents: [JunitComponent] = []

    package init() { }

    package func add(line: String) {
        // Remove any preceding or excessive spaces
        let line = line.trimmingCharacters(in: .whitespacesAndNewlines)

        if FailingTestCaptureGroup.regex.match(string: line) {
            guard let testCase = generateFailingTest(line: line) else { return }
            // reduce failing retrys, if any
            components.removePreviousFailingTestsAfter(testCase)
            components.append(.failingTest(testCase))
        } else if RestartingTestCaptureGroup.regex.match(string: line) {
            guard let testCase = generateRestartingTest(line: line) else { return }
            components.append(.failingTest(testCase))
        } else if TestCasePassedCaptureGroup.regex.match(string: line) {
            guard let testCase = generatePassingTest(line: line) else { return }
            // filter out failing retrys, if any
            components.removePreviousFailingTestsAfter(testCase)
            components.append(.testCasePassed(testCase))
        } else if TestCaseSkippedCaptureGroup.regex.match(string: line) {
            guard let testCase = generateSkippedTest(line: line) else { return }
            components.append(.skippedTest(testCase))
        } else if TestSuiteStartCaptureGroup.regex.match(string: line) {
            guard let testStart = generateSuiteStart(line: line) else { return }
            components.append(.testSuiteStart(testStart))
        } else if ParallelTestCaseFailedCaptureGroup.regex.match(string: line) {
            guard let testCase = generateParallelFailingTest(line: line) else { return }
            parallelComponents.append(.failingTest(testCase))
        } else if ParallelTestCasePassedCaptureGroup.regex.match(string: line) {
            guard let testCase = generatePassingParallelTest(line: line) else { return }
            parallelComponents.append(.testCasePassed(testCase))
        } else if ParallelTestCaseSkippedCaptureGroup.regex.match(string: line) {
            guard let testCase = generateSkippedParallelTest(line: line) else { return }
            parallelComponents.append(.testCasePassed(testCase))
        } else {
            // Not needed for generating a junit report
            return
        }
    }

    private func generateFailingTest(line: String) -> TestCase? {
        let groups = FailingTestCaptureGroup.regex.captureGroups(for: line)
        guard let group = FailingTestCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.testSuite, name: group.testCase, time: nil, failure: .init(message: "\(group.file) - \(group.reason)"))
    }

    private func generateRestartingTest(line: String) -> TestCase? {
        let groups = RestartingTestCaptureGroup.regex.captureGroups(for: line)
        guard let group = RestartingTestCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.testSuite, name: group.testCase, time: nil, failure: .init(message: line))
    }

    private func generateParallelFailingTest(line: String) -> TestCase? {
        // Parallel tests do not provide meaningful failure messages
        let groups = ParallelTestCaseFailedCaptureGroup.regex.captureGroups(for: line)
        guard let group = ParallelTestCaseFailedCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: nil, failure: .init(message: "Parallel test failed"))
    }

    private func generatePassingTest(line: String) -> TestCase? {
        let groups = TestCasePassedCaptureGroup.regex.captureGroups(for: line)
        guard let group = TestCasePassedCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time)
    }

    private func generateSkippedTest(line: String) -> TestCase? {
        let groups = TestCaseSkippedCaptureGroup.regex.captureGroups(for: line)
        guard let group = TestCaseSkippedCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time, skipped: .init(message: nil))
    }

    private func generatePassingParallelTest(line: String) -> TestCase? {
        let groups = ParallelTestCasePassedCaptureGroup.regex.captureGroups(for: line)
        guard let group = ParallelTestCasePassedCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time)
    }

    private func generateSkippedParallelTest(line: String) -> TestCase? {
        let groups = ParallelTestCaseSkippedCaptureGroup.regex.captureGroups(for: line)
        guard let group = ParallelTestCaseSkippedCaptureGroup(groups: groups) else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time, skipped: .init(message: nil))
    }

    private func generateSuiteStart(line: String) -> String? {
        let groups = TestSuiteStartCaptureGroup.regex.captureGroups(for: line)
        guard let group = TestSuiteStartCaptureGroup(groups: groups) else { return nil }
        return group.testSuiteName
    }

    package func generateReport() throws -> Data {
        let parser = JunitComponentParser()
        components.forEach { parser.parse(component: $0) }
        // Prefix a fake test suite start for the parallel tests.
        parallelComponents.insert(.testSuiteStart("PARALLEL_TESTS"), at: 0)
        parallelComponents.forEach { parser.parse(component: $0) }
        let encoder = XMLEncoder()
        encoder.keyEncodingStrategy = .lowercased
        encoder.outputFormatting = [.prettyPrinted]
        let result = parser.result()
        return try encoder.encode(result)
    }
}

private final class JunitComponentParser {
    private var mainTestSuiteName: String?
    private var testCases: [TestCase] = []

    func parse(component: JunitComponent) {
        switch component {
        case let .testSuiteStart(suiteName):
            guard mainTestSuiteName == nil else {
                break
            }
            mainTestSuiteName = suiteName

        case let .failingTest(testCase),
             let .testCasePassed(testCase),
             let .skippedTest(testCase):
            testCases.append(testCase)
        }
    }

    func result() -> Testsuites {
        var testSuites: [Testsuite] = []
        for testCase in testCases {
            let index: Int
            if let existingTestSuiteIndex = testSuites.firstIndex(where: { $0.name == testCase.classname }) {
                index = existingTestSuiteIndex
            } else {
                let newTestSuite = Testsuite(name: testCase.classname, testcases: [])
                testSuites.append(newTestSuite)
                index = testSuites.count - 1
            }
            var testSuite = testSuites[index]
            testSuite.testcases.append(testCase)
            testSuites[index] = testSuite
        }
        let container = Testsuites(name: mainTestSuiteName, testsuites: testSuites)
        return container
    }
}

private enum JunitComponent {
    case testSuiteStart(String)
    case failingTest(TestCase)
    case testCasePassed(TestCase)
    case skippedTest(TestCase)
}

private extension JunitComponent {
    var testCase: TestCase? {
        switch self {
        case .testSuiteStart: nil
        case let .failingTest(testCase), let .testCasePassed(testCase), let .skippedTest(testCase):
            testCase
        }
    }
}

private extension [JunitComponent] {
    mutating func removePreviousFailingTestsAfter(_ testCase: TestCase) {
        // base case, empty array or last is not the given TestCase
        guard let previousTestCase = last?.testCase,
              previousTestCase.failure != nil,
              testCase.classname == previousTestCase.classname,
              testCase.name == previousTestCase.name
        else {
            return
        }
        removeLast()
        // keep removing
        removePreviousFailingTestsAfter(testCase)
    }
}

private struct Testsuites: Encodable, DynamicNodeEncoding {
    var name: String?
    var testsuites: [Testsuite] = []

    enum CodingKeys: String, CodingKey {
        case name
        case tests
        case failures
        case testsuites = "testsuite"
    }

    static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .name, .tests, .failures:
            return .attribute

        case .testsuites:
            return .element
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(testsuites.reduce(into: 0) { $0 += $1.testcases.count }, forKey: .tests)
        try container.encode(testsuites.reduce(into: 0) { $0 += $1.testcases.filter { $0.failure != nil }.count }, forKey: .failures)
        try container.encode(testsuites, forKey: .testsuites)
    }
}

private struct Testsuite: Encodable, DynamicNodeEncoding {
    let name: String
    var testcases: [TestCase]

    enum CodingKeys: String, CodingKey {
        case name
        case tests
        case failures
        case testcases = "testcase"
    }

    static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .name, .tests, .failures:
            return .attribute

        case .testcases:
            return .element
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(testcases.count, forKey: .tests)
        try container.encode(testcases.filter { $0.failure != nil }.count, forKey: .failures)
        try container.encode(testcases, forKey: .testcases)
    }
}

private struct TestCase: Codable, DynamicNodeEncoding {
    let classname: String
    let name: String
    let time: String?
    let failure: Failure?
    let skipped: Skipped?

    init(classname: String, name: String, time: String?, failure: Failure? = nil, skipped: Skipped? = nil) {
        self.classname = classname
        self.name = name
        self.time = time
        self.failure = failure
        self.skipped = skipped
    }

    static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .classname, .name, .time:
            return .attribute

        case .failure, .skipped:
            return .element
        }
    }
}

private extension TestCase {
    struct Failure: Codable, DynamicNodeEncoding {
        let message: String

        static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
            let key = CodingKeys(stringValue: key.stringValue)!
            switch key {
            case .message:
                return .attribute
            }
        }
    }

    struct Skipped: Codable, DynamicNodeEncoding {
        let message: String?

        static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
            let key = CodingKeys(stringValue: key.stringValue)!
            switch key {
            case .message:
                return .attribute
            }
        }
    }
}
