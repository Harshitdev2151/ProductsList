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
            currentCartCount = products.count
        }
        let item = UIBarButtonItem(icon: UIImage(), badge: "\(currentCartCount)", target: self, action: #selector(didTapEditButton))
        self.navigationItem.rightBarButtonItems = [item]
    }
    
    /// Tap on right naiggation edit button click
    /// - Parameter sender: sender description
    @objc func didTapEditButton(sender: AnyObject) {
        guard let cartVC = self.storyboard?.instantiateViewController(identifier: Constants.cartTableViewController) as? CartTableViewController else { return }
        self.navigationController?.pushViewController(cartVC, animated: true)
        }
}
