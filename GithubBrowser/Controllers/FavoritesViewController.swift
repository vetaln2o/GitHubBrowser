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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorites"
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(favoritesTableView)

    }
    
    override func viewDidLayoutSubviews() {
        favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        favoritesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        favoritesTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
}
