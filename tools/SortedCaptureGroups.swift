#if os(macOS)
import Foundation

let fileURL = URL(fileURLWithPath: "./Sources/XcbeautifyLib/CaptureGroups.swift")
let content = try! String(contentsOf: fileURL, encoding: .utf8)

let lines = content
    .split(whereSeparator: \.isNewline)
    .compactMap { line -> String? in
        guard line.starts(with: "struct") else { return nil }
        return line.lowercased()
    }

if lines == lines.sorted() {
    exit(EXIT_SUCCESS)
} else {
    print("Found unsorted CaptureGroup(s)")
    exit(EXIT_FAILURE)
}
#endif
