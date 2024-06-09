//
//  StorageManager.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 08/06/2024.
//

import Foundation
import Combine
import FirebaseStorageCombineSwift
import FirebaseStorage

enum FiresstorageError: Error {
    case invalidImageID
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    let storage = Storage.storage()
    
    func getDownloadURL(for id: String?) -> AnyPublisher<URL, Error> {
        guard let id = id else {
            return Fail(error: FiresstorageError.invalidImageID)
                .eraseToAnyPublisher()
        }
        return storage
            .reference(withPath: id)
            .downloadURL()
            .print()
            .eraseToAnyPublisher()
    }
    
    
    func uploadProfilePhoto(with randomID: String, image: Data, metaData: StorageMetadata) -> AnyPublisher<StorageMetadata, Error> {
        
        return storage
            .reference()
            .child("images/\(randomID).jpg")
            .putData(image, metadata: metaData)
            .print()
            .eraseToAnyPublisher()
    }
    
   
}
