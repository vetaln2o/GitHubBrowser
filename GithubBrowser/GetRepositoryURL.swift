//
//  GitJSONModel.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import Foundation

struct RepositoryDetail: Decodable {
    var full_name: String
    var description: String?
    var updated_at: String
    var language: String?
    var stargazers_count: Int
    var forks_count: Int
    var owner: Owner
    
    struct  Owner: Decodable {
        var avatar_url: String
    }
    
}

struct RepositorySearch: Decodable {
    var items: [RepositoryUrl]
}

struct RepositoryUrl : Decodable {
    var url: String
}

class GetRepositoryURL {
    
    var urlList = [RepositoryUrl]()
    var repositoryArray = [RepositoryDetail]()
    
    func fillRepositoryArray(){
        for repo in urlList {
            getRepositoryInfo(urlString: repo.url) { (repository) in
                self.repositoryArray.append(repository)
                //print(self.repositoryArray)
            }
            //sleep(1)
        }
        print(self.repositoryArray)
    }
    
    func getRepositoryInfo(urlString: String, completion: @escaping (RepositoryDetail) -> Void) {
        guard let url = URL(string: urlString) else {return}
        var result = RepositoryDetail(full_name: "", description: "", updated_at: "", language: "", stargazers_count: 0, forks_count: 0, owner: RepositoryDetail.Owner(avatar_url: ""))
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {return}
            guard error == nil else {return}
            do {
                result = try JSONDecoder().decode(RepositoryDetail.self, from: data!)
                completion(result)
            } catch let error {
                print(error)
            }
            }.resume()
    }
    
    func getURL(completion: @escaping ([RepositoryUrl]) -> Void) {
        let urlString = "https://api.github.com/repositories?since=1000"
        guard let url = URL(string: urlString) else {return}
        var result = [RepositoryUrl]()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("DATA is EMPTY!")
                return
            }
            guard error == nil else {
                print(error)
                return
            }
            do {
                result = try JSONDecoder().decode([RepositoryUrl].self, from: data!)
                completion(result)
            } catch let error {
                print(error)
            }
            }.resume()
        
    }
    
    init() {
        getURL { (result) in
            for i in result.indices {
                self.urlList.append(result[i])
            }
        }
    }
    
    
}

