//
//  Bundle.swift
//
//  Created by Alvin Ling on 5/16/20.
//  Copyright © 2020 Alvin Ling. All rights reserved.
//

import Foundation
    
enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    private static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey:key) else {
            throw Error.missingKey
        }

        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
    
    static var endpoint: URL { try! URL(string: value(for: .endpoint))! }
    
    static var targetName: String { try! value(for: .target) }
}

// MARK: - Private Text
private extension String {
    static let endpoint = "ENDPOINT_URL"
    static let target = "TARGET_NAME"
}
