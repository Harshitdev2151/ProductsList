//
//  Products.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

struct Products: Codable {
    var productList: [Product]?
    var total: Int?
    var skip: Int?
    var limit: Int?

    enum CodingKeys: String, CodingKey {
        case total, skip, limit
        case productList = "products"
    }
}

struct Product: Codable {
    var title: String?
    var description: String?
    var thumbnail: String?
    var price: Int?
    var rating: Double?
    var brand: String?
    var category: String?
}
