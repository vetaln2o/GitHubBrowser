//
//  GitJSONModel.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import Foundation

enum ControllerType {
    case browse
    case search
}

struct RepositoryDetail: Decodable {
    var html_url: String
    var full_name: String
    var description: String?
    var updated_at: String?
    var language: String?
    var stargazers_count: Int?
    var forks_count: Int?
    var owner: Owner
    
    struct  Owner: Decodable {
        var avatar_url: String
    }
    
}

struct RepositorySearch: Decodable {
    var items: [RepositoryDetail]
}

class GetRepositoryURL {
    
    var repositoryListArray = [RepositoryDetail]()
    
    func getRepositoryArray(controllerType: ControllerType, urlString: String, completion: @escaping ([RepositoryDetail]) -> Void) {
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("DATA is EMPTY!")
                return
            }
            guard error == nil else {
                print(error!)
                return
            }
            do {
                if controllerType == .browse {
                    let result = try JSONDecoder().decode([RepositoryDetail].self, from: data!)
                    completion(result)
                } else if controllerType == .search {
                    let result = try JSONDecoder().decode(RepositorySearch.self, from: data!)
                    completion(result.items)
                }

            } catch let error {
                print(error)
            }
            }.resume()
        
    }
    
    init(controllerType: ControllerType, url: String) {
        getRepositoryArray(controllerType: controllerType, urlString: url) { (result) in
            for i in result.indices {
                self.repositoryListArray.append(result[i])
            }
        }
    }
    
    init() {
        self.repositoryListArray = [RepositoryDetail]()
    }
    
    public func getUpdateDate(stringData: inout String) -> String {
        var resultUpdatesAgo = "Updated "
        
        stringData.removeLast()
        var temp = stringData.split(separator: "T")
        stringData = temp[0]+" "+temp[1]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dataFromString = formatter.date(from: stringData)!
        
        var difference : (years:Int, days:Int, hours:Int)
        
        difference.years = Calendar.current.dateComponents([.year], from: dataFromString, to: Date()).year!
        difference.days = Calendar.current.dateComponents([.day], from: dataFromString, to: Date()).day!
        difference.hours = Calendar.current.dateComponents([.hour], from: dataFromString, to: Date()).hour!
        
        switch difference {
        case (let year,_,_) where year == 1: resultUpdatesAgo += "a year ago"
        case (let year,_,_) where year > 1: resultUpdatesAgo += "\(year) years ago"
        case (_,let day,_) where day == 1: resultUpdatesAgo += "a day ago"
        case (_,let day,_) where day > 1: resultUpdatesAgo += "\(day) days ago"
        case (_,_,let hour) where hour == 1: resultUpdatesAgo += "an hour ago"
        case (_,_,let hour) where hour > 1: resultUpdatesAgo += "\(hour) hours ago"
        default:
            resultUpdatesAgo = ""
        }
        
        return resultUpdatesAgo
    }
    
    
}

