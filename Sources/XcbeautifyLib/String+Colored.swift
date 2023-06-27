import Foundation

extension String {
    func coloredTime(colored: Bool) -> String {
        guard colored, let time = Double(self) else { return self }
        if time < 0.025 { return self }
        if time < 0.100 { return f.Yellow }
        return f.Red
    }

    func coloredDeviation(colored: Bool) -> String {
        guard colored, let deviation = Double(self) else { return self }
        if deviation < 1 { return self }
        if deviation < 10 { return f.Yellow }
        return f.Red
    }
}
