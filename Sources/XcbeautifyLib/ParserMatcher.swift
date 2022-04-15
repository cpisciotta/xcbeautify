import Foundation

class ParserMatcher: Matching {    
    init() { }
    
    func match(string: String) -> Bool {
        return false
    }
    
    func capturedGroups(string: String) -> [String] {
        return []
    }
}
