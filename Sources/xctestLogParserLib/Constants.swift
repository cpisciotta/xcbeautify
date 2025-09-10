/// Specifies the xcodebuild console output type.
/// As an example, a compiler warning, a compiler error, a test case, etc.
public enum OutputType {
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

public enum Architecture: String {
    case arm64
    case arm64_32
    case armv7k
    case i386
    case x86_64
}
