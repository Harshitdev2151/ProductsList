//
//  MockProductsService.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 02/04/24.
//



import Foundation
import UIKit
@testable import ProductsList


class MockProductsService: ProductsServiceProtocol {
    var isFailedService = false
    func fetchProducts(_ currentSkipProductCount: Int, completion: @escaping (Result<ProductsList.Products, ProductsList.NetworkError>) -> Void) {
        if !isFailedService {
            completion(.success(products))
        } else {
            completion(.failure(.requestFailed))
        }
    }


     var products: Products {
        return Products(products: [Product(title: "Black Motorbike",
                                           description: "Engine Type:Wet sump, Single Cylinder, Four Stroke, Two Valves, Air Cooled with SOHC (Single Over Head Cam) Chain Drive Bore & Stroke:47.0 x 49.5 MM")])
    }

}
