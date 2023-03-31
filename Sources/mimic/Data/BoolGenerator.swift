//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

struct BoolGenerator: ValueGenerator {
    
    func generate() -> Bool {
        return Bool.random()
    }
    
}
