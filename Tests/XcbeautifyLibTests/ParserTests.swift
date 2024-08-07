//
//  ParserTests.swift
//  
//
//  Created by Charles Pisciotta on 8/6/24.
//

import XCTest
@testable import XcbeautifyLib

final class ParserTests: XCTestCase {

    private var parser: Parser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.parser = Parser()
    }

    override func tearDownWithError() throws {
        self.parser = nil
        try super.tearDownWithError()
    }

    func testMatchCopyFilesMatchingSourceAndDestinationFilenames() throws {
        let input = #"Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/path/to/some/file.swift")
        XCTAssertEqual(captureGroup.firstFilename, "file.swift")
        XCTAssertEqual(captureGroup.secondFilePath, "/path/to/some/other/file.swift")
        XCTAssertEqual(captureGroup.secondFilename, "file.swift")
        XCTAssertEqual(captureGroup.target, "Target")
    }

    func testMatchCopyFilesDifferentSourceAndDestinationFilenames() throws {
        let input = #"Copy /path/to/some/first-file.swift /path/to/some/other/second-file.swift (in target 'Target' from project 'Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/path/to/some/first-file.swift")
        XCTAssertEqual(captureGroup.firstFilename, "first-file.swift")
        XCTAssertEqual(captureGroup.secondFilePath, "/path/to/some/other/second-file.swift")
        XCTAssertEqual(captureGroup.secondFilename, "second-file.swift")
        XCTAssertEqual(captureGroup.target, "Target")
    }

}
