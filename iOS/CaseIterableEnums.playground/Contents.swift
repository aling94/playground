import UIKit

enum EnumA: CaseIterable {
    
    case caseZ
    case caseB
    case caseC
    case caseA
    
}


EnumA.allCases.firstIndex(of: .caseZ) == 0

"asdf".compare("ASDF") == .orderedSame

"asdf".compare("ASDF", options: .caseInsensitive) == .orderedSame
