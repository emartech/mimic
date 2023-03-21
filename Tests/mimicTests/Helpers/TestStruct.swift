//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//

import Foundation
@testable import mimic

struct TestStruct: Mimic {

    let fnId = Fn<String>()
    
    let boolValue = true
    let wholeValue = 42
    let floatingValue = 3.1415926535897
    let stringValue = "Oh, yeah. Oooh, ahhh, that's how it always starts. Then later there's running and um, screaming."
    let array = [true, false, true]
    let dict = ["key": "value"]
    let optionalNil: String? = nil
    
    func fnForTest() -> String {
        return try! fnId.invoke()
    }
    
}
