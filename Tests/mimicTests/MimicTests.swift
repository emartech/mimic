import XCTest
@testable import mimic

final class MimicTests: XCTestCase {
    
    let testStruct = TestStruct()
    
    func testProps_shouldReturn_with_propertyLabels_values_asProps() {
        let expected = [
            "boolValue": true,
            "wholeValue": 42,
            "floatingValue": 3.1415926535897,
            "stringValue": "Oh, yeah. Oooh, ahhh, that's how it always starts. Then later there's running and um, screaming.",
            "array": [true, false, true],
            "dict": ["key": "value"],
            "optionalNil": nil
        ].toProps()
        
        let result = testStruct.props()
        
        XCTAssertEqual(result, expected)
    }
    
    func testEquality() {
        let struct1 = TestStruct()
        let struct2 = TestStruct()
        
        XCTAssertEqual(struct1, struct2)
    }
    
    func testWhen() {
        let expected = "Life, the Universe and Everything"
        
        testStruct.when(\.fnId) { invocationCount, params in
            return expected
        }
        
        let result = testStruct.fnForTest()
        
        XCTAssertEqual(result, expected)
    }
    
}
