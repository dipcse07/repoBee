//
//  Repository.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/02/27.
//

import Foundation
struct Repository {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    var avatarData: Data
    var contributors: [Contributor] = []
    
    
}
extension Repository {
    struct CodingData: Decodable {
        let name: String
        let owner: Owner
        let hasIssues: Bool
        let forks: Int
        let watchers: Int
        let openIssues: Int
        let pushedAt: String
        var repo: Repository {
            Repository(name: name, owner: owner, hasIssues: hasIssues, forks: forks, watchers: watchers, openIssues: openIssues, pushedAt: pushedAt, avatarData: Data())
        }
    }
}

struct Owner: Decodable {
    let avatarUrl:String
    
}
