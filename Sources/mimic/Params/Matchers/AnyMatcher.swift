//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct AnyMatcher: Matcher {
    
    let value: () = ()
    
    func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging
    }
    
}
