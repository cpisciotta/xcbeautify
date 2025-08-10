//
//  SwiftTestingGroup.swift
//  xcbeautify
//
//  Created by Charles Pisciotta on 8/9/25.
//

import Testing

struct SwiftTestingGroup {

    @Test func testTrueIsTrue() async throws {
        #expect(true == true)
    }

    @Test func testFailTrueIsFalse() async throws {
        #expect(true == false)
    }

}
