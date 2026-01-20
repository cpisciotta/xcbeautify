//
// XCBeautifier.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation
import XcLogParserLib

/// The single type responsible for formatting output.
public struct XCBeautifier {
    private let parser = Parser()
    private let formatter: Formatter
    private let preserveUnbeautifiedLines: Bool

    /// Creates an `XCBeautifier` instance.
    /// - Parameters:
    ///   - colored: Indicates if `XCBeautifier` should color its formatted output.
    ///   - renderer: Indicates the context, such as Terminal and GitHub Actions, where `XCBeautifier` is used.
    ///   - preserveUnbeautifiedLines: Indicates if `XCBeautifier` should preserve unrecognized output.
    ///   - additionalLines: A closure that provides `XCBeautifier` the subsequent console output when needed (i.e. multi-line output).
    public init(
        colored: Bool,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool,
        additionalLines: @escaping () -> String?
    ) {
        formatter = Formatter(
            colored: colored,
            renderer: renderer,
            additionalLines: additionalLines
        )

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
    }

    /// Formats `xcodebuild` console output.
    /// - Parameter line: The raw `xcodebuild` output.
    /// - Returns: The formatted output. Returns `nil` if the input is unrecognized, unless `preserveUnbeautifiedLines` is `true`.
    public func format(line: String) -> String? {
        guard let captureGroup = parser.parse(line: line) else {
            if preserveUnbeautifiedLines {
                return line
            } else {
                return nil
            }
        }

        return formatter.format(captureGroup: captureGroup)
    }
}
