//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct NotNilMatcher: Matcher {
    
    let value: () = ()
    
    func evaluate<Argument>(arg: Argument?) throws {
        // TODO: logging
        
        if case Optional<Any>.some = arg {
            throw MimicError.argumentMismatch
        }
    }
    
}
