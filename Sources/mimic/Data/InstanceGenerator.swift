// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct InstanceGenerator {
    
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    private let valueGeneratorFactory = ValueGeneratorFactory()
    
    public func generate<T>(_ predefinedValues: [PartialKeyPath<T>: Encodable]?, encodables: [Encodable]?) throws -> T where T: Decodable {
        var result: T? = nil
        var structure = [String: Any]()
        repeat {
            do {
                let structureData = try JSONSerialization.data(withJSONObject: structure, options: .prettyPrinted)
                result = try decoder.decode(T.self, from: structureData)
            } catch DecodingError.typeMismatch(let type, let context) {
                let value = try encodables?
                    .filter { String(reflecting: $0).hasPrefix(String(reflecting: type)) }
                    .map { try JSONSerialization.jsonObject(with: try encoder.encode($0), options: []) as! [String: Any] }
                    .first ?? valueGeneratorFactory.create(type).generate()
                try structure.update(value, context.codingPath)
            } catch DecodingError.keyNotFound(let codingKey, let context) {
                var paths = context.codingPath
                paths.append(codingKey)
                let value = predefinedValues?.first { $0.key.propertyName == paths.first!.stringValue }?.value ?? StringGenerator().generate()
                try structure.update(value, paths)
            }
        } while result == nil
        guard let result = result else {
            throw MimicError.decodingFailed
        }
        return result
    }
    
    public func generate<T>(_ encodables: [Encodable]?) throws -> T where T: Decodable {
        return try generate(nil, encodables: encodables)
    }
    
}
