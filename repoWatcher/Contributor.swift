//
//  Contributor.swift
//  repoWatcher
//
//  Created by MD SAZID HASAN DIP on 2023/03/14.
//

import Foundation
struct Contributor: Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl:String
    let contributions:Int
    let avatarData:Data
    
}
extension Contributor {
    struct CodingData: Decodable {
        let login: String
        let avatarUrl:String
        let contributions:Int
        
        var contributor:Contributor {
            return Contributor(login: login, avatarUrl: avatarUrl, contributions: contributions, avatarData: Data())
        }
    }
}
