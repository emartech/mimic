//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct ArrayGenerator<Element>: ValueGenerator {
    
    let element: Element
    
    func generate() -> [Element] {
        return [element]
    }
    
}
