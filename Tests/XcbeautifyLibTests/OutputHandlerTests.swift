//
// OutputHandlerTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import Testing
import XcbeautifyLib

@Suite struct OutputHandlerTests {
    @Test func earlyReturnIfEmptyString() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: false, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.error, nil)

        #expect(collector == [])
    }

    @Test func printAllOutputTypeByDefault() throws {
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

        #expect(collector == ["task 1", "error", "task 2", "warning", "result", "undefined"])
    }

    @Test func printOnlyTasksWithWarningOrError() throws { // quiet
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
        #expect(collector == ["error", "task 2", "warning", "result"])

        collector.removeAll()

        sut.write(.task, "task 1")
        sut.write(.task, "task 2")
        sut.write(.warning, "warning")
        sut.write(.result, "result")
        sut.write(.error, "error")
        sut.write(.undefined, "undefined")

        // NOTE: task 2 appear in result is because of "warning"
        #expect(collector == ["task 2", "warning", "result", "error"])
    }

    @Test func printOnlyTasksWithError() throws { // quieter
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

        #expect(collector == ["result", "error"])
    }

    @Test func printTestResultTooIfIsCIAndQuiet() throws { // on quiet/quiter , print test task too
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: true) { content in
            collector.append(content)
        }

        sut.write(.warning, "warning")
        sut.write(.undefined, "undefined")
        sut.write(.test, "test started")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        #expect(collector == ["warning", "test started", "test completed", "result"])
    }

    @Test func printTestResultTooIfIsCIAndQuieter() throws { // on quiet/quiter , print test task too
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: true, isCI: true) { content in
            collector.append(content)
        }

        sut.write(.error, "error")
        sut.write(.warning, "warning")
        sut.write(.test, "test started")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        #expect(collector == ["error", "test started", "test completed", "result"])

        collector.removeAll()

        sut.write(.warning, "warning")
        sut.write(.test, "test started")
        sut.write(.error, "error")
        sut.write(.test, "test completed")
        sut.write(.result, "result")

        #expect(collector == ["test started", "error", "test completed", "result"])
    }

    func testQuieterAfterErrorSwitchesToQuieterModeAfterFirstError() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: false, quieter: false, quieterAfterError: true, isCI: false) { content in
            collector.append(content)
        }

        // Before error, everything should be printed
        sut.write(.task, "task 1")
        sut.write(.warning, "warning 1")
        sut.write(.result, "result 1")

        XCTAssertEqual(collector, ["task 1", "warning 1", "result 1"])

        // Encounter an error
        sut.write(.error, "error 1")

        XCTAssertEqual(collector, ["task 1", "warning 1", "result 1", "error 1"])

        collector.removeAll()

        // After error, should behave like quieter mode
        sut.write(.task, "task 2")
        sut.write(.warning, "warning 2") // Should be suppressed
        sut.write(.error, "error 2") // Errors should still show (with task 2 banner)
        sut.write(.result, "result 2") // Results should still show
        sut.write(.undefined, "undefined") // Should be suppressed

        // Note: task 2 appears because it's the banner for error 2
        XCTAssertEqual(collector, ["task 2", "error 2", "result 2"])
    }

    func testQuieterAfterErrorDoesNotAffectNormalQuietMode() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, quieterAfterError: true, isCI: false) { content in
            collector.append(content)
        }

        // Should behave like quiet mode even before error
        sut.write(.task, "task 1")
        sut.write(.warning, "warning 1")
        sut.write(.result, "result 1")

        XCTAssertEqual(collector, ["task 1", "warning 1", "result 1"])

        // After error, should still behave like quieter mode
        sut.write(.error, "error 1")

        collector.removeAll()

        sut.write(.task, "task 2")
        sut.write(.warning, "warning 2") // Should be suppressed after error
        sut.write(.error, "error 2")
        sut.write(.result, "result 2")

        // Note: task 2 appears because it's the banner for error 2
        XCTAssertEqual(collector, ["task 2", "error 2", "result 2"])
    }
}
