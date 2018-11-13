//
//  MainTabBarController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/12/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let browseVC = BrowseViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()
        
        let browseNavigationVC = UINavigationController(rootViewController: browseVC)
        let searchNavigationVC = UINavigationController(rootViewController: searchVC)
        let favoritesNavigationVC = UINavigationController(rootViewController: favoritesVC)
        
        self.setViewControllers([browseNavigationVC, searchNavigationVC, favoritesNavigationVC], animated: true)
        
        var tabBarItem = UITabBarItem()
        tabBarItem = UITabBarItem(tabBarSystemItem: .recents, tag: 1)
        browseVC.tabBarItem = tabBarItem
        tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        searchVC.tabBarItem = tabBarItem
        tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 3)
        favoritesVC.tabBarItem = tabBarItem
    }

}
