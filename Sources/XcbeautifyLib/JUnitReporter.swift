//
// JUnitReporter.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

// Information about the JUNIT Schema/specification used in this file can be found here:
// * https://stackoverflow.com/a/9410271
// * https://github.com/bazelbuild/bazel/blob/45092bb122b840e3410845522df9fe89c59db465/src/java_tools/junitrunner/java/com/google/testing/junit/runner/model/AntXmlResultWriter.java#L29
// * http://windyroad.com.au/dl/Open%20Source/JUnit.xsd

#if compiler(>=6.0)
package import Foundation
package import XMLCoder
#else
import Foundation
import XMLCoder
#endif

package protocol JUnitReportable {
    func junitComponent() -> JUnitComponent
}

package protocol JUnitParallelReportable: JUnitReportable { }

package final class JUnitReporter {
    private var components: [JUnitComponent] = []
    // Parallel output does not guarantee order - so it is _very_ hard
    // to match to the parent suite. We can still capture test success/failure
    // and output a generic result file.
    private var parallelComponents: [JUnitComponent] = []

    package init() { }

    package func add(captureGroup: any JUnitReportable) {
        if let captureGroup = captureGroup as? any JUnitParallelReportable {
            parallelComponents.append(captureGroup.junitComponent())
        } else {
            components.append(captureGroup.junitComponent())
        }
    }

    package func generateReport() throws -> Data {
        let parser = JUnitComponentParser()
        for item in components {
            parser.parse(component: item)
        }
        // Prefix a fake test suite start for the parallel tests.
        parallelComponents.insert(.testSuiteStart("PARALLEL_TESTS"), at: 0)
        for parallelComponent in parallelComponents {
            parser.parse(component: parallelComponent)
        }
        let encoder = XMLEncoder()
        encoder.keyEncodingStrategy = .lowercased
        encoder.outputFormatting = [.prettyPrinted]
        let result = parser.result()
        return try encoder.encode(result)
    }
}

private final class JUnitComponentParser {
    private var mainTestSuiteName: String?
    private var testCases: [TestCase] = []

    func parse(component: JUnitComponent) {
        switch component {
        case let .testSuiteStart(suiteName):
            guard mainTestSuiteName == nil else {
                break
            }
            mainTestSuiteName = suiteName

        case let .failingTest(testCase),
             let .skippedTest(testCase),
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
        return Testsuites(name: mainTestSuiteName, testsuites: testSuites)
    }
}

package enum JUnitComponent {
    case testSuiteStart(String)
    case failingTest(TestCase)
    case testCasePassed(TestCase)
    case skippedTest(TestCase)
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
        case .failures, .name, .tests:
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
        case .failures, .name, .tests:
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

package struct TestCase: Codable, DynamicNodeEncoding {
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

    package static func nodeEncoding(for key: any CodingKey) -> XMLEncoder.NodeEncoding {
        let key = CodingKeys(stringValue: key.stringValue)!
        switch key {
        case .classname, .name, .time:
            return .attribute

        case .failure, .skipped:
            return .element
        }
    }
}

extension TestCase {
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
