//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

struct When<ReturnType> {
    
    var fn: Fn<ReturnType>
    
    func replaceFunction(_ fnName: String = #function, _ replaceFunction: @escaping (_ invocationCount: Int, _ params: Params) throws -> (ReturnType)) {
        fn.function = replaceFunction
    }
    
    func thenReturn(_ result: ReturnType) {
        fn.function = { _, _ in
            return result
        }
    }
    
    func thenReturn(_ results: ReturnType...) {
        fn.function = { invocationCount, _ in
            guard invocationCount <= results.count else {
                throw MimicError.missingResult
            }
            return results[invocationCount - 1]
        }
    }
    
}
