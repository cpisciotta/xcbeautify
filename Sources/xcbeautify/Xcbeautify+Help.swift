import ArgumentParser

extension Xcbeautify {
	private static var abstract: String = "Format the output of `xcodebuild` and `swift`"
	private static var additionalHelp: String = """
	EXAMPLE: xcodebuild test -project MyApp.xcodeproj -scheme MyApp -destination 'platform=iOS Simulator,OS=12.0,name=iPhone X' | xcbeautify
	"""
	static var configuration: CommandConfiguration = {
		return CommandConfiguration(abstract: abstract,
											 discussion: additionalHelp,
											 version: version)
	}()
}
