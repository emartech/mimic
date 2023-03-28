//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct NilMatcher: Matcher {
    
    let value: () = ()
    
    func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging

        if let optional = arg as? Optional<Argument>, optional != nil {
            throw MimicError.argumentMismatch
        }
    }
    
}
