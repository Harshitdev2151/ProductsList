//
//  NewsService.swift
//  NewsReader
//
//  Created by Harshit Kumar on 10/03/24.
//

import Foundation

protocol NewsServiceProtocol {
     func fetchUsers(completion: @escaping (Result<News, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    // Other possible errors
}

class ProductsService: NewsServiceProtocol {

     func fetchUsers(completion: @escaping (Result<News, NetworkError>) -> Void) {
         print("getdate is \(getdate())")
         guard let serviceURL = URL(string: EndPointURLs.newsServiceURL) else {
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
                let users = try JSONDecoder().decode(News.self, from: newData)
                if users.articles != nil {
                    completion(.success(users))
                } else {
                    completion(.failure(.requestFailed))
                }
            } catch {
                completion(.failure(.requestFailed))
            }
        }.resume()
    }
}
