// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct ArrayGenerator<Element>: ValueGenerator {
    
    let element: Element
    
    func generate() -> [Element] {
        return [element]
    }
    
}
