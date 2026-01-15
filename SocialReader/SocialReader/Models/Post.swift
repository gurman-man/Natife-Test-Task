//
//  Post.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import Foundation

struct Post: Codable, Hashable {
    // MARK: - API Data
    
    let postId: Int
    let timeshamp: TimeInterval
    let title: String
    let previewText: String
    let likesCount: Int
    
    // MARK: - Local State (Local Identifier)
    let uuid = UUID()
    var isExpanded: Bool = false
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case timeshamp
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
