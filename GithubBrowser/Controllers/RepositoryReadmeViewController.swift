//
//  RepositoryReadmeViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/10/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit
import WebKit

class RepositoryReadmeViewController: UIViewController, WKNavigationDelegate {
    
    var readmeWebView = WKWebView()
    var addFavoritesBarButton = UIBarButtonItem()
    var openSafariBarButton = UIBarButtonItem()
    
    let userDefaults = UserDefaults.standard
    var repositoryDetail: RepositoryDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = repositoryDetail?.fullName

        readmeWebView.translatesAutoresizingMaskIntoConstraints = false
        readmeWebView.navigationDelegate = self
        if let url = URL(string: "https://github.com/\(repositoryDetail!.fullName)/blob/master/README.md") {
            let urlRequest = URLRequest(url: url)
            readmeWebView.load(urlRequest)
        }
        view = readmeWebView
        
        addFavoritesBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        let safariButton = UIButton(type: .roundedRect)
        safariButton.setTitle("Open in Safari", for: .normal)
        safariButton.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        openSafariBarButton = UIBarButtonItem(customView: safariButton)
        self.navigationItem.rightBarButtonItems = [addFavoritesBarButton, openSafariBarButton]
        
    }
    
    @objc func addToFavorites() {
        var isInFavorites = false
        var selectedRepository = [RepositoryDetail]()
        selectedRepository.append(repositoryDetail!)
        if let data = userDefaults.object(forKey: "favoritesRepo") as? Data {
            if var favoritesRepo = try? PropertyListDecoder().decode([RepositoryDetail].self, from: data) {
                for repo in favoritesRepo {
                    if selectedRepository[0].fullName == repo.fullName {
                        isInFavorites = true
                    }
                }
                if !isInFavorites {
                    favoritesRepo += selectedRepository
                    userDefaults.removeObject(forKey: "favoritesRepo")
                    userDefaults.setValue(try? PropertyListEncoder().encode(favoritesRepo), forKey: "favoritesRepo")
                }
            }
        } else {
            userDefaults.set(try? PropertyListEncoder().encode(selectedRepository), forKey: "favoritesRepo")
        }
        let alert = UIAlertController(title: "Favorites", message: "Repository \(repositoryDetail!.fullName) added to Favorites!", preferredStyle: .actionSheet)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func openInSafari() {
        UIApplication.shared.open(URL(string: repositoryDetail!.htmlUrl)!, options: [:], completionHandler: nil)
    }

    private func AddConstraints() {
        readmeWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        readmeWebView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        readmeWebView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
}
