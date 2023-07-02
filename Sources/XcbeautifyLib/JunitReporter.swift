// Information about the JUNIT Schema/specification used in this file can be found here:
// * https://stackoverflow.com/a/9410271
// * https://github.com/bazelbuild/bazel/blob/45092bb122b840e3410845522df9fe89c59db465/src/java_tools/junitrunner/java/com/google/testing/junit/runner/model/AntXmlResultWriter.java#L29
// * http://windyroad.com.au/dl/Open%20Source/JUnit.xsd

import Foundation
import XMLCoder

public final class JunitReporter {
    private var components: [JunitComponent] = []
    // Parallel output does not guarantee order - so it is _very_ hard
    // to match to the parent suite. We can still capture test success/failure
    // and output a generic result file.
    private var parallelComponents: [JunitComponent] = []

    public init() { }

    public func add(line: String) {
        // Remove any preceding or excessive spaces
        let line = line.trimmingCharacters(in: .whitespacesAndNewlines)
        switch line {
        // Capture standard output
        case Regex.failingTest:
            guard let testCase = generateFailingTest(line: line) else { break }
            components.append(.failingTest(testCase))
        case Regex.restartingTest:
            guard let testCase = generateRestartingTest(line: line) else { break }
            components.append(.failingTest(testCase))
        case Regex.testCasePassed:
            guard let testCase = generatePassingTest(line: line) else { break }
            components.append(.testCasePassed(testCase))
        case Regex.testSuiteStart:
            guard let testStart = generateSuiteStart(line: line) else { break }
            components.append(.testSuiteStart(testStart))
        // Capture parallel output
        case Regex.parallelTestCaseFailed:
            guard let testCase = generateParallelFailingTest(line: line) else { break }
            parallelComponents.append(.failingTest(testCase))
        case Regex.parallelTestCasePassed:
            guard let testCase = generatePassingParallelTest(line: line) else { break }
            parallelComponents.append(.testCasePassed(testCase))
        default:
            // Not needed for generating a junit report
            break
        }
    }

    private func generateFailingTest(line: String) -> TestCase? {
        let group: CaptureGroup = line.captureGroup(with: .failingTest)
        guard let group = group as? FailingTestCaptureGroup else { return nil }
        return TestCase(classname: group.testSuite, name: group.testCase, time: nil, failure: .init(message: "\(group.file) - \(group.reason)"))
    }
    
    private func generateRestartingTest(line: String) -> TestCase? {
        let group: CaptureGroup = line.captureGroup(with: .restartingTest)
        guard let group = group as? RestartingTestCaptureGroup else { return nil }
        return TestCase(classname: group.testSuite, name: group.testCase, time: nil, failure: .init(message: line))
    }

    private func generateParallelFailingTest(line: String) -> TestCase? {
        // Parallel tests do not provide meaningful failure messages
        let group: CaptureGroup = line.captureGroup(with: .parallelTestCaseFailed)
        guard let group = group as? ParallelTestCaseFailedCaptureGroup else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: nil, failure: .init(message: "Parallel test failed"))
    }

    private func generatePassingTest(line: String) -> TestCase? {
        let group: CaptureGroup = line.captureGroup(with: .testCasePassed)
        guard let group = group as? TestCasePassedCaptureGroup else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time, failure: nil)
    }

    private func generatePassingParallelTest(line: String) -> TestCase? {
        let group: CaptureGroup = line.captureGroup(with: .parallelTestCasePassed)
        guard let group = group as? ParallelTestCasePassedCaptureGroup else { return nil }
        return TestCase(classname: group.suite, name: group.testCase, time: group.time, failure: nil)
    }
  
    private func generateSuiteStart(line: String) -> String? {
        let group: CaptureGroup = line.captureGroup(with: .testSuiteStart)
        guard let group = group as? TestSuiteStartCaptureGroup else { return nil }
        return group.testSuiteName
    }
    
    public func generateReport() throws -> Data {
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
          let .testCasePassed(testCase):
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

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .name, .tests, .failures:
            return .attribute
        
        case .testsuites:
            return .element
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(testsuites.reduce(into: 0, { $0 += $1.testcases.count }), forKey: .tests)
        try container.encode(testsuites.reduce(into: 0, { $0 += $1.testcases.filter { $0.failure != nil }.count }), forKey: .failures)
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

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .name, .tests, .failures:
            return .attribute
        
        case .testcases:
            return .element
        }
    }
    
    func encode(to encoder: Encoder) throws {
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
    
    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .classname, .name, .time:
            return .attribute
            
        case .failure:
            return .element
        }
    }
}

private extension TestCase {
    struct Failure: Codable, DynamicNodeEncoding {
        let message: String
        
        static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
            let key = CodingKeys(stringValue: key.stringValue)!
            switch key {
            case .message:
                return .attribute
            }
        }
    }
}
