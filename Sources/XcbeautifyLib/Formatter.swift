import Foundation

package class Formatter {

    private let colored: Bool
    private let renderer: OutputRendering
    private let additionalLines: () -> String?

    package init(
        colored: Bool = true,
        renderer: Renderer,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }

        self.additionalLines = additionalLines
    }

    package func format(captureGroup: CaptureGroup) -> String? {
        return renderer.beautify(
            group: captureGroup,
            additionalLines: additionalLines
        )
    }
}
