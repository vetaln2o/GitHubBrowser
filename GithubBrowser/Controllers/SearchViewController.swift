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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Search Projects"
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchProjectBar)
        view.addSubview(contenTableView)
    }
    
    override func viewDidLayoutSubviews() {

        searchProjectBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        searchProjectBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        searchProjectBar.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        contenTableView.topAnchor.constraint(equalTo: searchProjectBar.bottomAnchor).isActive = true
        contenTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contenTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
