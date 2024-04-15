//
//
// Copyright © 2024 Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

protocol ThreadVerifiable {
    
    func on(thread: Thread) throws -> Self
    
}
