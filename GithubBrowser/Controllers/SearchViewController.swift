//
//  SearchViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var gitRepositoryList = GetRepositoryURL()
    var searchProjectBar = UISearchBar()
    var contenTableView = UITableView()
    let tableIdentifier = "SearchTableView"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search Projects"
        
        searchProjectBar.translatesAutoresizingMaskIntoConstraints = false
        contenTableView.translatesAutoresizingMaskIntoConstraints = false
        contenTableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        contenTableView.separatorColor = .black
        
        view.addSubview(searchProjectBar)
        view.addSubview(contenTableView)
        contenTableView.delegate = self
        contenTableView.dataSource = self
        searchProjectBar.delegate = self
        AddConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func AddConstraints() {

        searchProjectBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchProjectBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchProjectBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        contenTableView.topAnchor.constraint(equalTo: searchProjectBar.bottomAnchor).isActive = true
        contenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contenTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gitRepositoryList.repositoryListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contenTableView.dequeueReusableCell(withIdentifier: tableIdentifier) as! RepositoryTableViewCell
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
        cell.layoutSubviews()
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            gitRepositoryList = GetRepositoryURL(controllerType: .search, url: "https://api.github.com/search/repositories?q=\(searchText)")
            sleep(3)
            contenTableView.reloadData()
        }
    }
}
