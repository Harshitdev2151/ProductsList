//
//  DetailProductViewModel.swift
//  ProductsList
//
//  Created by Harshit Kumar on 23/04/24.
//

import Foundation
import UIKit

/// ViewModel for DetailVC for particular product
class DetailProductViewModel {

    var productsCoreDataHelper: ProductsCoreDataHelper
    private var imageLoader: ImageLoaderProtocol

    init(imageLoader: ImageLoaderProtocol = AsyncImageView(),
         productsCoreDataHelper: ProductsCoreDataHelper) {
        self.imageLoader = imageLoader
        self.productsCoreDataHelper = productsCoreDataHelper
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
    
    /// Update Product in DB
    /// - Parameter product: product description
    /// - Returns: Error if it opccurs else nil
    func updateProduct(_ product: Product) throws -> Error? {
        return try? self.productsCoreDataHelper.updateProduct(product)
    }

}
