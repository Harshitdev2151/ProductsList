//
//  DetailProductViewModel.swift
//  ProductsList
//
//  Created by Harshit Kumar on 23/04/24.
//

import Foundation
import UIKit

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
    
    /// saveData in DB
    /// - Parameter productInfo: productInfo to add in DB
    func saveData(_ productInfo: Product) {
        self.productsCoreDataHelper.saveData(productInfo)
    }
}
