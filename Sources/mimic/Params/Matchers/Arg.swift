//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

struct Arg {
    
    static var `any` = AnyMatcher()

    static var `nil` = NilMatcher()

    static var notNil = NotNilMatcher()
    
    static func eq<ValueType>(_ value: ValueType) -> EqMatcher<ValueType> {
        return EqMatcher(value: value)
    }
    
    static func invokeClosure<ClosureType>(_ closure: @escaping (ClosureType) -> ()) -> ClosureMatcher<ClosureType> {
        return ClosureMatcher(value: closure )
    }
    
}
