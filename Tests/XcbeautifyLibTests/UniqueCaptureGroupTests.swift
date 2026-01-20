//
// UniqueCaptureGroupTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import Testing
@testable import XcbeautifyLib
import XcLogParserLib

@Suite struct UniqueCaptureGroupTests {
    private let captureGroupTypes = Parser().__for_test__captureGroupTypes()

    #if os(macOS)
    @Test func uniqueCaptureGroupRegistrations() {
        var seen = [any CaptureGroup.Type]()
        var duplicates = [any CaptureGroup.Type]()

        for type in captureGroupTypes {
            if seen.contains(where: { $0 == type }) {
                duplicates.append(type)
            } else {
                seen.append(type)
            }
        }

        #expect(
            duplicates.isEmpty,
            "Found the following duplicate CaptureGroup registration(s): \(ListFormatter.localizedString(byJoining: duplicates.map(String.init(describing:))))"
        )
    }
    #endif

    // TODO: Drop this macOS platform gating
    #if os(macOS)
    @Test func uniqueCaptureGroups() throws {
        let url = try #require(Bundle.module.url(forResource: "clean_build_xcode_15_1", withExtension: "txt"))

        var buildLog: [String] = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                #expect(type.init(groups: groups) != nil)
                return true
            }

            #expect(
                capturedTypes.count <= 1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    @Test func uniqueFileMissingError() {
        let line = "<unknown>:0: error: no such file or directory: '/path/file.swift'"

        let capturedTypes = captureGroupTypes.filter { type in
            guard let groups = type.regex.captureGroups(for: line) else { return false }
            #expect(type.init(groups: groups) != nil)
            return true
        }

        #expect(
            capturedTypes.count == 1,
            """
            Failed to uniquely parse xcodebuild output.
            Line: \(line)
            Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
            """
        )
    }

    @Test func uniqueLDWarning() {
        let line = "ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"

        let capturedTypes = captureGroupTypes.filter { type in
            guard let groups = type.regex.captureGroups(for: line) else { return false }
            #expect(type.init(groups: groups) != nil)
            return true
        }

        #expect(
            capturedTypes.count == 1,
            """
            Failed to uniquely parse xcodebuild output.
            Line: \(line)
            Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
            """
        )
    }

    @Test func uniqueUIFailingTest() {
        let line = "    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>"

        let capturedTypes = captureGroupTypes.filter { type in
            guard let groups = type.regex.captureGroups(for: line) else { return false }
            #expect(type.init(groups: groups) != nil)
            return true
        }

        #expect(
            capturedTypes.count == 1,
            """
            Failed to uniquely parse xcodebuild output.
            Line: \(line)
            Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
            """
        )
    }

    @Test func uniqueXcodebuildError() {
        let line = #"xcodebuild: error: Existing file at -resultBundlePath "/output/file.xcresult""#

        let capturedTypes = captureGroupTypes.filter { type in
            guard let groups = type.regex.captureGroups(for: line) else { return false }
            #expect(type.init(groups: groups) != nil)
            return true
        }

        #expect(
            capturedTypes.count == 1,
            """
            Failed to uniquely parse xcodebuild output.
            Line: \(line)
            Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
            """
        )
    }

    @Test func uniqueTestCaptureGroups() throws {
        let url = try #require(Bundle.module.url(forResource: "TestLog", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                #expect(type.init(groups: groups) != nil)
                return true
            }

            #expect(
                capturedTypes.count <= 1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    @Test func uniqueSwiftTestingCaptureGroups() throws {
        let url = try #require(Bundle.module.url(forResource: "swift_test_log_macOS", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                #expect(type.init(groups: groups) != nil)
                return true
            }

            #expect(
                capturedTypes.count <= 1,
                """
                Failed to uniquely parse xcodebuild output.
                Line: \(line)
                Captured Types: \(ListFormatter.localizedString(byJoining: capturedTypes.map(String.init(describing:))))
                """
            )
        }
    }

    @Test func uniqueParallelTestCaptureGroups() throws {
        let url = try #require(Bundle.module.url(forResource: "ParallelTestLog", withExtension: "txt"))
        var buildLog: [String] = try String(contentsOf: url, encoding: .utf8)
            .components(separatedBy: .newlines)

        while !buildLog.isEmpty {
            let line = buildLog.removeFirst()

            let capturedTypes = captureGroupTypes.filter { type in
                guard let groups = type.regex.captureGroups(for: line) else { return false }
                #expect(type.init(groups: groups) != nil)
                return true
            }

            #expect(
                capturedTypes.count <= 1,
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
