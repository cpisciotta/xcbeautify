import ArgumentParser

extension Xcbeautify {
    private static let abstract = "Format the output of `xcodebuild` and `swift`"

    private static let additionalHelp = """
        EXAMPLE: xcodebuild test -project MyApp.xcodeproj -scheme MyApp -destination 'platform=iOS Simulator,OS=12.0,name=iPhone X' | xcbeautify
    """

    static let configuration = CommandConfiguration(
        abstract: abstract,
        discussion: additionalHelp,
        version: version
    )
}
