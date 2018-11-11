//
//  SearchViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchProjectBar = UISearchBar()
    var contenTableView = UITableView()
    var loadIndicator = UIActivityIndicatorView()
    var footerView = UIView()
    var tableLoadIndicator = UIActivityIndicatorView()
    var swipeGesture = UISwipeGestureRecognizer()
    
    var gitRepositoryList = GetRepositoryInfo()
    let tableIdentifier = "SearchTableView"
    var lastRepositoryID = 1
    var loadMoreStatus = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Repository Search"
        
        searchProjectBar.translatesAutoresizingMaskIntoConstraints = false
        contenTableView.translatesAutoresizingMaskIntoConstraints = false
        contenTableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        contenTableView.separatorColor = .black
        contenTableView.rowHeight = UITableView.automaticDimension
        contenTableView.estimatedRowHeight = 44
        contenTableView.tableFooterView?.addSubview(tableLoadIndicator)
        contenTableView.tableFooterView?.isHidden = false
        
        view.addSubview(searchProjectBar)
        view.addSubview(contenTableView)
        view.addSubview(loadIndicator)
        contenTableView.delegate = self
        contenTableView.dataSource = self
        searchProjectBar.delegate = self
        
        loadIndicator.center = view.center
        loadIndicator.style = .whiteLarge
        loadIndicator.color = .black
        
        AddConstraints()
        lastRepositoryID = 1
        
        swipeGesture = UISwipeGestureRecognizer(target: self.contenTableView, action: #selector(performSwipeGesture))
        contenTableView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func performSwipeGesture() {
        searchProjectBar.resignFirstResponder()
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
        cell.repositoryToCell = gitRepositoryList.repositoryListArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: contenTableView.frame.size.width, height: 30))
        tableLoadIndicator.center = footerView.center
        footerView.backgroundColor = .gray
        tableLoadIndicator.style = .white
        footerView.addSubview(tableLoadIndicator)
        footerView.isHidden = true
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readmeVC = RepositoryReadmeViewController()
        readmeVC.repositoryDetail = gitRepositoryList.repositoryListArray[indexPath.row]
        self.navigationController?.pushViewController(readmeVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            if (!self.loadMoreStatus) && (!gitRepositoryList.repositoryListArray.isEmpty) && (gitRepositoryList.repositoryListArray.count >= 100) {
                footerView.isHidden = false
                tableLoadIndicator.startAnimating()
                loadTableAfterScroll()
            }
        }
    }
    
    func loadTableAfterScroll(){
        self.loadMoreStatus = true
        lastRepositoryID += 1
        let newArray = GetRepositoryInfo()
        print("Start reload")
        newArray.getArray(controllerType: .search, url: "https://api.github.com/search/repositories?q=\(searchProjectBar.text!)&page=\(lastRepositoryID)&per_page=100", closure: { [weak self] in
            DispatchQueue.main.async {
                self?.gitRepositoryList.makeImgFromUrl()
                self?.gitRepositoryList.repositoryListArray += newArray.repositoryListArray
                self?.contenTableView.reloadData()
                self?.tableLoadIndicator.stopAnimating()
                self?.footerView.isHidden = true
                self?.loadMoreStatus = false
                print("Finish reload")
            }
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Searching of Repository begin from 3rd letter. Get result of 100 element. Array and TableView cleared when there is less than 2 char
        if searchText.count > 2 {
            loadIndicator.startAnimating()
            contenTableView.isHidden = true
            gitRepositoryList = GetRepositoryInfo()
            gitRepositoryList.getArray(controllerType: .search, url: "https://api.github.com/search/repositories?q=\(searchText)&per_page=100", closure: { [weak self] in
                DispatchQueue.main.async {
                    self?.gitRepositoryList.makeImgFromUrl()
                    self?.contenTableView.reloadData()
                    self?.loadIndicator.stopAnimating()
                    self?.loadIndicator.isHidden = true
                    self?.contenTableView.isHidden = false
                }
            })
        } else {
            gitRepositoryList = GetRepositoryInfo()
            contenTableView.isHidden = false
            loadIndicator.stopAnimating()
            contenTableView.reloadData()
        }
    }
}
