struct TestSummary {
    let testsCount: String
    let failuresCount: String
    let unexpectedCount: String
    let time: String
}

extension TestSummary {
    func isSuccess() -> Bool {
        guard let failures = Int(failuresCount) else { return false }
        return failures == 0
    }

    var description: String {
        return "\(failuresCount) failed, \(testsCount) total (\(time) seconds)"
    }

    func format() -> String {
        if isSuccess() {
            return "Tests Passed: \(description)".s.Bold.f.Green
        } else {
            return "Tests Failed: \(description)".s.Bold.f.Red
        }
    }
}
