// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

enum MimicError: Error {
    case incompleteMimicking
    case missingResult
    case missingMatcher
    case argumentMismatch
    case verificationFailed
    case decodingFailed
}
