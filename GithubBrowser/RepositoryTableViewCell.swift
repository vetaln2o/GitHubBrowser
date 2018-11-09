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
    
    var repositoryName = ""
    var repositoryDescription: String?
    var avatarImage: String?
    var stars: Int?
    var language: String?
    var updateDate: String?
    var forks: Int?
    
    var addToFavoritesButton = UIButton(type: UIButton.ButtonType.contactAdd)
    var repositoryNameLable = UILabel()
    var repositoryDescriptionTextView = UITextView()
    var avatarImageView = UIImageView()
    var starsLabel = UILabel()
    var languageLabel = UILabel()
    var updateDataLabel = UILabel()
    var forksLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        repositoryNameLable.text = repositoryName
        
        if let description = repositoryDescription {
            repositoryDescriptionTextView.text = description
        }
        
        if let imagPath = avatarImage {
            let imageUrl = URL(string: imagPath)
            let imageData = try! Data(contentsOf: imageUrl!)
            let avatarImg = UIImage(data: imageData)
            avatarImageView.image = avatarImg
        }
        
        if let star = stars {
            starsLabel.text = "★ " + String(star)
        }
        
        if let lang = language {
            languageLabel.text = "● " + lang + " | "
        }
        
        if let date = updateDate {
            updateDataLabel.text = date
        }
        
        if forks != nil && forks != 0 {
            forksLabel.text = "\(forks!) forks"
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
    
    @objc func addToFavoritesAction(from button: UIButton) {
//        var selectedRepositoryDetail: RepositoryDetail
//        selectedRepositoryDetail.description = repositoryDescription
//        selectedRepositoryDetail.full_name = repositoryName
//        selectedRepositoryDetail.owner.avatar_url = avatarImage
//        
//        
//        var stars: Int?
//        var language: String?
//        var updateDate: String?
//        var forks: Int?
        
        var selectedRepository = [String]()
        selectedRepository.append(repositoryNameLable.text!)
        if var favoritesRepo = userDefaults.object(forKey: "favoritesRepo") as? [String] {
            favoritesRepo += selectedRepository
            userDefaults.removeObject(forKey: "favoritesRepo")
            userDefaults.set(favoritesRepo, forKey: "favoritesRepo")
            print("ADDED")
        } else {
            userDefaults.set(selectedRepository, forKey: "favoritesRepo")
            print("New defaults")
        }
    }

}
