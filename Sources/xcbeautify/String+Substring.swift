import Foundation

extension String {
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
    }
}
