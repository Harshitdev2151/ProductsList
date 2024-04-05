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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        /*
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartViewCell", for: indexPath)

        let product = self.products[indexPath.row]
        cell.textLabel?.text = product.value(forKeyPath: "title") as? String
        // Configure the cell...

       return cell
*/
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as? ProductsTableViewCell
        let product = self.products[indexPath.row]
        cell?.configureWithDatabaseObject(product)
        self.viewModel.fetchImage(product.value(forKeyPath: "thumbnail") as? String ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: "flower123"))
        }

        return cell ?? UITableViewCell()
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
