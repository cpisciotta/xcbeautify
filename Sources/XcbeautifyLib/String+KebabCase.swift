//
// String+KebabCase.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

package extension String {
    /// Converts a PascalCase or camelCase string to kebab-case.
    ///
    /// Consecutive uppercase letters (acronyms) are kept together as a single
    /// lowercased segment. A hyphen is inserted before an uppercase letter when
    /// the previous character is lowercase, or when the next character is
    /// lowercase (marking the end of an acronym).
    ///
    /// Examples:
    /// - `"FatalError"` -> `"fatal-error"`
    /// - `"UIFailingTest"` -> `"ui-failing-test"`
    /// - `"LDError"` -> `"ld-error"`
    /// - `"GenerateDSYM"` -> `"generate-dsym"`
    /// - `"already-kebab"` -> `"already-kebab"`
    var kebabCased: String {
        let chars = Array(self)
        var result = ""
        for (i, char) in chars.enumerated() {
            if char.isUppercase {
                let prevIsLower = i > 0 && chars[i - 1].isLowercase
                let nextIsLower = i + 1 < chars.count && chars[i + 1].isLowercase
                if i > 0, prevIsLower || nextIsLower {
                    result.append("-")
                }
            }
            result.append(contentsOf: char.lowercased())
        }
        return result
    }
}
