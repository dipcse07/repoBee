//
//  UserDefaults+Ext.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/03/24.
//

import Foundation
extension UserDefaults {
    static var shared: UserDefaults {
        UserDefaults(suiteName: "group.com.debuggerlab.repoWatcher")!
    }
    static let repoKey = "repos"
}
