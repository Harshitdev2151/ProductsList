//
//  ViewControllerHelper.swift
//  ProductsList
//
//  Created by Harshit Kumar on 11/04/24.
//

import Foundation

// MARK: - Root ViewController Configuration
/**
 Viewcontroller methods needed to perform press funcionality and Load more at bottom of tableview
 */
extension ViewController {

    /// When server is returning error then error screen will come and this is action on click of that button
    /// - Parameter sender: sender description
    @IBAction func pressErrorBtn(_ sender: Any) {
        activityIndicatorView.startAnimating()
        self.viewModel.fetchProducts()
    }

    /// Called when activity indicator is showing at bottom of tableview to load next set of data
    func beginBatchFetch() {
        self.fetchingMore = true
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.viewModel.fetchProducts()

        })
    }
}
