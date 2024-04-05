//
//  NewsService.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation

protocol ProductsServiceProtocol {
     func fetchProducts(_ currentSkipProductCount: Int, completion: @escaping (Result<Products, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    // Other possible errors
}

class ProductsService: ProductsServiceProtocol {
    func fetchProducts(_ currentSkipProductCount: Int = 10, completion: @escaping (Result<Products, NetworkError>) -> Void) {
        let urlString = "\(EndPointURLs.productsServiceURL)\(currentSkipProductCount)"

         guard let serviceURL = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: serviceURL) { data, _, error in
            if error != nil {
                completion(.failure(.requestFailed))
                return
            }
            guard let newData = data else {
                completion(.failure(.requestFailed))
                return
            }
            do {
                let products = try JSONDecoder().decode(Products.self, from: newData)
                if products.products != nil {
                    completion(.success(products))
                } else {
                    completion(.failure(.requestFailed))
                }
            } catch {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
