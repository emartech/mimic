//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        
import Foundation

class Fn<ReturnType>: MimickedFunction {
    
    var name: String!
    var function: ((_ invocationCount: Int, _ params: [Any]) throws -> (ReturnType))!
    
    var invocationCount: Int = 0
    
    func invoke(_ params: Any...) throws -> ReturnType {
        invocationCount += 1
        return try function(invocationCount, params)
    }
    
}
