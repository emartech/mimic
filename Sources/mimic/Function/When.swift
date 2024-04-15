// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class When<ReturnType> {
    
    private var fn: Fn<ReturnType>
    private var matchers: [any Matcher]?
    
    init(fn: Fn<ReturnType>) {
        self.fn = fn
    }
    
    public func calledWith(_ args: any Matcher...) -> When<ReturnType> {
        self.matchers = args.map { $0 }
        return self
    }
    
    public func thenReturn(_ result: ReturnType) {
        fn.function = { [unowned self] _, params in
            try self.validateParams(params)
            return result
        }
    }
    
    public func thenReturns(_ results: ReturnType...) {
        fn.function = { [unowned self] invocationCount, params in
            try self.validateParams(params)
            guard invocationCount <= results.count else {
                throw MimicError.missingResult
            }
            return results[invocationCount - 1]
        }
    }
    
    public func thenThrow<ErrorType>(error: ErrorType) where ErrorType: Error {
        fn.function = { _, _ in
            throw error
        }
    }
    
    public func replaceFunction(_ replaceFunction: @escaping (_ invocationCount: Int, _ params: Params?) throws -> (ReturnType)) {
        fn.function = { [unowned self] invocationCount, params in
            try self.validateParams(params)
            return try replaceFunction(invocationCount, params)
        }
    }
    
    fileprivate func validateParams(_ params: Params?) throws {
        if let params {
            if let matchers = self.matchers {
                for (index, wrappedValue) in params.elements.enumerated() {
                    let matcher = matchers[index]
                    try matcher.evaluate(arg: wrappedValue.value)
                }
            }
        }
    }
    
}
