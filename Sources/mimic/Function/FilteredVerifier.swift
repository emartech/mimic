//
//
// Copyright © 2024 Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

public class FilteredVerifier<ReturnType>: TimesVerifiable, ThreadVerifiable {
    
    private let fn: Fn<ReturnType>
    private let logs: [FnLogEntry<ReturnType>]
    private let args: [any Matcher]
    
    init(fn: Fn<ReturnType>, logs: [FnLogEntry<ReturnType>], args: [any Matcher]) {
        self.fn = fn
        self.logs = logs
        self.args = args
    }
    
    func times(times: Times) throws -> Self {
        guard !self.logs.isEmpty else {
            throw MimicError.zeroInteractions(functionName: self.fn.name)
        }
        switch times {
        case .zero:
            let callCount = self.logs.count
            guard callCount == 0 else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("zero", callCount))
            }
        case .eq(let num):
            let callCount = self.logs.count
            guard callCount == num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("exactly(\(num))", callCount))
            }
        case .atLeast(let num):
            let callCount = self.logs.count
            guard callCount >= num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("atLeast(\(num))", callCount))
            }
        case .max(let num):
            let callCount = self.logs.count
            guard callCount <= num else {
                throw MimicError.verificationFailed(message: self.invocationCountFailedMessage("max(\(num))", callCount))
            }
        }
        return self
    }
    
    func on(thread: Thread) throws -> Self {
        guard !self.logs.isEmpty else {
            throw MimicError.zeroInteractions(functionName: self.fn.name)
        }
        let threadName = String(describing: thread)
        let logThreads = Set(self.logs.map({ $0.thread }))
        if logThreads.count == 1 {
            if let logThread = logThreads.first, logThread != threadName {
                throw MimicError.verificationFailed(message: "Expected thread: `\(threadName)`, but was: `\(logThread)`")
            }
        } else {
            throw MimicError.verificationFailed(message: "Expected thread: `\(threadName)`, but was: `\(logThreads)`")
        }
        return self
    }
    
    private func invocationCountFailedMessage(_ expected: String, _ callCount: Int) -> String {
        "Expected `\(expected)` invocation on function(\(String(describing: self.fn.name!)), but was: `\(callCount)`"
    }
}
