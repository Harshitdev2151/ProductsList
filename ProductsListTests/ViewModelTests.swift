//
//  ViewModelTests.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 02/04/24.
//

import XCTest
@testable import ProductsList


final class ViewModelTests: XCTestCase {

    var storyboard: UIStoryboard!
    var rootViewModel: RootViewModel!
    var mockProductsService: MockProductsService!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockProductsService = MockProductsService()
        rootViewModel = RootViewModel(productsService: mockProductsService)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storyboard = nil
        mockProductsService = nil

    }

    func testProductListForSuccessScenario() throws {
        let myExpectation = expectation(description: "Expected the successful API for news articles called")

        mockProductsService.isFailedService = false
        rootViewModel.fetchProducts()
        myExpectation.fulfill()

        XCTAssertEqual(rootViewModel.products.productList?.count, 1)
        self.wait(for: [myExpectation], timeout: 5)
    }

    func testProductListForFailureScenario() throws {
        let myExpectation = expectation(description: "Expected the successful API for news articles called")

        mockProductsService.isFailedService = true
        rootViewModel.fetchProducts()
        myExpectation.fulfill()

        XCTAssertNil(rootViewModel.products.productList)
        self.wait(for: [myExpectation], timeout: 5)
    }

    func testExample() throws {
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
