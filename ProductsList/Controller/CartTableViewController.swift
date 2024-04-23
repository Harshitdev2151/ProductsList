//
//  CartTableViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

/**
 CartVC to shhow all product added to cart
 */
class CartTableViewController: UITableViewController {

    var products = [NSManagedObject]()
    lazy var cartViewModel : CartViewModel = {
        let viewModel = CartViewModel(imageLoader: AsyncImageView(),
                               productsCoreDataHelper: self.productsCoreDataHelper)
        return viewModel
    }()

    var productsCoreDataHelper: ProductsCoreDataHelper!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.cartViewTitle
        loadDatafromDB()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.productsTableViewCellIdentifier, for: indexPath) as? ProductsTableViewCell
        let product = self.products[indexPath.row]
        cell?.configureWithDatabaseObject(product)
        self.cartViewModel.fetchImage(product.value(forKeyPath: Constants.thumbnailString) as? String ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: Constants.defaultLoaderImage))
        }
        return cell ?? UITableViewCell()
    }
}

extension CartTableViewController {

    /// Function to fetch all stored data from DB
    func loadDatafromDB() {
        if let products = self.cartViewModel.fetchAllProductAddedToCart() {
            self.products = products
            self.tableView.reloadData()
        }
    }
}
