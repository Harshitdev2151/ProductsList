//
//  ViewControllerExtension.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import UIKit


extension UIViewController {
    /// Set right naviation Item on Naviation bar which is used in all controller
    /// - Parameter employeeCoreDataInteractor: coreData helper object to do CRUD opeartion
    func setRightNavigationItem(employeeCoreDataInteractor: ProductsCoreDataHelper) {
        var currentCartCount = 0
        if let products = employeeCoreDataInteractor.fetchAllProductAddedToCart() {
            currentCartCount = Int(products.reduce(0) { partialResult, productItem in
                partialResult + productItem.count
            })
        }
        let item = UIBarButtonItem(icon: UIImage(systemName: "cart.fill")!, badge: "\(currentCartCount)", target: self, action: #selector(didTapEditButton))
        self.navigationItem.rightBarButtonItems = [item]
    }

    /// Tap on right navigation edit button click
    /// - Parameter sender: sender description
    @objc func didTapEditButton(sender: AnyObject) {
        guard let cartVC = self.storyboard?.instantiateViewController(identifier: Constants.cartTableViewController) as? CartTableViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        cartVC.productsCoreDataHelper = ProductsCoreDataHelper(withContext: appDelegate.persistentContainer.viewContext)
        self.navigationController?.pushViewController(cartVC, animated: true)
    }
    
    /// Add alertcontroller to ViewController who is calling
    /// - Parameters:
    ///   - title: title description
    ///   - message: message description
    func addAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message, preferredStyle: UIAlertController.Style.alert)

        alertController.addAction(UIAlertAction(title: Constants.cancelAlertBtn,
                                                style: UIAlertAction.Style.default) { [weak self] _ in
            self?.dismiss(animated: false)
        })
        self.present(alertController, animated: true, completion: nil)
    }
}
