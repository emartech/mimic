//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        
import Foundation

class Fn<ReturnType>: MimickedFunction {

    var name: String!
    var function: ((_ invocationCount: Int, _ params: Params) throws -> (ReturnType))?
    
    var invocationCount: Int = 0
    
    func invoke(_ fnName: String = #function, params: Any...) throws -> ReturnType {
        guard let function = self.function else {
            throw MimicError.incompleteMimicking
        }
        self.name = fnName
        invocationCount += 1
        return try function(invocationCount, Params(elements: params.map { Wrapped(value: $0) }))
    }
    
    func when() -> When<ReturnType> {
        return When<ReturnType>(fn: self)
    }
    
}
