//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

class Verify<ReturnType> {
    
    private var fn: Fn<ReturnType>
    
    init(fn: Fn<ReturnType>) {
        self.fn = fn
    }
    
    func wasCalled(_ args: any Matcher...) throws -> Verify<ReturnType> {
        guard let params = self.fn.logs.last?.args else {
            throw MimicError.verificationFailed
        }
        for (index, wrappedValue) in params.elements.enumerated() {
            let matcher = args[index]
            try matcher.evaluate(arg: wrappedValue.value)
        }
        return self
    }
    
    func times(times: Times) throws -> Verify<ReturnType> {
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
