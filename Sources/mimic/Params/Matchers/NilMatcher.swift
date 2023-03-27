//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct NilMatcher: Matcher {
    
    let value: () = ()
    
    func evaluate<Argument>(arg: Argument?) throws {
        // TODO: logging
        guard case Optional<Any>.none = arg else {
            throw MimicError.argumentMismatch
        }
    }
    
}
