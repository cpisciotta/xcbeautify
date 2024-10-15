enum Format {
    static let indent = "    "
}

enum TestStatus {
    static let pass = "✔"
    static let fail = "✖"
    static let pending = "⧖"
    static let completion = "▸"
    static let measure = "◷"
    static let skipped = "⊘"
}

enum Symbol {
    static let error = "❌"
    static let asciiError = "[x]"

    static let warning = "⚠️"
    static let asciiWarning = "[!]"
}

/// Specifies the xcodebuild console output type.
/// As an example, a compiler warning, a compiler error, a test case, etc.
package enum OutputType {
    case undefined
    case task
    case test
    case testCase
    case nonContextualError
    case warning
    case error
    case result
    case issue
}

/// Maps to an `OutputRendering` type that formats raw `xcodebuild` output.
public enum Renderer: String {
    /// The default `OutputRendering` type for local and general use. Maps to `TerminalRenderer`.
    case terminal

    /// Formats output suitable for GitHub Actions annotations. Maps to `GitHubRenderer`.
    case gitHubActions = "github-actions"

    /// Formats output suitable for TeamCity service messages. Maps to `TeamCityRenderer`.
    case teamcity
}
