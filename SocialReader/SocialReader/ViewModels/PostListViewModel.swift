//
//  PostListViewModel.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import Foundation

final class PostListViewModel {
    // MARK: - Variables
    
    // Масив для збережння постів, отриманих з мережі
    private(set) var posts: [Post] = []
    
    var onStateChanged: (() -> Void)?   // спрацює коли дані оновляться
    var onError: ((String) -> Void)?
    
    // MARK: - Methods
    func loadData() {
        Task {
            do {
                // Receive posts
                let fetchedPosts = try await NetworkService.shared.fetchPosts()
                
                // Saved posts
                self.posts = fetchedPosts.sorted { $0.timeshamp > $1.timeshamp }
                
                // Return to the Main Thread to update the UI
                await MainActor.run {
                    self.onStateChanged?()
                }
                
            } catch {
                // Error handling
                await MainActor.run {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
