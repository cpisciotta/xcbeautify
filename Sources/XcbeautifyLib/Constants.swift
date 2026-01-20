//
// Constants.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

enum Format {
    static let indent = "    "
}

enum TestStatus {
    static let pass = "✔"
    static let fail = "✖"
    static let pending = "⧖"
    static let completion = "▸"
    static let measure = "◷"
    static let skipped = "⊘"
}

enum Symbol {
    static let error = "❌"
    static let asciiError = "[x]"

    static let warning = "⚠️"
    static let asciiWarning = "[!]"
}

/// Maps to an `OutputRendering` type that formats raw `xcodebuild` output.
public enum Renderer: String, CaseIterable {
    /// The default `OutputRendering` type for local and general use. Maps to `TerminalRenderer`.
    case terminal

    /// Formats output suitable for GitHub Actions annotations. Maps to `GitHubRenderer`.
    case gitHubActions = "github-actions"

    /// Formats output suitable for TeamCity service messages. Maps to `TeamCityRenderer`.
    case teamcity

    /// Formats output suitable for Azure DevOps Pipeline annotations. Maps to `AzureDevOpsPipelineRenderer`
    case azureDevOpsPipelines = "azure-devops-pipelines"
}
