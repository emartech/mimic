//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

extension String {
    
    func words() -> [String] {
        let regex = try! Regex(#"\w+"#)
        let matches = self.matches(of: regex).map { match in
            return String(self[match.range])
        }
        return matches
    }
}
