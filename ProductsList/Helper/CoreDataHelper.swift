//
//  CoreDataHelper.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import CoreData
import UIKit

/**
 Core data helper to save and fetc the data from DB
 */
struct ProductsCoreDataHelper {
    private var context : NSManagedObjectContext
    
    /// Constructor with context for DI
    /// - Parameter context: context description
    init(withContext context : NSManagedObjectContext) {
        self.context = context
    }
    
    /// Save particular product to DB
    /// - Parameter productInfo: productInfo description
    private func saveData(_ productInfo: Product) {
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.

         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: Constants.productItemEntity,
                                                in: self.context)!

        /*
         Initializes a managed object and inserts it into the specified managed object context.

         init(entity: NSEntityDescription,
         insertInto context: NSManagedObjectContext?)
         */
        let product = NSManagedObject(entity: entity,
                                      insertInto: self.context)

        /*
         With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
         */
        product.setValue(productInfo.title, forKeyPath: Constants.titleString)
        product.setValue(productInfo.description, forKeyPath: Constants.descString)
        product.setValue(productInfo.category, forKeyPath: Constants.categoryString)
        product.setValue(productInfo.thumbnail, forKeyPath: Constants.thumbnailString)
        product.setValue(productInfo.rating, forKeyPath: Constants.productRating)
        product.setValue(productInfo.id, forKeyPath: Constants.productItemID)
        product.setValue(1, forKeyPath: Constants.productItemCoun)
        product.setValue(productInfo.price, forKeyPath: Constants.productItemPrice)

        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try self.context.save()
        } catch _ as NSError {
        }
    }
    
    /// Fetch all products from DB with entity name "Constants.productItemEntity"
    /// - Returns: Array of [ProductItem]
    func fetchAllProductAddedToCart() -> [ProductItem]? {
        /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.

         Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
         */
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.productItemEntity)

        /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
        do {
            let products = try self.context.fetch(fetchRequest) as? [ProductItem]
            return products
        } catch _ as NSError {
            return nil
        }

    }
    
    /// Update Product in DB(save if no record is there else update the quantity)
    /// - Parameter product: product description
    /// - Returns: error if it occurs else nil
    func updateProduct(_ product: Product) throws -> Error? {
        let fetchRequest = NSFetchRequest<ProductItem>(entityName: Constants.productItemEntity)
        fetchRequest.predicate = NSPredicate(format: "id = %i", product.id ?? 0)
        do {
            let products = try self.context.fetch(fetchRequest)
// If no entity is found with that ID then save from scratch
            if products.count == 0 {
                self.saveData(product)
            } else {
                // If entity is found with that ID then update the count of that entity by 1
                let product = products[0]
                let count = product.count
                product.setValue(count + 1, forKey: Constants.productItemCoun)
            }

            try self.context.save()
        } catch let error as NSError {
            throw error
        }
        return nil
    }
    
    /// Delete all data from Entity
    /// - Parameter entity: entity description
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try self.context.execute(DelAllReqVar) }
        catch { print(error) }
    }
}
