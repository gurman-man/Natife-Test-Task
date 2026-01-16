//
//  PostListViewModel.swift
//  SocialReader
//
//  Created by mac on 15.01.2026.
//

import Foundation

final class PostListViewModel {
    // MARK: - Variables
    
    private(set) var posts: [Post] = []
    
    // Closures for bindings
    var onStateChanged: (() -> Void)?
    var onError: ((String) -> Void)?
    
    // MARK: - Methods
    
    func loadData() {
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                // Fetching on background thread
                let fetchedPosts = try await NetworkService.shared.fetchPosts()
                
                // Save & sort posts
                self.posts = fetchedPosts.sorted { $0.timeshamp > $1.timeshamp }
                
                // Updating State on Main Thread
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
    
    func togglePostState(postId: Int) {
        // Find the post index
        guard let index = posts.firstIndex(where: { $0.postId == postId }) else { return }
        
        // Toggle the expansion flag
        posts[index].isExpanded.toggle()
        
        // Notify View that data changed and refresh the UI
        onStateChanged?()
    }
}
