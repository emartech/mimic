// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct DoubleGenerator: ValueGenerator {
    
    func generate() -> Double {
        return Double.random(in: Double.leastNonzeroMagnitude..<Double.greatestFiniteMagnitude)
    }
    
}
