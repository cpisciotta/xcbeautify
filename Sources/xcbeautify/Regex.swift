import Foundation

struct Regex {
    let pattern: Pattern

    private var matcher: NSRegularExpression? {
        return try? NSRegularExpression(pattern: pattern.rawValue)
    }

    init(pattern: Pattern) {
        self.pattern = pattern
    }

    func match(string: String) -> Bool {
        return matcher?.numberOfMatches(in: string, range: NSRange(location: 0, length: string.count)) != 0
    }
}
