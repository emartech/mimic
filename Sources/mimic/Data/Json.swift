// Copyright © 2024. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2024 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum Json: Codable, Equatable {
    
    case string(String)
    case int(Int)
    case double(Double)
    case bool(Bool)
    case object([String: Json])
    case array([Json])
    case `nil`
    
    nonisolated init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(String.self) {
            self = .string(value)
        } else if let value = try? container.decode(Int.self) {
            self = .int(value)
        } else if let value = try? container.decode(Double.self) {
            self = .double(value)
        } else if let value = try? container.decode(Bool.self) {
            self = .bool(value)
        } else if let value = try? container.decode([String: Json].self) {
            self = .object(value)
        } else if let value = try? container.decode([Json].self) {
            self = .array(value)
        } else if container.decodeNil() {
            self = .nil
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode Json value")
        }
    }
    
    nonisolated func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let value): try container.encode(value)
        case .int(let value): try container.encode(value)
        case .double(let value): try container.encode(value)
        case .bool(let value): try container.encode(value)
        case .object(let value): try container.encode(value)
        case .array(let value): try container.encode(value)
        case .nil: try container.encodeNil()
        }
    }
    
}

extension Json {
    
    subscript(codingKeys: [CodingKey]) -> Json? {
        get {
            guard let key = codingKeys.first, let jsonValue = jsonValue(key) else {
                return nil
            }
            return codingKeys.count > 1 ? jsonValue[Array(codingKeys.dropFirst())] : jsonValue
        }
        set(newValue) {
            guard let key = codingKeys.first else {
                return
            }
            if codingKeys.count > 1 {
                let codingPath = Array(codingKeys.dropFirst())
                var jsonValue = self[[key]]
                jsonValue?[codingPath] = newValue
                self[[key]] = jsonValue
            } else {
                setJsonValue(key, newValue)
            }
        }
    }
    
    private func jsonValue(_ codingKey: CodingKey) -> Json? {
        var result: Json? = nil
        if let index = codingKey.intValue, case let .array(array) = self {
            result = array[index]
        } else if case let .object(dictionary) = self, let jsonValue = dictionary[codingKey.stringValue] {
            result = jsonValue
        }
        return result
    }
    
    private mutating func setJsonValue(_ codingKey: CodingKey, _ jsonValue: Json?) {
        if let index = codingKey.intValue, case var .array(array) = self, let jsonValue {
            array[index] = jsonValue
            self = .array(array)
        } else if case var .object(dictionary) = self {
            dictionary[codingKey.stringValue] = jsonValue
            self = .object(dictionary)
        }
    }
    
}
