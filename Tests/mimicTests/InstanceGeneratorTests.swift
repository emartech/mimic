//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import XCTest
@testable import mimic

enum SomeEnum: Codable {
    case case1(String, Int)
    case case2
}

struct SomeSubStruct: Decodable {
    let text: String
}

struct Inner: Decodable {
    let subStruct: SomeSubStruct
    let num: Int
    let floating: Double
    let bool: Bool
    let dict: [String: String]
    let array: [String]
}

struct SomeStruct: Decodable {
    let text: String
    let num: Int
    let floating: Double
    let bool: Bool
    var dict: [String: String]
    let array: [String]
    let inner: Inner
    let arrayInner: [Inner]
    let dictInner: [String: Inner]
    let someEnum: SomeEnum
    let optional: String?
}

final class InstanceGeneratorTests: XCTestCase {

    @Generate(SomeEnum.case1("someText", 42), SomeEnum.case2)
    var someStruct: SomeStruct
    
    func testGenerate() throws {
        XCTAssertNotNil(someStruct)
    }
    
}
