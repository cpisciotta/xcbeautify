//
// CaptureGroupTests.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import XCTest
@testable import XcbeautifyLib

final class CaptureGroupTests: XCTestCase {

    func testMatchSwiftTestingIssueArgument1() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "@Test(arguments: []) func f(f: () -> String) {}", expectedTypeName → "(() -> String).self", otherCode → nil at TestDeclarationMacroTests.swift:363:7: Expectation failed: !((output → "func f(f: () -> String) {}"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument2() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testMatchSwiftTestingIssueArgument3() {
        let input = #"􀢄  Test "Different kinds of functions are handled correctly" recorded an issue with 3 arguments input → "struct S_NAME {"#
        XCTAssertNil(SwiftTestingIssueCaptureGroup.regex.captureGroups(for: input))
        XCTAssertNotNil(SwiftTestingIssueArgumentCaptureGroup.regex.captureGroups(for: input))
    }

    func testForceFailure() {
        XCTAssertTrue(false, "True is never false.")
    }
}
