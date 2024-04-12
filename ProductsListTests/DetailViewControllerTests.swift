//
//  DetailViewControllerTests.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 04/04/24.
//

import XCTest
@testable import ProductsList

final class DetailViewControllerTests: XCTestCase {

    var storyboard: UIStoryboard!
    var sut: DetailViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "DetailViewController") as DetailViewController
        sut.loadViewIfNeeded()
        _ = UINavigationController(rootViewController: sut)
    }

    override func tearDownWithError() throws {
        sut = nil
        storyboard = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddToCartNavigation() throws {
        let myExpectation = expectation(description: "Testing navigation controler")

        sut.cartBtn.titleLabel?.text = "Go to cart"
        sut.addToCart((Any).self)
        XCTAssertNotNil(sut.navigationController)
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let cartVC = self.sut.navigationController?.topViewController
            var isTopVCIsCartVC = false
            if cartVC is CartTableViewController {
                isTopVCIsCartVC = true
            }
            XCTAssertTrue(isTopVCIsCartVC)
            myExpectation.fulfill()
            // Put your code which should be executed with a delay here
        }
        self.wait(for: [myExpectation], timeout: 1)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
