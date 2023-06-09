// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

@propertyWrapper
struct Generate<Item> where Item: Decodable {

    let instanceGenerator = InstanceGenerator()
    var encodables: [Encodable]
    
    var wrappedValue: Item {
        get {
            return try! instanceGenerator.generate(encodables)
        }
    }
    
    init(_ encodables: Encodable...) {
        self.encodables = encodables
    }

}
