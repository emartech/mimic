// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Array where Element == Any {
    
    mutating func update(_ value: Any, _ path: [CodingKey]) throws {
        guard let index = path.first?.intValue as? Int else {
            throw MimicError.decodingFailed // TODO: error handling
        }
        if path.count > 1 {
            let subValue = self[index]
            var nextPath = path
            nextPath.removeFirst()
            if var subDict = subValue as? [String: Any] {
                try subDict.update(value, nextPath)
                self[index] = subDict
            } else if var subArray = subValue as? [Any] {
                try subArray.update(value, nextPath)
                self[index] = subArray
            } else {
                throw MimicError.decodingFailed // TODO: error handling
            }
        } else {
            self[index] = value
        }
    }
    
}
