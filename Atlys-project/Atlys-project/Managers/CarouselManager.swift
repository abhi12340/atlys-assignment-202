//
//  CarouselManager.swift
//  Atlys-project
//
//  Created by Abhishek Kumar on 12/10/24.
//

import UIKit

protocol CarouselDelegate: AnyObject {
    func didScrollToPage(index: Int)
}

class CarouselManager {
    private let scrollView: UIScrollView
    private let stackView: UIStackView
    private let images: [UIImage]?
    weak var delegate: CarouselDelegate?

    private let zoomScale: CGFloat = 1.2 // Zoom scale for the centered image
    private let defaultScale: CGFloat = 0.8 // Default scale for non-centered images
    private let imageSpacing: CGFloat = 20 // Spacing around images
    private let imageWidthMultiplier: CGFloat = 0.7 // Set image width to 70% of scroll view width

    init(scrollView: UIScrollView, stackView: UIStackView, images: ImageLoader) {
        self.scrollView = scrollView
        self.stackView = stackView
        self.images = images.loadImages()
        setupImages()
    }

    private func setupImages() {
        for image in images ?? [] {
            let containerView = UIView() // Container for each image to add spacing
            containerView.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(containerView)
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 10
            imageView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: imageSpacing),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -imageSpacing),
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: imageSpacing),
                imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -imageSpacing),
                
                containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: imageWidthMultiplier),
                containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
        }
        zoomInImage(at: 1)
    }

    func handleScroll() {
        let currentPage = currentPageIndex()
        zoomInImage(at: currentPage)
    }

    private func zoomInImage(at index: Int) {
        for (i, view) in stackView.arrangedSubviews.enumerated() {
            let imageView = view.subviews.first as? UIImageView
            if i == index {
                UIView.animate(withDuration: 0.3) {
                    imageView?.transform = CGAffineTransform(scaleX: self.zoomScale, y: self.zoomScale)
                    imageView?.superview?.layer.zPosition = 1 // Bring to front
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    imageView?.transform = CGAffineTransform(scaleX: self.defaultScale, y: self.defaultScale)
                    imageView?.superview?.layer.zPosition = -1 // Send to back
                }
            }
        }
    }

    private func currentPageIndex() -> Int {
        let pageWidth = scrollView.bounds.size.width * imageWidthMultiplier
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        return currentPage
    }
}


