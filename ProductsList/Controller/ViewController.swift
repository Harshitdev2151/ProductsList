//
//  ViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: RootViewModel!
    @IBOutlet weak var tableView: UITableView!
    var products: Products?
    var fetchingMore = false
    var limit = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        self.title = "Product"
        self.viewModel = RootViewModel(productsService: ProductsService(), delegate: self)
        viewModel.fetchProducts()
    }


}


extension ViewController: RootViewModelDelegate {
    func fetchProducts(_ products: Products?) {
        if self.products?.products == nil {
            self.products = products
            self.limit = (self.products?.total ?? 0) - (self.products?.limit ?? 0)
        } else {
            self.products?.products?.append(contentsOf: products?.products ?? [Product()])
        }
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.fetchingMore = false
            self?.tableView?.tableFooterView?.isHidden = true
        }
    }

    func showError(message: String) {

    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("article clount is ")
        print(products?.products?.count ?? 0)
        return products?.products?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsTableViewCell", for: indexPath) as? ProductsTableViewCell
        let product = self.products?.products?[indexPath.row] ?? Product()
        cell?.configureWith(product)
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         // return 400
        return UITableView.automaticDimension
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       let lastSectionIndex = tableView.numberOfSections - 1
       let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
       if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
           if !fetchingMore && self.products?.products?.count ?? 0 <= self.limit {
               print("self.limit is \(self.limit)")
               print("self.products?.products?.count ?? 0 is \(self.products?.products?.count ?? 0)")
               beginBatchFetch()

               // print("this is the last cell")
               let spinner = UIActivityIndicatorView(style: .medium)
               spinner.startAnimating()
               spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

               self.tableView.tableFooterView = spinner
               self.tableView.tableFooterView?.isHidden = false
           }
       }
   }

   func beginBatchFetch() {
       fetchingMore = true
       print("beginBatchFetch!")
       tableView.reloadSections(IndexSet(integer: 1), with: .none)
       viewModel.fetchProducts()

   }

}


