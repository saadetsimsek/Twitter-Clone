//
//  ProfileViewViewModel.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 09/06/2024.
//

import Foundation
import Combine
import FirebaseAuth

final class ProfileViewViewModel: ObservableObject {
    
    @Published var user: TwitterUser?
    @Published var error: String?
    @Published var tweets: [Tweet] = []
    
    private var subscriptions: Set <AnyCancellable> = []
    
    
    func retreiveUser(){
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
    
    func fetchUserTweets(){
        guard let user = user else {return}
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
}
