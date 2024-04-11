//
//  Products.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//


/**
 Model struct to parse data recieved from server
 This will automatically parse the data, jsut have to give the require key withh exact name
 */
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
