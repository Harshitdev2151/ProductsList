//
//  ViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    var viewModel: RootViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    var products: Products?
    var fetchingMore = false
    var limit = 0
    var productsService: ProductsServiceProtocol = ProductsService()
    open var calledSegue: UIStoryboardSegue!

    var context : NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var employeeCoreDataInteractor: ProductsCoreDataInteractor?

    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!

    @IBOutlet weak var errorButton: UIButton!
    
    @IBAction func pressErrorBtn(_ sender: Any) {
        activityIndicatorView.startAnimating()

        self.viewModel.fetchProducts()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicatorView.startAnimating()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        self.title = Constants.rootVCTitle
        self.viewModel = RootViewModel(productsService: self.productsService, delegate: self)
        self.viewModel.fetchProducts()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.employeeCoreDataInteractor = ProductsCoreDataInteractor(withContext: self.context)

        guard let employeeCoreDataInteractor = self.employeeCoreDataInteractor else { return  }

        self.setRightNavigationItem(employeeCoreDataInteractor: employeeCoreDataInteractor)
    }

}


extension ViewController: RootViewModelDelegate {
    func fetchProducts(_ products: Products?) {
        if self.products?.productList == nil {
            self.products = products
            self.limit = (self.products?.total ?? 0) - (self.products?.limit ?? 0)
        } else {
            self.products?.productList?.append(contentsOf: products?.productList ?? [Product()])
        }
        DispatchQueue.main.async { [weak self] in
            self?.errorButton.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            self?.tableView.reloadData()
            self?.fetchingMore = false
            self?.tableView?.tableFooterView?.isHidden = true
        }
    }

    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicatorView.stopAnimating()
            self?.errorButton.isHidden = false
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.productList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.productsTableViewCellIdentifier, for: indexPath) as? ProductsTableViewCell
        let product = self.products?.productList?[indexPath.row] ?? Product()
        cell?.configureWith(product)
        viewModel.fetchImage(product.thumbnail ?? EndPointURLs.defaultImageURL) { img in
            cell?.setImage(img ?? UIImage(named: Constants.defaultLoaderImage))
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         // return 400
        return UITableView.automaticDimension
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = self.products?.productList?[indexPath.row] ?? Product()
        self.performSegue(withIdentifier: Constants.detailVCSegue, sender: product)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let product = sender as? Product {
            calledSegue = segue
            destinationVC.product = product
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            destinationVC.context = appDelegate.persistentContainer.viewContext
            //destinationVC.viewModel = self.viewModel
        }
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       let lastSectionIndex = tableView.numberOfSections - 1
       let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
       if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
           if !fetchingMore && self.products?.productList?.count ?? 0 <= self.limit {
               beginBatchFetch()
               let spinner = UIActivityIndicatorView(style: .medium)
               spinner.startAnimating()
               spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

               self.tableView.tableFooterView = spinner
               self.tableView.tableFooterView?.isHidden = false
           }
       }
   }

   func beginBatchFetch() {
           self.fetchingMore = true
           self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
       DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
           self.viewModel.fetchProducts()

       })

   }

}


