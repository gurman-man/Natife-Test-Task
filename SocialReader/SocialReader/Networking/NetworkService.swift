//
//  NetworkService.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import Foundation

// MARK: - Custom Network Errors
enum PostError: LocalizedError {
    case invalidURL
    case networkError(String)
    case noData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:               return "Incorrect server address"
        case .networkError(let msg):    return "Network error: \(msg)"
        case .noData:                   return "The server failed to send the data"
        case .decodingError(let msg):   return "Response processing error: \(msg)"
        }
    }
}

// MARK: - Network Service
final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let urlString = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    

    // Fetches the list of all posts asynchronously
    func fetchPosts() async throws -> [Post] {
        
        // Verify URL
        guard let url = URL(string: urlString) else {
            throw PostError.invalidURL
        }
        
        // Do request
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decoding
        do {
            let decodedResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
            return decodedResponse.posts
        } catch {
            throw PostError.decodingError(error.localizedDescription)
        }
    }
    
    
    // Fetches detailed information for a specific post by its ID
    func fetchPostDetails(id: Int) async throws -> PostDetail {
        let urlString = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/posts/\(id).json"
        
        guard let url = URL(string: urlString) else { throw PostError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let detail = try JSONDecoder().decode(PostDetail.self, from: data)
            return detail
        } catch {
            throw PostError.decodingError(error.localizedDescription)
        }
    }
    
}
