#if os(macOS)
import Foundation

private func checkCaptureGroups() -> Bool {
    let fileURL = URL(fileURLWithPath: "./Sources/XcbeautifyLib/CaptureGroups.swift")
    let content = try! String(contentsOf: fileURL, encoding: .utf8)

    let lines = content
        .split(whereSeparator: \.isNewline)
        .compactMap { line -> String? in
            guard line.starts(with: "struct") else { return nil }
            return line.lowercased()
        }

    return lines == lines.sorted()

}

private func checkParserRegistration() -> Bool {
    let fileURL = URL(fileURLWithPath: "./Sources/XcbeautifyLib/Parser.swift")
    let content = try! String(contentsOf: fileURL, encoding: .utf8)

    let lines = content
        .split(whereSeparator: \.isNewline)

    let startIndex = lines.firstIndex { $0.contains("// START SORT") }!
    let endIndex = lines.firstIndex { $0.contains("// END SORT") }!

    let filteredLines = Array(lines[(startIndex + 1)..<endIndex])
        .map { $0.lowercased() }

    return filteredLines == filteredLines.sorted()
}

var unsorted = false

if !checkCaptureGroups() {
    print("Found unsorted CaptureGroup(s) in CaptureGroups.swift.")
    unsorted = true
}

if !checkParserRegistration() {
    print("Found unsorted CaptureGroup(s) in Parser.swift.")
    unsorted = true
}

if unsorted {
    exit(EXIT_FAILURE)
} else {
    exit(EXIT_SUCCESS)
}
#endif
