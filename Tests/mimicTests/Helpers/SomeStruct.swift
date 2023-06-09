// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct SomeStruct: Decodable {
    let text: String
    let num: Int
    let floating: Double
    let bool: Bool
    var dict: [String: String]
    let array: [String]
    let inner: InnerStruct
    let arrayInner: [InnerStruct]
    let dictInner: [String: InnerStruct]
    let someEnum: SomeEnum
    let optional: String?
}
