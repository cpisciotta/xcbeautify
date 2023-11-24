import Foundation

public struct XCFormatter {
    private let renderer: OutputRendering
    private let colored: Bool

    public init(
        renderer: Renderer,
        colored: Bool
    ) {
        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }
        self.colored = colored
    }

    public func beautify(captureGroup: CaptureGroup) -> String? {
        return nil
    }
}
