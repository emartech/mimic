// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

class Props: Equatable {
    
    typealias Brace = (String, Any)
    
    private let braces: [Brace]
    
    private lazy var labels: [String] = {
        return braces.map({ $0.0 })
    }()
    
    private lazy var values: [Any] = {
        return braces.map({ $0.1 })
    }()
    
    init(subject: Any) {
        var mirror: Mirror!
        if let mirrored = subject as? Mirrored {
            mirror = mirrored.mirrored
        } else if let reflectable = subject as? CustomReflectable {
            mirror = reflectable.customMirror
        } else {
            mirror = Mirror(reflecting: subject)
        }
        braces = mirror.children
            .filter { child in
                return !(child.value is (any MimickedFunction))
            }
            .map({
                Brace($0.label!, $0.value)
            })
    }
    
    subscript(label: String) -> Any? {
        get {
            return braces.first(where: { $0.0 == label })?.1
        }
    }
    
    static func == (lhs: Props, rhs: Props) -> Bool {
        let ll = Set(lhs.labels)
        let rl = Set(rhs.labels)
        let lva = lhs.values.map({ String(describing: $0) })
        let rva = rhs.values.map({ String(describing: $0) })
        let lv = Set(lva)
        let rv = Set(rva)
        return ll == rl && lv == rv
    }
    
}

protocol Mirrored {
    
    var mirrored: Mirror { get }
    
}

extension Dictionary: Mirrored {
    
    var mirrored: Mirror {
        let children = self.map { element in
            var key: String
            var value: Any
            if let k = element.key as? String {
                key = k
            } else {
                key = String(describing: element.key)
            }
            
            if let v = element.value as? Optional<Any> {
                switch v {
                case Optional.some(let wrapped):
                    value = wrapped
                default:
                    value = element.value
                }
            } else {
                value = element.value
            }
            return Mirror.Child(key, value)
        }
        return Mirror(self, children: children, displayStyle: .struct)
    }
    
    func toProps() -> Props {
        Props(subject: self)
    }
    
}
