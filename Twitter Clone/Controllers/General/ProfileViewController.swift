//
//  ProfileViewController.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 03/06/2024.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    private var viewModel: ProfileViewViewModel
    
    private var subscription: Set<AnyCancellable> = []
    
    init(viewModel: ProfileViewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: profileTableView.frame.width,
                                                                  height: 400))
    
    private let statusBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.opacity = 0
        return view
    }()
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
    /*    let headerView = ProfileTableViewHeader(frame: CGRect(x: 0,
                                                              y: 0,
                                                              width: profileTableView.frame.width,
                                                              height: 400))
     */
        
        profileTableView.tableHeaderView = headerView
        
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        
        configureConstraits()
        bindViews()
        
     //   viewModel.retreiveUser()
        viewModel.fetchUserTweets()
    }
    
    
    private func bindViews(){
        
        viewModel.$tweets.sink {[weak self] _ in
            DispatchQueue.main.async {
                self?.profileTableView.reloadData()
            }
        }
        .store(in: &subscription)
        
        viewModel.$user.sink { [weak self] user in
          //  guard let user = user else {
          //      return
          //  }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.usernameLabel.text = "@\(user.username)"
            self?.headerView.followerCountLabel.text = "\(user.followersCount)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.userBioLabel.text = user.bio
            
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath)) //profile picture 
            
            self?.headerView.joinedDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "")"
            
        }
        .store(in: &subscription)
        
        viewModel.$currentFollowingState.sink { [weak self] state in
            switch state {
            case .personal:
                self?.headerView.configureAsPersonal()
            case .userIsFollowed:
                self?.headerView.configureButtonUnFollowed()
            case .userIsUnFollowed:
                self?.headerView.configureButtonAsFollowed()
            }
        }
        .store(in: &subscription)
        
        headerView.followButtonActionPublisher.sink {[weak self] state in
            switch state {
            case .userIsFollowed:
                self?.viewModel.unFollow()
            case .userIsUnFollowed:
                self?.viewModel.follow()
            case .personal:
                return
            }
        }
        .store(in: &subscription)
    }
    
    private func configureConstraits(){
        
        let profileTableViewConstraits = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraits = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraits)
        NSLayoutConstraint.activate(statusBarConstraits)
    }


}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        let tweet = viewModel.tweets[indexPath.row]
        cell.configureTweet(with: tweet.author.displayName,
                            username: tweet.author.username,
                            tweetTextContext: tweet.tweetContent,
                            avatarPath: tweet.author.avatarPath)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 1
            } completion: {_ in }
        }
        else if yPosition < 0 && !isStatusBarHidden {
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           options: .curveLinear) { [weak self] in
                self?.statusBar.layer.opacity = 0
            } completion: { _ in }
        }
    }
}
