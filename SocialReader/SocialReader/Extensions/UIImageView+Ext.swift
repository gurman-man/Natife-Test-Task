//
//  UIImageView+Ext.swift
//  SocialReader
//
//  Created by mac on 16.01.2026.
//

import UIKit
fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImage(from urlString: String) {
        // Reset previous image to avoid flickering
        self.image = nil
        
        guard let url = URL(string: urlString) else { return }
        
        // 1. Check for cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        // 2. Download asynchronously
        Task {
            do {
                // Fetch image data from the network
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Try to create a UIImage and update the UI on the Main Thread
                if let newImage = UIImage(data: data) {
                    
                    // Save to cache
                    imageCache.setObject(newImage, forKey: urlString as NSString)
                    
                    await MainActor.run() {
                        self.image = newImage
                    }
                }
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
}
