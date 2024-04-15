// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol TimesVerifiable {
    
    func times(times: Times) throws -> Self
    
}

public enum Times {
    case zero
    case eq(Int)
    case atLeast(Int)
    case max(Int)
}
