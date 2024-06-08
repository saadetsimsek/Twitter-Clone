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
    
}
