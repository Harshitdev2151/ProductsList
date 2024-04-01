//
//  EndPointURLs.swift
//  NewsReader
//
//  Created by Harshit Kumar on 14/03/24.
//

import Foundation

struct EndPointURLs {
    static let defaultImageURL = "https://cdn.portfolio.hu/articles/images-lg/s/z/e/szemelyesen-lobbizik-a-tesla-alelnokenel-osszel-szijjarto-274325.jpg"
    
    static let newsServiceURL =
    "https://newsapi.org/v2/everything?q=bitcoin&from=2024-03-\(getdate())&sortBy=publishedAt&apiKey=ec47e5338373481893c8cd4cf781bb68"
}
