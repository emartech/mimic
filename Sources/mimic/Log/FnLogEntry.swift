//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation

class FnLogEntry<ReturnType> {
    let startTimestamp = Date()
    let thread = String(describing: Thread.current)
    let callStack = Thread.callStackSymbols
    
    var args: Params!
    var result: ReturnType!
    var endTimestamp: Date!
    
    func end(args: Params, result: ReturnType) {
        self.args = args
        self.result = result
        self.endTimestamp = Date()
    }
}
