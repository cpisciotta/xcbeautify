import Foundation

package final class Formatter {
    private let colored: Bool
    private let renderer: any OutputRendering

    package init(
        colored: Bool = true,
        renderer: Renderer,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored, additionalLines: additionalLines)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer(colored: colored, additionalLines: additionalLines)
        case .teamcity:
            self.renderer = TeamCityRenderer(colored: colored, additionalLines: additionalLines)
        }
    }
}
