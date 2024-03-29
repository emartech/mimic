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
    
    lazy var when = When<ReturnType>(fn: self)
    lazy var verify = Verify<ReturnType>(fn: self)
    
    public func invoke(_ fnName: String = #function, params: Any...) throws -> ReturnType {
        let log: FnLogEntry<ReturnType> = FnLogEntry()
        guard let function = self.function else {
            throw MimicError.incompleteMimicking
        }
        self.name = fnName
        invocationCount += 1
        let params = Params(elements: params.map { Value(value: $0) })
        let result = try function(invocationCount, params)
        log.end(args: params, result: result)
        logs.append(log)
        return result
    }

}
