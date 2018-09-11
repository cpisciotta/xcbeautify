import Guaka
import XcbeautifyLib

var rootCommand = Command(
    usage: "xcbeautify",
    configuration: configuration,
    run: execute
)

private func configuration(command: Command) {
    command.add(flags: [
        .init(shortName: "v",
              longName: "version",
              value: false,
              description: "Prints the version",
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
    while let line = readLine() {
        guard let formatted = parser.parse(line: line) else { continue }
        print(formatted)
    }

    if let summary = parser.summary {
        print(summary.format())
    }
}
