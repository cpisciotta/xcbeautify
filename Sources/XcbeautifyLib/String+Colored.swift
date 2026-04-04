//
// String+Colored.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

// MARK: - Apply ANSI codes to a string

private let startOfCode = "\u{001B}["
private let reset = "\u{001B}[0m"

private extension String {
    func color(_ color: Color) -> String {
        applyCode(color.rawValue)
    }

    func style(_ style: Style) -> String {
        applyCode(style.rawValue)
    }

    private func applyCode(_ code: Int) -> String {
        // Case 1: No ANSI codes present → simple wrap
        guard contains(startOfCode) else {
            return "\(startOfCode)\(code)m\(self)\(reset)"
        }

        // Case 2: Single-wrapped ANSI string (e.g. "\u{001B}[Xm...\u{001B}[0m") → merge codes
        if hasPrefix(startOfCode),
           hasSuffix(reset),
           let mIndex = dropFirst(startOfCode.count).firstIndex(of: "m") {
            let afterPrefix = dropFirst(startOfCode.count)
            let content = afterPrefix.dropLast(reset.count)
            let innerContent = content[content.index(after: mIndex)...]
            if !innerContent.contains(startOfCode) {
                return "\(startOfCode)\(code);\(content[..<mIndex])m\(innerContent)\(reset)"
            }
        }

        // Case 3: String contains embedded ANSI codes → inject outer code and handle nesting.
        // Each nested opening code gets the outer code appended, and each reset is followed
        // by a resumption of the outer code.
        let outerOpen = "\(startOfCode)\(code)m"
        var result = outerOpen
        var index = startIndex
        while index < endIndex {
            if self[index...].hasPrefix(startOfCode) {
                let afterPrefix = self.index(index, offsetBy: startOfCode.count)
                var mPos = afterPrefix
                while mPos < endIndex, self[mPos].isNumber || self[mPos] == ";" {
                    mPos = self.index(after: mPos)
                }
                if mPos < endIndex, self[mPos] == "m" {
                    let innerCode = String(self[afterPrefix..<mPos])
                    if innerCode == "0" {
                        result += reset + outerOpen
                    } else {
                        result += "\(startOfCode)\(innerCode);\(code)m"
                    }
                    index = self.index(after: mPos)
                } else {
                    result.append(self[index])
                    index = self.index(after: index)
                }
            } else {
                result.append(self[index])
                index = self.index(after: index)
            }
        }
        result += reset
        return result
    }
}

// MARK: - Color Codes

private enum Color: Int {
    case red = 31
    case green = 32
    case yellow = 33
    case cyan = 36
}

private enum Style: Int {
    case bold = 1
    case italic = 3
}

// MARK: - String Extensions

extension String {
    // MARK: - Colors

    func red(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return color(.red)
    }

    func yellow(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return color(.yellow)
    }

    func green(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return color(.green)
    }

    func cyan(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return color(.cyan)
    }

    // MARK: - Styles

    func bold(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return style(.bold)
    }

    func italic(if enabled: Bool = true) -> String {
        guard enabled else { return self }
        return style(.italic)
    }
}

// MARK: - Colored Time and Deviation

extension String {
    func coloredTime() -> String {
        guard let time = Double(self) else { return self }
        if time < 0.025 { return self }
        if time < 0.100 { return yellow() }
        return red()
    }

    func coloredDeviation() -> String {
        guard let deviation = Double(self) else { return self }
        if deviation < 1 { return self }
        if deviation < 10 { return yellow() }
        return red()
    }
}
