//
//  CaptureGroupTests.swift
//
//
//  Created by Charles Pisciotta on 2/25/24.
//

import XCTest
@testable import XcbeautifyLib

final class CaptureGroupTests: XCTestCase {
    func testSwiftCompiling() {
        let inputs = [
            #"SwiftCompile normal x86_64 Compiling\ BackyardBirdsDataContainer.swift,\ ColorData.swift,\ DataGeneration.swift,\ DataGenerationOptions.swift /Backyard-Birds/BackyardBirdsData/General/BackyardBirdsDataContainer.swift /Backyard-Birds/BackyardBirdsData/General/ColorData.swift /Backyard-Birds/BackyardBirdsData/General/DataGeneration.swift /Backyard-Birds/BackyardBirdsData/General/DataGenerationOptions.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal x86_64 Compiling\ BackyardSnapshot.swift,\ BackyardSupplies.swift,\ BackyardTimeOfDay.swift,\ BackyardTimeOfDayColors.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSnapshot.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardSupplies.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDay.swift /Backyard-Birds/BackyardBirdsData/Backyards/BackyardTimeOfDayColors.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ PlantSpecies.swift,\ PlantSpeciesInfo.swift,\ PassIdentifiers.swift,\ GeneratedAssetSymbols.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpecies.swift /Backyard-Birds/BackyardBirdsData/Plants/PlantSpeciesInfo.swift /Backyard-Birds/BackyardBirdsData/Store/PassIdentifiers.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/GeneratedAssetSymbols.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
            #"SwiftCompile normal arm64 Compiling\ resource_bundle_accessor.swift,\ Account+DataGeneration.swift,\ Account.swift,\ Backyard+DataGeneration.swift,\ Backyard.swift /Backyard-Birds/Build/Intermediates.noindex/BackyardBirdsData.build/Debug/BackyardBirdsData.build/DerivedSources/resource_bundle_accessor.swift /Backyard-Birds/BackyardBirdsData/Account/Account+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Account/Account.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard+DataGeneration.swift /Backyard-Birds/BackyardBirdsData/Backyards/Backyard.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#,
        ]

        for input in inputs {
            XCTAssertTrue(SwiftCompilingCaptureGroup.regex.match(string: input))
        }
    }

    func testMatchCompilationResults() {
        let input = #"/* com.apple.actool.compilation-results */"#
        XCTAssertTrue(CompilationResultCaptureGroup.regex.match(string: input))
    }

    func testMatchCopyFilesMatchingSourceAndDestinationFilenames() {
        let input = #"Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"#
        XCTAssertTrue(CopyFilesCaptureGroup.regex.match(string: input))
    }

    func testMatchSwiftDriverJobDiscoveryEmittingModule() {
        let input = #"SwiftDriverJobDiscovery normal arm64 Emitting module for Widgets (in target 'Widgets' from project 'Backyard Birds')"#
        XCTAssertTrue(SwiftDriverJobDiscoveryEmittingModuleCaptureGroup.regex.match(string: input))
    }
}
