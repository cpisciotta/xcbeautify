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
        colorize(code: color.rawValue)
    }

    func style(_ style: Style) -> String {
        colorize(code: style.rawValue)
    }

    private func colorize(code: Int) -> String {
        if contains(startOfCode) {
            colorizeStringAndAddCodeSeparators(code: code)
        } else {
            colorizeStringWithoutPriorCode(code: code)
        }
    }

    private func colorizeStringWithoutPriorCode(code: Int) -> String {
        "\(preparedColorCode(code))\(self)\(reset)"
    }

    private func colorizeStringAndAddCodeSeparators(code: Int) -> String {
        // To refactor and use regex matching instead of replacing strings and using tricks
        let stringByRemovingEnding = removeEndingCode()
        let stringWithStart = "\(preparedColorCode(code))\(stringByRemovingEnding)"

        let stringByAddingCodeSeparator = stringWithStart.addCommandSeparators()

        return "\(stringByAddingCodeSeparator)\(reset)"
    }

    private func preparedColorCode(_ code: Int) -> String {
        "\(startOfCode)\(code)m"
    }

    private func addCommandSeparators() -> String {
        var rangeWithInset = index(after: startIndex)..<index(before: endIndex)
        let newString = replacingOccurrences(of: startOfCode, with: ";", options: .literal, range: rangeWithInset)

        rangeWithInset = newString.index(after: newString.startIndex)..<newString.index(before: newString.endIndex)
        return newString.replacingOccurrences(of: "m;", with: ";", options: .literal, range: rangeWithInset)
    }

    private func removeEndingCode() -> String {
        guard !isEmpty else { return self }
        let rangeWithInset = index(after: startIndex)..<endIndex
        return replacingOccurrences(of: reset, with: "", options: .literal, range: rangeWithInset)
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
    struct StringForegroundColorizer {
        let string: String

        var Red: String {
            string.color(.red)
        }

        var Yellow: String {
            string.color(.yellow)
        }

        var Green: String {
            string.color(.green)
        }

        var Cyan: String {
            string.color(.cyan)
        }
    }

    struct StringStyleColorizer {
        let string: String

        var Bold: String {
            string.style(.bold)
        }

        var Italic: String {
            string.style(.italic)
        }
    }

    var foreground: StringForegroundColorizer {
        StringForegroundColorizer(string: self)
    }

    var f: StringForegroundColorizer {
        foreground
    }

    var style: StringStyleColorizer {
        StringStyleColorizer(string: self)
    }

    var s: StringStyleColorizer {
        style
    }
}

// MARK: - Colored Time and Deviation

extension String {
    func coloredTime() -> String {
        guard let time = Double(self) else { return self }
        if time < 0.025 { return self }
        if time < 0.100 { return f.Yellow }
        return f.Red
    }

    func coloredDeviation() -> String {
        guard let deviation = Double(self) else { return self }
        if deviation < 1 { return self }
        if deviation < 10 { return f.Yellow }
        return f.Red
    }
}
