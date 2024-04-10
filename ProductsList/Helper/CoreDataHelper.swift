//
//  CoreDataHelper.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import CoreData
import UIKit


struct ProductsCoreDataInteractor {
    var context : NSManagedObjectContext
    init(withContext context : NSManagedObjectContext) {
        self.context = context
    }

    func saveData(_ productInfo: Product) {
        /*
         An NSEntityDescription object is associated with a specific class instance
         Class
         NSEntityDescription
         A description of an entity in Core Data.

         Retrieving an Entity with a Given Name here person
         */
        let entity = NSEntityDescription.entity(forEntityName: "ProductItem",
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
        product.setValue(productInfo.title, forKeyPath: "title")
        product.setValue(productInfo.description, forKeyPath: "desc")
        product.setValue(productInfo.category, forKeyPath: "category")
        product.setValue(productInfo.thumbnail, forKeyPath: "thumbnail")

        /*
         You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
         */
        do {
            try self.context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }


    func fetchAllProductAddedToCart() -> [NSManagedObject]? {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return nil
      }

        /*
      /*Before you can do anything with Core Data, you need a managed object context. */
      let managedContext = appDelegate.persistentContainer.viewContext
*/
      /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.

       Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
       */
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductItem")

      /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
      do {
          let products = try self.context.fetch(fetchRequest)
          return products
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
          return nil
      }

    }
}




