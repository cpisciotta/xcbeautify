#if os(macOS)
import Foundation

let fileURL = URL(fileURLWithPath: "./Sources/XcbeautifyLib/Parser.swift")
let content = try! String(contentsOf: fileURL, encoding: .utf8)

let lines = content
    .split(whereSeparator: \.isNewline)

let startIndex = lines.firstIndex { $0.contains("// START SORT") }!
let endIndex = lines.firstIndex { $0.contains("// END SORT") }!

let filteredLines = Array(lines[(startIndex + 1)..<endIndex])
    .map { $0.lowercased() }

if filteredLines == filteredLines.sorted() {
    exit(EXIT_SUCCESS)
} else {
    print("Found unsorted CaptureGroup(s)")
    exit(EXIT_FAILURE)
}
#endif
