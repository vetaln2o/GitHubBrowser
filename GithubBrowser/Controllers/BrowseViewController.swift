//
//  BrowseViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    var git = GetRepositoryURL()
    var browseTableView = UITableView()
    let tableIdentifier = "BrowseTableView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if git.urlList.isEmpty {
            git = GetRepositoryURL()
        }
        self.navigationItem.title = "Browse Projects"
        browseTableView = UITableView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: view.bounds.height - 100), style: .plain)
        browseTableView.delegate = self
        browseTableView.dataSource = self
        browseTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        view.addSubview(browseTableView)

        git.fillRepositoryArray()
        print(git.repositoryArray)
        for i in git.repositoryArray {
            print(i.description)
            print(i.forks_count)
            print(i.full_name)
            print(i.language)
            print(i.owner.avatar_url)
            print(i.stargazers_count)
            print(i.updated_at)
        }
    }
    
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return git.urlList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = browseTableView.dequeueReusableCell(withIdentifier: tableIdentifier, for: indexPath)
        let row = git.urlList[indexPath.row].url
        cell.textLabel?.text = row
        return cell
    }
}