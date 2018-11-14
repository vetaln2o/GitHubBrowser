//
//  BrowseViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {

    var browseTableView = UITableView()
    var loadIndicator = UIActivityIndicatorView() //Indicate loading of full Table of Repository list (first 100)
    var footerView = UIView()
    var tableLoadIndicator = UIActivityIndicatorView() //Indicate loading more after scrolling to the end of the table
    
    var gitRepositoryList = GetRepositoryInfo()
    let tableIdentifier = "BrowseTableView"
    var lastRepositoryId = 1 //ID of last Repository in list
    var loadMoreStatus = false //For check if loading after scroll to the table end running
    var isLoadedRepository = false //For check if Repository list was loaded when BrowseTab is opened
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Public Repositories"
        
        browseTableView.translatesAutoresizingMaskIntoConstraints = false
        browseTableView.delegate = self
        browseTableView.dataSource = self
        browseTableView.rowHeight = UITableView.automaticDimension
        browseTableView.estimatedRowHeight = 44
        browseTableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        browseTableView.separatorColor = .black
        browseTableView.tableFooterView?.isHidden = true

        view.addSubview(browseTableView)
        browseTableView.isHidden = true
        
        loadIndicator.center = view.center
        loadIndicator.style = .whiteLarge
        loadIndicator.color = .black
        view.addSubview(loadIndicator)
        
        addConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLoadedRepository {
            isLoadedRepository = true
            loadIndicator.startAnimating()
            gitRepositoryList.getArray(controllerType: .browse, url: "https://api.github.com/repositories?since=1&per_page=100", closure: { [weak self] in
                DispatchQueue.main.async {
//                    self?.gitRepositoryList.makeImgFromUrl()
                    self?.browseTableView.reloadData()
                    self?.loadIndicator.stopAnimating()
                    self?.loadIndicator.isHidden = true
                    self?.browseTableView.isHidden = false
                }
            })
        }
    }
    
    private func addConstraints() {
        browseTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        browseTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        browseTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        browseTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor).isActive = true
    }
    
}

extension BrowseViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gitRepositoryList.repositoryListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = browseTableView.dequeueReusableCell(withIdentifier: tableIdentifier) as! RepositoryTableViewCell
        let repository = gitRepositoryList.repositoryListArray[indexPath.row]
        cell.repositoryToCell = repository
        gitRepositoryList.imageFromServerURL(urlString: repository.owner.avatarUrl, closure: { image in
            cell.avatarImageView.image = image
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //This Footer with indicator shows when loading of another 100 of Repositories begin
        footerView = UIView(frame: CGRect(x: 0, y: 0, width: browseTableView.frame.size.width, height: 30))
        tableLoadIndicator.center = footerView.center
        footerView.backgroundColor = .gray
        tableLoadIndicator.style = .white
        footerView.addSubview(tableLoadIndicator)
        footerView.isHidden = true
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Open README.md file in WebView
        let readmeVC = RepositoryReadmeViewController()
        readmeVC.repositoryDetail = gitRepositoryList.repositoryListArray[indexPath.row]
        self.navigationController?.pushViewController(readmeVC, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Check scroll to the end of the TableView
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset
        
        if deltaOffset <= 0 {
            footerView.isHidden = false
            tableLoadIndicator.startAnimating()
            loadTableAfterScroll()
        }
    }
    
    private func loadTableAfterScroll(){
        if !self.loadMoreStatus{
            if (!gitRepositoryList.repositoryListArray.isEmpty) {
                self.loadMoreStatus = true
                let count = gitRepositoryList.repositoryListArray.count
                lastRepositoryId = gitRepositoryList.repositoryListArray[count-1].id
                let newArray = GetRepositoryInfo()
                newArray.getArray(controllerType: .browse, url: "https://api.github.com/repositories?since=\(lastRepositoryId)&per_page=100", closure: { [weak self] in
                    DispatchQueue.main.async {
//                        newArray.makeImgFromUrl()
                        self?.gitRepositoryList.repositoryListArray += newArray.repositoryListArray
                        self?.browseTableView.reloadData()
                        self?.tableLoadIndicator.stopAnimating()
                        self?.footerView.isHidden = true
                        self?.loadMoreStatus = false
                    }
                })
            }
        }
    }
    
}
