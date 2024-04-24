//
//  DetailViewController.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit
import CoreData

/**
 Detail VC of product of list of previous VC
 */
class DetailViewController: UIViewController {

    // MARK: - Detail ViewController IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var brandLbl: UILabel!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var productImgView: UIImageView!
    @IBOutlet weak var rateButton: UIButton!
    @IBOutlet weak var cartBtn: UIButton!

    // MARK: - Detail ViewController Dependency Injection
    lazy var detailProductViewModel : DetailProductViewModel = {
        let viewModel = DetailProductViewModel(imageLoader: AsyncImageView(),
                                               productsCoreDataHelper: self.productsCoreDataHelper)
        return viewModel
    }()
    var productsCoreDataHelper: ProductsCoreDataHelper!


    var product: Product?
    private let urlString = EndPointURLs.defaultImageURL
    private var imageLoader: ImageLoaderProtocol = AsyncImageView()

    // MARK: -  DetailViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabel()
        self.title = Constants.detailVCTitle
        detailProductViewModel.fetchImage(product?.thumbnail ?? EndPointURLs.defaultImageURL) { img in
            DispatchQueue.main.async {
                if let image = img {
                    self.productImgView.image = image
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Adding the right navigation item to show cart count
        self.setRightNavigationItem(productsCoreDataHelper: self.productsCoreDataHelper)
        cartBtn.setTitle(Constants.addToCartConstant, for: .normal)
    }
}

/// DetailVC Helper functions
extension DetailViewController {
    /// Iniitial set up for all Label with the data coming from previous Controller
    func initializeLabel() {
        self.titleLabel.text = self.product?.title
        self.descLbl.text = self.product?.description
        self.priceLbl.text = "\(Constants.priceConst)$\(String(self.product?.price ?? 0))"
        self.brandLbl.text = "\(Constants.brandConst)\(product?.brand ?? "") (\(product?.category?.firstUppercased ?? ""))"
        self.categoryLbl.text = ""
        self.rateButton.setTitle("\(product?.rating ?? 0)", for: .normal)
    }

    /// Add to cart click funcionality when customer want to add product to shoppin list
    /// - Parameter sender: sender description
    @IBAction func addToCart(_ sender: Any) {
        if cartBtn.titleLabel?.text == Constants.addToCartConstant {
            _ = try? self.detailProductViewModel.updateProduct(self.product ?? Product())
            self.addAlertController(title: Constants.prodAddSuccessTitle, message: Constants.prodAddSuccessMessage)
            self.setRightNavigationItem(productsCoreDataHelper: self.productsCoreDataHelper)
            cartBtn.setTitle(Constants.goToCartConstant, for: .normal)
        } else {
            guard let cartVC = self.storyboard?.instantiateViewController(identifier: Constants.cartTableViewController) as? CartTableViewController else { return }

            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            cartVC.productsCoreDataHelper = ProductsCoreDataHelper(withContext: appDelegate.persistentContainer.viewContext)
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
}
