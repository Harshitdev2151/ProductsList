//
//  ProductsCoreDataInteractorTests.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 04/04/24.
//

import XCTest
@testable import ProductsList
import CoreData

class MockPersistentStoreContainer: NSPersistentContainer {
    init() {
        let modelUrl = Bundle.main.url(forResource: "ProductsList", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel.init(contentsOf: modelUrl)!
        super.init(name: "ProductsList", managedObjectModel: managedObjectModel)
        let description = NSPersistentStoreDescription.init()
        description.type = NSInMemoryStoreType
        self.persistentStoreDescriptions = [description]
        [self.loadPersistentStores(completionHandler: { (persistentStore, error) in
            if (error as NSError?) != nil {
            }
        })]
    }
}
class ProductsCoreDataInteractorTests: XCTestCase {

    var productsCoreDataInteractor: ProductsCoreDataInteractor?
    var context: NSManagedObjectContext?
    override func setUpWithError() throws {
        let persistentStore = MockPersistentStoreContainer.init()
        self.context = persistentStore.newBackgroundContext()
        self.productsCoreDataInteractor = ProductsCoreDataInteractor.init(withContext: self.context!)
    }
override func tearDownWithError() throws {
        self.context = nil
    }

    func testSaveData() {
        self.productsCoreDataInteractor?.saveData(products.productList?[0] ?? Product())

        let products = self.productsCoreDataInteractor?.fetchAllProductAddedToCart()
        XCTAssertEqual(products?.count, 1)

        let product = products?[0]
        let title =  product?.value(forKeyPath: "title") as? String
        XCTAssertEqual(title, "Black Motorbike")

    }


    var products: Products {
        return Products(productList: [Product(title: "Black Motorbike",
                                          description: "Engine Type:Wet sump, Single Cylinder, Four Stroke, Two Valves, Air Cooled with SOHC (Single Over Head Cam) Chain Drive Bore & Stroke:47.0 x 49.5 MM")])
   }

}
