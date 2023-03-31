//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct DoubleGenerator: ValueGenerator {
    
    func generate() -> Double {
        return Double.random(in: Double.leastNonzeroMagnitude..<Double.greatestFiniteMagnitude)
    }
    
}
