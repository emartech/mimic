//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

protocol ValueGenerator {
    
    associatedtype ValueType
    
    func generate() -> ValueType
    
}
