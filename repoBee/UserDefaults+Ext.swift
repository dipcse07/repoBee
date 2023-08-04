//
//  UserDefaults+Ext.swift

//
//  Created by MD SAZID HASAN DIP on 2023/03/24.
//

import Foundation
extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.com.debuggerlab.repoBee")!
    }
    static let repoKey = "repos"
}


enum UserDefaultsError: Error {
    case retrieval
}
