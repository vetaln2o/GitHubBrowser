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
        
        searchProjectBar = UISearchBar(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 30))
        view.addSubview(searchProjectBar)
        contenTableView = UITableView(frame: CGRect(x: 0, y: 135, width: view.bounds.width, height: view.bounds.height-130), style: .plain)
        view.addSubview(contenTableView)

    }
}
