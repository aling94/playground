//
//  Bundle.swift
//  ConfigTest
//
//  Created by Alvin Ling on 7/13/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

extension Bundle {
    
    var appVersion: String {
        object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }
}
