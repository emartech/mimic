//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

struct ValueGeneratorFactory {
    
    func create(_ type: Any.Type) throws -> any ValueGenerator {
        let typeNames = String(describing: type).words()
        return try create(typeNames)
    }
    
    func create(_ typeNames: [String]) throws -> any ValueGenerator {
        var result: (any ValueGenerator)!
        guard typeNames.count > 0 else {
            throw MimicError.decodingFailed
        }
        switch typeNames.first {
        case "Bool":
            result = BoolGenerator()
        case "Int":
            result = IntGenerator()
        case "Double":
            result = DoubleGenerator()
        case "String":
            result = StringGenerator()
        case "Array":
            guard typeNames.count >= 2 else {
                throw MimicError.decodingFailed
            }
            let element = try create([typeNames[1]]).generate()
            result = ArrayGenerator(element: element)
        case "Dictionary":
            guard typeNames.count >= 3 else {
                throw MimicError.decodingFailed
            }
            guard let key = try create([typeNames[1]]).generate() as? AnyHashable else {
                throw MimicError.decodingFailed
            }
            let value = try create([typeNames[2]]).generate()
            result = DictionaryGenerator(key: key, value: value)
        default:
            result = DictionaryGenerator(key: "anyKey", value: "anyValue")
        }
        return result
    }
    
}
