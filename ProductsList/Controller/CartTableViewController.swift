//
//  CartTableViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

class CartTableViewController: UITableViewController {

    var products = [NSManagedObject]()
    var productsCoreDataInteractor: ProductsCoreDataHelper!
    var context : NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    lazy var viewModel : RootViewModel = {
        let  viewModel = RootViewModel(productsService: ProductsService(), imageLoader: self.imageLoader)
        return viewModel
    }()
    private var imageLoader: ImageLoaderProtocol = AsyncImageView()

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
        self.viewModel.fetchImage(product.value(forKeyPath: Constants.thumbnailString) as? String ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: Constants.defaultLoaderImage))
        }
        return cell ?? UITableViewCell()
    }
}

extension CartTableViewController {

    /// Function to fetch all stored data from DB
    func loadDatafromDB() {
        self.productsCoreDataInteractor = ProductsCoreDataHelper(withContext: self.context)

        if let products = self.productsCoreDataInteractor.fetchAllProductAddedToCart() {
            self.products = products
            self.tableView.reloadData()
        }
    }
}
