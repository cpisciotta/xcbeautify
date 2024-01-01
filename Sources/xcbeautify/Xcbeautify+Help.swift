import ArgumentParser

extension Xcbeautify {
    private static var abstract = "Format the output of `xcodebuild` and `swift`"
    private static var additionalHelp = """
    EXAMPLE: xcodebuild test -project MyApp.xcodeproj -scheme MyApp -destination 'platform=iOS Simulator,OS=12.0,name=iPhone X' | xcbeautify
    """
    static var configuration = CommandConfiguration(
        abstract: abstract,
        discussion: additionalHelp,
        version: version
    )
}
