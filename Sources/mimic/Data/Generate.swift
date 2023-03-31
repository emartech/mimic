//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

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
