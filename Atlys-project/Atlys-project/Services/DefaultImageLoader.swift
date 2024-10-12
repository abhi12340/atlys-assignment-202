//
//  DefaultImageLoader.swift
//  Atlys-project
//
//  Created by Abhishek Kumar on 12/10/24.
//

import UIKit

import UIKit

class DefaultImageLoader: ImageLoader {
    
    func loadImages() -> [UIImage]? {
        let imageNames = ["1", "2", "3", "4", "5"]
        
        // Safely load images from the bundle
        let images: [UIImage] = imageNames.compactMap { imageName in
            if let image = UIImage(named: imageName) {
                return image
            } else {
                print("Warning: Image named \(imageName) not found.")
                return nil
            }
        }
        return images.isEmpty ? nil : images
    }
}

