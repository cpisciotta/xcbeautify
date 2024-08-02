import Foundation

public struct XCBeautifier {
    private let parser = Parser()
    private let formatter: Formatter
    private let preserveUnbeautifiedLines: Bool

    public init(
        colored: Bool,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool,
        additionalLines: @escaping () -> String?
    ) {
        formatter = Formatter(
            colored: colored,
            renderer: renderer,
            additionalLines: additionalLines
        )

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
    }

    public func format(line: String) -> String? {
        guard let captureGroup = parser.parse(line: line) else {
            if preserveUnbeautifiedLines {
                return line
            } else {
                return nil
            }
        }

        return formatter.format(captureGroup: captureGroup)
    }
}
