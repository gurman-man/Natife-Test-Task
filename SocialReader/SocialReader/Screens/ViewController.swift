//
//  ViewController.swift
//  SocialReader
//
//  Created by mac on 14.01.2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            do {
                print("Downloading...")
                let posts = try await NetworkService.shared.fetchPosts()
                
                print("Success - total post: \(posts.count)")
                
                // Друкуємо перший пост для перевірки
                if let firstPost = posts.first {
                    print("First post: \(firstPost.title)")
                    print("Likes: \(firstPost.likesCount)")
                }
                
            } catch {
                print("Failure: \(error)")
            }
        }
    }

}

