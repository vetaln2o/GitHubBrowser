//
//  BrowseViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    var gitRepositoryList = GetRepositoryURL(controllerType: .browse, url: "https://api.github.com/repositories?since=364")
    var browseTableView = UITableView()
    var loadIndicator = UIActivityIndicatorView()
    let tableIdentifier = "BrowseTableView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gitRepositoryList = GetRepositoryURL()

        self.navigationItem.title = "Browse Projects"
        
        browseTableView.translatesAutoresizingMaskIntoConstraints = false
        browseTableView.delegate = self
        browseTableView.dataSource = self
        browseTableView.rowHeight = UITableView.automaticDimension
        browseTableView.estimatedRowHeight = 44
        browseTableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        browseTableView.separatorColor = .black

        view.addSubview(browseTableView)
        browseTableView.isHidden = true
        
        loadIndicator.center = view.center
        loadIndicator.style = .whiteLarge
        loadIndicator.color = .black
        view.addSubview(loadIndicator)
        
        AddConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadIndicator.startAnimating()
        gitRepositoryList.getArray(controllerType: .browse, url: "https://api.github.com/repositories?since=364", closure: { [weak self] in
            DispatchQueue.main.async {
                self?.browseTableView.reloadData()
                self?.loadIndicator.stopAnimating()
                self?.loadIndicator.isHidden = true
                self?.browseTableView.isHidden = false
            }
        })
    }
    
    private func AddConstraints() {
        browseTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        browseTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        browseTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepositoryList.repositoryListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = browseTableView.dequeueReusableCell(withIdentifier: tableIdentifier) as! RepositoryTableViewCell
        cell.repositoryName = gitRepositoryList.repositoryListArray[indexPath.row].full_name
        cell.addToFavoritesButton.tag = indexPath.row
        cell.repositoryDescription = gitRepositoryList.repositoryListArray[indexPath.row].description
        cell.avatarImage = gitRepositoryList.repositoryListArray[indexPath.row].owner.avatar_url
        cell.stars = gitRepositoryList.repositoryListArray[indexPath.row].stargazers_count
        cell.language = gitRepositoryList.repositoryListArray[indexPath.row].language
        if var date = gitRepositoryList.repositoryListArray[indexPath.row].updated_at {
            cell.updateDate = gitRepositoryList.getUpdateDate(stringData: &date)
        }
        cell.forks = gitRepositoryList.repositoryListArray[indexPath.row].forks_count
//        cell.layoutSubviews()
        return cell
    }
}
