import Foundation

class Formatter {

    private let colored: Bool
    private let renderer: OutputRendering
    private let additionalLines: () -> String?
    private(set) var preserveUnbeautifiedLines = false

    init(
        colored: Bool = true,
        renderer: Renderer,
        preserveUnbeautifiedLines: Bool = false,
        additionalLines: @escaping () -> (String?)
    ) {
        self.colored = colored

        switch renderer {
        case .terminal:
            self.renderer = TerminalRenderer(colored: colored, additionalLines: additionalLines)
        case .gitHubActions:
            self.renderer = GitHubActionsRenderer(additionalLines: additionalLines)
        case .teamcity:
            self.renderer = TeamCityRenderer(colored: colored, additionalLines: additionalLines)
        }

        self.preserveUnbeautifiedLines = preserveUnbeautifiedLines
        self.additionalLines = additionalLines
    }

    func format(captureGroup: CaptureGroup) -> String? {
        renderer.beautify(group: captureGroup)
    }
}
