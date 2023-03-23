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
    
    func testWhen_withReplaceFunction() {
        let expected = "Life, the Universe and Everything"
        
        testStruct.when(\.fnId).replaceFunction { invocationCount, params in
            return expected
        }
        
        let result = testStruct.fnForTest()
        
        XCTAssertEqual(result, expected)
    }
    
    func testWhen_withReplaceFunction_withoutReturn() throws {
        var result = 0;
        
        mimickedClass.when(\.fwr).replaceFunction() { invocationCount, params in
            result = invocationCount
        }
        
        try mimickedClass.functionWithoutResult()
        
        XCTAssertEqual(result, 1)
    }
    
    func testWhen_withReplaceFunction_withReturningNil() throws {
        var resultInvocationCount = 0;
        
        mimickedClass.when(\.fwor).replaceFunction() { invocationCount, params in
            resultInvocationCount = invocationCount
            return nil
        }
        
        let result = try mimickedClass.functionWithOptionalResult()
        
        XCTAssertEqual(resultInvocationCount, 1)
        XCTAssertNil(result)
    }
    
    func testWhen_withReplaceFunction_withParams() {
        var returnedInvocationCount = 0;
        var returnedArg1: String!
        var returnedArg2: Int!
        var returnedArg3: Bool? = true
        var returnedArg4: TestStruct!
        
        mimickedClass.when(\.fwa).replaceFunction() { invocationCount, params in
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
    
    func testWhen_withReturn_withValue() throws {
        let expected = "May the Force be with you."
        
        mimickedClass.when(\.fwor).thenReturn(expected)
        
        let result = try mimickedClass.functionWithOptionalResult()
        
        XCTAssertEqual(result, expected)
    }
    
    func testWhen_withReturn_withNil() throws {
        mimickedClass.when(\.fwor).thenReturn(nil)
        
        let result = try mimickedClass.functionWithOptionalResult()
        
        XCTAssertNil(result)
    }

    func testWhen_withReturns() throws {
        let expected1 = "I'll be back."
        let expected2 = "Houston, we have a problem."
        let expected4 = "A martini. Shaken, not stirred."
        
        mimickedClass.when(\.fwor).thenReturn(expected1, expected2, nil, expected4)
        
        let result1 = try mimickedClass.functionWithOptionalResult()
        let result2 = try mimickedClass.functionWithOptionalResult()
        let result3 = try mimickedClass.functionWithOptionalResult()
        let result4 = try mimickedClass.functionWithOptionalResult()
        
        XCTAssertEqual(result1, expected1)
        XCTAssertEqual(result2, expected2)
        XCTAssertNil(result3)
        XCTAssertEqual(result4, expected4)
    }
    
    func testWhen_withReturns_expectingMissingResultError() throws {
        let expected1 = "Magic Mirror on the wall, who is the fairest one of all?"
        let expected2 = "Hasta la vista, baby."
        let expected3 = "So you're telling me there's a chance?"
        
        mimickedClass.when(\.fwor).thenReturn(expected1, expected2, expected3)
        
        let result1 = try mimickedClass.functionWithOptionalResult()
        let result2 = try mimickedClass.functionWithOptionalResult()
        let result3 = try mimickedClass.functionWithOptionalResult()
        
        XCTAssertThrowsError(try mimickedClass.functionWithOptionalResult()) { error in
            XCTAssertEqual(error as! MimicError, MimicError.missingResult)
        }
        XCTAssertEqual(result1, expected1)
        XCTAssertEqual(result2, expected2)
        XCTAssertEqual(result3, expected3)
    }
    
    func testWhen_withoutUsinganythingOnWhen_expectingIncompleteMimickingError() {
        XCTAssertThrowsError(try mimickedClass.functionWithoutResult()) { error in
            XCTAssertEqual(error as! MimicError, MimicError.incompleteMimicking)
        }
    }
    
}
