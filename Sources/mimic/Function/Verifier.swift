// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class Verifier<ReturnType>: TimesVerifiable, ThreadVerifiable {
    
    private var fn: Fn<ReturnType>
    
    init(fn: Fn<ReturnType>) {
        self.fn = fn
    }
    
    public func wasCalled(_ args: any Matcher...) throws -> FilteredVerifier<ReturnType> {
        guard !self.fn.logs.isEmpty else {
            throw MimicError.zeroInteractions(functionName: self.fn.name)
        }
        guard !args.isEmpty else {
            throw MimicError.missingMatcher
        }
        let logs = self.fn.logs.filter { log in
            guard let params = log.args else {
                return false
            }
            return params.elements.enumerated().contains { index, wrappedValue in
                do {
                    try args[index].evaluate(arg: wrappedValue.value)
                    return true
                } catch {
                    return false
                }
            }
        }
        if logs.isEmpty {
            try self.fn.logs
                .filter({ $0.args != nil })
                .forEach({ log in
                    _ = try log.args!.elements.enumerated().contains { index, wrappedValue in
                        try args[index].evaluate(arg: wrappedValue.value)
                        return false
                    }
                })
        }
        return FilteredVerifier(fn: fn, logs: logs, args: args)
    }
    
    public func on(thread: Thread) throws -> Self {
        guard !self.fn.logs.isEmpty else {
            throw MimicError.zeroInteractions(functionName: self.fn.name)
        }
        let threadName = String(describing: thread)
        let logThreads = Set(self.fn.logs.map({ $0.thread }))
        if logThreads.count == 1 {
            if let logThread = logThreads.first, logThread != threadName {
                throw MimicError.verificationFailed(message: "Expected thread: `\(threadName)`, but was: `\(logThread)`")
            }
        } else {
            throw MimicError.verificationFailed(message: "Expected thread: `\(threadName)`, but was: `\(logThreads)`")
        }
        return self
    }
    
    public func times(times: Times) throws -> Self {
        guard !self.fn.logs.isEmpty else {
            throw MimicError.zeroInteractions(functionName: self.fn.name)
        }
        switch times {
        case .zero:
            let callCount = self.fn.logs.count
            guard callCount == 0 else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("zero", callCount))
            }
        case .eq(let num):
            let callCount = self.fn.logs.count
            guard callCount == num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("exactly(\(num))", callCount))
            }
        case .atLeast(let num):
            let callCount = self.fn.logs.count
            guard callCount >= num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("atLeast(\(num))", callCount))
            }
        case .max(let num):
            let callCount = self.fn.logs.count
            guard callCount <= num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("max(\(num))", callCount))
            }
        }
        return self
    }
    
    private func invocationCountFailedMessage(_ expected: String, _ callCount: Int) -> String {
        "Expected `\(expected)` invocation on function(\(String(describing: self.fn.name!)), but was: `\(callCount)`"
    }
    
}
