//
//  ViewControllerExtension.swift
//  ProductsList
//
//  Created by Harshit Kumar on 02/04/24.
//

import Foundation
import UIKit


extension UIViewController {
     func setRightNavigationItem(employeeCoreDataInteractor: ProductsCoreDataInteractor) {
        var currentCartCount = 0
        if let products = employeeCoreDataInteractor.fetchAllProductAddedToCart() {
            currentCartCount = products.count
        }
        let item = UIBarButtonItem(icon: UIImage(), badge: "\(currentCartCount)", target: self, action: #selector(didTapEditButton))
        self.navigationItem.rightBarButtonItems = [item]
    }

    @objc func didTapEditButton(sender: AnyObject) {
            print("hjxdbsdhjbv")
        guard let cartVC = self.storyboard?.instantiateViewController(identifier: "CartTableViewController") as? CartTableViewController else { return }
        self.navigationController?.pushViewController(cartVC, animated: true)
        }
}
