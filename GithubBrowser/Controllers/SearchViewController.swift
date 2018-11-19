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
    
    var gitRepositoryList = GetRepositoryInfo()
    let tableIdentifier = "SearchTableView"
    var lastRepositoryId = 1
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
        searchProjectBar.becomeFirstResponder()
        
        loadIndicator.center = view.center
        loadIndicator.style = .whiteLarge
        loadIndicator.color = .black
        
        addConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(param:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(param:)), name:UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    @objc private func keyboardWillShow(param: Notification) {
        print("keyboardWillShow")
        let userInfo = param.userInfo
        let getKeyboardRect = (userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let frameKeyboard = self.view.convert(getKeyboardRect, to: view.window)
        var contentInset  = contenTableView.contentInset
        contentInset.bottom = frameKeyboard.height
        contenTableView.contentInset = contentInset
    }
    
    @objc private func keyboardWillHide(param: Notification) {
        let contentInset = UIEdgeInsets.zero
        contenTableView.contentInset = contentInset
    }

    
    private func addConstraints() {

        if #available(iOS 11.0, *) {
            searchProjectBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            searchProjectBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
            searchProjectBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            contenTableView.topAnchor.constraint(equalTo: searchProjectBar.bottomAnchor).isActive = true
            contenTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
            contenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            contenTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        } else {
            searchProjectBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            searchProjectBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            searchProjectBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            
            contenTableView.topAnchor.constraint(equalTo: searchProjectBar.bottomAnchor).isActive = true
            contenTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            contenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            contenTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        }
        
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gitRepositoryList.repositoryListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contenTableView.dequeueReusableCell(withIdentifier: tableIdentifier) as! RepositoryTableViewCell
        let repository = gitRepositoryList.repositoryListArray[indexPath.row]
        cell.pushInfoToCell(from: repository, searchWordSignal: searchProjectBar.text)
        gitRepositoryList.imageFromServerURL(urlString: repository.owner.avatarUrl, completion: { image in
            cell.avatarImageView.image = image
        })
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
        searchProjectBar.resignFirstResponder()
        let readmeVC = RepositoryReadmeViewController()
        readmeVC.repositoryDetail = gitRepositoryList.repositoryListArray[indexPath.row]
        self.navigationController?.pushViewController(readmeVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchProjectBar.resignFirstResponder()
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
        lastRepositoryId += 1
        let newArray = GetRepositoryInfo()
        newArray.getArray(controllerType: .search, url: "https://api.github.com/search/repositories?q=\(searchProjectBar.text!)&page=\(lastRepositoryId)&per_page=100", completion: { [weak self] in
            DispatchQueue.main.async {
                let lastRowBefore = (self?.gitRepositoryList.repositoryListArray.count)! - 1
                self?.gitRepositoryList.repositoryListArray += newArray.repositoryListArray
                var indexPathArray = [IndexPath]()
                for row in newArray.repositoryListArray.indices {
                    indexPathArray.append(IndexPath(row: row + lastRowBefore, section: 0))
                }
                self?.contenTableView.insertRows(at: indexPathArray, with: .automatic)
                self?.tableLoadIndicator.stopAnimating()
                self?.footerView.isHidden = true
                self?.loadMoreStatus = false
            }
        })
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
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
            gitRepositoryList.getArray(controllerType: .search, url: "https://api.github.com/search/repositories?q=\(searchText)&per_page=100", completion: { [weak self] in
                DispatchQueue.main.async {
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
