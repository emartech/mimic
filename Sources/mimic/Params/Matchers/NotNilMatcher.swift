// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct NotNilMatcher: Matcher {
    
    public let value: () = ()
    
    public func evaluate<Argument>(arg: Argument) throws {
        if let optional = arg as? Optional<Argument>, optional == nil {
            throw MimicError.argumentMismatch(message: "Argument must not be `nil`, but it was `nil`.")
        }
    }
    
}
