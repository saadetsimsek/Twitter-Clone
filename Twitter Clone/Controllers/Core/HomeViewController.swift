//
//  ViewController.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 28/05/2024.
//

import UIKit
import FirebaseAuth
import Combine

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    private lazy var composeTweetButton: UIButton = {
        let button = UIButton(type: .system, primaryAction: UIAction { [weak self] _ in
           // print("Tweet is being")
            self?.navigateToTweetComposer()
        })
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .twitterBlueColor
        button.tintColor = .white
        let plusSign = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        return button
    }()
    
    private let timeLineTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(timeLineTableView)
        view.addSubview(composeTweetButton)
        
        timeLineTableView.delegate = self
        timeLineTableView.dataSource = self
        
        configureNavigationBar()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapSignOut))
        
        bindViews()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        timeLineTableView.frame = view.bounds
        configureConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        handleAuthentication()
        viewModel.retreiveUser()
     
    }
    
    private func navigateToTweetComposer(){
        let vc = UINavigationController(rootViewController: TweetComposeViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
    }
    
    private func handleAuthentication(){
        if Auth.auth().currentUser == nil {
            let vc = UINavigationController(rootViewController: OnboardingViewController())
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    private func bindViews(){ //listen, eğer kullanıcı giriş yaparsa
        viewModel.$user.sink { [weak self] user in // $ publisher
            guard let user = user else {
                return
            }
            if !user.isUserOnboarded {
                self?.completeUsersOnboarding()
            }
        }
        .store(in: &subscriptions)
        
        viewModel.$tweets.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.timeLineTableView.reloadData()
            }
        }
        .store(in: &subscriptions)
    }
    
    func completeUsersOnboarding(){
        let vc = ProfileDataFormViewController()
        present(vc, animated: true)
    }
    
    
    
    private func configureNavigationBar(){
        let size: CGFloat = 36
        let logoImageView = UIImageView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: size,
                                                      height: size))
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.image = UIImage(named: "twitterLogo")
        
        let middleView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: size,
                                              height: size))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
        
        let profileImage = UIImage(systemName: "person")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: profileImage,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(didTapProfile))
    }
    
    @objc private func didTapProfile(){
        guard let user = viewModel.user else {return}
        let profileViewModel = ProfileViewViewModel(user: user)
        let vc = ProfileViewController(viewModel: profileViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapSignOut(){
        try? Auth.auth().signOut()
        handleAuthentication()
    }
    
    private func configureConstraints(){
        let composeTweetButtonConstraints = [
            composeTweetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            composeTweetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120),
            composeTweetButton.widthAnchor.constraint(equalToConstant: 60),
            composeTweetButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(composeTweetButtonConstraints)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else{
            return UITableViewCell()
        }
        let tweetModel = viewModel.tweets[indexPath.row]
        cell.configureTweet(with: tweetModel.author.displayName,
                            username: tweetModel.author.username,
                            tweetTextContext: tweetModel.tweetContent,
                            avatarPath: tweetModel.author.avatarPath)
        cell.delegate = self
        return cell
    }
    
}


extension HomeViewController: TweetTableViewCellDelegate {
    func tweetTableViewCellDidTapReply() {
        print("reply")
    }
    
    func tweetTableViewCellDidTapRetweet() {
        print("retweet")
    }
    
    func tweetTableViewCellDidTapLike() {
        print("like")
    }
    
    func tweetTableViewCellDidTapShare() {
        print("share")
    }
    
    
}
