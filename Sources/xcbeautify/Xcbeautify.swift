import ArgumentParser
import Foundation
import XcbeautifyLib


struct Xcbeautify: ParsableCommand {
    enum Report: String, ExpressibleByArgument {
        case junit
    }

    @Flag(name: [.short, .long], help: "Only print tasks that have warnings or errors.")
    var quiet = false
    
    @Flag(name: [.long, .customLong("qq", withSingleDash: true)], help: "Only print tasks that have errors.")
    var quieter = false
    
    @Flag(name: [.long], help: "Preserves unbeautified output lines.")
    var preserveUnbeautified = false

    @Flag(name: .long, help: "Print test result too under quiet/quieter flag.")
    var isCi = false

    @Flag(name: .long, help: "Disable the colored output")
    var disableColoredOutput = (ProcessInfo.processInfo.environment["NO_COLOR"] != nil)

    @Option(help: "Generate the specified reports")
    var report: [Report] = []

    @Option(help: "The path to use when generating reports")
    var reportPath = "build/reports"

    @Option(help: "The name of JUnit report file name")
    var junitReportFilename = "junit.xml"

    func run() throws {
        let output = OutputHandler(quiet: quiet, quieter: quieter, isCI: isCi, { print($0) })
        let junitReporter = JunitReporter()

        func readLine() -> String? {
            let line = Swift.readLine()
            if let line = line {
                if report.contains(.junit) {
                    junitReporter.add(line: line)
                }
            }
            return line
        }
        
        let parser = Parser(
            colored: !disableColoredOutput,
            preserveUnbeautifiedLines: preserveUnbeautified,
            additionalLines: { readLine() }
        )

        while let line = readLine() {
            guard let formatted = parser.parse(line: line) else { continue }
            output.write(parser.outputType, formatted)
        }
        
        if let summary = parser.summary {
            print(summary.format())
        }

        if !report.isEmpty {
            let outputPath = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
                .appendingPathComponent(reportPath)
            try FileManager.default.createDirectory(at: outputPath, withIntermediateDirectories: true)

            for reportType in Set(report) {
                switch reportType {
                case .junit:
                    let junitOutputPath = outputPath.appendingPathComponent(junitReportFilename)
                    let report = try junitReporter.generateReport()
                    try report.write(to: junitOutputPath)
                }
            }
        }
    }
}
