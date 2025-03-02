//
// Constants.swift
//
// Copyright (c) 2025 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

enum Architecture: String {
    case arm64
    case arm64_32
    case armv7k
    case i386
    case x86_64
}

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

/// Specifies the xcodebuild console output type.
/// As an example, a compiler warning, a compiler error, a test case, etc.
package enum OutputType {
    case undefined
    case task
    case test
    case testCase
    case nonContextualError
    case warning
    case error
    case result
    case issue
}

// TODO: ArgumentParser will eventually obviate this, once a release is made that includes ExpressibleByArgument.allValueDescriptions.
/// A protocol to prepare a string description of all of an option's valid settings, based on the option's CaseIterable enum String rawValues.
package protocol UsageOptionsDescribable {
    static var optionsDescription: String { get }
}

package extension
UsageOptionsDescribable where Self: CaseIterable & RawRepresentable<String> {
    static var optionsDescription: String {
        allCases.map(\.rawValue).joined(separator: " | ")
    }
}

/// Maps to an `OutputRendering` type that formats raw `xcodebuild` output.
public enum Renderer: String, CaseIterable, UsageOptionsDescribable {
    /// The default `OutputRendering` type for local and general use. Maps to `TerminalRenderer`.
    case terminal

    /// Formats output suitable for GitHub Actions annotations. Maps to `GitHubRenderer`.
    case gitHubActions = "github-actions"

    /// Formats output suitable for TeamCity service messages. Maps to `TeamCityRenderer`.
    case teamcity

    /// Formats output suitable for Azure DevOps Pipeline annotations. Maps to `AzureDevOpsPipelineRenderer`
    case azureDevOpsPipelines = "azure-devops-pipelines"
}
