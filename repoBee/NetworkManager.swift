//
//  NetworkManager.swift

//
//  Created by MD SAZID HASAN DIP on 2023/02/28.
//

import Foundation
class NetworkManager {
    static let shared = NetworkManager()
    
   // let theme: SelectSingleRepoIntent.repo
    let decoder = JSONDecoder()
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
    }
    
    func getRepo(atUrl urlString: String) async throws -> Repository {
        guard let url = URL (string: urlString) else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let codingData = try decoder.decode(Repository.CodingData.self, from: data)
            return codingData.repo
        }catch {
            throw NetworkError.invalidRepoData
        }
        
    }
    
    func getCommitsAndDates(atUrl urlString: String) async throws -> [String: Int]{
        guard let url = URL (string: urlString) else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        var commitsByDate: [String: Int] = [:]
        do {
            if let commits = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                var calender = Calendar.current
                for commit in commits {
                    if let dateString = (commit["commit"] as? [String: Any])?["author"] as? [String: Any]? {
                        
                        //      print(dateString)
                        let dateStr = dateString!["date"] as! String// Extract YYYY-MM-DD
                        //print(dateStr)
                        let formatter = ISO8601DateFormatter()
                        
                        let lastActivityDate = formatter.date(from: dateStr ) ?? .now
                        let dateComponent =  calender.dateComponents([.year, .month, .day], from: lastActivityDate)
                        
                        let extractedDateString = String(format: "%04d-%02d-%02d", dateComponent.year!, dateComponent.month!, dateComponent.day!)
                        
                        
                        if let count = commitsByDate[extractedDateString] {
                            commitsByDate[extractedDateString] = count + 1
                        } else {
                            commitsByDate[extractedDateString] = 1
                        }
                    }
                }
               
            }
            print(commitsByDate)
            return commitsByDate
        } catch {
            print("Error:", error.localizedDescription)
            throw NetworkError.invalidRepoData
        }
        
    }
    
    func getContributors(atUrl urlString: String) async throws -> [Contributor] {
        guard let url = URL (string: urlString) else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        do {
            let codingData = try decoder.decode([Contributor.CodingData].self, from: data)
            return codingData.map{$0.contributor}
        }catch {
            throw NetworkError.invalidRepoData
        }
        
    }
    
    func downloadImageData(from urlString: String ) async -> Data? {
        guard let url = URL(string: urlString) else {return nil}
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        }catch {
            return nil
        }
    }
}

enum NetworkError:Error {
    case invalidUrl
    case invalidResponse
    case invalidRepoData
    
}

enum RepoUrl {
    static let prefix = "https://api.github.com/repos/"
    static let swiftNews = "https://api.github.com/repos/sallen0400/swift-news"
    static let publish = "https://api.github.com/repos/johnsundell/publish"
    static let googleSignIn = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
