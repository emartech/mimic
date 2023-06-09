// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct DictionaryGenerator<Key, Value>: ValueGenerator where Key: Hashable {
    
    let key: Key
    let value: Value
    
    func generate() -> [Key: Value] {
        return [key: value]
    }
    
}
