//
//  SearchViewViewModel.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 22/06/2024.
//

import Foundation
import Combine

class SearchViewViewModel {
    
    var subscription: Set<AnyCancellable> = []
    
    func search(with query: String, _ completion: @escaping ([TwitterUser]) -> Void) {
        
        DatabaseManager.shared.collectionUsers(search: query)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { users in
                completion(users)
            }
            .store(in: &subscription)
    }
}
