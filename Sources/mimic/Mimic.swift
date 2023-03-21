//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

protocol Mimic: Equatable {
    
    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, function: @escaping (_ invocationCount: Int, _ params: [Any]) throws -> (ReturnType))

    func invoke<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, params: Any...) throws -> ReturnType
    
    func props() -> Props
    
}

extension Mimic {
    
    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, function: @escaping (_ invocationCount: Int, _ params: [Any]) throws -> (ReturnType)) {
        let mimicked = self[keyPath: fnKeyPath]
        mimicked.function = function
    }
    
    func invoke<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, params: Any...) throws -> ReturnType {
        let mimicked = self[keyPath: fnKeyPath]
        return try mimicked.invoke(params)
    }
    
    func props() -> Props {
        return Props(subject: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.props() == rhs.props()
    }
    
}
