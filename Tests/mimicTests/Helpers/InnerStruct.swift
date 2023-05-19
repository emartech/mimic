//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

struct InnerStruct: Decodable {
    let subStruct: SomeSubStruct
    let num: Int
    let floating: Double
    let bool: Bool
    let dict: [String: String]
    let array: [String]
}
