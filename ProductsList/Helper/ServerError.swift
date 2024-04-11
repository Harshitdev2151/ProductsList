//
//  ServerError.swift
//  ProductsList
//
//  Created by Harshit Kumar on 11/04/24.
//

/**

 Enumerations for all possible errors from server fetch
 */
enum ServerError: Error {
    case unsupportedURL
    case incorrectImageFormat
    case incorrectResponse
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    // Other possible errors
}
