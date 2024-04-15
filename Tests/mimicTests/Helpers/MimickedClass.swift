// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
// SPDX-FileCopyrightText: 2023 Emarsys-Technologies Kft.
//
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import mimic

final class MimickedClass: Mimic {
    
    typealias ErrorClosure = (Error) -> ()
    
    let fwr = Fn<()>()
    let fwor = Fn<String?>()
    let fwa = Fn<()>()
    let fwar = Fn<String>("defaultResult")
    let fwcar = Fn<String>()
    
    func functionWithoutResult() throws {
        try fwr.invoke()
    }
    
    func functionWithOptionalResult() throws -> String? {
        try fwor.invoke()
    }
    
    func functionWithArgs(arg1: String, arg2: Int, arg3: Bool?, arg4: TestStruct) {
        try! fwa.invoke(params: arg1, arg2, arg3 as Any, arg4)
    }
    
    func functionWithArg(arg: String?) throws -> String {
        try fwar.invoke(params: arg as Any)
    }
    
    func functionWithCArg(completion: @escaping ErrorClosure) async throws -> String {
        try fwcar.invoke(params: completion)
    }
}
