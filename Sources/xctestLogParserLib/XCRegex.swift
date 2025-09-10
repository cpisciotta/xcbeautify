//
// XCRegex.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

// `NSRegularExpression` is marked as `@unchecked Sendable`.
// Match the definition here.
public final class XCRegex: @unchecked Sendable {
    private let pattern: String

    private lazy var regex: NSRegularExpression? = {
        let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
        assert(regex != nil)
        return regex
    }()

    init(pattern: String) {
        self.pattern = pattern
    }

    func captureGroups(for line: String) -> [String]? {
        assert(regex != nil)

        guard let match = regex?.firstMatch(in: line, options: .anchored, range: NSRange(location: 0, length: line.utf16.count)) else {
            return nil
        }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return [] }

        return (1...lastRangeIndex).compactMap { index in
            let capturedGroupIndex = match.range(at: index)
            return line.substring(with: capturedGroupIndex)
        }
    }
}
