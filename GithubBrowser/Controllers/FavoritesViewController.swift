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
    var editButton = UIButton()
    
    let userDefaults = UserDefaults.standard
    var favoritesListArray = [RepositoryDetail]()
    let tableIdentifier = "FavoritesTableView"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Favorites"
        
        favoritesTableView.translatesAutoresizingMaskIntoConstraints = false
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        favoritesTableView.register(RepositoryTableViewCell.self, forCellReuseIdentifier: tableIdentifier)
        favoritesTableView.rowHeight = UITableView.automaticDimension
        favoritesTableView.estimatedRowHeight = 44
        favoritesTableView.separatorColor = .black
        view.addSubview(favoritesTableView)
        
        AddConstraints()
        
        editButton = UIButton(type: UIButton.ButtonType.roundedRect)
        editButton.setTitle("Edit", for: .normal)
        editButton.addTarget(self, action: #selector(makeTableEditable), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
    }
    
    @objc private func makeTableEditable() {
        favoritesTableView.isEditing = !favoritesTableView.isEditing
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorites()
        favoritesTableView.reloadData()
        favoritesTableView.isEditing = false
    }
    
    private func getFavorites() {
        //Fill Array of Favorites Repo from USerDefaults with key favoritesRepo
        if let data = userDefaults.object(forKey: "favoritesRepo") as? Data {
            if let favoritesRepo = try? PropertyListDecoder().decode([RepositoryDetail].self, from: data) {
                favoritesListArray = favoritesRepo
            }
        }
    }
    
    private func AddConstraints() {
        favoritesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        favoritesTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        favoritesTableView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoritesTableView.dequeueReusableCell(withIdentifier: tableIdentifier) as! RepositoryTableViewCell
        cell.repositoryToCell = favoritesListArray[indexPath.row]
        cell.shouldIndentWhileEditing = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let readmeVC = RepositoryReadmeViewController()
        readmeVC.repositoryDetail = favoritesListArray[indexPath.row]
        readmeVC.addFavoritesBarButton.isEnabled = false
        self.navigationController?.pushViewController(readmeVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Deleting from current array and USerDefaults with key favoritesRepo
        if editingStyle == .delete {
            favoritesListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            userDefaults.removeObject(forKey: "favoritesRepo")
            userDefaults.set(try? PropertyListEncoder().encode(favoritesListArray), forKey: "favoritesRepo")
        }
    }
}
