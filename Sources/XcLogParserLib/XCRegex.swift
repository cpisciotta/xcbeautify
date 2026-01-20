//
// XCRegex.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

package struct XCRegex: Sendable {
    private let regex: NSRegularExpression?

    private static func makeRegex(pattern: String) -> NSRegularExpression? {
        let regex = try? NSRegularExpression(pattern: pattern, options: [.anchorsMatchLines])
        assert(regex != nil)
        return regex
    }

    init(pattern: String) {
        regex = Self.makeRegex(pattern: pattern)
    }

    public func captureGroups(for line: String) -> [String]? {
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
