//
// TestCaseCaptureGroupTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib

struct TestCaseCaptureGroupTests {
    private let captureGroupTypes = Parser().__for_test__captureGroupTypes()

    @Test func validOutputTypes() {
        for captureGroupType in captureGroupTypes {
            switch captureGroupType.outputType {
            case .error, .issue, .nonContextualError, .result, .task, .test, .undefined, .warning:
                #expect(!(captureGroupType is any TestCaseCaptureGroup.Type))
            case .testCaseFailure, .testCasePass, .testCaseSkip:
                #expect(captureGroupType is any TestCaseCaptureGroup.Type)
            }
        }
    }
}
