//
//  ImageExtension.swift
//  MedBook
//
//  Created by Rupesh Kumar Gangwar on 16/03/25.
//  Copyright © 2025 Rupesh Kumar Gangwar. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageWithUrl(coverId: String) {
        self.image = UIImage(systemName: "book")
        if coverId.isEmpty {
            return
        }
        
        let urlString = "https://covers.openlibrary.org/b/id/\(coverId)-M.jpg"
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        if let imageURL = URL(string: urlString) {
            APIManager.shared.downloadCoverImage(url: imageURL) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    guard let imageToCache = UIImage(data: data) else { return }
                    imageCache.setObject(imageToCache, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                case .failure(_):
                    //do nothing, default image already set
                    print("")
                }
            }
        }
    }
}
