//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

protocol Mimic: Equatable {

    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> When<ReturnType>
    
    func props() -> Props
    
}

extension Mimic {

    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> When<ReturnType> {
        let mimicked = self[keyPath: fnKeyPath]
        return mimicked.when
    }
    
    func props() -> Props {
        return Props(subject: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.props() == rhs.props()
    }
    
}
