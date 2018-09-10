import Guaka

struct XcbeautifyHelp: HelpGenerator {
    let commandHelp: CommandHelp

    init(commandHelp: CommandHelp) {
        self.commandHelp = commandHelp
    }

    var usageSection: String? {
        return """
        Usage:
          $ xcodebuild [options] | xcbeautify


        """
    }

    var informationSection: String? {
        return nil
    }
}
