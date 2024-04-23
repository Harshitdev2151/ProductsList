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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
