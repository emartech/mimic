// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

@propertyWrapper
public struct Generate<Item> where Item: Decodable {

    let instanceGenerator = InstanceGenerator()
    var encodables: [Encodable]
    var predefined: [PartialKeyPath<Item>: Encodable]?
    
    var item: Item!
    
    public var wrappedValue: Item {
        mutating get {
            item = try! instanceGenerator.generate(predefined, encodables)
            return item
        }
        set {
            item = newValue
        }
    }
    
    public init(_ predefined: [PartialKeyPath<Item>: Encodable]? = nil, encodables: Encodable...) {
        self.predefined = predefined
        self.encodables = encodables
    }

}
