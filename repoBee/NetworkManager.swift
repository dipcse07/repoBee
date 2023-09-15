//
//  NetworkManager.swift

//
//  Created by MD SAZID HASAN DIP on 2023/02/28.
//

import Foundation
import OrderedCollections
import NetworkKit
import SwiftUI

class NetworkManager {
    static let shared = NetworkManager()
    
   // let theme: SelectSingleRepoIntent.repo
    let decoder = JSONDecoder()
    let configuration = SelectSingleRepoIntent()
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
    }
    
    
    var theme: Theme {
        configuration.theme
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
    
    
    
    func getColorsFromCommitsAndDates(atUrl urlString: String) async throws -> [[Color]] {
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
                let calender = Calendar.current
                for commit in commits {
                    if let dateString = (commit["commit"] as? [String: Any])?["author"] as? [String: Any]? {
                        
                        //      print(dateString)
                        let dateStr = dateString!["date"] as! String// Extract YYYY-MM-DD
                      //  print(dateStr)
                        
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
            
            //print(commitsByDate)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let sortedKeys = commitsByDate.keys.sorted {
                if let date1 = dateFormatter.date(from: $0), let date2 = dateFormatter.date(from: $1) {
                   // print("date 1: ", date1," date2: ", date2)
                    return date1 < date2
                }
                return false
            }

            // Create a sorted dictionary
           
            var sortedDictionary: OrderedDictionary<String,Int> = [:]
            for key in sortedKeys {
                sortedDictionary[key] = commitsByDate[key]
                
            }
            
            //MARK: Get number of dates
            
            var numberOfDays = 0
            let startDateString = sortedDictionary.keys.first ?? ""
            let endDateString = sortedDictionary.keys.last ?? ""

            if let startDate = dateFormatter.date(from: startDateString),
               let endDate = dateFormatter.date(from: endDateString) {
                let calendar = Calendar.current
                let components = calendar.dateComponents([.day], from: startDate, to: endDate)
                
                if let days = components.day {
                    print("Number of days between \(startDateString) and \(endDateString): \(days) days")
                    numberOfDays = days
                } else {
                    print("Unable to calculate the number of days.")
                }
            } else {
                print("Invalid date format.")
            }
            
            numberOfDays = numberOfDays > 140 ? 140: numberOfDays
            
            let startDateFrom = endDateString
            var currentDate = dateFormatter.date(from: startDateFrom)!

            var dateArray: [Date] = []

            // Generate dates and add them to the array
            for _ in 0..<numberOfDays {
                dateArray.append(currentDate)
                currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
            }

            // Reverse the array to have the dates in ascending order
           // print(dateArray)
            dateArray.reverse()

            // Print the sorted array of dates
            var sortedDictionary2: OrderedDictionary<String,Int> = [:]
            for date in dateArray {
                let key = dateFormatter.string(from: date)
                if sortedDictionary.keys.contains(key) {
                    sortedDictionary2[key] = sortedDictionary[key]
                }else {
                    sortedDictionary2[key] = 0
                }
            }
            
            print(sortedDictionary2)
            
            
            let values = sortedDictionary2.values.map({ value in
                return [theme.color(for: GitHub.Contribution.Level(rawValue: value) ?? .zero)]
            })
           
            return values //commitsByDate
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
