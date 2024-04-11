//
//  CartTableViewControllerTests.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 04/04/24.
//

import XCTest
@testable import ProductsList
import CoreData

final class CartTableViewControllerTests: XCTestCase {

    var storyboard: UIStoryboard!
    var sut: CartTableViewController!
    var context: NSManagedObjectContext!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "CartTableViewController") as CartTableViewController
        let persistentStore = MockPersistentStoreContainer.init()
        sut.context = persistentStore.newBackgroundContext()
        sut.productsCoreDataInteractor = ProductsCoreDataHelper.init(withContext: sut.context)
        sut.productsCoreDataInteractor?.saveData(products.productList?[0] ?? Product())
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testProductIsNotNil() throws {

        XCTAssertNotNil(sut.products)
        XCTAssertEqual(sut.products.count, 1)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testCellForRow() throws {
        XCTAssertNotNil(sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)))
    }


    var products: Products {
        return Products(productList: [Product(title: "Black Motorbike",
                                          description: "Engine Type:Wet sump, Single Cylinder, Four Stroke, Two Valves, Air Cooled with SOHC (Single Over Head Cam) Chain Drive Bore & Stroke:47.0 x 49.5 MM")])
   }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
