//
//  MockData.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/03/13.
//

import Foundation
struct MockData {
    static let repoOne = Repository(name: "Your repo 1",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: true,
                                        forks: 0,
                                        watchers: 0,
                                        openIssues: 0,
                                        pushedAt: "2023-02-27",
                                    
                                        avatarData: Data(),
                                    
                                    contributors: [
                                        Contributor(login: "Sean allan", avatarUrl: "", contributions: 43, avatarData: Data()),
                                        Contributor(login: "Michael Jordan ", avatarUrl: "", contributions: 22, avatarData: Data()),
                                        Contributor(login: "Steph Carry", avatarUrl: "", contributions: 34, avatarData: Data()),
                                        Contributor(login: "Rabab Shayra", avatarUrl: "", contributions: 43, avatarData: Data())
                                    ],
                                    colors: Array(repeating: [.green], count: 140)
    )
    static let repoTwo = Repository(name: "Your repo 2",
                                        owner: Owner(avatarUrl: ""),
                                        hasIssues: false,
                                        forks: 20,
                                        watchers: 330,
                                        openIssues: 10,
                                        pushedAt: "2023-02-27",
                                        avatarData: Data()
    )
}
