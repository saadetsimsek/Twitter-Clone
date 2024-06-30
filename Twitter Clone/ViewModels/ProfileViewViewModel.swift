//
//  ProfileViewViewModel.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 09/06/2024.
//

import Foundation
import Combine
import FirebaseAuth

enum ProfileFollowingState {
    case userIsFollowed
    case userIsUnFollowed
    case personal
}

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    @Published var currentFollowingState: ProfileFollowingState = .personal
    
    private var subscriptions: Set <AnyCancellable> = []
    
    init(user: TwitterUser) {
        self.user = user
        checkIfFollow()
    }
    
    
/*   func retreiveUser(){
        guard let id = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionUsers(retreive: id)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.user = user
                self?.fetchUserTweets()
            }
            .store(in: &subscriptions)
    }
    */
    private func checkIfFollow(){
        guard let personalUserID = Auth.auth().currentUser?.uid,
        personalUserID != user.id
        else {
            currentFollowingState = .personal
            return
        }
        DatabaseManager.shared.collectionFollowings(isFollower: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] isFollowed in
                self?.currentFollowingState = isFollowed ? .userIsFollowed: .userIsUnFollowed
            }
            .store(in: &subscriptions)

    }
    
    func fetchUserTweets(){
       // guard let user = user else {return}
        DatabaseManager.shared.collectionTweets(retreiveTweets: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] tweets in
                self?.tweets = tweets
            }
            .store(in: &subscriptions)
    }
    
    func getFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM YYYY"
        return dateFormatter.string(from: date)
    }
    
    func follow(){
        guard let personalUserID = Auth.auth().currentUser?.uid else{return}
        DatabaseManager.shared.collectionFollowings(follower: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: {[weak self] isFollowed in
                self?.currentFollowingState = .userIsFollowed
            }
            .store(in: &subscriptions)
    }
    
    func unFollow(){
        guard let personalUserID = Auth.auth().currentUser?.uid else {return}
        DatabaseManager.shared.collectionFollowings(delete: personalUserID, following: user.id)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.currentFollowingState = .userIsUnFollowed
            }
            .store(in: &subscriptions)
    }
    
    
}
