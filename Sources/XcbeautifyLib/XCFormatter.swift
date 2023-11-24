import Foundation

public struct XCFormatter {
    private let renderer: OutputRendering
    private let colored: Bool
    private let additionalLines: () -> String?

    public init(
        renderer: Renderer,
        colored: Bool,
        additionalLines: @escaping () -> String?
    ) {
        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }
        self.colored = colored
        self.additionalLines = additionalLines
    }

    public func beautify(
        captureGroup: CaptureGroup,
        line: String
    ) -> String? {
        renderer.beautify(captureGroup: captureGroup, line: line, additionalLines: additionalLines)
    }
}
