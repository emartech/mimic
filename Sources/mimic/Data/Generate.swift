// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

@propertyWrapper
public struct Generate<Item> where Item: Decodable {

    let instanceGenerator = InstanceGenerator()
    var encodables: [Encodable]
    
    public var wrappedValue: Item {
        get {
            return try! instanceGenerator.generate(encodables)
        }
    }
    
    public init(_ encodables: Encodable...) {
        self.encodables = encodables
    }

}
