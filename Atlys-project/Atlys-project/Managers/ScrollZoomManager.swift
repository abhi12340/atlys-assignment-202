//
//  ScrollZoomManager.swift
//  Atlys-project
//
//  Created by Abhishek Kumar on 12/10/24.
//

import UIKit

class ScrollZoomManager {
    
    private let scrollView: UIScrollView
    private let stackView: UIStackView
    private let images: [UIImage]
    
    // Inject dependencies via initializer
    init?(scrollView: UIScrollView?, stackView: UIStackView?, images: [UIImage]?) {
        // Safely unwrap and assign optional values to properties, else return nil
        guard let scrollView = scrollView,
              let stackView = stackView,
              let images = images, !images.isEmpty else {
            // If any dependency is missing, initialization will fail
            print("Error: ScrollView, StackView, or Images not provided correctly.")
            return nil
        }
        
        self.scrollView = scrollView
        self.stackView = stackView
        self.images = images
        
        setupImages()
    }
    
    private func setupImages() {
        for image in images {
            createImageView(image: image)
        }
    }
    
    private func createImageView(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10 // Rounded corners
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor) // 1:1 aspect ratio
        ])
    }
    
    // Apply zoom effect to the images in the scroll view
    func applyZoomEffect() {
        // Make sure the scrollView has content before proceeding
        guard !scrollView.subviews.isEmpty else {
            print("Error: ScrollView is empty.")
            return
        }
        
        let centerX = scrollView.contentOffset.x + scrollView.bounds.size.width / 2
        
        for case let imageView as UIImageView in stackView.arrangedSubviews {
            let imageCenterX = imageView.convert(imageView.center, to: scrollView).x
            let distanceFromCenter = abs(centerX - imageCenterX)
            let scale = max(1 - (distanceFromCenter / scrollView.bounds.size.width), 0.75)
            imageView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}

