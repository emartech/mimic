//
//
// Copyright © 2023. Emarsys-Technologies Kft. All rights reserved.
//
        

import Foundation

enum TestError: Error, Equatable{
    case magicWord
}

extension TestError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .magicWord:
            return NSLocalizedString("Uh uh uh! You didn't say the magic word! Uh uh uh! Uh uh uh!", comment: "Uh uh uh!")
        }
    }
}
