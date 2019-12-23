import Guaka
import XcbeautifyLib

var rootCommand = Command(
    usage: "xcbeautify",
    configuration: configuration,
    run: execute
)

private func configuration(command: Command) {
    command.add(flags: [
        .init(shortName: "q",
              longName: "quiet",
              value: false,
              description: "Only print tasks that have warnings or errors.",
              inheritable: true)
        ])

    command.add(flags: [
        .init(shortName: "v",
              longName: "version",
              value: false,
              description: "Prints the version",
              inheritable: true)
        ])

    command.add(flags: [
        .init(shortName: "V",
              longName: "verbose",
              value: 2,
              description: "Set verbosity level. 1 for least verbose and 3 for most verbose. Default verbosity is 2.",
              inheritable: true)
        ])

    command.inheritablePreRun = { flags, args in
        if let versionFlag = flags.getBool(name: "version"), versionFlag == true {
            print(version)
            return false
        }

        return true
    }

    command.example = """
      $ xcodebuild test -project MyApp.xcodeproj -scheme MyApp -destination 'platform=iOS Simulator,OS=12.0,name=iPhone X' | xcbeautify
    """
}

private func execute(flags: Flags, args: [String]) {
    let parser = Parser()
    let quiet = flags.getBool(name: "quiet") == true
    let verbose = flags.getInt(name: "verbose")
    var lastFormatted: String? = nil

    while let line = readLine() {
        guard let formatted = parser.parse(line: line) else { continue }

        if !quiet && verbose == 3 {
            print(formatted)
            continue
        }
        else if !quiet && verbose == 2 {
            switch parser.outputType {
                case OutputType.detail:
                    continue
                default:
                    print(formatted)
                    continue
            }
        }
        else if verbose == 1 {
            switch parser.outputType {
                case OutputType.warning, OutputType.error:
                    if let last = lastFormatted {
                        print(last)
                        lastFormatted = nil
                    }
                    print(formatted)
                case OutputType.result:
                    print(formatted)
                default:
                    lastFormatted = formatted
            }
        }
    }

    if let summary = parser.summary {
        print(summary.format())
    }
}
