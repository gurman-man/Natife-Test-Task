//
//  NetworkService.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import Foundation

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


final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let urlString = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/main.json"
    
    func fetchPosts() async throws -> [Post] {
        
        // Verify URL
        guard let url = URL(string: urlString) else {
            throw PostError.invalidURL
        }
        
        // Do request
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // Decoding
        do {
            let decodedResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
            return decodedResponse.posts
        } catch {
            throw PostError.decodingError(error.localizedDescription)
        }
    }
    
}
