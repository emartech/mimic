//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//


import Foundation

protocol Matcher: ValueContainer {
    
    func evaluate<Argument>(arg: Argument) throws
    
}
