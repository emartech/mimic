//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct IntGenerator: ValueGenerator {
    
    func generate() -> Int {
        return Int.random(in: 0..<Int.max)
    }
    
}
