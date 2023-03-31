//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct StringGenerator: ValueGenerator {
    
    func generate() -> String {
        return UUID().uuidString
    }
    
}
