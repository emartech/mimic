//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import XCTest
@testable import mimic


final class InstanceGeneratorTests: XCTestCase {

    @Generate(SomeEnum.case1("someText", 42), SomeEnum.case2)
    var someStruct: SomeStruct
    
    func testGenerate() throws {
        XCTAssertNotNil(someStruct)
    }
    
}
