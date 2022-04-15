import Foundation

protocol Matching {
    func match(string: String) -> Bool
    func capturedGroups(string: String) -> [String]
}
