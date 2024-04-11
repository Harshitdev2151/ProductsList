//
//  DetailViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!

    var viewModel: RootViewModel = RootViewModel(productsService: ProductsService())
    var product: Product?

    private let urlString = EndPointURLs.defaultImageURL
    var imageLoader: ImageLoaderProtocol = AsyncImageView()
    var productsCoreDataHelper: ProductsCoreDataHelper!
    var context : NSManagedObjectContext!
    @IBOutlet weak var cartBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabel()
        self.title = Constants.detailVCTitle
        self.viewModel = RootViewModel(productsService: ProductsService(), imageLoader: self.imageLoader)

        viewModel.fetchImage(product?.thumbnail ?? EndPointURLs.defaultImageURL) { img in
            DispatchQueue.main.async {
                if let image = img {
                    self.productImgView.image = image
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.productsCoreDataHelper = ProductsCoreDataHelper(withContext: self.context)
        self.setRightNavigationItem(employeeCoreDataInteractor: self.productsCoreDataHelper)
        cartBtn.setTitle(Constants.addToCartConstant, for: .normal)
    }
}

extension DetailViewController {
    
    /// Iniitial set up for all Label with the data coming from previous Controller
    func initializeLabel() {
        self.titleLabel.text = self.product?.title
        self.descLbl.text = self.product?.description
        self.priceLbl.text = String(self.product?.price ?? 0)
        self.ratingLbl.text = String(self.product?.rating ?? 0)

        self.brandLbl.text = self.product?.brand
        self.categoryLbl.text = self.product?.category
    }

    
    /// Add to cart click funcionality when customer want to add product to shoppin list
    /// - Parameter sender: sender description
    @IBAction func addToCart(_ sender: Any) {
        if cartBtn.titleLabel?.text == Constants.addToCartConstant {
            self.productsCoreDataHelper.saveData(self.product ?? Product())
            self.setRightNavigationItem(employeeCoreDataInteractor: self.productsCoreDataHelper)
            cartBtn.setTitle(Constants.goToCartConstant, for: .normal)


        } else {
            guard let cartVC = self.storyboard?.instantiateViewController(identifier: Constants.cartTableViewController) as? CartTableViewController else { return }

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            cartVC.context = appDelegate.persistentContainer.viewContext
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}
