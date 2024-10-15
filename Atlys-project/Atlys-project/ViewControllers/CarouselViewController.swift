//
//  CarouselViewController.swift
//  Atlys-project
//
//  Created by Abhishek Kumar on 12/10/24.
//

import UIKit

class CarouselViewController: UIViewController, UIScrollViewDelegate, CarouselDelegate {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var carouselManager: CarouselManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupStackView()
        loadImages()
        
        scrollView.delegate = self
    }

    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = false // Disable default paging for custom behavior
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.decelerationRate = .fast
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1) // 1:1 aspect ratio
        ])
    }

    func setupStackView() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0 // Will be set dynamically in the manager
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

    func loadImages() {
        let imageLoader = DefaultImageLoader()
        // Initialize the carousel manager with dependency injection
        carouselManager = CarouselManager(scrollView: scrollView, stackView: stackView, images: imageLoader)
        carouselManager?.delegate = self
    }

    // ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselManager?.handleScroll()
    }

    // CarouselDelegate method
    func didScrollToPage(index: Int) {
        print("Scrolled to page: \(index)")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set the initial offset to display the middle image
        carouselManager?.handleScroll()
    }
}



