//
//  UIImageView+Ext.swift
//  SocialReader
//
//  Created by mac on 16.01.2026.
//

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String) {
        self.image = nil
        
        // Validate the URL string
        guard let url = URL(string: urlString) else { return }
        
        // Start an asynchronous task to dowload image
        Task {
            do {
                // Fetch image data from the network
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // Try to create a UIImage and update the UI on the Main Thread
                if let newImage = UIImage(data: data) {
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
