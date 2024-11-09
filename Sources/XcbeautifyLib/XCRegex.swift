import Foundation

// `NSRegularExpression` is marked as `@unchecked Sendable`.
// Match the definition here.
package final class XCRegex: @unchecked Sendable {
    private let pattern: String

    private lazy var regex: NSRegularExpression? = {
        let regex = try? NSRegularExpression(pattern: "^" + pattern, options: [.caseInsensitive])
        assert(regex != nil)
        return regex
    }()

    init(pattern: String) {
        self.pattern = pattern
    }

    func match(string: String) -> Bool {
        let fullRange = NSRange(string.startIndex..., in: string)
        return regex?.rangeOfFirstMatch(in: string, range: fullRange).location != NSNotFound
    }

    func captureGroups(for line: String) -> [String] {
        let matches = regex?.matches(in: line, range: NSRange(location: 0, length: line.utf16.count))
        guard let match = matches?.first else { return [] }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return [] }

        return (1...lastRangeIndex).compactMap { index in
            let capturedGroupIndex = match.range(at: index)
            return line.substring(with: capturedGroupIndex)
        }
    }
}
