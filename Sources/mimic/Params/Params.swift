//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//


import Foundation

struct Params {
    
    let elements: [Value<Any>]

    subscript<ElementType>(index: Int) -> ElementType {
        get {
            let value = elements[index].value
            guard let value = value as? ElementType else {
                assertionFailure("Expected type: \(type(of: value)) doesn't match with value type: \(ElementType.self)")
                return value as! ElementType
            }
            return value
        }
    }
    
}
