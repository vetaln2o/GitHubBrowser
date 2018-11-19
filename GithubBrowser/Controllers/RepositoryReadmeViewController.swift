//
//  RepositoryReadmeViewController.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/10/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit
import Down

class RepositoryReadmeViewController: UIViewController {
    
    var readmeTextView = UITextView()
    var addFavoritesBarButton = UIBarButtonItem()
    var openSafariBarButton = UIBarButtonItem()
    var notExistAlert = UIAlertController()
    var notExistAlertAction = UIAlertAction()
    
    let userDefaults = UserDefaults.standard
    var repositoryDetail: RepositoryDetail?
    
    var readmeUrlVariantArray: [String] {
        var newReadmeArray = [String]()
        if let currentRepository = repositoryDetail {
            var basicReadmeUrl = "https://raw.githubusercontent.com/\(currentRepository.fullName)/master/README"
            newReadmeArray.append(basicReadmeUrl)
            newReadmeArray.append(basicReadmeUrl + ".md")
            newReadmeArray.append(basicReadmeUrl + ".markdown")
            newReadmeArray.append(basicReadmeUrl + ".txt")
            newReadmeArray.append(basicReadmeUrl + ".rst")
            newReadmeArray.append(basicReadmeUrl + ".rdoc")
            basicReadmeUrl = "https://raw.githubusercontent.com/\(currentRepository.fullName)/master/readme"
            newReadmeArray.append(basicReadmeUrl)
            newReadmeArray.append(basicReadmeUrl + ".md")
            newReadmeArray.append(basicReadmeUrl + ".markdown")
            newReadmeArray.append(basicReadmeUrl + ".txt")
            newReadmeArray.append(basicReadmeUrl + ".rst")
            newReadmeArray.append(basicReadmeUrl + ".rdoc")
        }
        return newReadmeArray
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = repositoryDetail?.fullName
        readmeTextView.backgroundColor = UIColor.lightGray
        readmeTextView.translatesAutoresizingMaskIntoConstraints = false
        readmeTextView.sizeToFit()
        readmeTextView.isEditable = false
        view.addSubview(readmeTextView)
        addConstraints()
        
        addFavoritesBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToFavorites))
        let safariButton = UIButton(type: .roundedRect)
        safariButton.setTitle("Open in Safari", for: .normal)
        safariButton.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)
        openSafariBarButton = UIBarButtonItem(customView: safariButton)
        self.navigationItem.rightBarButtonItems = [addFavoritesBarButton, openSafariBarButton]
        
        getReadmeContent(completion: { (readmeContent) in
            DispatchQueue.main.async(execute: {
                let down = Down(markdownString: readmeContent)
                let attributedString = try? down.toAttributedString()
                self.readmeTextView.attributedText = attributedString
            })
        })
    }
    

    
    private func getReadmeContent(completion: @escaping (String) -> ()) {
        var isReadmeExist = [Bool]()
        for readmeUrl in readmeUrlVariantArray {
            if let url = URL(string: readmeUrl) {
                URLSession.shared.dataTask(with: url) { (data, response, _) in
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode != 404 {
                            isReadmeExist.append(true)
                            let readmeContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
                            completion(readmeContent)
                        } else {
                            isReadmeExist.append(false)
                        }
                    }
                    }.resume()
            }
        }
        DispatchQueue.main.async(execute: {
            repeat {
                if isReadmeExist.count == self.readmeUrlVariantArray.count {
                    if !isReadmeExist.contains(true) {
                        self.showNotExtistAlert()
                    }
                }
            } while isReadmeExist.count < self.readmeUrlVariantArray.count
        })
    }
    
    private func showNotExtistAlert() {
        self.notExistAlert = UIAlertController(title: "README", message: "Readme file not exist in \((self.repositoryDetail?.fullName)!). Open Repository in Safari?", preferredStyle: .alert)
        self.notExistAlertAction = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            self.openInSafari()
            self.navigationController?.popViewController(animated: true)
        })
        self.notExistAlert.addAction(self.notExistAlertAction)
        self.notExistAlertAction = UIAlertAction(title: "No", style: .default, handler: { (alert) in
            self.navigationController?.popViewController(animated: true)
        })
        self.notExistAlert.addAction(self.notExistAlertAction)
        self.present(self.notExistAlert, animated: true)
    }
    
    @objc private func addToFavorites() {
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
    
    
    @objc private func openInSafari() {
        UIApplication.shared.open(URL(string: repositoryDetail!.htmlUrl)!, options: [:], completionHandler: nil)
    }

    private func addConstraints() {
        if #available(iOS 11.0, *) {
            readmeTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            readmeTextView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
            readmeTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            readmeTextView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            readmeTextView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            readmeTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
    }
    
}
