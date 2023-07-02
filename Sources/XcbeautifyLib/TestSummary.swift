public struct TestSummary {
    let testsCount: Int
    let skippedCount: Int
    let failuresCount: Int
    let unexpectedCount: Int
    let time: Double
    let colored: Bool

    static func += (_left: inout TestSummary?, right: TestSummary) {
        guard let left = _left else {
            _left = right
            return
        }

        _left = TestSummary(
            testsCount: left.testsCount + right.testsCount,
            skippedCount: left.skippedCount + right.skippedCount,
            failuresCount: left.failuresCount + right.failuresCount,
            unexpectedCount: left.unexpectedCount + right.unexpectedCount,
            time: left.time + right.time,
            colored: left.colored || right.colored
        )
    }
}

extension TestSummary {
    func isSuccess() -> Bool {
        return failuresCount == 0
    }

    var description: String {
        let timeFormatted = String(format: "%.3f", time)
        return "\(failuresCount) failed, \(skippedCount) skipped, \(testsCount) total (\(timeFormatted) seconds)"
    }

    public func format() -> String {
        if isSuccess() {
            return colored ? "Tests Passed: \(description)".s.Bold.f.Green : "Tests Passed: \(description)"
        } else {
            return colored ? "Tests Failed: \(description)".s.Bold.f.Red : "Tests Failed: \(description)"
        }
    }
}
