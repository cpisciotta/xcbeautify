public struct TestSummary {
    let testsCount: Int
    let skippedCount: Int
    let failuresCount: Int
    let unexpectedCount: Int
    let time: Double
    let colored: Bool
    
    init(testsCount: Int, skippedCount: Int, failuresCount: Int, unexpectedCount: Int, time: Double, colored: Bool, testSummary: TestSummary?) {
        self.testsCount = testsCount + (testSummary?.testsCount ?? 0)
        self.skippedCount = skippedCount + (testSummary?.skippedCount ?? 0)
        self.failuresCount = failuresCount + (testSummary?.failuresCount ?? 0)
        self.unexpectedCount = unexpectedCount + (testSummary?.unexpectedCount ?? 0)
        self.time = time + (testSummary?.time ?? 0)
        self.colored = colored || (testSummary?.colored ?? false)
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
