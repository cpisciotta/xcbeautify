//
// RendererTests.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Testing
@testable import XcbeautifyLib

struct RendererTests {
    @Test func detectGitHubActions() {
        let renderer = Renderer.detect(environment: ["GITHUB_ACTIONS": "true"])
        #expect(renderer == .gitHubActions)
    }

    @Test func detectTeamCity() {
        let renderer = Renderer.detect(environment: ["TEAMCITY_VERSION": "true"])
        #expect(renderer == .teamcity)
    }

    @Test func detectAzurePipelines() {
        let renderer = Renderer.detect(environment: ["AZURE_DEVOPS_PIPELINES": "true"])
        #expect(renderer == .azureDevOpsPipelines)
    }

    @Test func detectTerminal() {
        let renderer = Renderer.detect(environment: [:])
        #expect(renderer == .terminal)
    }
}
