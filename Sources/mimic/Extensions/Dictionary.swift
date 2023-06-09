// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Dictionary where Key == String, Value == Any {
    
    mutating func update(_ value: Any, _ path: [CodingKey]) throws {
        if path.count > 1 {
            let key = path.first!.stringValue
            let subValue = self[key]
            var nextPath = path
            nextPath.removeFirst()
            if var subDict = subValue as? [Key: Value] {
                try subDict.update(value, nextPath)
                self[key] = subDict
            } else if var subArray = subValue as? [Any] {
                try subArray.update(value, nextPath)
                self[key] = subArray
            } else {
                throw MimicError.decodingFailed // TODO: error handling
            }
        } else {
            guard let key = path.last?.stringValue else {
                throw MimicError.decodingFailed // TODO: error handling
            }
            self[key] = value
        }
    }
}
