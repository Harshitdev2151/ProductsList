//
//  ProductItem+CoreDataProperties.swift
//  ProductsList
//
//  Created by Harshit Kumar on 04/04/24.
//
//

import Foundation
import CoreData


extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: "ProductItem")
    }

    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var rating: Int16
    @NSManaged public var title: String?
    @NSManaged public var thumbnail: String?

}

extension ProductItem : Identifiable {

}
