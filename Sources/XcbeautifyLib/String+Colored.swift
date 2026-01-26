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
        guard
            hasPrefix(startOfCode),
            hasSuffix(reset),
            let mIndex = dropFirst(startOfCode.count).firstIndex(of: "m")
        else {
            return "\(startOfCode)\(code)m\(self)\(reset)"
        }

        let content = dropFirst(startOfCode.count).dropLast(reset.count)
        return "\(startOfCode)\(code);\(content[..<mIndex])m\(content[content.index(after: mIndex)...])\(reset)"
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

    func red() -> String {
        color(.red)
    }

    func yellow() -> String {
        color(.yellow)
    }

    func green() -> String {
        color(.green)
    }

    func cyan() -> String {
        color(.cyan)
    }

    // MARK: - Styles

    func bold() -> String {
        style(.bold)
    }

    func italic() -> String {
        style(.italic)
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
