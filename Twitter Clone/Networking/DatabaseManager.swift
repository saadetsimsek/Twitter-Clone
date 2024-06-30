//
//  DatabaseManager.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 06/06/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestoreCombineSwift
import Combine


class DatabaseManager {
    static let shared = DatabaseManager()
    
    let db = Firestore.firestore() //database erişme
    let usersPath: String = "users" // databasedeki veri tutucu collectionlar
    let tweetsPath: String = "tweets"
    let followingPath: String = "Followings"
    
    func collectionUsers(add user: User) -> AnyPublisher<Bool, Error> {
        let twitterUser = TwitterUser(from: user)
        return db.collection(usersPath).document(twitterUser.id).setData(from: twitterUser)
            .map{ _ in
                return true
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(retreive id: String) -> AnyPublisher<TwitterUser, Error> {
        db.collection(usersPath).document(id).getDocument()
            .tryMap {
                try $0.data(as: TwitterUser.self)
            }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(updateFields: [String: Any], for id: String) -> AnyPublisher<Bool, Error> {
        
        db.collection(usersPath).document(id).updateData(updateFields)
            .map{ _ in true}
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(dispatch tweet: Tweet) -> AnyPublisher<Bool, Error> {
        db.collection(tweetsPath).document(tweet.id).setData(from: tweet)
            .map { _ in true }
            .eraseToAnyPublisher()
    }
    
    func collectionUsers(search query: String) -> AnyPublisher<[TwitterUser], Error> {
        db.collection(usersPath).whereField("username", isEqualTo: query)
            .getDocuments()
            .map(\.documents)
            .tryMap { snapshots in
                try snapshots.map({
                    try $0.data(as: TwitterUser.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    func collectionTweets(retreiveTweets forUserID: String) -> AnyPublisher<[Tweet], Error>{
        
        db.collection(tweetsPath).whereField("authorID", isEqualTo: forUserID)
            .getDocuments()
            .tryMap(\.documents)
            .tryMap { snapshots in
                try snapshots.map({
                    try $0.data(as: Tweet.self)
                })
            }
            .eraseToAnyPublisher()
    }
    
    func collectionFollowings(isFollower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followingPath)
            .whereField("follower", isEqualTo: isFollower)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .map(\.count)
            .map {
                return $0 != 0 // true or false
            }
            .eraseToAnyPublisher()
    }
    
    func collectionFollowings(follower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followingPath).document().setData([
            "follower": follower,
            "following": following
        ])
        .map(){
            true
        }
        .eraseToAnyPublisher()
    }
    
    func collectionFollowings(delete follower: String, following: String) -> AnyPublisher<Bool, Error> {
        db.collection(followingPath)
            .whereField("follower", isEqualTo: follower)
            .whereField("following", isEqualTo: following)
            .getDocuments()
            .map(\.documents.first)
            .map { query in
                query?.reference.delete(completion: nil)
                return true
            }
            .eraseToAnyPublisher()
    }
}
