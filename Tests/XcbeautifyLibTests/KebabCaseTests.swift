//
// KebabCaseTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib

struct KebabCaseTests {
    @Test func simpleWords() {
        #expect("FatalError".kebabCased == "fatal-error")
        #expect("CompileWarning".kebabCased == "compile-warning")
        #expect("PhaseSuccess".kebabCased == "phase-success")
    }

    @Test func multipleWords() {
        #expect("FatalErrorWithFilePath".kebabCased == "fatal-error-with-file-path")
        #expect("LinkerDuplicateSymbols".kebabCased == "linker-duplicate-symbols")
    }

    @Test func leadingAcronym() {
        #expect("UIFailingTest".kebabCased == "ui-failing-test")
        #expect("LDError".kebabCased == "ld-error")
        #expect("LDWarning".kebabCased == "ld-warning")
    }

    @Test func trailingAcronym() {
        #expect("GenerateDSYM".kebabCased == "generate-dsym")
    }

    @Test func singleWord() {
        #expect("Compile".kebabCased == "compile")
    }

    @Test func alreadyLowercase() {
        #expect("already".kebabCased == "already")
    }

    @Test func allUppercase() {
        #expect("DSYM".kebabCased == "dsym")
    }

    @Test func emptyString() {
        #expect("".kebabCased == "")
    }
}
