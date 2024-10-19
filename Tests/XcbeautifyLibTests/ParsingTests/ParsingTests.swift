import XCTest
@testable import XcbeautifyLib

final class ParsingTests: XCTestCase {
    func testCleanBuildXcode15_1() throws {
        let url = Bundle.module.url(forResource: "clean_build_xcode_15_1", withExtension: "txt")!

        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        let parser = Parser()

        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 193)
        #else
        XCTAssertEqual(uncapturedOutput, 209)
        #endif
    }

    func testLargeXcodebuildLog() throws {
        let url = Bundle.module.url(forResource: "large_xcodebuild_log", withExtension: "txt")!

        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        let parser = Parser()

        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 6432)
        #else
        XCTAssertEqual(uncapturedOutput, 7000)
        #endif
    }

    func testParsingSwiftTestingTestOutput() throws {
        let url = Bundle.module.url(forResource: "swift_test_log", withExtension: "txt")!
        let logContent = try String(contentsOf: url)
        var buildLog = logContent.components(separatedBy: .newlines)
        let parser = Parser()
        var uncapturedOutput = 0

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()
            if !line.isEmpty, parser.parse(line: line) == nil {
                print(line)
                uncapturedOutput += 1
            }
        }

        // The following is a magic number.
        // It represents the number of lines that aren't captured by the Parser.
        // Slowly, this value should decrease until it reaches 0.
        // It uses `XCTAssertEqual` instead of `XCTAssertLessThanOrEqual` as a reminder.
        // Update this magic number whenever `uncapturedOutput` is less than the current magic number.
        // There's a regression whenever `uncapturedOutput` is greater than the current magic number.
        #if os(macOS)
        XCTAssertEqual(uncapturedOutput, 162)
        #else
        XCTAssertEqual(uncapturedOutput, 271)
        #endif
    }
}
