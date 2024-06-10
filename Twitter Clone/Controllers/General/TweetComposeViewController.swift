//
//  TweetComposeViewController.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 10/06/2024.
//

import UIKit

class TweetComposeViewController: UIViewController {
    
    private let tweetButton : UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.setTitle("Tweet", for: .normal)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.isEnabled = false
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.7), for: .disabled)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Tweet"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapToCancel))
        
        view.addSubview(tweetButton)
        
        configureConstraints()
    }
    
    @objc private func didTapToCancel(){
        dismiss(animated: true)
    }
    
    

    private func configureConstraints(){
        
        let tweetButtonConstraints = [
            tweetButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -10),
                       tweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                       tweetButton.widthAnchor.constraint(equalToConstant: 120),
                       tweetButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(tweetButtonConstraints)
    }

}

