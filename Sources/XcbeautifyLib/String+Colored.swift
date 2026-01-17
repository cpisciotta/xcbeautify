//
// String+Colored.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

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
