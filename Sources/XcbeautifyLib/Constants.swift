enum Format {
    static let indent = "    "
}

enum TestStatus {
    static let pass = "✔"
    static let fail = "✖"
    static let pending = "⧖"
    static let completion = "▸"
    static let measure = "◷"
}

enum Symbol {
    static let error = "❌"
    static let asciiError = "[x]"

    static let warning = "⚠️"
    static let asciiWarning = "[!]"
}

public enum OutputType {
    case undefined
    case task
    case test
    case warning
    case error
    case result
}

extension OutputType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .undefined:
            return "undefined"
        case .task:
            return "task"
        case .test:
            return "test"
        case .warning:
            return "warning"
        case .error:
            return "error"
        case .result:
            return "result"
        }
    }
}

/// Maps to an `OutputRendering` type that formats raw `xcodebuild` output.
public enum Renderer: String {
    /// The default `OutputRendering` type for local and general use. Maps to `TerminalRenderer`.
    case terminal

    /// Formats output suitable for GitHub Actions annotations. Maps to `GitHubRenderer`.
    case gitHubActions = "github-actions"
    
}
