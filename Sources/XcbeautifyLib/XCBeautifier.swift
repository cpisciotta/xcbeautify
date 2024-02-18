import Foundation

public struct XCBeautifier {
    private let parser: Parser

    public init(
        colored: Bool,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool,
        additionalLines: @escaping () -> String?
    ) {
        parser = Parser(
            colored: colored,
            renderer: renderer,
            preserveUnbeautifiedLines: preserveUnbeautifiedLines,
            additionalLines: additionalLines
        )
    }

    public func format(line: String) -> String? {
        parser.parse(line: line)
    }
}
