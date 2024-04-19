// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct IntGenerator: ValueGenerator {
    
    func generate() -> Int {
        return Int.random(in: 0..<Int.max)
    }
    
}
