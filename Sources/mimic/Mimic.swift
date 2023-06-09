// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol Mimic: Equatable {

    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> When<ReturnType>
    
    func verify<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> Verify<ReturnType>
    
    func props() -> Props
    
}

extension Mimic {

    func when<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> When<ReturnType> {
        let mimicked = self[keyPath: fnKeyPath]
        return mimicked.when
    }
    
    func verify<ReturnType>(_ fnKeyPath: KeyPath<Self, Fn<ReturnType>>) -> Verify<ReturnType> {
        let mimicked = self[keyPath: fnKeyPath]
        return mimicked.verify
    }
    
    func props() -> Props {
        return Props(subject: self)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.props() == rhs.props()
    }
    
}
