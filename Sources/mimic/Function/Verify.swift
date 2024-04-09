// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class Verify<ReturnType> {
    
    private var fn: Fn<ReturnType>
    private var log: FnLogEntry<ReturnType>?
    
    init(fn: Fn<ReturnType>, log: FnLogEntry<ReturnType>?) {
        self.fn = fn
        self.log = log
    }
    
    public func wasCalled(_ args: any Matcher...) throws -> Verify<ReturnType> {
        guard let log = log else {
            throw MimicError.verificationFailed
        }
        if args.count > 0 {
            guard let params = log.args else {
                throw MimicError.verificationFailed
            }
            for (index, wrappedValue) in params.elements.enumerated() {
                let matcher = args[index]
                try matcher.evaluate(arg: wrappedValue.value)
            }
        }
        return self
    }
    
    public func on(thread: Thread) throws -> Verify<ReturnType> {
        guard let log = log else {
            throw MimicError.verificationFailed
        }
        guard String(describing: thread) == log.thread else {
            throw MimicError.verificationFailed
        }
        return self
    }
    
    public func times(times: Times) throws -> Verify<ReturnType> {
        switch times {
        case .zero:
            guard self.fn.logs.count == 0 else {
                throw MimicError.verificationFailed
            }
        case .eq(let num):
            guard self.fn.logs.count == num else {
                throw MimicError.verificationFailed
            }
        case .atLeast(let num):
            guard self.fn.logs.count >= num else {
                throw MimicError.verificationFailed
            }
        case .max(let num):
            guard self.fn.logs.count <= num else {
                throw MimicError.verificationFailed
            }
        }
        return self
    }
    
}
