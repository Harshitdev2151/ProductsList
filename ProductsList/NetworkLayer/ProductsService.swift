//
//  NewsService.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation

/**
 Protocol to fetch Products detail from server and return the products/ error based on condition
 */
protocol ProductsServiceProtocol {
     func fetchProducts(_ currentSkipProductCount: Int, completion: @escaping (Result<Products, NetworkError>) -> Void)
}

class ProductsService: ProductsServiceProtocol {
    
    /// Metod to fetch products detail from remote server
    /// - Parameters:
    ///   - currentSkipProductCount: for paination to load 10 set of data in one count
    ///   - completion: completion handler to return products/ error to callin class
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
                if products.productList != nil {
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
