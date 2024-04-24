//
//  ViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

/**
 Root VC / startin screen of app
 */
// MARK: - Root ViewController
class ViewController: UIViewController {

    // MARK: - Root ViewController Dependency Injection

    lazy var viewModel : RootViewModel = {
        let  viewModel = RootViewModel(productsService: self.productsService, delegate: self)
        return viewModel
    }()
    private var productsService: ProductsServiceProtocol = ProductsService()
    open var calledSegue: UIStoryboardSegue!

    private var context : NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var productsCoreDataHelper: ProductsCoreDataHelper?

    // MARK: - Root ViewController IBOutlet
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    var products: Products?
    var fetchingMore = false
    var limit = 0

    // MARK: -  ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        activityIndicatorView.startAnimating()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 400
        self.title = Constants.rootVCTitle
        self.viewModel.fetchProducts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.productsCoreDataHelper = ProductsCoreDataHelper(withContext: self.context)
        guard let productsCoreDataHelper = self.productsCoreDataHelper else { return  }
        //Adding the right navigation item to show cart count
        self.setRightNavigationItem(productsCoreDataHelper: productsCoreDataHelper)
        //Hide right navigation item if no product is there
        let alphaValue = self.products?.productList == nil ? 0: 1
        self.navigationItem.rightBarButtonItem?.customView?.alpha = CGFloat(alphaValue)
    }
}

/**
 Helper delegate to handle success/ failure API response
 */
extension ViewController: RootViewModelDelegate {
    func fetchProducts(_ products: Products?) {
        if self.products?.productList == nil {
            self.products = products
            self.limit = (self.products?.total ?? 0) - (self.products?.limit ?? 0)
        } else {
            self.products?.productList?.append(contentsOf: products?.productList ?? [Product()])
        }
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            self?.errorButton.isHidden = true
            self?.activityIndicatorView.stopAnimating()
            self?.fetchingMore = false
            self?.tableView?.tableFooterView?.isHidden = true
            self?.tableView.reloadData()

        }
    }

    func showError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.navigationItem.rightBarButtonItem?.customView?.alpha = 1
            self?.addAlertController(title: Constants.errorMessage, message: Constants.errorTitle)
            self?.activityIndicatorView.stopAnimating()
            self?.errorButton.isHidden = false
        }
    }
}

/**
 Tableview datasource
 */
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products?.productList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ProductCellIdentifier, for: indexPath) as? ProductCell
        cell?.tag = indexPath.row
        let product = self.products?.productList?[indexPath.row] ?? Product()
        cell?.configureWith(product)
        viewModel.fetchImage(product.thumbnail ?? EndPointURLs.defaultImageURL) { img in
            DispatchQueue.main.async {
                if(cell?.tag == indexPath.row) {
                    cell?.setImage(img ?? UIImage(named: Constants.defaultLoaderImage))
                }
            }
        }
        return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

/**
 Tableview delegate
 */
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
            destinationVC.productsCoreDataHelper = ProductsCoreDataHelper(withContext: appDelegate.persistentContainer.viewContext)
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
}
