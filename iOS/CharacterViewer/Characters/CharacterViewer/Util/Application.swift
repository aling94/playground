//
//  Application.swift
//  Simpsons
//
//  Created by Alvin Ling on 5/31/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import UIKit

extension UIApplication {
    
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
