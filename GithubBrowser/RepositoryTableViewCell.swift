//
//  RepositoryTableViewCell.swift
//  GithubBrowser
//
//  Created by Vitalij Semenenko on 11/8/18.
//  Copyright © 2018 Vitalij Semenenko. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    let userDefaults = UserDefaults.standard
    
    var repositoryToCell: RepositoryDetail?
    var searchWordSignal: String?
    
    var addToFavoritesButton = UIButton(type: UIButton.ButtonType.contactAdd)
    var repositoryNameLable = UILabel()
    var repositoryDescriptionTextView = UITextView()
    var avatarImageView = UIImageView()
    var starsLabel = UILabel()
    var languageLabel = UILabel()
    var updateDataLabel = UILabel()
    var forksLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK - Custom Visual Settings for Cell
        addToFavoritesButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoritesButton.backgroundColor = .white
        
        repositoryNameLable.translatesAutoresizingMaskIntoConstraints = false
        repositoryNameLable.font.withSize(20)
        repositoryNameLable.textColor = UIColor.blue
        
        repositoryDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        repositoryDescriptionTextView.sizeToFit()
        repositoryDescriptionTextView.isScrollEnabled = false
        repositoryDescriptionTextView.isEditable = false
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleToFill
        
        starsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        languageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        updateDataLabel.translatesAutoresizingMaskIntoConstraints = false
        
        forksLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addToFavoritesButton.addTarget(self, action: #selector(addToFavoritesAction(from:)), for: .touchUpInside)
        
        self.addSubview(repositoryNameLable)
        self.addSubview(repositoryDescriptionTextView)
        self.addSubview(addToFavoritesButton)
        self.addSubview(avatarImageView)
        self.addSubview(starsLabel)
        self.addSubview(languageLabel)
        self.addSubview(updateDataLabel)
        self.addSubview(forksLabel)
        
        addCounstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Get Date from Repositories an put to Table Cell
        if let currentRep = repositoryToCell {
            if searchWordSignal == nil {
                repositoryNameLable.text = currentRep.fullName
                repositoryDescriptionTextView.text = currentRep.description
            } else {
                repositoryNameLable.attributedText = highlight(inputText: currentRep.fullName)
                repositoryDescriptionTextView.attributedText = highlight(inputText: currentRep.description ?? "")
            }
            
            if let star = currentRep.stargazersCount {
                starsLabel.text = "★ " + String(star)
            }
            if let lang = currentRep.language {
                languageLabel.text = "● " + lang + " | "
            }
            if var date = currentRep.updatedAt {
                updateDataLabel.text = GetRepositoryInfo.getUpdateDate(stringData: &date) //Convert Update Date to w/s format
            }
            if let fork = currentRep.forksCount {
                forksLabel.text = "\(fork) forks"
            }
//            if let img = currentRep.owner.avatarImg {
//                let avatarImg = UIImage(data: img)
//                avatarImageView.image = avatarImg
//            }
        }
    }
    
    func highlight(inputText: String) -> NSMutableAttributedString {
        let col = UIColor.red
        var ranges = [Int]()
        let attrString = NSMutableAttributedString(string: inputText)
        
        let str = searchWordSignal!
        var range = (inputText.localizedLowercase as NSString).range(of: str.localizedLowercase)
        
        while (range.location != NSNotFound && ranges.index(of: range.location) != nil) {
            let subRange = NSMakeRange(range.location + 1, inputText.count - range.location - 1)
            range = (inputText as NSString).range(of: str, options: NSString.CompareOptions.literal, range: subRange)
        }
        
        if range.location != NSNotFound {
            ranges.append(range.location)
            attrString.addAttribute(NSAttributedString.Key.foregroundColor, value: col, range: range)
        }
        
        return attrString
    }
    
    private func addCounstraints() {
        repositoryNameLable.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        repositoryNameLable.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        repositoryNameLable.heightAnchor.constraint(equalToConstant: 20).isActive = true
        repositoryNameLable.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -100).isActive = true
        
        repositoryDescriptionTextView.topAnchor.constraint(equalTo: repositoryNameLable.bottomAnchor, constant: 5).isActive = true
        repositoryDescriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        repositoryDescriptionTextView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -100).isActive = true
        
        addToFavoritesButton.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        addToFavoritesButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        addToFavoritesButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        addToFavoritesButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        avatarImageView.rightAnchor.constraint(equalTo: addToFavoritesButton.leftAnchor, constant: -5).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        starsLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 5).isActive = true
        starsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        starsLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        starsLabel.leftAnchor.constraint(equalTo: avatarImageView.leftAnchor).isActive = true
        
        languageLabel.topAnchor.constraint(equalTo: repositoryDescriptionTextView.bottomAnchor, constant: 5).isActive = true
        languageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        languageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        forksLabel.leftAnchor.constraint(equalTo: languageLabel.rightAnchor).isActive = true
        forksLabel.topAnchor.constraint(equalTo: repositoryDescriptionTextView.bottomAnchor, constant: 5).isActive = true
        forksLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        updateDataLabel.topAnchor.constraint(equalTo: languageLabel.bottomAnchor, constant: 5).isActive = true
        updateDataLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        updateDataLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        self.heightAnchor.constraint(equalTo: repositoryDescriptionTextView.heightAnchor, constant: 85).isActive = true
    }
    
    //Save selected Repository to UserDefaults (key: favoritesRepo) for Favorites Tab
    @objc func addToFavoritesAction(from button: UIButton) {
        var isInFavorites = false
        var selectedRepository = [RepositoryDetail]()
        selectedRepository.append(repositoryToCell!)
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
    }

}
