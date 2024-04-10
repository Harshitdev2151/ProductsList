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

    var employeeCoreDataInteractor: ProductsCoreDataInteractor!

    var context : NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    var viewModel: RootViewModel = RootViewModel(productsService: ProductsService())
    var imageLoader: ImageLoaderProtocol = AsyncImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "CartView"

        self.viewModel = RootViewModel(productsService: ProductsService(), imageLoader: self.imageLoader)

        self.employeeCoreDataInteractor = ProductsCoreDataInteractor(withContext: self.context)


        if let products = self.employeeCoreDataInteractor.fetchAllProductAddedToCart() {
            self.products = products
            self.tableView.reloadData()
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as? ProductsTableViewCell
        let product = self.products[indexPath.row]
        cell?.configureWithDatabaseObject(product)
        self.viewModel.fetchImage(product.value(forKeyPath: "thumbnail") as? String ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: "flower123"))
        }

        return cell ?? UITableViewCell()
    }

}
