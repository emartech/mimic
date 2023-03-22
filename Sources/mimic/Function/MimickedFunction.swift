//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        
import Foundation

protocol MimickedFunction {
    
    associatedtype ReturnType
    
    var name: String! { get }
    var function: ((_ invocationCount: Int, _ params: Params<Any>) throws -> (ReturnType))! { get }
    var invocationCount: Int { get set }
    
    func invoke(_ fnName: String, params: Any...) throws -> ReturnType
    
}
