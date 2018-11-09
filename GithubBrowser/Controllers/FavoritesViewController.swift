//
//  FavoritesViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/2/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    var favoritesTableView = UITableView()
    var gitRepositoryList = GetRepositoryURL()
    var favoritesListArray = [RepositoryDetail]()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorites"
        favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesTableView)
        AddConstraints()

    }
    
    private func AddConstraints() {
        favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        favoritesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        favoritesTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
//    private func loadFromUserDefaults() {
//        if var favoritesRepo = userDefaults.object(forKey: "favoritesRepo") as? [String] {
//            
//        }
//    }
}
