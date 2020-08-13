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
        .init(longName: "quieter",
              value: false,
              description: "Only print tasks that have errors.",
              inheritable: true)
    ])
    
    command.add(flags: [
        .init(longName: "isCI",
              value: false,
              description: "Print test result too under quiet/quiter flag")
    ])
    
    command.add(flags: [
        .init(shortName: "v",
              longName: "version",
              value: false,
              description: "Prints the version",
              inheritable: true)
    ])
    
    command.inheritablePreRun = { flags, args in
        if let versionFlag = flags.getBool(name: "version"), versionFlag == true {
            print("Version: \(version)")
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
    let quieter = flags.getBool(name: "quieter") == true
    let isCI = flags.getBool(name: "isCI") == true
    let output = OutputHandler(quiet: quiet, quieter: quieter, isCI: isCI, { print($0) })
    
    while let line = readLine() {
        guard let formatted = parser.parse(line: line) else { continue }
        output.write(parser.outputType, formatted)
    }
    
    if let summary = parser.summary {
        print(summary.format())
    }
}
