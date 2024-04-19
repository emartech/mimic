// Copyright © 2024. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2024 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol Factory {
    
    associatedtype Value
    associatedtype ResultType
    
    func create(_ create: Value) throws -> ResultType
    
}
