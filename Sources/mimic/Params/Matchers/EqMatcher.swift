// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct EqMatcher<Value>: Matcher {
    
    let value: Value
    
    func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging
        
        guard let argument = arg as? Value else {
            assertionFailure("Expected type: \(Value.self) doesn't match with value type: \(Argument.self)")
            return
        }
        guard String(describing: argument) == String(describing: value) else {
            throw MimicError.argumentMismatch
        }
    }
    
}
