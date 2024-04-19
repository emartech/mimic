// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct InstanceGenerator {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let jsonFactory = JsonFactory(boolGenerator: BoolGenerator(), intGenerator: IntGenerator(), doubleGenerator: DoubleGenerator(), stringGenerator: StringGenerator())
    
    public func generate<T>(_ predefinedValues: [PartialKeyPath<T>: Encodable]?, _ encodables: [Encodable]?) throws -> T where T: Decodable {
        var result: T? = nil
        var json = Json.object([:])
        repeat {
            do {
                let jsonData = try encoder.encode(json)
                result = try decoder.decode(T.self, from: jsonData)
            } catch DecodingError.typeMismatch(let type, let context) {
                let value = try encodable(encodables, type) ?? jsonFactory.create(type)
                json[context.codingPath] = value
            } catch DecodingError.keyNotFound(let codingKey, let context) {
                var paths = context.codingPath
                paths.append(codingKey)
                let value = try predefinedValue(predefinedValues, paths.first!) ?? Json.string(StringGenerator().generate())
                json[paths] = value
            }
        } while result == nil
        guard let result = result else {
            throw MimicError.decodingFailed(message: "Instance creation failed")
        }
        return result
    }
    
    public func generate<T>(_ encodables: [Encodable]?) throws -> T where T: Decodable {
        return try generate(nil, encodables)
    }
    
    private func predefinedValue<T>(_ predefinedValues: [PartialKeyPath<T>: Encodable]?, _ codingKey: any CodingKey) throws -> Json? {
        return try predefinedValues?
            .first(where: { $0.key.propertyName == codingKey.stringValue })?
            .value.toJson(encoder, decoder)
    }
    
    private func encodable(_ encodables: [Encodable]?, _ type: any Any.Type) throws -> Json? {
        return try encodables?
            .first(where: { String(reflecting: $0).hasPrefix(String(reflecting: type)) })?
            .toJson(encoder, decoder)
    }
    
}
