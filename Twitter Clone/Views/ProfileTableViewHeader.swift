//
//  ProfileHeader.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 04/06/2024.
//

import UIKit

class ProfileTableViewHeader: UIView {
    
    private enum SectionTabs: String {
        case tweets = "Tweets"
        case tweetsAndReplies = "Tweets & Replies"
        case media = "Media"
        case likes = "Likes"
        
        var index: Int {
            switch self {
            case .tweets:
                return 0
            case .tweetsAndReplies:
                return 1
            case .media:
                return 2
            case .likes:
                return 3
            }
        }
    
    }
    
    private var leadingAnchors: [NSLayoutConstraint] = []
    private var trailingAnchors: [NSLayoutConstraint] = []
    
    private let followersTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Followers"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let followerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1M"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let followingTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Following"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "314"
        label.textColor = .label
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()

    private let joinedDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.text = "Joined May 2021"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let joinDateImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar",
                                  withConfiguration: UIImage.SymbolConfiguration(pointSize: 14))
        imageView.tintColor = .secondaryLabel
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let userBioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textColor = .label
        label.text = "İOS Developer"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "@SadeSimsek"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    
    private let displayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sade"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    private let profileAvatarImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 40
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .yellow
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let profileHeaderImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false//önemli eklemeyi unutma
        imageView.image = UIImage(named: "header")
        return imageView
    }()
    private var selectedTab: Int = 0 {
         didSet {
             for i in 0..<tabs.count {// seçilen butonun renginin değişmesi
                 UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) { [weak self] in
                     self?.sectionStackView.arrangedSubviews[i].tintColor = i == self?.selectedTab ? .label : .secondaryLabel
                     //indicatorun değişmesi
                     self?.leadingAnchors[i].isActive = i == self?.selectedTab ? true : false
                     self?.trailingAnchors[i].isActive = i == self?.selectedTab ? true : false
                     self?.layoutIfNeeded()
                 } completion: { _ in
                     
                 }

             }
         }
     }

    private var tabs: [UIButton] = ["Tweets", "Tweets & Replies", "Media", "Likes"] // ayrı ayrı buton oluşturmak yerine tek bir butonda hepsini hallettin
        .map { buttonTitle in
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
            button.tintColor = .label
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    
    private lazy var sectionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: tabs) // hepsini grup yaptık
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let indicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 29/255,
                                       green: 161/255,
                                       blue: 242/255,
                                       alpha: 1)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileHeaderImageView)
        addSubview(profileAvatarImageView)
        addSubview(displayNameLabel)
        addSubview(usernameLabel)
        addSubview(userBioLabel)
        addSubview(joinDateImageView)
        addSubview(joinedDateLabel)
        addSubview(followingCountLabel)
        addSubview(followingTextLabel)
        addSubview(followerCountLabel)
        addSubview(followersTextLabel)
        addSubview(sectionStackView)
        addSubview(indicator)
        
        configureConstraits()
        configureStackButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureStackButton(){
        for (i, button) in sectionStackView.arrangedSubviews.enumerated() {
            guard let button = button as? UIButton else {
                return
            }
            
            if i == selectedTab { //rek değişmesi
                button.tintColor = .label
            }else{
                button.tintColor = .secondaryLabel
            }
            
            button.addTarget(self,
                             action: #selector(didTapTab(_:)),
                             for: .touchUpInside)
        }
    }
    
    @objc private func didTapTab(_ sender: UIButton) {
       // print(sender.titleLabel?.text ?? "")
        guard let label = sender.titleLabel?.text else {
            return
        }
        switch label {
        case SectionTabs.tweets.rawValue:
            selectedTab = 0
        case SectionTabs.tweetsAndReplies.rawValue:
            selectedTab = 1
        case SectionTabs.media.rawValue:
            selectedTab = 2
        case SectionTabs.likes.rawValue:
            selectedTab = 3
        default:
            selectedTab = 0
        }
    }
    
    private func configureConstraits(){
        
        for i in 0..<tabs.count {
            let leadingAnchor = indicator.leadingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].leadingAnchor)
                   leadingAnchors.append(leadingAnchor)
            let trailingAnchor = indicator.trailingAnchor.constraint(equalTo: sectionStackView.arrangedSubviews[i].trailingAnchor)
                   trailingAnchors.append(trailingAnchor)
               }
        
        let profileHeaderImageViewConstraits = [
            profileHeaderImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileHeaderImageView.topAnchor.constraint(equalTo: topAnchor),
            profileHeaderImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileHeaderImageView.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        let profileAvatarImageViewConstraits = [
            profileAvatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileAvatarImageView.centerYAnchor.constraint(equalTo: profileHeaderImageView.bottomAnchor, constant: 10),
            profileAvatarImageView.widthAnchor.constraint(equalToConstant: 80),
            profileAvatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ]
        
        let displayNameLabelConstraits = [
            displayNameLabel.leadingAnchor.constraint(equalTo: profileAvatarImageView.leadingAnchor),
            displayNameLabel.topAnchor.constraint(equalTo: profileAvatarImageView.bottomAnchor, constant: 20)
        ]
        
        let usernameLabelConstraits = [
            usernameLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: displayNameLabel.bottomAnchor, constant: 5)
        ]
        
        let userBioLabelConstraits = [
            userBioLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            userBioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            userBioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 5)
        ]
        
        let joinDateImageViewConstraits = [
            joinDateImageView.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            joinDateImageView.topAnchor.constraint(equalTo: userBioLabel.bottomAnchor, constant: 5)
        ]
        
        let joinedDateLabelConstraits = [
            joinedDateLabel.leadingAnchor.constraint(equalTo: joinDateImageView.trailingAnchor, constant: 2),
            joinedDateLabel.bottomAnchor.constraint(equalTo: joinDateImageView.bottomAnchor)
        ]
        
        let followingCountLabelConstraits = [
            followingCountLabel.leadingAnchor.constraint(equalTo: displayNameLabel.leadingAnchor),
            followerCountLabel.topAnchor.constraint(equalTo: joinedDateLabel.bottomAnchor, constant: 10)
        ]
        
        let followingTextLabelConstraints = [
            followingTextLabel.leadingAnchor.constraint(equalTo: followingCountLabel.trailingAnchor, constant: 4),
            followingTextLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let followerCountLabelConstraits = [
            followerCountLabel.leadingAnchor.constraint(equalTo: followingTextLabel.trailingAnchor, constant: 8),
            followerCountLabel.bottomAnchor.constraint(equalTo: followingCountLabel.bottomAnchor)
        ]
        
        let followersTextLabelConstraits = [
            followersTextLabel.leadingAnchor.constraint(equalTo: followerCountLabel.trailingAnchor, constant: 4),
            followersTextLabel.bottomAnchor.constraint(equalTo: followerCountLabel.bottomAnchor)
        ]
        
        let sectionStackViewConstraits = [
            sectionStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 25),
            sectionStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
            sectionStackView.topAnchor.constraint(equalTo: followingCountLabel.bottomAnchor, constant: 5),
            sectionStackView.heightAnchor.constraint(equalToConstant: 35)
        ]
        
        let indicatorConstraints = [
            leadingAnchors[0],
            trailingAnchors[0],
            indicator.topAnchor.constraint(equalTo: sectionStackView.bottomAnchor, constant: -4),
            indicator.heightAnchor.constraint(equalToConstant: 4)
        ]
        
        NSLayoutConstraint.activate(profileHeaderImageViewConstraits)
        NSLayoutConstraint.activate(profileAvatarImageViewConstraits)
        NSLayoutConstraint.activate(displayNameLabelConstraits)
        NSLayoutConstraint.activate(usernameLabelConstraits)
        NSLayoutConstraint.activate(userBioLabelConstraits)
        NSLayoutConstraint.activate(joinDateImageViewConstraits)
        NSLayoutConstraint.activate(joinedDateLabelConstraits)
        NSLayoutConstraint.activate(followingCountLabelConstraits)
        NSLayoutConstraint.activate(followingTextLabelConstraints)
        NSLayoutConstraint.activate(followerCountLabelConstraits)
        NSLayoutConstraint.activate(followersTextLabelConstraits)
        NSLayoutConstraint.activate(sectionStackViewConstraits)
        
        NSLayoutConstraint.activate(indicatorConstraints)
        
    }

}
