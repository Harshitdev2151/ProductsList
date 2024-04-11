//
//  RootViewModel.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//


import UIKit

/**
 Protocol to pass data/ error loggs to ViewController whichh is recieved from Network layer
 */
protocol RootViewModelDelegate: AnyObject {
    func  fetchProducts(_ products: Products?)
    func showError(message: String)
}

/**
 ViewModel which is part of MVVM pattern.
 It act as bridge betwwen VC and network layer
 Contains thhe business logic for app.
 */
class RootViewModel {
    private var productsService: ProductsServiceProtocol
    var products = Products()
    weak private var delegate: RootViewModelDelegate?
    static var currentSkipProductCount = 0
    private var imageLoader: ImageLoaderProtocol

    init(productsService: ProductsServiceProtocol,
         delegate: RootViewModelDelegate? = nil, imageLoader: ImageLoaderProtocol = AsyncImageView()) {
        self.delegate = delegate
        self.productsService = productsService
             self.imageLoader = imageLoader

    }
    
    /// Mrehod to fetch API response from server
    func fetchProducts() {
        // Assume a UserService for fetching users from an API
        self.productsService.fetchProducts(RootViewModel.currentSkipProductCount) { [weak self] result in
            switch result {
            case .success(let fetchedProducts):
                self?.products = fetchedProducts
                RootViewModel.currentSkipProductCount = RootViewModel.currentSkipProductCount + 10
                self?.delegate?.fetchProducts(self?.products)
            case .failure(let error):
                print(error)
                self?.delegate?.showError(message: error.localizedDescription)
            }
        }
    }
    
    /// Method to fetch Image from seever
    /// - Parameters:
    ///   - url: url description
    ///   - completion: completion description
    func fetchImage(_ url: String,completion: @escaping (UIImage?) -> Void) {
        imageLoader.fetchImage(url) { image in
            completion(image)
        }
    }
}
