// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import XCTest
@testable import mimic


final class InstanceGeneratorTests: XCTestCase {
        
    @Generate(encodables: SomeEnum.case1("someText", 42), SomeEnum.case2)
    var someStruct: SomeStruct
    
    @Generate([
        \SomeStruct.text: "Chicken. Good. Chicken.",
         \SomeStruct.bool: true
    ], encodables: SomeEnum.case2)
    var someOtherStruct: SomeStruct
    
    func testGenerate() throws {
        XCTAssertNotNil(someStruct)
    }
    
    func testGenerateWithPredfinedValues() throws {
        XCTAssertEqual(someOtherStruct.text, "Chicken. Good. Chicken.")
        XCTAssertEqual(someOtherStruct.bool, true)
    }
    
    func testInstanceGeneratorWithPredefinedValues() throws {
        let expectedText = "Chicken. Good. Chicken."
        let expectedBool = true
        var someStructTest: SomeStruct
        
        let predefined = [
            \SomeStruct.text: expectedText,
             \SomeStruct.bool: expectedBool
        ] as [PartialKeyPath<SomeStruct>: Encodable]
        
        let instanceGenerator = InstanceGenerator()
        
        someStructTest = try instanceGenerator.generate(predefined, encodables: [SomeEnum.case1("someText", 42)])
        
        XCTAssertEqual(someStructTest.text, expectedText)
        XCTAssertEqual(someStructTest.bool, expectedBool)
    }
    
}
