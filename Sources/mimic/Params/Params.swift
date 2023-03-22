//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//


import Foundation

struct Params<Element> {
    
    let elements: [Element]

    subscript<ElementType>(index: Int) -> ElementType {
        get {
            let value = elements[index]
            guard let value = value as? ElementType else {
                assertionFailure("Expected type: \(value.self) doesn't match with value type: \(ElementType.self)")
                return value as! ElementType
            }
            return value
        }
    }
    
}
