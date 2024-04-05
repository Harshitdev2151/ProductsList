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
    var currentCount: Int = 0

    let urlString = EndPointURLs.defaultImageURL
    var imageLoader: ImageLoaderProtocol = AsyncImageView()

    var employeeCoreDataInteractor: ProductsCoreDataInteractor!
    var context : NSManagedObjectContext!


    @IBOutlet weak var cartBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLabel()

        self.title = "ProductDetail"
        self.viewModel = RootViewModel(productsService: ProductsService(), imageLoader: self.imageLoader)

        viewModel.fetchImage(product?.thumbnail ?? EndPointURLs.defaultImageURL) { img in
            DispatchQueue.main.async {
                if let image = img {
                    self.productImgView.image = image
                }
            }



        }

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.employeeCoreDataInteractor = ProductsCoreDataInteractor(withContext: self.context)
        self.setRightNavigationItem(employeeCoreDataInteractor: self.employeeCoreDataInteractor)
        cartBtn.setTitle("Add to cart", for: .normal)
    }


    func initializeLabel() {
        self.titleLabel.text = self.product?.title
        self.descLbl.text = self.product?.description
        self.priceLbl.text = String(self.product?.price ?? 0)
        self.ratingLbl.text = String(self.product?.rating ?? 0)

        self.brandLbl.text = self.product?.brand
        self.categoryLbl.text = self.product?.category
    }


    @IBAction func addToCart(_ sender: Any) {
        if cartBtn.titleLabel?.text == "Add to cart" {
            self.employeeCoreDataInteractor.saveData(self.product ?? Product())
            self.setRightNavigationItem(employeeCoreDataInteractor: self.employeeCoreDataInteractor)
            cartBtn.setTitle("Go to cart", for: .normal)


        } else {
            guard let cartVC = self.storyboard?.instantiateViewController(identifier: "CartTableViewController") as? CartTableViewController else { return }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
              return
            }
            cartVC.context = appDelegate.persistentContainer.viewContext
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
