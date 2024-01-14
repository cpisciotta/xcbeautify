import Foundation

package class Formatter {

    private let colored: Bool
    private let renderer: OutputRendering
    private let additionalLines: () -> String?
    package var preserveUnbeautifiedLines = false

    package init(
        colored: Bool = true,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool = false,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer()
        }

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.additionalLines = additionalLines
    }

}
