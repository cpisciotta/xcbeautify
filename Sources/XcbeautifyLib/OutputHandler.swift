//
// OutputHandler.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

/// Filters formatted output by `OutputType` only if `quiet` or `quieter` are specified.
package class OutputHandler {
    let quiet: Bool
    let quieter: Bool
    let quieterAfterError: Bool
    let isCI: Bool
    let writer: (String) -> Void

    /// In quiet mode, lastFormatted will record last output and whether it will be
    /// printed is determined by the current output type. In this way, if we encounter
    /// warnings or errors, we get a chance to print last output as their banner. So now
    /// the output is in following form:
    /// [Target] Doing Something
    /// warnings or errors
    ///
    /// Ref: https://github.com/cpisciotta/xcbeautify/pull/15
    private var lastFormatted: String?

    /// Tracks if an error has been encountered when using quieterAfterError mode
    private var errorEncountered = false

    package init(quiet: Bool, quieter: Bool, quieterAfterError: Bool = false, isCI: Bool = false, _ writer: @escaping (String) -> Void) {
        self.quiet = quiet
        self.quieter = quieter
        self.quieterAfterError = quieterAfterError
        self.isCI = isCI
        self.writer = writer
    }

    package func write(_ type: OutputType, _ content: String?) {
        guard let content else { return }

        // Determine effective quiet/quieter mode
        let effectiveQuiet = quiet || (quieterAfterError && errorEncountered)
        let effectiveQuieter = quieter || (quieterAfterError && errorEncountered)

        if !effectiveQuiet, !effectiveQuieter {
            writer(content)
            // Check after writing to activate quieter mode for next output
            if quieterAfterError, type == .error {
                errorEncountered = true
            }
            return
        }

        switch type {
        case OutputType.warning:
            if effectiveQuieter { return }
            fallthrough
        case OutputType.error:
            if let last = lastFormatted {
                writer(last)
                lastFormatted = nil
            }
            writer(content)
            // Check after writing to activate quieter mode for next output
            if quieterAfterError, type == .error {
                errorEncountered = true
            }
        case OutputType.issue:
            writer(content)
        case OutputType.result:
            writer(content)
        case OutputType.testCase:
            if isCI {
                writer(content)
            }
        case OutputType.nonContextualError:
            writer(content)
        case OutputType.test:
            if isCI {
                writer(content)
                lastFormatted = nil
            } else {
                fallthrough
            }
        default:
            lastFormatted = content
        }
    }
}
