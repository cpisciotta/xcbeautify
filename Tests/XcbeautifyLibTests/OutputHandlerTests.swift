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

    @Test func testCaseFilteredInQuietMode() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.testCase, "test case passed")
        sut.write(.testCase, "test case failed")
        sut.write(.result, "result")

        // In quiet mode without CI, .testCase is filtered out
        #expect(collector == ["result"])
    }

    @Test func testCaseShownInQuietModeOnCI() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: true) { content in
            collector.append(content)
        }

        sut.write(.testCase, "test case passed")
        sut.write(.testCase, "test case failed")
        sut.write(.result, "result")

        // In quiet mode with CI, .testCase is shown
        #expect(collector == ["test case passed", "test case failed", "result"])
    }

    @Test func errorAlwaysShownInQuietMode() throws {
        var collector: [String] = []
        let sut = OutputHandler(quiet: true, quieter: false, isCI: false) { content in
            collector.append(content)
        }

        sut.write(.error, "failed test error")
        sut.write(.result, "result")

        // .error is always shown, even in quiet mode without CI
        #expect(collector == ["failed test error", "result"])
    }
}
