//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

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
        
        mimickedClass.when(\.fwor).thenReturns(expected1, expected2, nil, expected4)
        
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
        
        mimickedClass.when(\.fwor).thenReturns(expected1, expected2, expected3)
        
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
    
    func testWhen_withoutUsingAnyFunctionOnWhen_expectingIncompleteMimickingError() {
        XCTAssertThrowsError(try mimickedClass.functionWithoutResult()) { error in
            XCTAssertEqual(error as! MimicError, .incompleteMimicking)
        }
    }
    
    func testWhen_calledWith_multipleMatchers() {
        mimickedClass.when(\.fwa)
            .calledWith(Arg.eq("expectedValue"), Arg.notNil, Arg.nil, Arg.eq(testStruct))
            .thenReturn(())
        
        mimickedClass.functionWithArgs(arg1: "expectedValue", arg2: 42, arg3: nil, arg4: testStruct)
    }
    
    func testWhen_calledWith_eqMatcher_shouldThrowArgumentMismatchError_forThenReturn() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.eq("expectedValue")).thenReturn("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_nilMatcher_shouldThrowArgumentMismatchError_forThenReturn() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.nil).thenReturn("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_notNilMatcher_shouldThrowArgumentMismatchError_forThenReturn() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.notNil).thenReturn("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: nil)) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_closureMatcher_shouldUseClosure_forThenReturn() async throws {
        let closure: (MimickedClass.ErrorClosure) -> () = { errorClosure in
            errorClosure(TestError.magicWord)
        }
  
        mimickedClass.when(\.fwcar).calledWith(Arg.invokeClosure(closure)).thenReturn("result")
        
        var returnedError: Error? = nil
        let result = try await mimickedClass.functionWithCArg { error in
            returnedError = error
        }
        
        XCTAssertEqual(result, "result")
        XCTAssertEqual(returnedError as! TestError, TestError.magicWord)
    }
    
    func testWhen_calledWith_eqMatcher_shouldThrowArgumentMismatchError_forThenReturns() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.eq("expectedValue")).thenReturns("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_nilMatcher_shouldThrowArgumentMismatchError_forThenReturns() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.nil).thenReturns("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_notNilMatcher_shouldThrowArgumentMismatchError_forThenReturns() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.notNil).thenReturns("result")
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: nil)) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_closureMatcher_shouldUseClosure_forThenReturns() async throws {
        let closure: (MimickedClass.ErrorClosure) -> () = { errorClosure in
            errorClosure(TestError.magicWord)
        }
  
        mimickedClass.when(\.fwcar).calledWith(Arg.invokeClosure(closure)).thenReturns("result")
        
        var returnedError: Error? = nil
        let result = try await mimickedClass.functionWithCArg { error in
            returnedError = error
        }
        
        XCTAssertEqual(result, "result")
        XCTAssertEqual(returnedError as! TestError, TestError.magicWord)
    }
    
    func testWhen_calledWith_eqMatcher_shouldThrowArgumentMismatchError_forReplaceFunction() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.eq("expectedValue")).replaceFunction { invocationCount, params in
            return "result"
        }
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_nilMatcher_shouldThrowArgumentMismatchError_forReplaceFunction() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.nil).replaceFunction { invocationCount, params in
            return "result"
        }
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: "inputValue")) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_notNilMatcher_shouldThrowArgumentMismatchError_forReplaceFunction() {
        
        mimickedClass.when(\.fwar).calledWith(Arg.notNil).replaceFunction { invocationCount, params in
            return "result"
        }
        
        XCTAssertThrowsError(try mimickedClass.functionWithArg(arg: nil)) { error in
            XCTAssertEqual(error as!MimicError, .argumentMismatch)
        }
    }
    
    func testWhen_calledWith_closureMatcher_shouldUseClosure_forReplaceFunction() async throws {
        let closure: (MimickedClass.ErrorClosure) -> () = { errorClosure in
            errorClosure(TestError.magicWord)
        }
  
        mimickedClass.when(\.fwcar).calledWith(Arg.invokeClosure(closure)).replaceFunction { invocationCount, params in
            return "result"
        }
        
        var returnedError: Error? = nil
        let result = try await mimickedClass.functionWithCArg { error in
            returnedError = error
        }
        
        XCTAssertEqual(result, "result")
        XCTAssertEqual(returnedError as! TestError, TestError.magicWord)
    }
    
    func testWhen_thenThrow() {
        mimickedClass.when(\.fwr).thenThrow(error: TestError.magicWord)
        
        XCTAssertThrowsError(try mimickedClass.functionWithoutResult()) { error in
            XCTAssertEqual(error as! TestError, .magicWord)
        }
    }
    
    func testVerify_wasCalled_fail() throws {
        mimickedClass.when(\.fwar).thenReturn("Frankly, my dear, I don't give a damn.")
        
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).wasCalled(Arg.eq("Did he fire six shots or only five?"))) { error in
            XCTAssertEqual(error as! MimicError, .argumentMismatch)
        }
    }
    
    func testVerify_onThread() async throws {
        
        @MainActor
        func runOnMain() async throws {
            _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        }
        
        mimickedClass.when(\.fwar).thenReturn("Chewie, we’re home.")
        
        try await runOnMain()
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).on(thread: Thread.current)) { error in
            XCTAssertEqual(error as! MimicError, .verificationFailed)
        }
    }
    
    func testVerify_times_zero() throws {
        mimickedClass.when(\.fwar).thenReturn("Toto, I've a feeling we're not in Kansas anymore.")
        
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).times(times: .zero)) { error in
            XCTAssertEqual(error as! MimicError, .verificationFailed)
        }
    }
    
    func testVerify_times_atLeast() throws {
        mimickedClass.when(\.fwar).thenReturn("It's alive! It's alive!")
        
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).times(times: .atLeast(2))) { error in
            XCTAssertEqual(error as! MimicError, .verificationFailed)
        }
    }
    
    func testVerify_times_atMax() throws {
        mimickedClass.when(\.fwar).thenReturn("My precious.")
        
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).times(times: .max(1))) { error in
            XCTAssertEqual(error as! MimicError, .verificationFailed)
        }
    }
    
    func testVerify_times_atEq() throws {
        mimickedClass.when(\.fwar).thenReturn("I feel the need—the need for speed!")
        
        
        _ = try mimickedClass.functionWithArg(arg: "Oh, well.. That was unexpected.")
        
        XCTAssertThrowsError(try mimickedClass.verify(\.fwar).times(times: .eq(2))) { error in
            XCTAssertEqual(error as! MimicError, .verificationFailed)
        }
    }
    
}
