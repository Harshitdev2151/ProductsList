//
//  ProductItem+CoreDataProperties.swift
//  ProductsList
//
//  Created by Harshit Kumar on 04/04/24.
//
//

import CoreData

extension ProductItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductItem> {
        return NSFetchRequest<ProductItem>(entityName: Constants.productItemEntity)
    }

    @NSManaged public var id: Int16
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var rating: Double
    @NSManaged public var title: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var count: Int16
    @NSManaged public var price: Int16


}

extension ProductItem : Identifiable {

}
