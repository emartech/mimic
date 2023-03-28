//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct ClosureMatcher<ClosureType>: Matcher {

    let value: (ClosureType) -> ()
    
    func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging
        
        guard let argument = arg as? ClosureType else {
            assertionFailure("Expected type: \(ClosureType.self) doesn't match with value type: \(Argument.self)")
            return
        }
        
        value(argument)
    }
    
}
