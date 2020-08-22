enum TestStatus: String {
    case pass = "✔"
    case fail = "✖"
    case pending = "⧖"
    case completion = "▸"
    case measure = "◷"
}

enum Symbol: String {
    case error = "❌"
    case asciiError = "[x]"

    case warning = "⚠️"
    case asciiWarning = "[!]"
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
