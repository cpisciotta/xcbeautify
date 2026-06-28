//
// XCBeautifier.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

/// The result of processing a single log line through `XCBeautifier`.
package struct FormattingResult {
    /// The matched capture group, or `nil` when the line was unrecognized but preserved.
    package let captureGroup: (any CaptureGroup)?
    /// The output type used for routing (e.g. through `OutputHandler`).
    package let outputType: OutputType
    /// The formatted string, or `nil` when the renderer has no output for a recognized group.
    /// For preserved-unbeautified lines this is the original raw line.
    package let formatted: String?
}

/// The single type responsible for formatting output.
public struct XCBeautifier {
    private let parser = Parser()
    private let formatter: Formatter
    private let preserveUnbeautifiedLines: Bool
    private let skippedCaptureGroups: Set<String>

    /// Creates an `XCBeautifier` instance.
    /// - Parameters:
    ///   - colored: Indicates if `XCBeautifier` should color its formatted output.
    ///   - renderer: Indicates the context, such as Terminal and GitHub Actions, where `XCBeautifier` is used.
    ///   - preserveUnbeautifiedLines: Indicates if `XCBeautifier` should preserve unrecognized output.
    ///   - skippedCaptureGroups: A set of capture group identifiers whose formatting should be skipped. Matched lines are emitted as plain text instead.
    ///   - additionalLines: A closure that provides `XCBeautifier` the subsequent console output when needed (i.e. multi-line output).
    public init(
        colored: Bool,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool,
        skippedCaptureGroups: Set<String> = [],
        additionalLines: @escaping () -> String?
    ) {
        formatter = Formatter(
            colored: colored,
            renderer: renderer,
            additionalLines: additionalLines
        )

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.skippedCaptureGroups = skippedCaptureGroups
    }

    /// Formats `xcodebuild` console output.
    /// - Parameter line: The raw `xcodebuild` output.
    /// - Returns: The formatted output. Returns `nil` if the input is unrecognized, unless `preserveUnbeautifiedLines` is `true`.
    public func format(line: String) -> String? {
        process(line: line)?.formatted
    }

    /// Processes a single raw log line and returns a `FormattingResult` for routing and reporting.
    /// - Parameter line: The raw `xcodebuild` or `swift` output line.
    /// - Returns: A `FormattingResult` when the line is recognized or `preserveUnbeautifiedLines` is `true`; `nil` otherwise.
    package func process(line: String) -> FormattingResult? {
        guard let captureGroup = parser.parse(line: line) else {
            guard preserveUnbeautifiedLines else { return nil }
            return FormattingResult(captureGroup: nil, outputType: .undefined, formatted: line)
        }

        if skippedCaptureGroups.contains(captureGroup.identifier) {
            return FormattingResult(
                captureGroup: captureGroup,
                outputType: captureGroup.outputType,
                formatted: line
            )
        }

        return FormattingResult(
            captureGroup: captureGroup,
            outputType: captureGroup.outputType,
            formatted: formatter.format(captureGroup: captureGroup)
        )
    }
}
