//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

extension PartialKeyPath {
    
    var propertyName: String {
        String(describing: self).words().last!
    }
    
}
