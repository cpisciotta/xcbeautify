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
    case warning
    case error
    case result
}
