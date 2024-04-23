//
//  DetailProductViewModel.swift
//  ProductsList
//
//  Created by Harshit Kumar on 23/04/24.
//

import Foundation
import UIKit
import CoreData

class CartViewModel {

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
    
    /// fetchAllProductAddedToCartFrom DB
    /// - Returns: Array of Managed Objects from DB
    func fetchAllProductAddedToCart() -> [NSManagedObject]? {
        return self.productsCoreDataHelper.fetchAllProductAddedToCart()
    }
}
