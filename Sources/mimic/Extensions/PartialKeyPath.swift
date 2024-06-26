// Copyright © 2024. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2024 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension PartialKeyPath {
    
    var propertyName: String {
        String(describing: self).words().last!
    }
    
}
