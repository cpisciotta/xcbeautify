//
//  ParserTests.swift
//
//
//  Created by Charles Pisciotta on 8/6/24.
//

import XCTest
@testable import XcbeautifyLib

final class ParserTests: XCTestCase {
    private var parser: Parser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        parser = Parser()
    }

    override func tearDownWithError() throws {
        parser = nil
        try super.tearDownWithError()
    }

    func testMatchCopyFilesMatchingSourceAndDestinationFilenames() throws {
        let input = #"Copy /path/to/some/file.swift /path/to/some/other/file.swift (in target 'Target' from project 'Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/path/to/some/file.swift")
        XCTAssertEqual(captureGroup.firstFilename, "file.swift")
        XCTAssertEqual(captureGroup.secondFilePath, "/path/to/some/other/file.swift")
        XCTAssertEqual(captureGroup.secondFilename, "file.swift")
        XCTAssertEqual(captureGroup.target, "Target")
    }

    func testMatchCopyFilesDifferentSourceAndDestinationFilenames() throws {
        let input = #"Copy /Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json /Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json (in target 'Backyard Birds' from project 'Backyard Birds')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? CopyFilesCaptureGroup)
        XCTAssertEqual(captureGroup.firstFilePath, "/Backyard-Birds/Build/Products/Debug/Backyard_Birds.swiftmodule/x86_64-apple-macos.abi.json")
        XCTAssertEqual(captureGroup.firstFilename, "x86_64-apple-macos.abi.json")
        XCTAssertEqual(captureGroup.secondFilePath, #"/Backyard-Birds/Build/Intermediates.noindex/Backyard\ Birds.build/Debug/Backyard\ Birds.build/Objects-normal/x86_64/Backyard_Birds.abi.json"#)
        XCTAssertEqual(captureGroup.secondFilename, "Backyard_Birds.abi.json")
        XCTAssertEqual(captureGroup.target, "Backyard Birds")
    }

    func testMatchSwiftDriverJobDiscoveryCompilingCaptureGroupOneFile() throws {
        let input = #"SwiftDriverJobDiscovery normal arm64 Compiling resource_bundle_accessor.swift (in target 'Some Target' from project 'Some Project')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        XCTAssertEqual(captureGroup.state, "normal")
        XCTAssertEqual(captureGroup.architecture, "arm64")
        XCTAssertEqual(captureGroup.filenames, ["resource_bundle_accessor.swift"])
        XCTAssertEqual(captureGroup.target, "Some Target")
        XCTAssertEqual(captureGroup.project, "Some Project")
    }

    func testMatchSwiftDriverJobDiscoveryCompilingCaptureGroupMultipleFiles() throws {
        let input = #"SwiftDriverJobDiscovery normal x86_64 Compiling BackyardVisitorEvent+DataGeneration.swift, BackyardVisitors\ &\ Events.swift, Bird+DataGeneration.swift, Bird.swift (in target 'BackyardBirdsDataTarget' from project 'BackyardBirdsDataProject')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftDriverJobDiscoveryCompilingCaptureGroup)
        XCTAssertEqual(captureGroup.state, "normal")
        XCTAssertEqual(captureGroup.architecture, "x86_64")
        XCTAssertEqual(captureGroup.filenames, ["BackyardVisitorEvent+DataGeneration.swift", #"BackyardVisitors\ &\ Events.swift"#, "Bird+DataGeneration.swift", "Bird.swift"])
        XCTAssertEqual(captureGroup.target, "BackyardBirdsDataTarget")
        XCTAssertEqual(captureGroup.project, "BackyardBirdsDataProject")
    }

    func testMatchSwiftCompile() throws {
        let input = #"SwiftCompile normal arm64 /Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift (in target 'BackyardBirdsData' from project 'BackyardBirdsData')"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? SwiftCompileCaptureGroup)
        XCTAssertEqual(captureGroup.filePath, #"/Backyard-Birds/BackyardBirdsData/Food\ &\ Drink/BirdFood+DataGeneration.swift"#)
        XCTAssertEqual(captureGroup.filename, #"BirdFood+DataGeneration.swift"#)
        XCTAssertEqual(captureGroup.target, "BackyardBirdsData")
    }

    func testMatchExplicitDependency() throws {
        let input = #"        ➜ Explicit dependency on target 'BackyardBirdsData_BackyardBirdsData' in project 'Backyard Birds Data'"#
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? ExplicitDependencyCaptureGroup)
        XCTAssertEqual(captureGroup.target, "BackyardBirdsData_BackyardBirdsData")
        XCTAssertEqual(captureGroup.project, "Backyard Birds Data")
    }
    
    func testMatchTestingStarted() throws {
        let input = "Testing started"
        let captureGroup = try XCTUnwrap(parser.parse(line: input) as? TestingStartedCaptureGroup)
        XCTAssertEqual(captureGroup.wholeMessage, "Testing started")
    }
    
    func testNotMatchTestingStarted() throws {
        let input = #"2024-08-18 18:17:52.619 xcodebuild[9799:394817] [MT] IDETestOperationsObserverDebug: 21.975 elapsed -- Testing started completed."#
        XCTAssertNil(parser.parse(line: input))
    }
}
