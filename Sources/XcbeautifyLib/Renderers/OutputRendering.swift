import Foundation

protocol OutputRendering {
    func beautify(line: String, pattern: Pattern, additionalLines: @escaping () -> (String?)) -> String?
}
