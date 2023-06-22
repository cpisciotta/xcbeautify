import Foundation

struct GitHubRenderer: OutputRendering {
    func beautify(
        line: String,
        pattern: Pattern,
        outputType: OutputType,
        additionalLines: @escaping () -> (String?)
    ) -> String? {
        return nil
    }
}
