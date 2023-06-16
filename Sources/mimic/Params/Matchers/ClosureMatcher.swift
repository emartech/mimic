// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct ClosureMatcher<ClosureType>: Matcher {

    public let value: (ClosureType) -> ()
    
    public func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging
        
        guard let argument = arg as? ClosureType else {
            assertionFailure("Expected type: \(ClosureType.self) doesn't match with value type: \(Argument.self)")
            return
        }
        
        value(argument)
    }
    
}
