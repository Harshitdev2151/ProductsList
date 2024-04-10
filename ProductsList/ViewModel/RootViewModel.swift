//
//  RootViewModel.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//


import UIKit

protocol RootViewModelDelegate: AnyObject {
    func  fetchProducts(_ products: Products?)
    func showError(message: String)
}

class RootViewModel {
    var productsService: ProductsServiceProtocol
    var products = Products()
    weak var delegate: RootViewModelDelegate?
    static var currentSkipProductCount = 0
    var imageLoader: ImageLoaderProtocol

    init(productsService: ProductsServiceProtocol,
         delegate: RootViewModelDelegate? = nil, imageLoader: ImageLoaderProtocol = AsyncImageView()) {
        self.delegate = delegate
        self.productsService = productsService
             self.imageLoader = imageLoader

    }

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

    func fetchImage(_ url: String,completion: @escaping (UIImage?) -> Void) {
        imageLoader.fetchImage(url) { image in
            completion(image)
        }
    }

}
