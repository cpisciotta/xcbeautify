//
// AzureDevOpsPipelinesRenderer.swift
//
// Copyright (c) 2026 Charles Pisciotta and other contributors
// Licensed under MIT License
//
// See https://github.com/cpisciotta/xcbeautify/blob/main/LICENSE for license information
//

import Foundation

struct AzureDevOpsPipelinesRenderer: MicrosoftOutputRendering {
    let colored: Bool
    let additionalLines: () -> String?

    func makeOutputLog(
        annotation: Annotation,
        prefix: String?,
        fileComponents: FileComponents?,
        message: String
    ) -> String {
        assert(annotation.platforms.contains(.azureDevOps))
        let formattedFileComponents = fileComponents?.formatted ?? ""
        if let prefix {
            return "##vso[task.logissue \(prefix) type=\(annotation.value)\(formattedFileComponents)]\(message)"
        } else {
            return "##vso[task.logissue type=\(annotation.value)\(formattedFileComponents)]\(message)"
        }
    }
}

private extension FileComponents {
    var formatted: String {
        guard let line else {
            return ";sourcepath=\(path)"
        }

        guard let column else {
            return ";sourcepath=\(path);linenumber=\(line)"
        }

        return ";sourcepath=\(path);linenumber=\(line);columnnumber=\(column)"
    }
}
