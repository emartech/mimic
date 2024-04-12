// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension String {
    
    func words() -> [String] {
        var results = [String]()
        let range = NSRange(location: 0, length: self.count)
        let regex = try! NSRegularExpression(pattern: #"(\w+)"#)
        let matches = regex.matches(in: self, options: [], range: range)
        
        for match in matches {
            if let range = Range(match.range(at: 1), in: self) {
                results.append(String(self[range]))
            }
        }
        return results
    }
}
