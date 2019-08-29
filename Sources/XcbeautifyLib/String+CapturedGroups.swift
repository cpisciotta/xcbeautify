import Foundation

extension String {
    func capturedGroups(with pattern: Pattern) -> [String] {
        var results = [String]()

        var regex: NSRegularExpression
        do {
            regex = try NSRegularExpression(pattern: pattern.rawValue, options: [.caseInsensitive])
        } catch {
            return results
        }

        let matches = regex.matches(in: self, range: NSRange(location:0, length: self.utf16.count))

        guard let match = matches.first else { return results }

        let lastRangeIndex = match.numberOfRanges - 1
        guard lastRangeIndex >= 1 else { return results }

        for i in 1...lastRangeIndex {
            let capturedGroupIndex = match.range(at: i)
            guard let matchedString = substring(with: capturedGroupIndex) else { continue }
            results.append(matchedString)
        }

        return results
    }
}
