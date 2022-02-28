import Foundation

class Regex {
    let pattern: Pattern

    private lazy var matcher: NSRegularExpression? = {
        return try? NSRegularExpression(pattern: "^" + pattern.rawValue, options: [.caseInsensitive])
    }()

    init(pattern: Pattern) {
        self.pattern = pattern
    }

    func match(string: String) -> Bool {
        let fullRange = NSRange(string.startIndex..., in: string)
        return matcher?.rangeOfFirstMatch(in: string, range: fullRange).location != NSNotFound
    }
}
