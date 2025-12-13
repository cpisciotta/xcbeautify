//
// Condition+Ext.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing

enum Platform {
    case linux
    case macOS

    var isActive: Bool {
        #if os(macOS)
        self == .macOS
        #else
        self == .linux
        #endif
    }
}

extension Trait where Self == ConditionTrait {
    static func disabled(
        if platform: Platform,
        _ comment: Comment?,
        sourceLocation: SourceLocation = #_sourceLocation
    ) -> ConditionTrait {
        .disabled(if: platform.isActive, comment)
    }
}
