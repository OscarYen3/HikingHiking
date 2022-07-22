//
//  Common.swift
//  Hiking
//
//  Created by Oscar Yen on 2022/7/22.
//  Copyright © 2022 OscarYen. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    private enum Key : String {
        case myToken    = "MyToken"
    }
    
    static var myToken: String? {
        get {
            let defs = UserDefaults.standard
            return defs.string(forKey: Key.myToken.rawValue)
        }
        set(value) {
            let defs = UserDefaults.standard
            if let value = value {
                defs.set(value, forKey: Key.myToken.rawValue)
                return
            }
            defs.removeObject(forKey: Key.myToken.rawValue)
        }
    }
}
