//
//  ViewControllerTests.swift
//  ProductsListTests
//
//  Created by Harshit Kumar on 02/04/24.
//

import XCTest
@testable import ProductsList


final class ViewControllerTests: XCTestCase {
    var storyboard: UIStoryboard!
    var rootViewModel: RootViewModel!
    var sut: ViewController!
    var mockProductsService: MockProductsService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "ViewController") as ViewController
        mockProductsService = MockProductsService()
        sut.loadViewIfNeeded()
        sut.viewModel = RootViewModel(productsService: mockProductsService, delegate: sut)

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storyboard = nil
        sut =  nil
        mockProductsService = nil

    }

    func testProductsNotNil() {
        let myExpectation = expectation(description: "Expected the product not to be nil")

        DispatchQueue.main.async {
            XCTAssertNotNil(self.sut.products)
            XCTAssertEqual(self.sut.products?.productList?.count, 1)
            myExpectation.fulfill()
        }
        self.wait(for: [myExpectation], timeout: 5)
    }

    func testCellForRowAtIndexPath() {
        let productsTableViewCell = self.sut.tableView(self.sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as! ProductsTableViewCell
        XCTAssertNotNil(productsTableViewCell)

    }

    func testNumberOfRows() {
        let numberOfRows =  sut.tableView(sut.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, sut.products?.productList?.count)
    }

    func testDidSelectRow() {
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(sut.calledSegue.destination as? DetailViewController)
    }

    func testDetailVC() {
        sut.tableView(sut.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
        if let detailVC = sut.calledSegue.destination as? DetailViewController {
            detailVC.loadViewIfNeeded()
            detailVC.product = sut.products?.productList?[0]
            XCTAssertNotNil(detailVC.titleLabel.text)
            XCTAssertNotNil(detailVC.descLbl.text)
        }
    }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
