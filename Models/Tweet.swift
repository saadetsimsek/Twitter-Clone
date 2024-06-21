//
//  Tweet.swift
//  Twitter Clone
//
//  Created by Saadet Şimşek on 10/06/2024.
//

import Foundation

struct Tweet: Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
    
}
