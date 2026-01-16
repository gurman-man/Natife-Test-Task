//
//  PostDetail.swift
//  SocialReader
//
//  Created by mac on 16.01.2026.
//

import Foundation

// MARK: - API Properties
struct PostDetail: Codable {
    let postId: Int
    let timeshamp: TimeInterval
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int
}

// MARK: - CodingKeys
enum CodingKeys: String, CodingKey {
    case postId
    case timeshamp
    case title
    case text
    case postImage = "postImage"
    case likesCount = "likes_count"
}
