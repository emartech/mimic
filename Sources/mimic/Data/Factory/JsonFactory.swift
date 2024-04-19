// Copyright © 2024. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2024 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct JsonFactory<BoolGenerator: ValueGenerator, 
                        IntGenerator: ValueGenerator,
                     DoubleGenerator: ValueGenerator,
                   StringGenerator: ValueGenerator>: Factory where
BoolGenerator.ValueType == Bool,
IntGenerator.ValueType == Int,
DoubleGenerator.ValueType == Double,
StringGenerator.ValueType == String {
    
    let boolGenerator: BoolGenerator
    let intGenerator: IntGenerator
    let doubleGenerator: DoubleGenerator
    let stringGenerator: StringGenerator
    
    func create(_ type: Any.Type) throws -> Json {
        let typeNames = String(describing: type).words()
        return try generate(typeNames)
    }
    
    func generate(_ typeNames: [String]) throws -> Json {
        guard let type = typeNames.first else {
            throw MimicError.decodingFailed(message: "typeNames is empty.")
        }
        var result: Json!
        switch type {
        case "Bool":
            result = Json.bool(boolGenerator.generate())
        case "Int":
            result = Json.int(intGenerator.generate())
        case "Double":
            result = Json.double(doubleGenerator.generate())
        case "String":
            result = Json.string(stringGenerator.generate())
        case "Array":
            guard typeNames.count >= 2 else {
                throw MimicError.decodingFailed(message: "Array type is not available")
            }
            result = Json.array([try generate(Array(typeNames.dropFirst()))])
        case "Dictionary":
            guard typeNames.count >= 3 else {
                throw MimicError.decodingFailed(message: "Dictionary type is not available")
            }
            result = Json.object([stringGenerator.generate(): try generate(Array(typeNames.dropFirst(2)))])
        default:
            result = Json.object([stringGenerator.generate(): Json.string(stringGenerator.generate())])
        }
        return result
    }
    
}
