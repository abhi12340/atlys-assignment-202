//
//  CarouselViewController.swift
//  Atlys-project
//
//  Created by Abhishek Kumar on 12/10/24.
//

import UIKit

import UIKit

class CarouselViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    var images: [UIImage] = [] // Array to store images
    
    // Manager responsible for adding images and setting up the carousel
    private var carouselManager: CarouselManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Using a guard to handle optional values
        guard let images = loadImages() else {
            print("Error: Failed to load images")
            return
        }
        self.images = images
        
        setupScrollView()
        setupStackView()
        
        carouselManager = CarouselManager(scrollView: scrollView, stackView: stackView, images: images)
        
        scrollView.delegate = self // Assign the delegate to handle scroll events
    }
    
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true // Enable paging to snap to images
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1)
        ])
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    // Use an image loader service to load the images
    func loadImages() -> [UIImage]? {
        let imageLoader = DefaultImageLoader()
        return imageLoader.loadImages()
    }
    
    // Scroll View Delegate to handle zoom effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselManager?.applyZoomEffect()
    }
    
    // Ensure the center image is zoomed in when scrolling stops
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set the initial offset to display the middle image
        let initialOffset = CGPoint(x: scrollView.bounds.size.width, y: 0)
        scrollView.setContentOffset(initialOffset, animated: false)
        
        scrollViewDidScroll(scrollView) // Trigger zoom effect for the initial state
    }
}



