// Copyright © 2024. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2024 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Encodable {
    
    func toJson(_ encoder: JSONEncoder, _ decoder: JSONDecoder) throws -> Json? {
        let encodedSelf = try encoder.encode(self)
        return try decoder.decode(Json.self, from: encodedSelf)
    }
    
}
