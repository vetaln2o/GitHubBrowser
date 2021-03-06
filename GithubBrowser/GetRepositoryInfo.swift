//
//  GitJSONModel.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import Foundation
import UIKit

struct RepositoryDetail: Codable {
    var id: Int
    var htmlUrl: String
    var fullName: String
    var description: String?
    var updatedAt: String?
    var language: String?
    var stargazersCount: Int?
    var forksCount: Int?
    var owner: Owner
    
    struct  Owner: Codable {
        var avatarUrl: String
        var avatarImg: Data?
        
        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
            case avatarImg
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case htmlUrl = "html_url"
        case fullName = "full_name"
        case description
        case updatedAt = "updated_at"
        case language
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case owner
    }
    
}

enum ControllerType {
    case browse
    case search
}

struct RepositorySearch: Decodable {
    var items: [RepositoryDetail]
}

struct ErrorHandle: Decodable {
    var message: String?
}

class GetRepositoryInfo {
    
    var repositoryListArray = [RepositoryDetail]()
    
    init() {
        self.repositoryListArray = [RepositoryDetail]()
    }
    
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
                //for BrowseViewController
                if controllerType == .browse {
                    let result = try JSONDecoder().decode([RepositoryDetail].self, from: data!)
                    completion(result)
                } else if controllerType == .search {
                    //For Search View Controller
                    let result = try JSONDecoder().decode(RepositorySearch.self, from: data!)
                    completion(result.items)
                }

            } catch {
                do {
                    let errorMessage = try JSONDecoder().decode(ErrorHandle.self, from: data!)
                    print("Error Message from API: " + (errorMessage.message ?? ""))
                } catch let error {
                    print(error)
                }
            }
            }.resume()
        
    }

    //Completion of adding data, which receiver from JSON to Array of RepoDetail
    func getArray(controllerType: ControllerType, url: String, completion: @escaping () -> ()) {
        repositoryListArray = [RepositoryDetail]()
        getRepositoryArray(controllerType: controllerType, urlString: url) { (result) in
            for i in result.indices {
                self.repositoryListArray.append(result[i])
                if i == result.indices.max() {
                    completion()
                }
            }
        }
    }

    
    //Get images from server and convert to Image format (added to current Array of Repositories)
    func imageFromServerURL(urlString: String, completion: @escaping (UIImage) -> ()) {
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let data = data {
                    let image = UIImage(data: data)
                    completion(image ?? UIImage())
                }
            })
        }).resume()
    }
    
    //Func to change data from GitHub API Format to W/S format (Updated _ days/hours ago)
    static func getUpdateDate(stringData: inout String) -> String {
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

