//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

protocol Mimic: Equatable {
    
    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, replaceFunction: @escaping (_ invocationCount: Int, _ params: Params) throws -> (ReturnType))

    func props() -> Props
    
}

extension Mimic {
    
    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>, replaceFunction: @escaping (_ invocationCount: Int, _ params: Params) throws -> (ReturnType)) {
        let mimicked = self[keyPath: fnKeyPath]
        mimicked.function = replaceFunction
    }
    
    func props() -> Props {
        return Props(subject: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.props() == rhs.props()
    }
    
}
