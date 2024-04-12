// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class Fn<ReturnType>: MimickedFunction {
    
    public init() {
    }

    public var name: String!
    public var function: ((_ invocationCount: Int, _ params: Params) throws -> (ReturnType))?
    public var invocationCount: Int = 0
    public var logs: [FnLogEntry<ReturnType>] = []
    private var verificationCount = 0
    
    lazy var when = When<ReturnType>(fn: self)
    
    var verify: Verify<ReturnType> {
        get {
            var log: FnLogEntry<ReturnType>? = nil
            if verificationCount < logs.count {
                log = logs[verificationCount]
            }
            verificationCount += 1
            return Verify<ReturnType>(fn: self, log: log)
        }
    }
    
    public func invoke(_ fnName: String = #function, params: Any...) throws -> ReturnType {
        let log: FnLogEntry<ReturnType> = FnLogEntry()
        defer {
            logs.append(log)
        }
        guard let function = self.function else {
            throw MimicError.incompleteMimicking
        }
        self.name = fnName
        invocationCount += 1
        let params = Params(elements: params.map { Value(value: $0) })
        var result: ReturnType
        do {
            result = try function(invocationCount, params)
            log.end(args: params, result: result)
        } catch {
            log.end(args: params, result: nil)
            throw error
        }
        return result
    }

}
