//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation
@testable import mimic

final class MimickedClass: Mimic {
    
    let fwr = Fn<()>()
    let fwor = Fn<String?>()
    let fwa = Fn<()>()
    
    func functionWithoutResult() throws {
        try fwr.invoke()
    }
    
    func functionWithOptionalResult() throws -> String? {
        try fwor.invoke()
    }
    
    func functionWithArgs(arg1: String, arg2: Int, arg3: Bool?, arg4: TestStruct) {
        try! fwa.invoke(params: arg1, arg2, arg3 as Any, arg4)
    }
    
}
