//
//  Bundle.swift
//
//  Created by Alvin Ling on 5/16/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation

extension Bundle {
    
    func path(for resource: Resource.Name, type: Resource.Ext) -> String? {
        path(forResource: resource.rawValue, ofType: type.rawValue)
    }
    
    func infoPListItem<T>(key: String) -> T {
        let path = self.path(for: .info, type: .plist)!
        let list = NSDictionary(contentsOfFile: path)!
        return list.value(forKey: key) as! T
    }
    
    var targetName: String { infoPListItem(key: .target) }
    
    var endpoint: URL { URL(string: infoPListItem(key: .endpoint))! }
}

// MARK: - Private Text
private extension String {
    static let endpoint = "ENDPOINT_URL"
    static let target = "TARGET_NAME"
}

enum Resource {
    
    enum Name: String {
        case info = "Info"
    }
    
    enum Ext: String {
        case plist
    }
}
