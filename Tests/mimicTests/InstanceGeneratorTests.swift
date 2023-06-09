// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import XCTest
@testable import mimic


final class InstanceGeneratorTests: XCTestCase {

    @Generate(SomeEnum.case1("someText", 42), SomeEnum.case2)
    var someStruct: SomeStruct
    
    func testGenerate() throws {
        XCTAssertNotNil(someStruct)
    }
    
}
