// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct AnyMatcher: Matcher {
    
    public let value: () = ()
    
    public func evaluate<Argument>(arg: Argument) throws {
        // TODO: logging
    }
    
}
