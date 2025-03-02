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

    // TODO: Drop this macOS platform gating
    #if os(macOS)
    func testUniqueCaptureGroups() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "clean_build_xcode_15_1", withExtension: "txt"))

        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                XCTAssertNotNil(type.init(groups: groups))
                return true
            }

            XCTAssertLessThanOrEqual(
                capturedTypes.count,
                1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    func testUniqueFileMissingError() {
        let line = "<unknown>:0: error: no such file or directory: '/path/file.swift'"

        let capturedTypes = captureGroupTypes.filter { type in
            guard let groups = type.regex.captureGroups(for: line) else { return false }
            XCTAssertNotNil(type.init(groups: groups))
            return true
        }

        XCTAssertEqual(
            capturedTypes.count,
            1,
            """
            Failed to uniquely parse xcodebuild output.
            Line: \(line)
            Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
            """
        )
    }

    func testUniqueTestCaptureGroups() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "TestLog", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                XCTAssertNotNil(type.init(groups: groups))
                return true
            }

            XCTAssertLessThanOrEqual(
                capturedTypes.count,
                1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    func testUniqueSwiftTestingCaptureGroups() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "swift_test_log", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                XCTAssertNotNil(type.init(groups: groups))
                return true
            }

            XCTAssertLessThanOrEqual(
                capturedTypes.count,
                1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    func testUniqueParallelTestCaptureGroups() throws {
        let url = try XCTUnwrap(Bundle.module.url(forResource: "ParallelTestLog", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                XCTAssertNotNil(type.init(groups: groups))
                return true
            }

            XCTAssertLessThanOrEqual(
                capturedTypes.count,
                1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }
    #endif
}
