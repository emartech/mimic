import XCTest
@testable import mimic

final class MimicTests: XCTestCase {
    
    let testStruct = TestStruct()
    let mimickedClass = MimickedClass()
    
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
    
    func testWhen_withoutReturn() {
        var result = 0;
        
        mimickedClass.when(\.fwr) { invocationCount, params in
            result = invocationCount
        }
        
        mimickedClass.functionWithoutResult()
        
        XCTAssertEqual(result, 1)
    }
    
    func testWhen_withReturningNil() {
        var resultInvocationCount = 0;
        
        mimickedClass.when(\.fwor) { invocationCount, params in
            resultInvocationCount = invocationCount
            return nil
        }
        
        let result = mimickedClass.functionWithOptionalResult()
        
        XCTAssertEqual(resultInvocationCount, 1)
        XCTAssertNil(result)
    }
    
    func testWhen_withParams() {
        var returnedInvocationCount = 0;
        var returnedArg1: String!
        var returnedArg2: Int!
        var returnedArg3: Bool? = true
        var returnedArg4: TestStruct!
        
        mimickedClass.when(\.fwa) { invocationCount, params in
            returnedInvocationCount = invocationCount
            returnedArg1 = params[0]
            returnedArg2 = params[1]
            returnedArg3 = params[2]
            returnedArg4 = params[3]
        }
        
        mimickedClass.functionWithArgs(arg1: "testArg", arg2: 42, arg3: nil, arg4: testStruct)
        
        XCTAssertEqual(returnedInvocationCount, 1)
        XCTAssertEqual(returnedArg1, "testArg")
        XCTAssertEqual(returnedArg2, 42)
        XCTAssertNil(returnedArg3)
        XCTAssertEqual(returnedArg4, testStruct)
    }
    
}
