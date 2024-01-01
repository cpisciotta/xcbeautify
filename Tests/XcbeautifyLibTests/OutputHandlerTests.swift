import Foundation
import XcbeautifyLib
import XCTest

class OutputHandlerTests: XCTestCase {
    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testEarlyReturnIfEmptyString() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: false, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.error, nil)

        XCTAssertEqual(collector, [])
    }

    func testPrintAllOutputTypeByDefault() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: false, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.task, "task 1")
        sut.write(.error, "error")
        sut.write(.task, "task 2")
        sut.write(.warning, "warning")
        sut.write(.result, "result")
        sut.write(.undefined, "undefined")

        XCTAssertEqual(collector, ["task 1", "error", "task 2", "warning", "result", "undefined"])
    }

    func testPrintOnlyTasksWithWarningOrError() throws { // quiet
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.error, "error")
        sut.write(.task, "task 1")
        sut.write(.task, "task 2")
        sut.write(.warning, "warning")
        sut.write(.result, "result")
        sut.write(.undefined, "undefined")

        // NOTE: task 2 appear in result is because of "warning"
        XCTAssertEqual(collector, ["error", "task 2", "warning", "result"])

        collector.removeAll()

        sut.write(.task, "task 1")
        sut.write(.task, "task 2")
        sut.write(.warning, "warning")
        sut.write(.result, "result")
        sut.write(.error, "error")
        sut.write(.undefined, "undefined")

        // NOTE: task 2 appear in result is because of "warning"
        XCTAssertEqual(collector, ["task 2", "warning", "result", "error"])
    }

    func testPrintOnlyTasksWithError() throws { // quieter
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: true, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.result, "result")
        sut.write(.error, "error")
        sut.write(.task, "task 1")
        sut.write(.task, "task 2")
        sut.write(.warning, "warning")
        sut.write(.undefined, "undefined")

        XCTAssertEqual(collector, ["result", "error"])
    }

    func testPrintTestResultTooIfIsCIAndQuiet() throws { // on quiet/quiter , print test task too
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: true) { content in
            collector.append(content)
        }

        sut.write(.warning, "warning")
        sut.write(.undefined, "undefined")
        sut.write(.test, "test started")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        XCTAssertEqual(collector, ["warning", "test started", "test completed", "result"])
    }

    func testPrintTestResultTooIfIsCIAndQuieter() throws { // on quiet/quiter , print test task too
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: true, isCI: true) { content in
            collector.append(content)
        }

        sut.write(.error, "error")
        sut.write(.warning, "warning")
        sut.write(.test, "test started")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        XCTAssertEqual(collector, ["error", "test started", "test completed", "result"])

        collector.removeAll()

        sut.write(.warning, "warning")
        sut.write(.test, "test started")
        sut.write(.error, "error")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        XCTAssertEqual(collector, ["test started", "error", "test completed", "result"])
    }
}
