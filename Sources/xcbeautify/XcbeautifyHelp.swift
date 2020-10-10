import ArgumentParser

extension Xcbeautify {
	static var additionalHelp: String { """
	Usage:
	  $ xcodebuild [options] | xcbeautify

	"""
	}
	static var configuration: CommandConfiguration = {
		return CommandConfiguration(discussion: additionalHelp,
													 version: version)
	}()
}
