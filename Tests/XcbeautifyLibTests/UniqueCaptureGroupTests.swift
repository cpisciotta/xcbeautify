//
//  UniqueCaptureGroupTests.swift
//  xcbeautify
//
//  Created by Charles Pisciotta on 2/9/25.
//

import XCTest
@testable import XcbeautifyLib

final class UniqueCaptureGroupTests: XCTestCase {
    private let captureGroupTypes = Parser().__for_test__captureGroupTypes()

    #if os(macOS)
    func testUniqueCaptureGroupRegistrations() {
        var seen = [any CaptureGroup.Type]()
        var duplicates = [any CaptureGroup.Type]()

        for type in captureGroupTypes {
            if seen.contains(where: { $0 == type }) {
                duplicates.append(type)
            } else {
                seen.append(type)
            }
        }

        XCTAssertEqual(
            duplicates.count,
            0,
            "Found the following duplicate CaptureGroup registration(s): \(ListFormatter.localizedString(byJoining: duplicates.map(String.init(describing:))))"
        )
    }
    #endif
}
